import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

ThemeData lightThemeData = ThemeData(
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: Colors.red,
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Colors.red,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: const TextStyle(
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
    //for article content

    bodySmall: TextStyle(
      fontSize: 15.sp,
      color: Colors.amber,
      fontWeight: FontWeight.w500,
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
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
      textStyle: const TextStyle(
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
      fontSize: 20.sp,
    ),
    iconTheme: const IconThemeData(
      color: appBarItemColor,
    ),
    color: appBarColor,
    elevation: 0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: appBarColor,
      statusBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: appBarColor,
    ),
  ),
  //==Scaffold==

  scaffoldBackgroundColor: scaffoldColor,
  //====BOTTOM NAVIGATION Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 4,
    backgroundColor: scaffoldColor,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    selectedItemColor: Color.fromARGB(255, 2, 2, 2),
    unselectedItemColor: Color.fromARGB(255, 132, 131, 131),
    showUnselectedLabels: true,
    showSelectedLabels: true,
    type: BottomNavigationBarType.shifting,
  ),

  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: const BorderSide(
        color: appBarColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    filled: false,
    prefixIconColor: formFieldIconColor,
    suffixIconColor: formFieldIconColor,
    hintStyle: const TextStyle(
      color: Colors.black26,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    ),
    errorStyle: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w500,
    ),
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Colors.black,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
  ),
);

const Color appBarColor = Color(0xFFD35C26);
const Color formFieldIconColor = Color(0xFF3958CE);
const Color elevatedButtonColor = Color(0xFF3958CE);
const Color scaffoldColor = Color(0xFFF2F3FA);
const Color appBarItemColor = Colors.white;
const Color textButtonTextColor = Colors.white;
BoxDecoration articleBoxDecoration = BoxDecoration(
  border: Border.all(color: Colors.black, width: 0.5, style: BorderStyle.solid),
  borderRadius: const BorderRadius.all(
    Radius.circular(5),
  ),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.black26,
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
      borderSide: const BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    filled: false,
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Colors.black,
      ),
    ),
  );
}

BoxDecoration listTileDecoration = BoxDecoration(
  border: Border.all(color: Colors.white70, width: 2, style: BorderStyle.solid),
  borderRadius: const BorderRadius.all(
    Radius.circular(20),
  ),
  color: Colors.black12,
);

BoxDecoration categoryTopDecoration = BoxDecoration(
  border:
      Border.all(color: Colors.white70, width: 0.5, style: BorderStyle.solid),
  borderRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ),
  // color: Color(0xFFD35C26),
  gradient: const LinearGradient(
    stops: [0.2, 0.4, 0.6, 0.8],
    colors: [
      appBarColor,
      Color.fromARGB(255, 233, 109, 51),
      Color.fromARGB(255, 248, 121, 62),
      Color.fromARGB(255, 246, 136, 85)
    ],
  ),
);
BoxDecoration profileBox1Decoration = BoxDecoration(
  border:
      Border.all(color: Colors.blueAccent, width: 2, style: BorderStyle.solid),
  borderRadius: const BorderRadius.all(
    Radius.circular(10),
  ),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 8, 66, 194),
      Color.fromARGB(255, 14, 118, 156),
    ],
  ),
);
const snackbarBackgroundColor = Color(0xFF91BED6);
const snackbarColorText = Colors.black;
const customIndicatorColors = [
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.yellowAccent
];

InputDecoration forgotPasswordFormFieldDecoration = InputDecoration(
  enabledBorder: UnderlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.black,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(20),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.black,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(20),
  ),
  filled: false,
  prefixIconColor: formFieldIconColor,
  suffixIconColor: formFieldIconColor,
  hintStyle: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 20,
  ),
  errorStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    height: 0,
  ),
  border: UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: Colors.blue,
    ),
  ),
  focusedErrorBorder: UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: Colors.blue,
    ),
  ),
  errorBorder: UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: Colors.blue,
    ),
  ),
);
//applied to auth pages form fields
InputDecoration inputFormFieldBoxDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.black,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(20),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.black,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(20),
  ),
  filled: false,
  prefixIconColor: formFieldIconColor,
  suffixIconColor: formFieldIconColor,
  hintStyle: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    height: 0,
  ),
  errorStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: Colors.blue,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: Colors.blue,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: Colors.blue,
    ),
  ),
);
//applied to auth pages form fields containers
BoxDecoration formFieldBoxDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 158, 203, 248),
  border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid),
  borderRadius: const BorderRadius.all(
    Radius.circular(20),
  ),
);
