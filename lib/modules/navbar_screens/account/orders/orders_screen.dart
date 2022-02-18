import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/orders_model.dart';
import 'package:shop/modules/navbar_screens/account/orders/order_details_screen.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Your Orders',
              style: appBarStyle(context),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: cubit.orderModel.data!.data.length,
                  itemBuilder: (context, index) {
                    return buildOrderCard(
                        cubit.orderModel.data!.data[index], cubit, context);
                  })),
        );
      },
    );
  }

  Widget buildOrderCard(OrderData data, HomeCubit cubit, context) {
    if (data.status == 'Cancelled') {
      return Container();
    } else {
      return InkWell(
        onTap: () {
          cubit.getOrderDetails(data.id).then((value) {
            navigateTo(context, OrderDetailsScreen());
          });
        },
        child: Card(
          child: ListTile(
            title: Text(
              '${data.status}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Text(
              '${data.date}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Text(
              '${kFormatCurrency.format(data.total)}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      );
    }
  }
}
