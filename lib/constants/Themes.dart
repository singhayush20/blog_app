import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

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
  //==== OUTLINED BUTTON THEME====
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 15.sp,
        fontWeight: FontWeight.w800,
      ),
    ),
  ),
  //====APP BAR Theme
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: appBarItemColor,
      fontWeight: FontWeight.w900,
      fontSize: 15.sp,
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
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    selectedItemColor: Color.fromARGB(255, 23, 34, 241),
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

const Color appBarColor = Color.fromARGB(255, 197, 58, 19);
const Color scaffoldColor = Color.fromARGB(255, 246, 233, 233);
const Color appBarItemColor = Colors.white;
BoxDecoration boxDecoration = BoxDecoration(
  border: Border.all(color: Colors.black, width: 0.5, style: BorderStyle.solid),
  borderRadius: BorderRadius.all(
    Radius.circular(20),
  ),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 39, 80, 176),
      Colors.lightBlue,
    ],
  ),
  color: Color.fromARGB(255, 39, 80, 176),
);

InputDecoration fieldDecoration(
    {required String label, required IconData icon}) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.black,
      fontSize: 10.sp,
    ),
    prefixIcon: Icon(
      icon,
      color: Colors.black,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    filled: false,
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
  );
}

BoxDecoration listTileDecoration = BoxDecoration(
  border: Border.all(
      color: Color.fromARGB(255, 60, 4, 78),
      width: 2,
      style: BorderStyle.solid),
  borderRadius: const BorderRadius.all(
    Radius.circular(20),
  ),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 243, 240, 244),
      Color.fromARGB(255, 249, 246, 177),
      Color.fromARGB(255, 199, 221, 54),
    ],
    stops: [0.2, 0.5, 1],
  ),
);

BoxDecoration categoryTopDecoration = BoxDecoration(
  border: Border.all(color: Colors.black, width: 0.5, style: BorderStyle.solid),
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 39, 80, 176),
      Colors.lightBlue,
    ],
  ),
  color: Color.fromARGB(255, 39, 80, 176),
);
