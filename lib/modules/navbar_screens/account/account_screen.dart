import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/login/cubit/login_cubit.dart';
import 'package:shop/modules/login/cubit/login_states.dart';
import 'package:shop/modules/navbar_screens/account/address/address_screen.dart';
import 'package:shop/modules/navbar_screens/account/orders/orders_screen.dart';
import 'package:shop/modules/navbar_screens/account/update/update_account_screen.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Conditional(
            condition: state is HomeGetOrdersLoadingState ||
                state is HomeGetAddressLoading,
            onConditionTrue: Center(
              child: CircularProgressIndicator(),
            ),
            onConditionFalse: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                  const  SizedBox(
                      height: 10.0,
                    ),
                    buildAccountCard(
                        title: 'Update your account informations',
                        leadingIcon: Icons.person,
                        onTap: () {
                          navigateTo(context, UpdateAccountScreen());
                        },
                        context: context),
                    buildAccountCard(
                        title: 'Addresses',
                        leadingIcon: Icons.house,
                        onTap: () {
                          cubit.getUserAddress().then((value) {
                            navigateTo(context, AddressSreen());
                          });
                        },
                        context: context),
                    buildAccountCard(
                        title: 'Orders',
                        leadingIcon: Icons.shopping_bag,
                        onTap: () {
                          cubit.getOrders().then((value) {
                            navigateTo(context, OrdersScreen());
                          });
                        },
                        context: context),
                    defaultButton('Log out', () {
                      cubit.logout(context);
                    }, context),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget buildAccountCard(
      {@required String title,
      @required IconData leadingIcon,
      @required Function onTap,
      @required context}) {
    return Card(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          leadingIcon,
          color: defaultColor,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: defaultColor,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
