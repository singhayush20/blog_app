import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/login_and_auth/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: ((context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: lightThemeData,
          home: const LoginPage(),
        );
      }),
    );
  }
}
