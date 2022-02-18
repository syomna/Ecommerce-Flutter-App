import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/modules/navbar_screens/products/product_details_screen.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class BuildListViewItems extends StatelessWidget {
  const BuildListViewItems(
      {Key? key,
      required this.model,
      required this.cubit,
      this.isSearch = false})
      : super(key: key);

  final model;
  final HomeCubit cubit;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        cubit.getProductsDetails(model.id).then((value) {
          navigateTo(context, ProductDetailsScreen());
        });
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: CachedNetworkImage(
                  imageUrl: '${model.image}',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.name}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          model.oldPrice == null ||
                                  model.oldPrice == model.price
                              ? SizedBox.shrink()
                              : Text(
                                  isSearch ? '' : '${model.oldPrice} ',
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                          Text(
                            '${kFormatCurrency.format(model.price)}',
                            style: TextStyle(
                                color: kDefaultColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
