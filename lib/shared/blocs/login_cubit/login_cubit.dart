import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/user_model.dart';
import 'package:shop/shared/blocs/login_cubit/login_states.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPasswordInvisible = true;
  IconData suffixIcon = Icons.visibility;

  changePasswordVisibility() {
    isPasswordInvisible = !isPasswordInvisible;
    suffixIcon = isPasswordInvisible ? Icons.visibility : Icons.visibility_off;
    emit(LoginChangePasswordVisibilityState());
  }

  UserModel? userModel;

  void userLogin({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      Response response = await DioHelper.postData(
          url: kLogin, data: {'email': email, 'password': password});
          
      userModel = UserModel.fromJson(response.data);

      CacheHelper.setData(key: 'token', value: userModel!.data!.token)
          .then((value) {
        token = userModel?.data?.token;
        print(token);
      });
      
      emit(LoginSuccessState(userModel));

    } catch (error) {
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    }
  }
}
