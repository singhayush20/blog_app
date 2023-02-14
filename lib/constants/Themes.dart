import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

ThemeData lightThemeData = ThemeData(
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 50.sp,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w800,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    ),
  ),

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
      backgroundColor: elevatedButtonColor,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: textButtonTextColor,
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
    elevation: 4,
    backgroundColor: Color.fromARGB(255, 37, 37, 37),
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    selectedItemColor: Colors.white,
    unselectedItemColor: Color.fromARGB(255, 132, 131, 131),
    showUnselectedLabels: true,
    showSelectedLabels: false,
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
    prefixIconColor: Colors.green,
    suffixIconColor: Colors.greenAccent,
    hintStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    ),
    errorStyle: TextStyle(
      color: Colors.amberAccent,
      fontWeight: FontWeight.w500,
    ),
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.white70,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.amberAccent,
      ),
    ),
  ),
);

const Color appBarColor = Color.fromARGB(255, 7, 7, 7);
const Color elevatedButtonColor = Color.fromARGB(255, 177, 69, 69);
const Color scaffoldColor = Color.fromARGB(255, 0, 0, 0);
const Color appBarItemColor = Colors.white;
const Color textButtonTextColor = Colors.white;
BoxDecoration articleBoxDecoration = BoxDecoration(
  border: Border.all(color: Colors.black, width: 0.5, style: BorderStyle.solid),
  borderRadius: BorderRadius.all(
    Radius.circular(20),
  ),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.black,
      Colors.black45,
      Colors.black26,
    ],
  ),
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
  border:
      Border.all(color: Colors.white70, width: 0.5, style: BorderStyle.solid),
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ),
  color: appBarColor,
);

const snackbarBackgroundColor = Colors.white;
const snackbarColorText = Colors.black;
const customIndicatorColors = [
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.yellowAccent
];

//applied to auth pages form fields
InputDecoration formFieldDecoration = InputDecoration(
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
  prefixIconColor: Colors.green,
  suffixIconColor: Colors.greenAccent,
  hintStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 20,
  ),
  errorStyle: TextStyle(
    color: Colors.amberAccent,
    fontWeight: FontWeight.w500,
  ),
  border: UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: Colors.white70,
    ),
  ),
  errorBorder: UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: Colors.amberAccent,
    ),
  ),
);
//applied to auth pages form fields containers
BoxDecoration formFieldBoxDecoration = BoxDecoration(
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.3, 0.8, 1],
    colors: [
      Color.fromARGB(179, 75, 75, 75),
      Color.fromARGB(179, 75, 75, 75),
      Color.fromARGB(179, 75, 75, 75),
    ],
  ),
  border: Border.all(color: Colors.white, width: 1, style: BorderStyle.solid),
  borderRadius: BorderRadius.all(
    Radius.circular(20),
  ),
);
