import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color kDefaultColor = Color(0xFFFFDE59);

TextStyle appBarStyle(context) => Theme.of(context)
    .textTheme
    .headline6!.copyWith(fontWeight: FontWeight.bold);

ThemeData lightTheme = ThemeData(
    fontFamily: 'Koho',
    iconTheme: IconThemeData(color: Colors.black),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(size: 30),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold)),
    textTheme: TextTheme(
      headline4: TextStyle(color: Colors.black),
        bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
    primarySwatch: Colors.amber,
    primaryColor: kDefaultColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: kDefaultColor),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kDefaultColor, systemNavigationBarColor: kDefaultColor),
      backgroundColor: Colors.white,
      elevation: 0.0,
    ));

ThemeData darkTheme = ThemeData.dark().copyWith(
    textTheme: TextTheme(
        bodyText1: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black, systemNavigationBarColor: Colors.black),
    ));
