import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color defaultColor = Color(0xFF536DFE);

ThemeData lightTheme = ThemeData(
    fontFamily: 'Koho',
    iconTheme: IconThemeData(color: Colors.black),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(size: 30),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold)),
    textTheme: TextTheme(
        bodyText1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    primarySwatch: Colors.indigo,
    primaryColor: defaultColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: defaultColor),
      backwardsCompatibility: false,
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
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black, systemNavigationBarColor: Colors.black),
    ));
