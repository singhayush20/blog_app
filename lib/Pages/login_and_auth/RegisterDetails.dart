import 'package:blog_app/Service/UserService.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/Pages/login_and_auth/LoginPage.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RegisterDetails extends StatefulWidget {
  String? email;
  RegisterDetails({required String email}) {
    this.email = email;
  }

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late final _emailController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _aboutController = TextEditingController();
  bool isPasswordVisible = true;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Registration Details',
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: Container(
              height: 100,
              width: 100,
              child: const CustomLoadingIndicator(),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: height * 0.1,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Fill out your details and then register",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Container(
                height: height * 0.4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: formFieldBoxDecoration,
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          //====NAME====
                          Container(
                            alignment: Alignment.center,
                            height: constraints.maxHeight * 0.2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: constraints.maxHeight * 0.2,
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      obscureText: false,
                                      cursorColor: Colors.white,
                                      style: TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'First Name cannot be empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: formFieldDecoration.copyWith(
                                        hintText: "First Name",
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.person,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: constraints.maxHeight * 0.2,
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      obscureText: false,
                                      cursorColor: Colors.white,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.name,
                                      validator: (value) {},
                                      decoration: formFieldDecoration.copyWith(
                                        hintText: "Last Name",
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.person,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //====EMAIL====
                          Container(
                            height: constraints.maxHeight * 0.2,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: false,
                                    controller: _emailController,
                                    obscureText: false,
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email cannot be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: formFieldDecoration.copyWith(
                                      hintText: "Email",
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.circleUser,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password cannot be empty';
                                  } else if (value.length < 6) {
                                    return "Password must be atleast 6 characters long";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: formFieldDecoration.copyWith(
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
                                )),
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
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password cannot be empty";
                                } else if (value != _passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                              decoration: formFieldDecoration.copyWith(
                                hintText: "Confirm Password",
                                prefixIcon: Icon(
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
                          //====About====
                          Container(
                            height: constraints.maxHeight * 0.2,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _aboutController,
                              obscureText: false,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please describe yourself";
                                }
                                return null;
                              },
                              decoration: formFieldDecoration.copyWith(
                                hintText: "Describe yourself",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.user,
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
                height: height * 0.1,
              ),
              Container(
                height: height * 0.05,
                width: width * 0.5,
                child: ElevatedButton(
                  onPressed: () async {
                    // save the details to the database
                    if (_formKey.currentState!.validate()) {
                      final UserService userService = UserService();
                      context.loaderOverlay.show();
                      String code = await userService.registerUser(
                          password: _passwordController.text,
                          email: _emailController.text,
                          about: _aboutController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text);
                      context.loaderOverlay.hide();

                      if (code == "2000") {
                        Get.snackbar(
                          "Successful",
                          "You have been registered successfully",
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: snackbarColorText,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundColor: snackbarBackgroundColor,
                        );
                        Get.offAll(
                          const LoginPage(),
                          transition: Transition.fadeIn,
                          duration: Duration(
                            milliseconds: 800,
                          ),
                        );
                      } else {
                        Get.snackbar(
                          "Failed",
                          "Registration was not successful!",
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: snackbarColorText,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundColor: snackbarBackgroundColor,
                        );
                      }
                    }
                  },
                  child: Text(
                    'Submit Details',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
