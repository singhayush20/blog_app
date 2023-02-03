import 'dart:developer';

import 'package:blog_app/Pages/login_and_auth/RegisterDetails.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class VerifyEmailOTP extends StatefulWidget {
  String? email;
  VerifyEmailOTP({required String email}) {
    this.email = email;
  }

  @override
  State<VerifyEmailOTP> createState() => _VerifyEmailOTPState();
}

class _VerifyEmailOTPState extends State<VerifyEmailOTP> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final API api = API();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Verify OTP',
        ),
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
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.15,
                ),
                Container(
                  height: height * 0.1,
                  child: Text(
                    'You must have received an OTP on the email you just entered. Enter it here and click verify',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  height: height * 0.1,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: boxDecoration,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _otpController,
                      obscureText: false,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter OTP';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "OTP",
                        prefixIcon: Icon(
                          FontAwesomeIcons.key,
                          color: Colors.white,
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
                  child: ElevatedButton(
                    child: FittedBox(
                      child: Text(
                        "Verify",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        context.loaderOverlay.show();
                        Map<String, dynamic> result =
                            await api.verifyEmailVerificationOTP(
                                email: widget.email ?? 'null',
                                otp: _otpController.text);
                        log('email otp verification result: $result');
                        String? code = result['code'];
                        context.loaderOverlay.hide();
                        if (code == '2000') {
                          Get.to(
                            RegisterDetails(email: widget.email!),
                            transition: Transition.leftToRight,
                            duration: const Duration(
                              microseconds: 800,
                            ),
                          );
                          Get.snackbar("Success", "OTP Verified!",
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (code == '2001') {
                          Get.snackbar("Failed", "Verification failed!",
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  height: height * 0.05,
                  child: TextButton(
                    child: FittedBox(
                      child: Text(
                        "Didn't receive? Resend.",
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      context.loaderOverlay.show();
                      Map<String, dynamic> result = await api
                          .sendEmailVerificationOTP(email: widget.email!);
                      context.loaderOverlay.hide();
                      log('email otp sent again: $result');
                      String? code = result['code'];
                      if (code == '2000') {
                        Get.snackbar("OTP", "OTP resent");
                      } else {
                        Get.snackbar("Error", "OTP could not be sent!");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
