import 'package:shop/models/add_address_model.dart';
import 'package:shop/models/add_order.model.dart';
import 'package:shop/models/change_cart_model.dart';
import 'package:shop/models/change_favorites_model.dart';
import 'package:shop/models/delete_address_model.dart';
import 'package:shop/models/delete_cart_model.dart';
import 'package:shop/models/search_model.dart';
import 'package:shop/models/update_cart_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeGetDataLoadingState extends HomeStates {}

class HomeGetDataSuccessState extends HomeStates {}

class HomeGetDataErrorState extends HomeStates {
  final String error;
  HomeGetDataErrorState(this.error);
}

class HomeChangeFavoritesLoadingState extends HomeStates {}

class HomeChangeFavoritesSuccessState extends HomeStates {
  final ChangeFavoritesModel model;
  HomeChangeFavoritesSuccessState(this.model);
}

class HomeChangeFavoritesErrorState extends HomeStates {
  final String error;
  HomeChangeFavoritesErrorState(this.error);
}

class HomeGetFavoritesLoadingState extends HomeStates {}

class HomeGetFavoritesChangeState extends HomeStates {}

class HomeGetFavoritesSuccessState extends HomeStates {}

class HomeGetFavoritesErrorState extends HomeStates {
  final String error;
  HomeGetFavoritesErrorState(this.error);
}

class HomeChangeCartLoadingState extends HomeStates {}

class HomeChangeCartSuccessState extends HomeStates {
  final ChangeCartModel model;
  HomeChangeCartSuccessState(this.model);
}

class HomeChangeCartErrorState extends HomeStates {
  final String error;
  HomeChangeCartErrorState(this.error);
}

class HomeGetCartLoadingState extends HomeStates {}

class HomeGetCartChangeState extends HomeStates {}

class HomeGetCartSuccessState extends HomeStates {}

class HomeGetCartErrorState extends HomeStates {
  final String error;
  HomeGetCartErrorState(this.error);
}

class HomeQuantityIncrementState extends HomeStates {}

class HomeQuantityDecrementState extends HomeStates {}

class HomeUpdateCartLoadingState extends HomeStates {}

class HomeUpdateCartSuccessState extends HomeStates {
  final UpdateCartModel model;
  HomeUpdateCartSuccessState(this.model);
}

class HomeUpdateCartErrorState extends HomeStates {
  final String error;
  HomeUpdateCartErrorState(this.error);
}

class HomeGetCategoriesLoadingState extends HomeStates {}

class HomeGetCategoriesSuccessState extends HomeStates {}

class HomeGetCategoriesErrorState extends HomeStates {
  final String error;
  HomeGetCategoriesErrorState(this.error);
}

class HomeGetProductsByCategoryLoadingState extends HomeStates {}

class HomeGetProductsByCategorySuccessState extends HomeStates {}

class HomeGetProductsByCategoryErrorState extends HomeStates {
  final String error;
  HomeGetProductsByCategoryErrorState(this.error);
}

class HomeGetProductsDetailsLoadingState extends HomeStates {}

class HomeGetProductsDetailsSuccessState extends HomeStates {}

class HomeGetProductsDetailsErrorState extends HomeStates {
  final String error;
  HomeGetProductsDetailsErrorState(this.error);
}

class HomeGetSearchLoadingState extends HomeStates {}

class HomeGetSearchSuccessState extends HomeStates {
  final SearchModel searchModel;
  HomeGetSearchSuccessState(this.searchModel);
}

class HomeGetSearchErrorState extends HomeStates {
  final String error;
  HomeGetSearchErrorState(this.error);
}

class HomeGetUserDataLoadingState extends HomeStates {}

class HomeGetUserDataSuccessState extends HomeStates {}

class HomeGetUserDataErrorState extends HomeStates {
  final String error;
  HomeGetUserDataErrorState(this.error);
}

class HomeUpdateUserDataLoadingState extends HomeStates {}

class HomeUpdateUserDataSuccessState extends HomeStates {}

class HomeUpdateUserDataErrorState extends HomeStates {
  final String error;
  HomeUpdateUserDataErrorState(this.error);
}

class HomeChangeExtendDetailsState extends HomeStates {}

class HomeChangeFavoriteState extends HomeStates {}

class HomeGetCurrentLocationLoading extends HomeStates {}

class HomeGetCurrentLocationSuccess extends HomeStates {}

class HomeGetCurrentLocationError extends HomeStates {
  final String error;
  HomeGetCurrentLocationError(this.error);
}

class HomePostAddressLoading extends HomeStates {}

class HomePostAddressSuccess extends HomeStates {
  final AddAddressModel addAddressModel;
  HomePostAddressSuccess(this.addAddressModel);
}

class HomePostAddressError extends HomeStates {
  final String error;
  HomePostAddressError(this.error);
}

class HomeRadioButtonHomeState extends HomeStates {}

class HomeRadioButtonWorkState extends HomeStates {}

class HomeAddressRadioButtonHomeState extends HomeStates {}

class HomePaymentMethodRadioButtonHomeState extends HomeStates {}

class HomeGetAddressLoading extends HomeStates {}

class HomeGetAddressSuccess extends HomeStates {}

class HomeGetAddressError extends HomeStates {
  final String error;
  HomeGetAddressError(this.error);
}

class HomeDeleteAddressLoading extends HomeStates {}

class HomeDeleteAddressSuccess extends HomeStates {
  final DeleteAddressModel deleteAddressModel;
  HomeDeleteAddressSuccess(this.deleteAddressModel);
}

class HomeDeleteAddressError extends HomeStates {
  final String error;
  HomeDeleteAddressError(this.error);
}

class HomeAddOrderLoadingState extends HomeStates {}

class HomeAddOrderSuccessState extends HomeStates {
  final AddOrderModel addOrderModel;
  HomeAddOrderSuccessState(this.addOrderModel);
}

class HomeAddOrderErrorState extends HomeStates {
  final String error;
  HomeAddOrderErrorState(this.error);
}

class HomeGetOrdersLoadingState extends HomeStates {}

class HomeGetOrdersSuccessState extends HomeStates {}

class HomeGetOrdersErrorState extends HomeStates {
  final String error;
  HomeGetOrdersErrorState(this.error);
}

class HomeGetOrderDetailsLoadingState extends HomeStates {}

class HomeGetOrderDetailsSuccessState extends HomeStates {}

class HomeGetOrderDetailsErrorState extends HomeStates {
  final String error;
  HomeGetOrderDetailsErrorState(this.error);
}

class HomeDeleteCartLoadingState extends HomeStates {}

class HomeDeleteCartSuccessState extends HomeStates {
  final DeleteCartModel deleteCartModel;
  HomeDeleteCartSuccessState(this.deleteCartModel);
}

class HomeDeleteCartErrorState extends HomeStates {
  final String error;
  HomeDeleteCartErrorState(this.error);
}
