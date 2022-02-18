import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/home_layout.dart';
import 'package:shop/modules/register/register_screen.dart';
import 'package:shop/shared/blocs/login_cubit/login_cubit.dart';
import 'package:shop/shared/blocs/login_cubit/login_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';
import 'package:shop/shared/widgets/export_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          print(state.error);

          showToast(
              toastText: 'Something wrong happened!', toastColor: ToastColor.ERROR);
        } else if (state is LoginSuccessState) {
          if (state.userModel!.status! == true) {
            navigateAndRemove(context, HomeLayout());
          } else {
            showToast(
                toastText: state.userModel!.message,
                toastColor: ToastColor.ERROR);
          }
        }
      },
      builder: (context, state) {
        var cubit = LoginCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back,',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Sign in to continue!',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DefaultTextFormField(
                          label: 'Email',
                          controller: emailController,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultTextFormField(
                        label: 'Password',
                        controller: passwordController,
                        prefixIcon: Icons.lock_outline,
                        isPassword: cubit.isPasswordInvisible,
                        onSubmit: (String value) {
                          _login(cubit);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password cannot be too short';
                          }
                        },
                        onIconPressed: cubit.changePasswordVisibility,
                        suffixIcon: cubit.suffixIcon,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      state is LoginLoadingState
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DefaultButton(
                              buttonText: 'login'.toUpperCase(),
                              onPressed: () {
                                _login(cubit);
                              }),
                      const SizedBox(
                        height: 15,
                      ),
                      _registerLine(context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Row _registerLine(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.normal),
        ),
        TextButton(
            onPressed: () {
              navigateTo(context, RegisterScreen());
            },
            child: Text('Register',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: kDefaultColor)))
      ],
    );
  }

  void _login(cubit) {
    if (formKey.currentState!.validate()) {
      cubit.userLogin(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    }
  }
}
