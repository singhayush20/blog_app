import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightThemeData = ThemeData(
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appBarColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      backgroundColor: appBarColor,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: appBarColor,
    ),
  ),
  //====APP BAR Theme
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: appBarItemColor,
      fontWeight: FontWeight.w900,
      fontSize: 30,
    ),
    iconTheme: IconThemeData(
      color: appBarItemColor,
    ),
    elevation: 0,
    shadowColor: Colors.white,
    color: appBarColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: appBarColor,
      statusBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: true,
    ),
  ),
  //==Scaffold==
  scaffoldBackgroundColor: scaffoldColor,
  //====BOTTOM NAVIGATION Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: appBarColor,
    selectedItemColor: Colors.white,
    unselectedItemColor: scaffoldColor,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    filled: false,
    suffixIconColor: Colors.white,
    hintStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    ),
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.white70,
      ),
    ),
  ),
);

const Color appBarColor = Color.fromARGB(255, 74, 20, 140);
const Color scaffoldColor = Color(0xFFF3E5F5);
const Color appBarItemColor = Colors.white;
BoxDecoration boxDecoration = BoxDecoration(
  border: Border.all(color: Colors.black, width: 0.5, style: BorderStyle.solid),
  borderRadius: BorderRadius.all(
    Radius.circular(20),
  ),
  color: Color(0xFF9C27B0),
);
