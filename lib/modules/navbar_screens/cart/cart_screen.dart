import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/cart_model.dart';
import 'package:shop/modules/navbar_screens/cart/check_order_screen.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/modules/navbar_screens/products/product_details_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/styles/themes.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeUpdateCartSuccessState) {
          if (!state.model.status) {
            showToast(
                toastText: state.model.message, toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.model.message, toastColor: ToastColor.SUCESS);
          }
        }

        if (state is HomeDeleteCartSuccessState) {
          if (!state.deleteCartModel.status) {
            showToast(
                toastText: state.deleteCartModel.message,
                toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.deleteCartModel.message,
                toastColor: ToastColor.SUCESS);
          }
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Cart',
              style: appBarStyle(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Conditional(
                      condition: cubit.cartModel.data.cartItems.isEmpty,
                      onConditionTrue: buildEmptyCart(context),
                      onConditionFalse: ListView.builder(
                          itemCount: cubit.cartModel.data.cartItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                padding: const EdgeInsets.all(10.0),
                                child: buildcartItem(
                                    cubit.cartModel.data.cartItems[index],
                                    cubit,
                                    index,
                                    context));
                          }),
                    )),
                Text(
                  'your total: ${kFormatCurrency.format(cubit.cartModel.data.total)}'
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                defaultButton('order now'.toUpperCase(), () {
                  cubit.getUserAddress().then((value) {
                    navigateTo(context, CheckOrderScreen());
                  });
                }, context)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildEmptyCart(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage('assets/images/empty_cart.png')),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          'Add Some Products To Your Cart',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget buildcartItem(CartItems model, HomeCubit cubit, index, context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 35,
        ),
      ),
      onDismissed: (direction) {
        cubit.deleteCart(model.id);
      },
      child: InkWell(
        onTap: () {
          cubit.getProductsDetails(model.cartProduct.id).then((value) {
            navigateTo(context, ProductDetailsScreen());
          });
        },
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image(
                image: NetworkImage('${model.cartProduct.image}'),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.cartProduct.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      model.cartProduct.discount != 0
                          ? Text(
                              '${model.cartProduct.oldPrice} ',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            )
                          : Container(),
                      Text(
                        '${kFormatCurrency.format(model.cartProduct.price)}',
                        style: TextStyle(
                            color: defaultColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildQuantityButton(Icons.remove, () {
                        cubit.quantityDecrement(index);
                        cubit
                            .updateCart(model.id, cubit.counter[index])
                            .then((value) {
                          print(value);
                        });
                      }),
                      Text(
                        '${model.quantity}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      buildQuantityButton(Icons.add, () {
                        cubit.quantityIncrement(index);
                        print(model.id);
                        cubit
                            .updateCart(model.id, cubit.counter[index])
                            .then((value) {
                          print(value);
                        });
                      }),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuantityButton(IconData icon, Function onPressed) {
    return MaterialButton(
      color: defaultColor,
      minWidth: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }
}
