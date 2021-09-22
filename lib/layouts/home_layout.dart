import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/cubit/layout_cubit.dart';
import 'package:shop/layouts/cubit/layout_states.dart';
import 'package:shop/modules/navbar_screens/cart/cart_screen.dart';

import 'package:shop/shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);
        cubit.getCartLength();
        print('rebuild');
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
                  cubit.cartLength == null
                      ? const SizedBox()
                      : CircleAvatar(
                          child: Text(
                            '${cubit.cartLength}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          minRadius: 10,
                          backgroundColor: Colors.red,
                        )
                ],
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (value) => cubit.changeIndex(value),
              items: cubit.bottomNavList),
          body: cubit.layoutBody[cubit.currentIndex],
        );
      },
    );
  }
}
