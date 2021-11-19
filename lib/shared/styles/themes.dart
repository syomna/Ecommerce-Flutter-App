import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color defaultColor = Color(0xFFff619b);

ThemeData lightTheme = ThemeData(
    fontFamily: 'Koho',
    iconTheme: IconThemeData(color: Colors.black),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(size: 30),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold)),
    textTheme: TextTheme(
      headline4: TextStyle(color: Colors.black),
        bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
    primarySwatch: Colors.pink,
    primaryColor: defaultColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: defaultColor),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: defaultColor, systemNavigationBarColor: defaultColor),
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
