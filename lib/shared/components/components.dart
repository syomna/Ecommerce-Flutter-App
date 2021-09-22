import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/home_model.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/products/all_products_screen.dart';
import 'package:shop/modules/navbar_screens/products/product_by_category_screen.dart';
import 'package:shop/modules/navbar_screens/products/product_details_screen.dart';
import 'package:shop/shared/styles/themes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final kFormatCurrency =
    NumberFormat.simpleCurrency(locale: 'en_EG', name: 'EG ');

TextStyle appBarStyle(context) =>
    Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold);


Widget defaultTextField(
    {@required String label,
    @required TextEditingController controller,
    @required IconData prefixIcon,
    @required Function validator,
    TextInputType keyboardType,
    Function onSubmit,
    Function onIconPressed,
    bool isPassword = false,
    IconData suffixIcon}) {
      
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: isPassword,
    keyboardType: keyboardType,
    onFieldSubmitted: onSubmit,
    decoration: InputDecoration(
      suffixIcon: IconButton(
        icon: Icon(suffixIcon),
        onPressed: onIconPressed,
      ),
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(
        borderSide: BorderSide(),
        borderRadius: BorderRadius.circular(10),
      ),
      labelText: label,
    ),
  );
}

Widget defaultButton(String buttonText, Function onPressed, context,
    {bool isUpdate = false, Color color = defaultColor}) {
  return MaterialButton(
      color: isUpdate ? Colors.green : color,
      padding: const EdgeInsets.all(15.0),
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        buttonText,
        style:
            Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
      ),
      onPressed: onPressed);
}

navigateAndReplacment(context, Widget widget) => Navigator.of(context)
    .pushReplacement(MaterialPageRoute(builder: (context) => widget));

navigateTo(context, Widget widget) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));

Future<bool> showToast(
        {@required String toastText, @required ToastColor toastColor}) =>
    Fluttertoast.showToast(
        msg: '$toastText',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: toastBackgroundColor(toastColor),
        textColor: Colors.white,
        fontSize: 16.0);

Color toastBackgroundColor(ToastColor toast) {
  Color color;
  switch (toast) {
    case ToastColor.SUCESS:
      color = Colors.green;
      break;

    case ToastColor.ERROR:
      color = Colors.red;
      break;
  }
  return color;
}

enum ToastColor { SUCESS, ERROR }

Widget buildSmoothPageIndicator(
    {@required PageController pageController, @required int listLength}) {
  return SmoothPageIndicator(
      controller: pageController, // PageController
      count: listLength,
      effect: ExpandingDotsEffect(), // your preferred effect
      onDotClicked: (index) {});
}

Widget buildGridItems(model, context, HomeCubit cubit) {
  return InkWell(
    onTap: () {
      cubit.getProductsDetails(model.id).then((value) {
        navigateTo(context, ProductDetailsScreen());
      });
    },
    child: Container(
      padding: const EdgeInsets.only(left: 8.0),
      margin: const EdgeInsets.all(10.0),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
              //  alignment: AlignmentDirectional.bottomStart,

              children: [
                model.image == null
                    ? Center(
                        child: Icon(Icons.image_search),
                      )
                    : Image(
                        height: MediaQuery.of(context).size.height * 0.18,
                        image: NetworkImage('${model.image}'),
                      ),
                model.discount != 0
                    ? Container(
                        color: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.2,
                        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 0, 2.0),
                        child: Text(
                          '${model.discount} % off'.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container()
              ]),
          Spacer(),
          Text(
            '${model.name}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Row(
            children: [
              model.oldPrice == null || model.oldPrice == model.price
                  ? Container()
                  : Text(
                      '${model.oldPrice}',
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
              Spacer(),
              Text(
                '${kFormatCurrency.format(model.price)}',
                style:
                    TextStyle(color: defaultColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: MaterialButton(
                    padding: const EdgeInsets.all(2.0),
                    color: cubit.cart[model.id] ? defaultColor : Colors.grey,
                    onPressed: () {
                      cubit.addToOrRemoveFromCart(model.id);
                    },
                    child: Text(
                      cubit.cart[model.id]
                          ? 'added to cart'.toUpperCase()
                          : 'add to cart'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              IconButton(
                onPressed: () {
                  cubit.changeFavorites(model.id);
                },
                icon: cubit.favorites[model.id]
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border),
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget categoriesContainer(CategoryData category, HomeCubit cubit, context) {
  return InkWell(
    onTap: () {
      cubit.getProductsByCategory(category.id).then((value) {
        print(category.id.toString());
        print(value);
        print(
            'the products by category ${cubit.productsByCategoryModel.data.data.length}');
        navigateTo(context, ProductsByCategoryScreen('${category.name}'));
      });
    },
    child: Container(
      width: MediaQuery.of(context).size.width * 0.3,
      margin: EdgeInsets.all(10.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage('${category.image}'),
            fit: BoxFit.fill,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            child: Text(
              '${category.name}',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    ),
  );
}

Widget buildListViewItems(model, context, HomeCubit cubit,
    {bool isSearch = false}) {
  return InkWell(
    onTap: () {
      cubit.getProductsDetails(model.id).then((value) {
        navigateTo(context, ProductDetailsScreen());
      });
    },
    child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image(
                image: NetworkImage('${model.image}'),
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
                      '${model.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        model.oldPrice == null
                            ? Container()
                            : Text(
                                isSearch ? '' : '${model.oldPrice} ',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough),
                              ),
                        Text(
                          '${kFormatCurrency.format(model.price)}',
                          style: TextStyle(
                              color: defaultColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        )),
  );
}
