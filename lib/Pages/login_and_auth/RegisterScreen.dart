import 'dart:developer';

import 'package:blog_app/Pages/login_and_auth/VerifyEmailOTP.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final API api = API();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Container(
            height: 100,
            width: 100,
            child: const CustomLoadingIndicator(),
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                Container(
                  height: height * 0.1,
                  alignment: Alignment.center,
                  child: Text(
                    'Enter the email address you want to use for your account',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  height: height * 0.2,
                  decoration: formFieldBoxDecoration,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: constraints.maxHeight * 0.1,
                            ),
                            Container(
                              height: constraints.maxHeight * 0.5,
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: _emailController,
                                obscureText: false,
                                style: const TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.fade,
                                ),
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
                            SizedBox(
                              height: constraints.maxHeight * 0.1,
                            ),
                            Container(
                              height: constraints.maxHeight * 0.2,
                              child: ElevatedButton(
                                child: const Text(
                                  "Send OTP",
                                ),
                                onPressed: () async {
                                  if (_emailController.text.isEmail) {
                                    context.loaderOverlay.show();

                                    String email = _emailController.text;
                                    Map<String, dynamic> result = await api
                                        .sendEmailVerificationOTP(email: email);

                                    log('result from fetching email otp: $result');
                                    context.loaderOverlay.hide();
                                    String? code = result[CODE];
                                    if (code == '2000') {
                                      Get.to(
                                        VerifyEmailOTP(email: email),
                                        transition: Transition.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 800),
                                      );
                                      Get.snackbar(
                                        "Successful",
                                        "OTP has been sent successfully!",
                                        snackPosition: SnackPosition.BOTTOM,
                                        snackStyle: SnackStyle.FLOATING,
                                        backgroundColor:
                                            snackbarBackgroundColor,
                                        colorText: snackbarColorText,
                                      );
                                    } else {
                                      Get.snackbar(
                                        "${result[STATUS]}",
                                        "Failed to send OTP!",
                                        backgroundColor:
                                            snackbarBackgroundColor,
                                        colorText: snackbarColorText,
                                      );
                                    }
                                  } else {
                                    Get.snackbar(
                                      "Invalid Email",
                                      "Please check the email you entered!",
                                      snackPosition: SnackPosition.BOTTOM,
                                      snackStyle: SnackStyle.FLOATING,
                                      backgroundColor: snackbarBackgroundColor,
                                      colorText: snackbarColorText,
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
