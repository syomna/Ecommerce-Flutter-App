import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/order_details_model.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class OrderDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Order Details',
              style: appBarStyle(context),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildCostCard(context, cubit),
                    const SizedBox(
                      height: 15.0,
                    ),
                    buildAddressCard(
                        cubit.orderDetailsModel.data!.address, context),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 0.65),
                          itemCount:
                              cubit.orderDetailsModel.data!.products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: buildOrderProductsDetails(
                                  cubit.orderDetailsModel.data!.products[index],
                                  context),
                            );
                          }),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget buildCostCard(BuildContext context, HomeCubit cubit) {
    return Container(
      child: Row(
        children: [
          Text(
            'Your Cost : ',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            '${kFormatCurrency.format(cubit.orderDetailsModel.data?.cost)}',
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }

  Widget buildAddressCard(address, context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text('Delivered to',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
        ListTile(
          title: Text('${address.city} , ${address.name}',
              style: Theme.of(context).textTheme.bodyText1),
          // subtitle: Text('${address.details}',
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //     style: Theme.of(context).textTheme.bodyText2),
        )
      ],
    );
  }

  Widget buildOrderProductsDetails(OrderProducts product, context) {
    return Column(
      children: [
        Text(
          'Quantity : ${product.quantity}',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image(
                  errorBuilder:
                      (BuildContext context, Object child, StackTrace? trace) =>
                          Icon(Icons.broken_image),
                  height: MediaQuery.of(context).size.height * 0.2,
                  image: NetworkImage('${product.image}'),
                ),
                Text(
                  '${product.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${kFormatCurrency.format(product.price)}',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold, color: kDefaultColor),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
