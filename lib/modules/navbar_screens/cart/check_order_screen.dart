import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/home_layout.dart';
import 'package:shop/models/address_model.dart';
import 'package:shop/modules/navbar_screens/account/orders/orders_screen.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';

class CheckOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeAddOrderSuccessState) {
          if (!state.addOrderModel.status) {
            showToast(
                toastText: state.addOrderModel.message,
                toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.addOrderModel.message,
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
            body: Conditional(
              condition: state is HomeAddOrderLoadingState,
              onConditionTrue: Center(
                child: CircularProgressIndicator(),
              ),
              onConditionFalse: Padding(
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
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: cubit.addressModel.data.data
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
                                isPayment: true, cubit: cubit, context: context)
                          ],
                        ),
                      ),
                    ),
                    defaultButton('Check Out', () {
                      print(cubit.selectedAddress);
                      if (cubit.selectedAddress == '0') {
                        showToast(
                            toastText: 'Please choose your address',
                            toastColor: ToastColor.ERROR);
                      } else {
                        cubit
                            .addOrder(
                                addressId: int.parse(cubit.selectedAddress),
                                paymentMethod: 1,
                                usePoints: false,
                                promoCodeId: 0)
                            .then((value) {
                          navigateAndReplacment(context, HomeLayout());
                        });
                      }
                    }, context)
                  ],
                ),
              ),
            ));
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
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildRadioCard(
      {AddressData e,
      HomeCubit cubit,
      BuildContext context,
      bool isPayment = false}) {
    return Card(
        child: ListTile(
      title: Text(
        isPayment ? 'Cash' : '${e.city} , ${e.name}',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        isPayment ? 'Pay when you recieve your products' : '',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      trailing: Radio(
          value: isPayment ? 'cash' : '${e.id}',
          groupValue:
              isPayment ? cubit.selectedPaymentMethod : cubit.selectedAddress,
          onChanged: (value) {
            isPayment
                ? cubit.paymentMethodRadioOnChanged(value)
                : cubit.addressRadioOnChanged(value);

            print('this is the value $value');
          }),
    ));
  }
}
