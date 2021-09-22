import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/layouts/home_layout.dart';
import 'package:shop/modules/register/cubit/register_cubit.dart';
import 'package:shop/modules/register/cubit/register_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/styles/themes.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  

  void _register(cubit) {
    if (formKey.currentState.validate()) {
      cubit.userRegister(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
          phone: phoneController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is RegisterErrorState) {
          print(state.error);
          showToast(
              toastText: state.error.toString(), toastColor: ToastColor.ERROR);
        } else if (state is RegisterSuccessState) {
          if (state.userModel.status) {
            showToast(
                    toastText: state.userModel.message,
                    toastColor: ToastColor.SUCESS)
                .then((value) {
              CacheHelper.setData(
                      key: 'token', value: state.userModel.data.token)
                  .then((value) {
                    token = state.userModel.data.token;
                navigateAndReplacment(context, HomeLayout());
              });
            });
            print(state.userModel.data.token);
          } else {
            showToast(
                toastText: state.userModel.message,
                toastColor: ToastColor.ERROR);
          }
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create account,',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: defaultColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Register to get started!',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.grey),
                    ),
                  const  SizedBox(
                      height: 30,
                    ),
                    defaultTextField(
                      label: 'Name',
                      controller: nameController,
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter your name';
                        }
                      },
                      keyboardType: TextInputType.name,
                    ),
                  const  SizedBox(
                      height: 20,
                    ),
                    defaultTextField(
                      label: 'Email',
                      controller: emailController,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter your email address';
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  const  SizedBox(
                      height: 20,
                    ),
                    defaultTextField(
                      label: 'Phone',
                      controller: phoneController,
                      prefixIcon: Icons.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter your phone number';
                        }
                      },
                      keyboardType: TextInputType.phone,
                    ),
                  const  SizedBox(
                      height: 20,
                    ),
                    defaultTextField(
                        label: 'Password',
                        controller: passwordController,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: cubit.suffixIcon,
                        isPassword: cubit.isPasswordInvisible,
                        onSubmit: (value) {
                          _register(cubit);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'password cannot be too short';
                          }
                        },
                        onIconPressed: cubit.changePasswordVisibility,
                        keyboardType: TextInputType.number),
                  const  SizedBox(
                      height: 30,
                    ),
                    state is RegisterLoadingState
                        ? Center(child: CircularProgressIndicator())
                        : defaultButton('Register'.toUpperCase(), () {
                            _register(cubit);
                          } , context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
