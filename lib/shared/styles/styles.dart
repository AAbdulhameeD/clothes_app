 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


ThemeData lightTheme = ThemeData(
  fontFamily: 'Jannah',

  textTheme: TextTheme(
    subtitle1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25.0,
      color: Colors.black,
    ),
    subtitle2: TextStyle(
      fontFamily: 'Jannah',
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      color: Colors.white,
    ),
  ),
  primaryColor: Colors.redAccent,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(

    backgroundColor: Colors.red,
    showSelectedLabels: false,
    selectedLabelStyle:TextStyle(fontWeight: FontWeight.bold,color: Colors.amber,fontSize: 20.0) ,
    selectedIconTheme:IconThemeData(
      size: 24.0,
      color: Colors.amber
    ) ,
    unselectedIconTheme: IconThemeData(
      size: 18.0,
      color: Colors.white,
    ),
    unselectedLabelStyle: TextStyle(fontSize: 15.0,color: Colors.white),
    unselectedItemColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.amber,
    elevation: 60.0,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    // for status bar options
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        // statusBarBrightness:  Brightness.light,
        statusBarColor: Colors.white,
      ),
      color: Colors.white,
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25.0),
      elevation: 0.0),
);
