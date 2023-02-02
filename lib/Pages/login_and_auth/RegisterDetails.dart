import 'package:blog_app/Service/UserService.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/Pages/login_and_auth/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get.dart';

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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _aboutController = TextEditingController();
  bool isPasswordVisible = true;

  String? userRole;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                height: height * 0.2,
                child: FittedBox(
                  child: Text(
                    "User Details",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Container(
                height: height * 0.5,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: boxDecoration,
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
                                      decoration: const InputDecoration(
                                        hintText: "First Name",
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
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
                                      style: TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        // if (value!.isEmpty) {
                                        //   return 'Last Name cannot be empty';
                                        // } else {
                                        //   return null;
                                        // }
                                        //last name can be empty
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Last Name",
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.person,
                                          color: Colors.white,
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
                                    decoration: const InputDecoration(
                                      hintText: "Email",
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.circleUser,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 20,
                                // ),
                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.center,
                                //     children: [
                                //       Expanded(
                                //         flex: 1,
                                //         child: Container(
                                //           alignment: Alignment.bottomLeft,
                                //           child: Text(
                                //             'Account Type',
                                //             style:
                                //                 TextStyle(color: Colors.white),
                                //           ),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         flex: 2,
                                //         child: Column(
                                //           children: [
                                //             Expanded(
                                //               child: Container(
                                //                 alignment: Alignment.bottomLeft,
                                //                 child: RadioListTile(
                                //                   selectedTileColor:
                                //                       Colors.white,
                                //                   tileColor: Colors.white,
                                //                   title: Text(
                                //                     "Admin",
                                //                     style: TextStyle(
                                //                       color: Colors.white,
                                //                     ),
                                //                   ),
                                //                   value: "ADMIN",
                                //                   groupValue: userRole,
                                //                   onChanged: (value) {
                                //                     setState(() {
                                //                       userRole =
                                //                           value.toString();
                                //                     });
                                //                   },
                                //                 ),
                                //               ),
                                //             ),
                                //             Expanded(
                                //               child: Container(
                                //                 alignment: Alignment.bottomLeft,
                                //                 child: RadioListTile(
                                //                   selectedTileColor:
                                //                       Colors.white,
                                //                   tileColor: Colors.white,
                                //                   title: Text(
                                //                     "Student",
                                //                     style: TextStyle(
                                //                       color: Colors.white,
                                //                     ),
                                //                   ),
                                //                   value: "STUDENT",
                                //                   groupValue: userRole,
                                //                   onChanged: (value) {
                                //                     setState(() {
                                //                       userRole =
                                //                           value.toString();
                                //                     });
                                //                   },
                                //                 ),
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // )
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
                                      isPasswordVisible = !isPasswordVisible;
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
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password cannot be empty";
                                } else if (value != _passwordController.text) {
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
                              decoration: const InputDecoration(
                                hintText: "Describe yourself",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.user,
                                  color: Colors.white,
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
                    if (_formKey.currentState!.validate() && userRole != null) {
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
                        Get.snackbar("Successful",
                            "You have been registered successfully");
                        Get.offAll(const LoginPage());
                      } else {
                        Get.snackbar(
                            "Failed", "Registration was not successful!");
                      }
                    } else if (userRole == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Select the account type!'),
                        ),
                      );
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
