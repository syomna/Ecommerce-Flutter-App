import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';
import 'package:shop/shared/widgets/export_widget.dart';

class UpdateAccountScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeUpdateUserDataSuccessState) {
          showToast(
                  toastText: 'Profile Updated Successfully',
                  toastColor: ToastColor.SUCESS)
              .then((value) {
            HomeCubit.get(context).getUserData();
          });
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        nameController.text = cubit.userModel.data!.name!;
        emailController.text = cubit.userModel.data!.email!;
        phoneController.text = cubit.userModel.data!.phone!;
        if (cubit.userModel.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Update your account infos',
                style: appBarStyle(context),
              ),
            ),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is HomeUpdateUserDataLoadingState)
                        LinearProgressIndicator(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const SizedBox(
                        height: 20.0,
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
                        height: 20,
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
                        height: 20,
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
                        height: 20.0,
                      ),
                      state is HomeUpdateUserDataLoadingState
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DefaultButton(
                              buttonText: 'Update',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  print(cubit.userModel.data!.image);
                                  cubit.updateProfile(
                                    name: nameController.text,
                                    email: emailController.text.trim(),
                                    phone: phoneController.text.trim(),
                                  );
                                }
                              },
                              isUpdate: true),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
