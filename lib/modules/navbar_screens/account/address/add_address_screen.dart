import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/account/address/address_screen.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class AddAddressScreen extends StatelessWidget {
  final cityController = TextEditingController();

  final regionController = TextEditingController();

  final detailsController = TextEditingController();

  final notesController = TextEditingController();

  final latitudeController = TextEditingController();

  final longitudeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomePostAddressSuccess) {
          if (!state.addAddressModel!.status!) {
            showToast(
                toastText: state.addAddressModel!.message,
                toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.addAddressModel!.message,
                toastColor: ToastColor.SUCESS);
          }
        }
        if (state is HomeGetCurrentLocationSuccess) {
          showToast(
              toastText: 'Your location got picked successfully',
              toastColor: ToastColor.SUCESS);
        }
        if (state is HomeGetCurrentLocationError) {
          showToast(
              toastText: state.error.toString(), toastColor: ToastColor.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
       
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Adress',
              style: appBarStyle(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildRadioButtons(cubit, context),
                    const SizedBox(
                      height: 10.0,
                    ),
                    state is HomeGetCurrentLocationLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _pickCurrentLocationButton(cubit, context),
                    const SizedBox(
                      height: 20.0,
                    ),
                  
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultTextField(
                      label: 'notes',
                      controller: notesController,
                      prefixIcon: Icons.book,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please type some notes';
                        }
                      },
                    ),
               
                    const SizedBox(
                      height: 20.0,
                    ),
                    state is HomePostAddressLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : defaultButton('Save Address', () {
                            if (formKey.currentState!.validate()) {
                              if (cubit.address != null) {
                                cubit
                                    .postAddress(
                                        name: cubit.radioValue,
                                        city: cubit.address!.administrativeArea!,
                                        region: cubit.address!.locality!,
                                        details: cubit.address!.street!,
                                        notes: notesController.text,
                                        latitude:
                                            cubit.position?.latitude,
                                        longitude:
                                            cubit.position?.longitude)
                                    .then((value) {
                                  navigateAndReplacment(
                                      context, AddressSreen());
                                });
                              } else {
                                showToast(
                                    toastText: 'pick your address location',
                                    toastColor: ToastColor.ERROR);
                              }
                            }
                          }, context)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildRadioButtons(HomeCubit cubit, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Radio(
            value: 'home',
            groupValue: cubit.radioValue,
            onChanged: (dynamic value) {
              print(value);
              cubit.homeOnChanged(value);
            }),
        Text(
          'Home',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Radio(
            value: 'work',
            groupValue: cubit.radioValue,
            onChanged: (dynamic value) {
              print(value);
              cubit.workOnChanged(value);
            }),
        Text(
          'Work',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  _pickCurrentLocationButton(HomeCubit cubit, context) {
    return MaterialButton(
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: defaultColor, width: 1.5),
          borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(
          'Pick My Current Location',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: Icon(
          Icons.location_on,
          color: defaultColor,
        ),
      ),
      onPressed: () async {
        await cubit.pickMyCurrentLocation();
      },
    );
  }
}
