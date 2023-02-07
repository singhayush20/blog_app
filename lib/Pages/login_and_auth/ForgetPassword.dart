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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Container(
              height: 100, width: 100, child: const CustomLoadingIndicator()),
        ),
        child: SafeArea(
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Reset your password by verifying your registered email',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                    height: height * 0.4,
                    decoration: boxDecoration,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Form(
                      key: _formKey,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              //====Email====
                              Container(
                                alignment: Alignment.center,
                                height: constraints.maxHeight * 0.2,
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
                                      FontAwesomeIcons.envelope,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              //Send OTP Button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: constraints.maxHeight * 0.1,
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
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(
                                            //   SnackBar(
                                            //     content: Text(
                                            //         '${result['message']}'),
                                            //   ),
                                            // );
                                            Get.snackbar("Error",
                                                "OTP could not be sent");
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
                                            'Send OTP',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                              //====OTP====
                              Container(
                                height: constraints.maxHeight * 0.2,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  enabled: isOTPSent ? true : false,
                                  controller: _otpController,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter otp';
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

                              //====PASSWORD====
                              Container(
                                height: constraints.maxHeight * 0.2,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: isPasswordVisible,
                                  cursorColor: Colors.white,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Password cannot be empty';
                                    } else if (value.length < 8) {
                                      return "Password must be atleast 8 characters long";
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
                                        (!isPasswordVisible)
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              //====CONFIRM PASSWORD====
                              Container(
                                height: constraints.maxHeight * 0.2,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: isPasswordVisible,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Password cannot be empty";
                                    } else if (value !=
                                        _passwordController.text) {
                                      return "Passwords do not match";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Confirm Password",
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.white,
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
                            Get.snackbar("Successful",
                                "Password has been reset successfully");
                            Navigator.pop(context);
                          } else {
                            Get.snackbar("Failed", "Password reset failed");
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
        ),
      ),
    );
  }
}
