import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shop/models/add_address_model.dart';
import 'package:shop/models/add_order.model.dart';
import 'package:shop/models/address_model.dart';
import 'package:shop/models/cart_model.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/change_cart_model.dart';
import 'package:shop/models/change_favorites_model.dart';
import 'package:shop/models/delete_address_model.dart';
import 'package:shop/models/delete_cart_model.dart';
import 'package:shop/models/favorites_model.dart';
import 'package:shop/models/home_model.dart';
import 'package:shop/models/order_details_model.dart';
import 'package:shop/models/orders_model.dart';
import 'package:shop/models/products_by_category_model.dart';
import 'package:shop/models/products_details.dart';
import 'package:shop/models/search_model.dart';
import 'package:shop/models/update_cart_model.dart';
import 'package:shop/models/user_model.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  late Categories categoriesModel;
  List<CategoryData>? categories = [];

  void getCategories() async {
    emit(HomeGetCategoriesLoadingState());
    try {
      Response _respones = await DioHelper.getData(url: kCategories);

      categoriesModel = Categories.fromJson(_respones.data);
      categories = categoriesModel.data!.data;
      emit(HomeGetCategoriesSuccessState());
    } catch (error) {
      print(error);
      emit(HomeGetCategoriesErrorState(error.toString()));
    }
  }

  late HomeData homeData;
  List<Banners>? banners = [];
  List<Products>? products = [];
  Map<int?, bool?> favorites = {};
  Map<int?, bool?> cart = {};

  void getHomeData() async {
    emit(HomeGetDataLoadingState());

    try {
      Response _response =
          await DioHelper.getData(url: kHomeData, token: token);
      homeData = HomeData.fromJson(_response.data);
      banners = homeData.data!.banners;
      products = homeData.data!.products;

      for (var product in homeData.data!.products!) {
        favorites.addAll({product.id: product.inFavorites});
      }
      for (var product in homeData.data!.products!) {
        cart.addAll({product.id: product.inCart});
      }
    } catch (error) {
      print(error);
      emit(HomeGetDataErrorState(error.toString()));
    }
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int? productId) async {
    emit(HomeChangeFavoritesLoadingState());

    favorites[productId] = !favorites[productId]!;
    emit(HomeGetFavoritesChangeState());

    try {
      Response _response = await DioHelper.postData(
          url: kfavorites, token: token, data: {'product_id': productId});
      changeFavoritesModel = ChangeFavoritesModel.fromJson(_response.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }

      emit(HomeChangeFavoritesSuccessState(changeFavoritesModel));
    } catch (error) {
      print(error.toString());
      favorites[productId] = !favorites[productId]!;
      emit(HomeChangeFavoritesErrorState(error.toString()));
    }
  }

  late FavoriteModel favoriteModel;

  void getFavorites() async {
    emit(HomeGetFavoritesLoadingState());

    try {
      Response _response = await DioHelper.getData(
        url: kfavorites,
        token: token,
      );
      favoriteModel = FavoriteModel.fromJson(_response.data);
      emit(HomeGetFavoritesSuccessState());
    } catch (error) {
      print(error.toString());
      emit(HomeGetFavoritesErrorState(error.toString()));
    }
  }

  ChangeCartModel? changeCartModel;

  void addToOrRemoveFromCart(int? productId) async {
    emit(HomeChangeCartLoadingState());

    cart[productId] = !cart[productId]!;
    emit(HomeGetCartChangeState());
    await DioHelper.postData(
        url: kCart,
        token: token,
        data: {'product_id': productId}).then((value) {
      print(value.data);
      changeCartModel = ChangeCartModel.fromJson(value.data);
      if (!changeCartModel!.status!) {
        cart[productId] = !cart[productId]!;
      } else {
        getCart();
      }

      emit(HomeChangeCartSuccessState(changeCartModel));
    }).catchError((error) {
      print(error.toString());
      cart[productId] = !cart[productId]!;
      emit(HomeChangeCartErrorState(error.toString()));
    });
  }

  CartModel? cartModel;

  void getCart() async {
    emit(HomeGetCartLoadingState());
    await DioHelper.getData(
      url: kCart,
      token: token,
    ).then((value) {
      print(value.data);
      cartModel = CartModel.fromJson(value.data);
      CacheHelper.setData(
          key: 'CartLength', value: cartModel?.data!.cartItems!.length);
      print('Cart Length ${cartModel?.data?.cartItems?.length}');
      emit(HomeGetCartSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetCartErrorState(error.toString()));
    });
  }

  List<int> counter = [];

  quantityIncrement(int index) {
    if (counter.length < cartModel!.data!.cartItems!.length) {
      counter.add(1);
    }
    counter[index]++;
    emit(HomeQuantityIncrementState());
  }

  quantityDecrement(int index) {
    if (counter.length < cartModel!.data!.cartItems!.length) {
      counter.add(1);
    }
    counter[index]--;
    if (counter[index] < 1) {
      counter[index] = 1;
    }
    emit(HomeQuantityDecrementState());
  }

  UpdateCartModel? updateCartModel;

  Future updateCart(int? cartProductId, int quantity) async {
    emit(HomeUpdateCartLoadingState());
    await DioHelper.putData(
        url: kCart + '/' + '$cartProductId',
        token: token,
        data: {'quantity': quantity}).then((value) {
      print(value.data);
      updateCartModel = UpdateCartModel.fromJson(value.data);
      getCart();
      emit(HomeUpdateCartSuccessState(updateCartModel));
    }).catchError((error) {
      print(error.toString());
      emit(HomeUpdateCartErrorState(error.toString()));
    });
  }

  DeleteCartModel? deleteCartModel;

  void deleteCart(int? cartId) async {
    emit(HomeDeleteCartLoadingState());
    await DioHelper.deleteData(url: kCart + '/' + '$cartId', token: token)
        .then((value) {
      print(value.data);
      deleteCartModel = DeleteCartModel.fromJson(value.data);
      getCart();
      emit(HomeDeleteCartSuccessState(deleteCartModel));
    }).catchError((error) {
      print(error.toString());
      emit(HomeDeleteCartErrorState(error.toString()));
    });
  }

  late ProductsByCategoryModel productsByCategoryModel;

  Future getProductsByCategory(int? id) async {
    emit(HomeGetProductsByCategoryLoadingState());
    await DioHelper.getData(
        url: kGetProductsByCategory,
        token: token,
        query: {'category_id': id}).then((value) {
      print(value.data);
      productsByCategoryModel = ProductsByCategoryModel.fromJson(value.data);
      emit(HomeGetProductsByCategorySuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetProductsByCategoryErrorState(error.toString()));
    });
  }

  bool isDetailsPressed = false;
  IconData iconData = Icons.arrow_drop_down;

  changeExtendDetails() {
    isDetailsPressed = !isDetailsPressed;
    iconData = isDetailsPressed ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    emit(HomeChangeExtendDetailsState());
  }

  late ProductsDetails productsDetails;

  Future getProductsDetails(int? id) async {
    emit(HomeGetProductsDetailsLoadingState());
    await DioHelper.getData(
      url: kGetProductDetails + '$id',
      token: token,
    ).then((value) {
      print(value.data);
      productsDetails = ProductsDetails.fromJson(value.data);
      emit(HomeGetProductsDetailsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetProductsByCategoryErrorState(error.toString()));
    });
  }

  SearchModel? searchModel;

  void searchProducts(String value) async {
    emit(HomeGetSearchLoadingState());
    await DioHelper.postData(
      url: kSearch,
      token: token,
      data: {'text': value},
    ).then((value) {
      // print(value.data);
      print('Search method ');
      searchModel = SearchModel.fromJson(value.data);
      emit(HomeGetSearchSuccessState(searchModel));
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetSearchErrorState(error.toString()));
    });
  }

  late UserModel userModel;

  void getUserData() async {
    emit(HomeGetUserDataLoadingState());
    await DioHelper.getData(url: kProfile, token: token).then((value) {
      userModel = UserModel.fromJson(value.data);
      emit(HomeGetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetUserDataErrorState(error.toString()));
    });
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? image,
  }) async {
    emit(HomeUpdateUserDataLoadingState());
    await DioHelper.putData(url: kUpdateProfile, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image
    }).then((value) {
      print(value.data);
      emit(HomeUpdateUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeUpdateUserDataErrorState(error.toString()));
    });
  }

  void logout(context) {
    CacheHelper.removeData(key: 'token').then((value) {
      if (value) {
        navigateAndRemove(context, LoginScreen());
      }
    });
  }

  Position? position;
  Placemark? address;

  pickMyCurrentLocation() async {
    emit(HomeGetCurrentLocationLoading());
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('latitude is ${position?.latitude}');
      print('longitude is ${position?.longitude}');
      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position!.latitude, position!.longitude);
        address = placemarks.first;

        print(address?.country);
        emit(HomeGetCurrentLocationSuccess());
      }
    } else {
      await Geolocator.openLocationSettings();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print('permission denied');
        emit(HomeGetCurrentLocationError('permission denied'));
      } else if (permission == LocationPermission.deniedForever) {
        print('permission denied forever');
        emit(HomeGetCurrentLocationError('permission denied forever'));
      }
      print('not enabled');
    }
  }

  String radioValue = 'home';

  homeOnChanged(value) {
    radioValue = value;
    emit(HomeRadioButtonHomeState());
  }

  workOnChanged(value) {
    radioValue = value;
    emit(HomeRadioButtonWorkState());
  }

  String? selectedAddress = '0';

  addressRadioOnChanged(value) {
    selectedAddress = value;
    emit(HomeAddressRadioButtonHomeState());
  }

  String? selectedPaymentMethod = 'cash';

  paymentMethodRadioOnChanged(value) {
    selectedPaymentMethod = value;
    emit(HomePaymentMethodRadioButtonHomeState());
  }

  AddAddressModel? addAddressModel;

  Future postAddress({
    required String name,
    required String city,
    required String region,
    required String details,
    dynamic latitude,
    dynamic longitude,
    required String notes,
  }) async {
    emit(HomePostAddressLoading());
    await DioHelper.postData(
            url: kAddresses,
            data: {
              'name': name,
              'city': city,
              'region': region,
              'details': details,
              'latitude': latitude,
              'longitude': longitude,
              'notes': notes
            },
            token: token)
        .then((value) {
      print(value.data);
      addAddressModel = AddAddressModel.fromJson(value.data);
      getUserAddress();
      emit(HomePostAddressSuccess(addAddressModel));
    }).catchError((error) {
      print(error.toString());
      emit(HomePostAddressError(error.toString()));
    });
  }

  late AddressModel addressModel;

  Future getUserAddress() async {
    emit(HomeGetAddressLoading());
    await DioHelper.getData(url: kAddresses, token: token).then((value) {
      print(value.data);
      addressModel = AddressModel.fromJson(value.data);
      emit(HomeGetAddressSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetAddressError(error.toString()));
    });
  }

  DeleteAddressModel? deleteAddressModel;

  deleteUserAddress({required int? addressId}) async {
    emit(HomeDeleteAddressLoading());
    await DioHelper.deleteData(url: kAddresses + '/$addressId', token: token)
        .then((value) {
      print(value.data);
      deleteAddressModel = DeleteAddressModel.fromJson(value.data);
      getUserAddress();
      emit(HomeDeleteAddressSuccess(deleteAddressModel));
    }).catchError((error) {
      print(error.toString());
      emit(HomeDeleteAddressError(error.toString()));
    });
  }

  AddOrderModel? addOrderModel;

  Future addOrder(
      {required int addressId,
      required int paymentMethod,
      required bool usePoints,
      required int promoCodeId}) async {
    emit(HomeAddOrderLoadingState());
    await DioHelper.postData(
            url: kOrders,
            data: {
              'address_id': addressId,
              'payment_method': paymentMethod,
              'use_points': usePoints,
              'promo_code_id': promoCodeId,
            },
            token: token)
        .then((value) {
      print(value.data);
      addOrderModel = AddOrderModel.fromJson(value.data);
      cartModel?.data!.cartItems!.clear();
      // deleteCart();
      emit(HomeAddOrderSuccessState(addOrderModel));
    }).catchError((error) {
      print(error.toString());
      emit(HomeAddOrderErrorState(error.toString()));
    });
  }

  late OrderModel orderModel;

  Future getOrders() async {
    emit(HomeGetOrdersLoadingState());
    await DioHelper.getData(url: kOrders, token: token).then((value) {
      print(value.data);
      orderModel = OrderModel.fromJson(value.data);
      emit(HomeGetOrdersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetOrdersErrorState(error.toString()));
    });
  }

  late OrderDetailsModel orderDetailsModel;

  Future getOrderDetails(int? orderId) async {
    emit(HomeGetOrderDetailsLoadingState());
    try {
      await DioHelper.getData(url: kOrders + '/' + '$orderId', token: token)
          .then((value) {
        print(value.data);
        orderDetailsModel = OrderDetailsModel.fromJson(value.data);
        emit(HomeGetOrderDetailsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(HomeGetOrderDetailsErrorState(error.toString()));
      });
    } catch (error) {
      print(error.toString());
      emit(HomeGetOrderDetailsErrorState(error.toString()));
    }
  }
}
