import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/cubit/layout_cubit.dart';
import 'package:shop/layouts/cubit/layout_states.dart';
import 'package:shop/modules/navbar_screens/cart/cart_screen.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';

import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);
        print('rebuild layout');
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.layoutTitle[cubit.currentIndex],
                style: appBarStyle(context)),
            actions: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  IconButton(
                      icon: Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        navigateTo(context, CartScreen());
                      }),
                  if (HomeCubit.get(context).cartModel != null)
                    CircleAvatar(
                      child: Text(
                        '${HomeCubit.get(context).cartModel!.data?.cartItems.length}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      minRadius: 10,
                      backgroundColor: Colors.red,
                    )
                ],
              )
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            items: items,
            backgroundColor: defaultColor,
            onTap: (value) {
              cubit.changeIndex(value);
            },
          ),

          // BottomNavigationBar(
          //   backgroundColor: Colors.white,
          //   showUnselectedLabels: false,
          //   showSelectedLabels:  false,
          //     type: BottomNavigationBarType.fixed,
          //     currentIndex: cubit.currentIndex,
          //     onTap: (value) => cubit.changeIndex(value),
          //     items: cubit.bottomNavList),
          body: cubit.layoutBody[cubit.currentIndex],
        );
      },
    );
  }

  final List<Widget> items = [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.favorite_border),
    Icon(Icons.person_outline),
  ];
}
