import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      listener: (context, state) {
        if (state is HomeGetOrdersSuccessState) {
          navigateTo(context, OrdersScreen());
        }
        if (state is HomeGetAddressSuccess) {
          navigateTo(context, AddressSreen());
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
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
                  onTap: () async {
                   await cubit.getUserAddress();
                  },
                  context: context),
              buildAccountCard(
                  title: 'Orders',
                  leadingIcon: Icons.shopping_bag,
                  onTap: () async {
                  await  cubit.getOrders();
                  },
                  context: context),

              InkWell(
                onTap: () {
                  cubit.logout(context);
                },
                child: Card(
                  color: Colors.red.withOpacity(0.8),
                  elevation: 5,
                  margin: const EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Log Out',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              // defaultButton('Log out', () {
              //   cubit.logout(context);
              // }, context),
            ],
          ),
        );
      },
    );
  }

  Widget buildAccountCard(
      {required String title,
      required IconData leadingIcon,
      required Function onTap,
      required context}) {
    return Card(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: ListTile(
        onTap: onTap as void Function()?,
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
