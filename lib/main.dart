import 'dart:developer';
import 'package:blog_app/Pages/Home/HomePage.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/Pages/login_and_auth/LoginPage.dart';
import 'package:blog_app/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _sharedPreferences;
bool isLoggedIn = false;
Future<void> initializePrefs() async {
  log("Loading Shared Preferences");
  _sharedPreferences = await SharedPreferences.getInstance();
  log('Shared Preferences loaded');
  isLoggedIn = _sharedPreferences.getBool(IS_LOGGED_IN) ?? false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializePrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider.initialze(_sharedPreferences),
        ),
      ],
      child: Sizer(
        builder: ((context, orientation, deviceType) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightThemeData,
            home: (isLoggedIn == false) ? LoginPage() : HomePage(),
          );
        }),
      ),
    );
  }
}
