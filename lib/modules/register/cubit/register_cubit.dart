import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/user_model.dart';
import 'package:shop/modules/register/cubit/register_states.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPasswordInvisible = true;
  IconData suffixIcon = Icons.visibility;

  changePasswordVisibility() {
    isPasswordInvisible = !isPasswordInvisible;
    suffixIcon = isPasswordInvisible ? Icons.visibility : Icons.visibility_off;
    emit(RegisterChangePasswordVisibilityState());
  }

  UserModel? userModel;

  void userRegister(
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    emit(RegisterLoadingState());
    try {
      Response response = await DioHelper.postData(url: kRegister, data: {
        'email': email,
        'password': password,
        'phone': phone,
        'name': name
      });
      if(response.statusCode != 200){
        print(response.statusMessage);
        emit(RegisterErrorState(response.statusMessage!));
      }
    
        print(response.data);
        userModel = UserModel.fromJson(response.data);
        token = userModel?.data?.token;
      
    } catch (error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    }
    //   await DioHelper.postData(url: kRegister, data: {
    //     'email': email,
    //     'password': password,
    //     'phone': phone,
    //     'name': name
    //   }).then((value) {
    //     print(value.data);
    //     userModel = UserModel.fromJson(value.data);
    //     token = userModel!.data!.token;
    //     emit(RegisterSuccessState(userModel));
    //   }).catchError((error) {
    //     print(error.toString());
    //     emit(RegisterErrorState(error));
    //   });
  }
}
