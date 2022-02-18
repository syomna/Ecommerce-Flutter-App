import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/modules/navbar_screens/products/product_details_screen.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class BuildGridItems extends StatelessWidget {
  const BuildGridItems({Key? key, required this.model, required this.cubit})
      : super(key: key);

  final model;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        cubit.getProductsDetails(model.id).then((value) {
          navigateTo(context, ProductDetailsScreen());
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8.0),
        margin: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
                //  alignment: AlignmentDirectional.bottomStart,

                children: [
                  model.image == null
                      ? Center(
                          child: Icon(Icons.image_search),
                        )
                      : CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.18,
                          imageUrl: '${model.image}',
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.broken_image),
                        ),
                  // Image(
                  //     height: MediaQuery.of(context).size.height * 0.18,
                  //     errorBuilder: (BuildContext context , Object child, StackTrace? trace) => Icon(Icons.broken_image),
                  //     image: NetworkImage('${model.image}'),
                  //   ),
                  model.discount != 0
                      ? Container(
                          color: Colors.red,
                          width: MediaQuery.of(context).size.width * 0.2,
                          padding: const EdgeInsets.fromLTRB(8.0, 2.0, 0, 2.0),
                          child: Text(
                            '${model.discount} % off'.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container()
                ]),
            Spacer(),
            Text(
              '${model.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Row(
              children: [
                model.oldPrice == null || model.oldPrice == model.price
                    ? Container()
                    : Text(
                        '${model.oldPrice}',
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                Spacer(),
                Text(
                  '${kFormatCurrency.format(model.price)}',
                  style: TextStyle(
                      color: kDefaultColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: MaterialButton(
                      padding: const EdgeInsets.all(2.0),
                      color:
                          cubit.cart[model.id]! ? kDefaultColor : Colors.grey,
                      onPressed: () {
                        cubit.addToOrRemoveFromCart(model.id);
                      },
                      child: Text(
                        cubit.cart[model.id]!
                            ? 'added to cart'.toUpperCase()
                            : 'add to cart'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                IconButton(
                  onPressed: () {
                    cubit.changeFavorites(model.id);
                  },
                  icon: cubit.favorites[model.id]!
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
