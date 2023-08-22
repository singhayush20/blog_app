import 'dart:developer';

import 'package:blog_app/Pages/Home/HomePage.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/Pages/login_and_auth/ForgetPassword.dart';
import 'package:blog_app/Pages/login_and_auth/RegisterScreen.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool isPasswordVisible = false;
  late SharedPreferences _sharedPreferences;
  void initializePreference() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initializePreference();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        //AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Connect',
          ),
        ),
        body: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: Container(
                height: 100, width: 100, child: const CustomLoadingIndicator()),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
            height: height,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                    child: Image.asset('images/BlogImage.png',
                        height: 200, fit: BoxFit.fill),
                  ),
                  Container(
                    height: height * 0.05,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                      height: height * 0.3,
                      decoration: formFieldBoxDecoration,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Form(
                        key: _formKey,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: constraints.maxHeight * 0.4,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    controller: _emailController,
                                    obscureText: false,
                                    style: const TextStyle(color: Colors.black),
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email cannot be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration:
                                        inputFormFieldBoxDecoration.copyWith(
                                      hintText: "Email",
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.circleUser,
                                      ),
                                    ),
                                  ),
                                ),
                                //====PASSWORD====
                                SizedBox(
                                  height: constraints.maxHeight * 0.1,
                                ),
                                Container(
                                  height: constraints.maxHeight * 0.4,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: !isPasswordVisible,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Password cannot be empty';
                                      } else if (value.length < 8) {
                                        return "Password must be at least 8 characters long";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration:
                                        inputFormFieldBoxDecoration.copyWith(
                                      hintText: "Password",
                                      prefixIcon: const Icon(
                                        FontAwesomeIcons.lock,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          (isPasswordVisible)
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              isPasswordVisible =
                                                  !isPasswordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.2,
                    ),
                    height: height * 0.05,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_emailController.text.trim().isEmpty ||
                            _passwordController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Empty Fields",
                            "Email and password cannot be empty",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: snackbarBackgroundColor,
                            colorText: snackbarColorText,
                            snackStyle: SnackStyle.FLOATING,
                          );
                        }
                        if (_formKey.currentState!.validate() == true) {
                          context.loaderOverlay.show();
                          final API api = API();
                          final FirebaseMessaging messaging =
                              FirebaseMessaging.instance;
                          String? token = await messaging.getToken();
                          Map<String, dynamic> result = await api.login(
                              email: _emailController.text,
                              password: _passwordController.text,
                              deviceToken: token ?? 'null');
                          context.loaderOverlay.hide();
                          String code = result[CODE];
                          if (code == '2000') {
                            String token = result['data']['token'];
                            token = Bearer + token;
                            log('Saving token and setting login status to true $token');
                            _sharedPreferences.setString(BEARER_TOKEN, token);
                            _sharedPreferences.setString(
                                EMAIL, _emailController.text.trim());
                            _sharedPreferences.setBool(IS_LOGGED_IN, true);
                            _sharedPreferences.setInt(
                                USER_ID, result['data']['userId']);
                            Get.off(
                              () => const HomePage(),
                              transition: Transition.fade,
                              duration: const Duration(milliseconds: 800),
                            );
                            Get.snackbar(
                              "Logged In",
                              "You have been logged in successfully",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: snackbarBackgroundColor,
                              colorText: snackbarColorText,
                              snackStyle: SnackStyle.FLOATING,
                            );
                          } else {
                            Get.snackbar(
                              "${result[STATUS]}",
                              "Login has failed",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                      height: height * 0.05,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextButton(
                              onPressed: () {
                                Get.to(
                                  const ForgetPassword(),
                                  transition: Transition.leftToRight,
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              onPressed: () {
                                Get.to(
                                  const RegisterScreen(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(
                                    milliseconds: 100,
                                  ),
                                );
                              },
                              child: FittedBox(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
