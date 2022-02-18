import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

final kFormatCurrency =
    NumberFormat.simpleCurrency(locale: 'en_EG', name: 'EG ');

navigateAndRemove(context, Widget widget) =>
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget), (route) => false);

navigateTo(context, Widget widget) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));

Future<bool?> showToast(
        {required String? toastText, required ToastColor toastColor}) =>
    Fluttertoast.showToast(
        msg: '$toastText',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: toastBackgroundColor(toastColor),
        textColor: Colors.white,
        fontSize: 16.0);

Color? toastBackgroundColor(ToastColor toast) {
  Color? color;
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

List<OnBoardingData> onBoarding = [
  OnBoardingData(
      title: 'Shopping Online',
      subtitle: 'We help you to get what you want in the most easiest way!',
      image: 'assets/images/onboarding_one.png'),
  OnBoardingData(
      title: 'Adding To Cart',
      subtitle: 'Collect your products to order them in one package!',
      image: 'assets/images/onboarding_two.png'),
  OnBoardingData(
      title: 'Delivery',
      subtitle: 'Order and get your products wherever you are!',
      image: 'assets/images/onboarding_three.png'),
];

class OnBoardingData {
  String title;
  String subtitle;
  String image;

  OnBoardingData(
      {required this.title, required this.subtitle, required this.image});
}
