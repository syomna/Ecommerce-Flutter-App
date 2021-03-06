import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/account/account_screen.dart';
import 'package:shop/modules/navbar_screens/home/home_screen.dart';
import 'package:shop/modules/navbar_screens/search/search_screen.dart';
import 'package:shop/modules/navbar_screens/wishlist/wishlist_screen.dart';
import 'package:shop/shared/blocs/layout_cubit/layout_states.dart';
import 'package:shop/shared/network/local/cache_helper.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int? cartLength = 0;
  getCartLength() {
    cartLength = CacheHelper.getData('CartLength');
    emit(LayoutCartLengthState());
  }

  int currentIndex = 0;

  changeIndex(value) {
    currentIndex = value;
    emit(LayoutChangeNavBarState());
  }

  List<Widget> layoutBody = [
    HomeScreen(),
    SearchScreen(),
    WishListScreen(),
    AccountScreen()
  ];

  List<String> layoutTitle = ['Y-Shop', 'Search', 'WishList', 'Account'];

  List<BottomNavigationBarItem> bottomNavList = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label:'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite_border,
        ),
        label: 'Wishlist'),
    BottomNavigationBarItem(
        icon: Icon(Icons.person_outlined), label: 'Account'),
  ];
}
