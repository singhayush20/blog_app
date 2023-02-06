import 'dart:developer';

import 'package:blog_app/Pages/Home/HomePage.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/Pages/login_and_auth/ForgetPassword.dart';
import 'package:blog_app/Pages/login_and_auth/RegisterScreen.dart';
import 'package:blog_app/network_util/API.dart';
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.4, 0.7, 0.9],
          colors: [
            Color.fromARGB(255, 245, 233, 165),
            Color.fromARGB(255, 153, 238, 253),
            Color.fromARGB(255, 214, 255, 167),
            Color.fromARGB(255, 250, 242, 169),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
              child: Container(
                  height: 100, width: 100, child: CustomLoadingIndicator()),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                      height: height * 0.1,
                      alignment: Alignment.center,
                      child: Text(
                        'SFBlog',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                      height: height * 0.05,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: height * 0.2,
                        decoration: boxDecoration.copyWith(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.3, 0.8, 1],
                            colors: [
                              Color.fromARGB(255, 39, 80, 176),
                              Colors.lightBlue,
                              Colors.lightBlueAccent,
                            ],
                          ),
                          border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid),
                        ),
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
                                    height: constraints.maxHeight * 0.2,
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      controller: _emailController,
                                      obscureText: false,
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Email cannot be empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.circleUser,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  //====PASSWORD====
                                  SizedBox(
                                    height: constraints.maxHeight * 0.2,
                                  ),
                                  Container(
                                    height: constraints.maxHeight * 0.2,
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: !isPasswordVisible,
                                      cursorColor: Colors.white,
                                      style: TextStyle(color: Colors.white),
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
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: Colors.white,
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
                          context.loaderOverlay.show();
                          final API api = API();
                          Map<String, dynamic> result = await api.login(
                              email: _emailController.text,
                              password: _passwordController.text);
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
                              () => HomePage(),
                              transition: Transition.fade,
                              duration: const Duration(milliseconds: 800),
                            );
                            Get.snackbar(
                              "Logged In",
                              "You have been logged in successfully",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } else {
                            Get.snackbar(
                              "${result[STATUS]}",
                              "Login has failed",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgetPassword(),
                                    ),
                                  );
                                },
                                child: FittedBox(
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(
                                    RegisterScreen(),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(
                                      milliseconds: 600,
                                    ),
                                  );
                                },
                                child: FittedBox(
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      decoration: TextDecoration.underline,
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
      ),
    );
  }
}
