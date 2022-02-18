import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/home_layout.dart';
import 'package:shop/models/address_model.dart';
import 'package:shop/modules/navbar_screens/account/address/add_address_screen.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';
import 'package:shop/shared/widgets/export_widget.dart';

class CheckOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeAddOrderSuccessState) {
          if (!state.addOrderModel!.status!) {
            showToast(
                toastText: state.addOrderModel!.message,
                toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.addOrderModel!.message,
                toastColor: ToastColor.SUCESS);
          }
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Check Order',
              style: appBarStyle(context),
            ),
          ),
          body: state is HomeAddOrderLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              buildCustomText('Choose Your Address', context),
                              const SizedBox(height: 15.0),
                              cubit.addAddressModel == null
                                  ? MaterialButton(
                                      color: kDefaultColor,
                                      onPressed: () {
                                        navigateTo(context, AddAddressScreen());
                                      },
                                      child: Text('Add Address'),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: cubit
                                              .addressModel.data!.data
                                              .map((e) => buildRadioCard(
                                                  e: e,
                                                  cubit: cubit,
                                                  context: context))
                                              .toList(),
                                        ),
                                      )),
                              const SizedBox(height: 15.0),
                              buildCustomText('Payment Method', context),
                              const SizedBox(
                                height: 15.0,
                              ),
                              buildRadioCard(
                                  isPayment: true,
                                  cubit: cubit,
                                  context: context)
                            ],
                          ),
                        ),
                      ),
                      DefaultButton(
                          buttonText: 'Check Out',
                          onPressed: () {
                            print(cubit.selectedAddress);
                            if (cubit.selectedAddress == '0') {
                              showToast(
                                  toastText: 'Please choose your address',
                                  toastColor: ToastColor.ERROR);
                            } else {
                              cubit
                                  .addOrder(
                                      addressId:
                                          int.parse(cubit.selectedAddress!),
                                      paymentMethod: 1,
                                      usePoints: false,
                                      promoCodeId: 0)
                                  .then((value) {
                                navigateAndRemove(context, HomeLayout());
                              });
                            }
                          }),
                      const SizedBox(height: 4)
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget buildCustomText(String text, BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildRadioCard(
      {AddressData? e,
      HomeCubit? cubit,
      required BuildContext context,
      bool isPayment = false}) {
    return Card(
        child: ListTile(
      title: Text(
        isPayment ? 'Cash' : '${e!.city} , ${e.name}',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        isPayment ? 'Pay when you recieve your products' : '',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      trailing: Radio(
          value: isPayment ? 'cash' : '${e!.id}',
          groupValue:
              isPayment ? cubit!.selectedPaymentMethod : cubit!.selectedAddress,
          onChanged: (dynamic value) {
            isPayment
                ? cubit.paymentMethodRadioOnChanged(value)
                : cubit.addressRadioOnChanged(value);

            print('this is the value $value');
          }),
    ));
  }
}
