import 'dart:developer';
import 'dart:io';

import 'package:blog_app/constants/urls.dart';
import 'package:dio/dio.dart';

class API {
  final Dio _dio = Dio();

  /**
   * ---Login and Authentication---
   * 1. Send Email Verification OTP
   * 2. Verify Email Verification OTP
   * 3. Send Password Reset OTP
   * 4. Reset Password
   * 5. Login
   * 6. Register
   */

  //1.
  Future<Map<String, dynamic>> sendEmailVerificationOTP(
      {required String email}) async {
    Map<String, String> data = {"email": email};
    log('Sending otp for email verification: $data  and url: $sendEmailVerificationOTPUrl');
    Response response =
        await _dio.post(sendEmailVerificationOTPUrl, queryParameters: data);
    log('email otp response: $response');

    return response.data;
  }

  //2.
  Future<Map<String, dynamic>> verifyEmailVerificationOTP(
      {required String email, required String otp}) async {
    Map<String, String> data = {"email": email, 'otp': otp};
    log('Verifying otp for email verification: $data');
    Response response =
        await _dio.post(verifyEmailVerificationOTPUrl, queryParameters: data);
    log('email otp verification response: $response');

    return response.data;
  }

  //3.
  Future<Map<String, dynamic>> sendResetPasswordOTP(
      {required String email}) async {
    Map<String, String> data = {"email": email};
    log('Sending otp for resetting password: $data');
    Response response =
        await _dio.post(sendResetPasswordOTPUrl, queryParameters: data);
    log('reset password otp response: $response');

    return response.data;
  }

  //4.
  Future<Map<String, dynamic>> resetPassword(
      {required String email,
      required String otp,
      required String password}) async {
    Map<String, String> data = {
      "email": email,
      'otp': otp,
      'password': password
    };
    log('Reseting password for: $data');
    Response response =
        await _dio.post(verifyEmailVerificationOTPUrl, queryParameters: data);
    log('reset password response: $response');

    return response.data;
  }

  //5.
  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {
      "username": email,
      "password": password,
    };
    log('Logging in user for: $data');
    Response response = await _dio.post(loginUrl, data: data);
    log('login user response: $response');
    return response.data;
  }

  //6.
  Future<Map<String, dynamic>> register({required userData}) async {
    log(' Registering user for: $userData');
    Response response = await _dio.post(registerUrl, data: userData);
    log('register user response: $response');
    return response.data;
  }

  //User profile data on profile page
  Future<Map<String, dynamic>> getUserProfileData(
      {String? email, String? token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});

    Map<String, dynamic> queryParam = {"email": email};
    log('Fetching user details for: $queryParam  $getUserDetailsUrl');
    Response response = await _dio.get(getUserDetailsUrl,
        queryParameters: queryParam, options: options);

    log('fetch user detail response: $response');
    return response.data;
  }

  //update user details from dialog
  Future<Map<String, dynamic>> updateUserProfile(
      {required int userid,
      required String firstName,
      required String lastName,
      required String about,
      required String? token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});

    Map<String, dynamic> data = {
      "about": about,
      "firstName": firstName,
      "lastName": lastName,
    };
    Map<String, dynamic> queryParam = {"userid": userid};
    log('update user details for: $data $queryParam $updateUserProfileUrl');
    Response response = await _dio.put(updateUserProfileUrl,
        data: data, options: options, queryParameters: queryParam);

    log('update user detail response: $response');
    return response.data;
  }
}
