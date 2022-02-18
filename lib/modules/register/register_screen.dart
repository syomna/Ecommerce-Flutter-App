import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/home_layout.dart';
import 'package:shop/shared/blocs/register_cubit/register_cubit.dart';
import 'package:shop/shared/blocs/register_cubit/register_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/widgets/export_widget.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final phoneController = TextEditingController();

  final nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
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
          if (state.userModel!.status!) {
            navigateAndRemove(context, HomeLayout());
          } else {
            showToast(
                toastText: state.userModel!.message,
                toastColor: ToastColor.ERROR);
          }
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: _registerBody(context, cubit, state),
        );
      },
    );
  }

  void _register(cubit) async {
    if (formKey.currentState!.validate()) {
      await cubit.userRegister(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
          phone: phoneController.text.trim());
    }
  }

  Widget _registerBody(
      BuildContext context, RegisterCubit cubit, RegisterStates state) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up for a new account,',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Register to get started!',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(
                height: 30,
              ),
              DefaultTextFormField(
                label: 'Name',
                controller: nameController,
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter your name';
                  }
                },
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 10,
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
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              DefaultTextFormField(
                label: 'Phone',
                controller: phoneController,
                prefixIcon: Icons.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter your phone number';
                  }
                },
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 10,
              ),
              DefaultTextFormField(
                  label: 'Password',
                  controller: passwordController,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: cubit.isPasswordInvisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  isPassword: cubit.isPasswordInvisible,
                  onSubmit: (value) {
                    _register(cubit);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'password cannot be too short';
                    }
                  },
                  onIconPressed: cubit.changePasswordVisibility,
                  keyboardType: TextInputType.number),
              const SizedBox(
                height: 30,
              ),
              state is RegisterLoadingState
                  ? Center(child: CircularProgressIndicator())
                  : DefaultButton(
                      buttonText: 'Register'.toUpperCase(),
                      onPressed: () {
                        _register(cubit);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
