
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/address_model.dart';

import 'package:shop/modules/navbar_screens/account/address/add_address_screen.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class AddressSreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeDeleteAddressSuccess) {
          if (!state.deleteAddressModel!.status!) {
            showToast(
                toastText: state.deleteAddressModel!.message,
                toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.deleteAddressModel!.message,
                toastColor: ToastColor.SUCESS);
          }
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Your Addresses',
              style: appBarStyle(context),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              navigateTo(context, AddAddressScreen());
            },
          ),
          body: Padding(
              padding: const EdgeInsets.all(10.0),
              child:
              cubit.addressModel.data!.data.isEmpty ? Center(
                  child: Text(
                    'Add your address',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ) : ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10.0,
                      );
                    },
                    itemCount: cubit.addressModel.data!.data.length,
                    itemBuilder: (context, index) {
                      return buildAddressBody(
                          cubit.addressModel.data!.data[index],
                          cubit,
                          index,
                          context);
                    }),
              ),
        );
      },
    );
  }

  Widget buildAddressBody(
      AddressData addressData, HomeCubit cubit, int index, context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: ObjectKey(cubit.addressModel.data!.data[index]),
      background: Container(
        padding: const EdgeInsets.only(left: 20.0),
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 25,
        ),
      ),
      onDismissed: (direction) {
        cubit.addressModel.data!.data.removeAt(index);
        cubit.deleteUserAddress(addressId: addressData.id);
      },
      child: Card(
        child: ListTile(
          leading: Icon(
            addressData.name == 'home' ? Icons.home : Icons.work,
            color: kDefaultColor,
          ),
          title: Text(
            '${addressData.name!.toUpperCase()}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(
            '${addressData.city}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
