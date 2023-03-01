// import 'dart:developer';

// import 'package:blog_app/constants/app_constants.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserProvider with ChangeNotifier {
//   SharedPreferences? sharedPreferences;
//   late LoadingStatus loadingStatus;
//   late AccountType? accountType;
//   var image;
//   UserProvider() {}
//   UserProvider.initialze(SharedPreferences sf) {
//     _initializePrefs(sf);
//     loadingStatus = LoadingStatus.NOT_STARTED;
//   }
//   void _initializePrefs(SharedPreferences sf) {
//     log('Initializing sharedPreferences');
//     sharedPreferences = sf;
//     log('Shared preference initialized');
//   }

//   // User? user;
//   // UserService userService = UserService();
//   // Future<void> saveUserDetails(
//   //     {required String email, required String token}) async {
//   //   print('UserProvider: Loading and saving user details');
//   //   loadingStatus = LoadingStatus.LOADING;
//   //   // notifyListeners();
//   //   Map<String, dynamic> userDetails =
//   //       await userService.loadUserByUsername(email: email, token: token);
//   //   log('UserProvider: userDetails obtained: $userDetails');
//   //   String code = userDetails['code'];
//   //   if (code == '2000' || code == 2000) {
//   //     log('userProvider: saving user details');
//   //     userDetails = userDetails['data'];
//   //     user = User.saveUser(
//   //         userId: userDetails['userId'].toString(),
//   //         firstName: userDetails['firstName'],
//   //         lastName: userDetails['lastName'],
//   //         password: userDetails['password'],
//   //         email: userDetails['email'],
//   //         phoneNumber: userDetails['phone'],
//   //         userName: userDetails['user_name'],
//   //         profile: userDetails['profile'],
//   //         roles: userDetails['roles']);
//   //     sharedPreferences!.setString(USERNAME, user!.userName);
//   //     sharedPreferences!.setString(EMAIL, user!.email);
//   //     sharedPreferences!.setInt(USER_ID, int.parse(user!.userId));

//   //     String accountType = user!.roles[0]['roleName'];
//   //     sharedPreferences!.setString(ROLE, accountType);
//   //     if (accountType == ROLE_NORMAL) {
//   //       this.accountType = AccountType.NORMAL;
//   //     } else {
//   //       this.accountType = AccountType.ADMIN;
//   //     }
//   //     image = CachedNetworkImage(
//   //       imageUrl: 'enter image url',
//   //       placeholder: (context, url) =>
//   //           new Image.asset('images/DefaultProfileImage.jpg'),
//   //       errorWidget: (context, url, error) =>
//   //           new Image.asset('images/DefaultProfileImage.jpg'),
//   //     );
//   //     // _sharedPreferences!.setString("firstName", user!.firstName);
//   //     // _sharedPreferences!.setString("lastName", user!.lastName);
//   //     // _sharedPreferences!.setString("phone", user!.phoneNumber);
//   //     loadingStatus = LoadingStatus.COMPLETED;
//   //     notifyListeners();
//   //   }
//   // }

//   // Future<String> updateUserDetails(
//   //     String userId,
//   //     String firstName,
//   //     String lastName,
//   //     String email,
//   //     String password,
//   //     String phone,
//   //     String username,
//   //     String profile,
//   //     List<dynamic> userRole) async {
//   //   print('UserProvider: Loading and updating user details');
//   //   loadingStatus = LoadingStatus.LOADING;
//   //   final User user = User.saveUser(
//   //       userId: userId,
//   //       firstName: firstName,
//   //       lastName: lastName,
//   //       password: password,
//   //       email: email,
//   //       phoneNumber: phone,
//   //       userName: username,
//   //       profile: profile,
//   //       roles: userRole);
//   //   Map<String, dynamic> userDetails = await userService.updateUser(
//   //       user, sharedPreferences!.getString(BEARER_TOKEN)!);

//   //   log('UserProvider: userDetails obtained: $userDetails');
//   //   String code = userDetails['code'];
//   //   if (code == '2000') {
//   //     userDetails = userDetails['data'];
//   //     this.user = User.saveUser(
//   //         userId: userDetails['userId'].toString(),
//   //         firstName: userDetails['firstName'],
//   //         lastName: userDetails['lastName'],
//   //         password: userDetails['password'],
//   //         email: userDetails['email'],
//   //         phoneNumber: userDetails['phone'],
//   //         userName: userDetails['user_name'],
//   //         profile: userDetails['profile'],
//   //         roles: userDetails['roles']);
//   //     sharedPreferences!.setString(USERNAME, this.user!.userName);
//   //     sharedPreferences!.setString(EMAIL, this.user!.email);
//   //     sharedPreferences!.setInt(USER_ID, int.parse(this.user!.userId));
//   //     image = CachedNetworkImage(
//   //       imageUrl: 'enter image url',
//   //       placeholder: (context, url) =>
//   //           new Image.asset('images/DefaultProfileImage.jpg'),
//   //       errorWidget: (context, url, error) =>
//   //           new Image.asset('images/DefaultProfileImage.jpg'),
//   //     );
//   //   }
//   //   // _sharedPreferences!.setString("firstName", user!.firstName);
//   //   // _sharedPreferences!.setString("lastName", user!.lastName);
//   //   // _sharedPreferences!.setString("phone", user!.phoneNumber);
//   //   loadingStatus = LoadingStatus.COMPLETED;
//   //   notifyListeners();
//   //   return code;
//   // }
// }
