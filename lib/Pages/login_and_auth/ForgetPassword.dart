import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool isPasswordVisible = false;

  final _confirmPasswordController = TextEditingController();

  final _otpController = TextEditingController();

  bool isOTPSent = false;
  @override
  Widget build(BuildContext context) {
    final API api = API();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Container(
              height: 100, width: 100, child: const CustomLoadingIndicator()),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                ),
                height: height * 0.1,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reset your password by verifying your registered email',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.55,
                decoration: formFieldBoxDecoration,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                  vertical: height * 0.02,
                ),
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, boxConstraints) {
                      return Column(
                        children: [
                          //====Email====
                          Container(
                            alignment: Alignment.center,
                            height: boxConstraints.maxHeight * 0.2,
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
                                  forgotPasswordFormFieldDecoration.copyWith(
                                hintText: "Email",
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.envelope,
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.sp,
                                  height: 0,
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //Send OTP Button
                          Container(
                            height: boxConstraints.maxHeight * 0.2,
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () async {
                                if (EmailValidator.validate(
                                    _emailController.text)) {
                                  context.loaderOverlay.show();
                                  Map<String, dynamic> result =
                                      await api.sendResetPasswordOTP(
                                          email: _emailController.text);
                                  context.loaderOverlay.hide();
                                  String code = result[CODE];
                                  if (code == '2000') {
                                    if (!isOTPSent) {
                                      setState(() {
                                        isOTPSent = true;
                                      });
                                    }
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "OTP could not be sent",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: snackbarBackgroundColor,
                                      colorText: snackbarColorText,
                                      snackStyle: SnackStyle.FLOATING,
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    "Email is Empty",
                                    "Please provide an email",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: snackbarBackgroundColor,
                                    colorText: snackbarColorText,
                                    snackStyle: SnackStyle.FLOATING,
                                  );
                                }
                              },
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //====OTP====
                          Container(
                            height: boxConstraints.maxHeight * 0.2,
                            alignment: Alignment.center,
                            child: TextFormField(
                              enabled: isOTPSent ? true : false,
                              controller: _otpController,
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter otp';
                                } else {
                                  return null;
                                }
                              },
                              decoration:
                                  forgotPasswordFormFieldDecoration.copyWith(
                                hintText: "OTP",
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.key,
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black45,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.sp,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),

                          //====PASSWORD====
                          Container(
                            height: boxConstraints.maxHeight * 0.2,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: isPasswordVisible,
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password cannot be empty';
                                } else if (value.length < 6) {
                                  return "Password must be atleast 6 characters long";
                                } else {
                                  return null;
                                }
                              },
                              decoration:
                                  forgotPasswordFormFieldDecoration.copyWith(
                                hintText: "Password",
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.lock,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    (!isPasswordVisible)
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                          //====CONFIRM PASSWORD====
                          Container(
                            height: boxConstraints.maxHeight * 0.2,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: isPasswordVisible,
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password cannot be empty";
                                } else if (value != _passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                              decoration:
                                  forgotPasswordFormFieldDecoration.copyWith(
                                hintText: "Confirm Password",
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.lock,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    (!isPasswordVisible)
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () {
                                        isPasswordVisible = !isPasswordVisible;
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
                ),
              ),
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
                    if (_formKey.currentState!.validate()) {
                      context.loaderOverlay.show();
                      Map<String, dynamic> result = await api.resetPassword(
                          email: _emailController.text,
                          otp: _otpController.text,
                          password: _passwordController.text);
                      context.loaderOverlay.hide();
                      String code = result[CODE];
                      if (code == '2000') {
                        Get.snackbar(
                          "Successful",
                          "Password has been reset successfully",
                          snackPosition: SnackPosition.BOTTOM,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundColor: snackbarBackgroundColor,
                          colorText: snackbarColorText,
                        );
                        Get.back();
                      } else {
                        Get.snackbar(
                          "Failed",
                          "Password reset failed",
                          snackPosition: SnackPosition.BOTTOM,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundColor: snackbarBackgroundColor,
                          colorText: snackbarColorText,
                        );
                      }
                    }
                  },
                  child: const FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.fitWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
