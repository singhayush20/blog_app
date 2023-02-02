import 'dart:developer';

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
    log('Sending otp for email verification: $data');
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
  Future<Map<String, dynamic>> register(
      {required String username,
      required String email,
      required String password,
      required String about,
      required String firstName,
      required String lastName}) async {
    Map<String, dynamic> data = {
      "username": username,
      "email": email,
      "password": password,
      "about": about,
      "firstName": firstName,
      "lastName": lastName
    };
    log('Logging in user for: $data');
    Response response = await _dio.post(loginUrl, data: data);
    log('login user response: $response');
    return response.data;
  }
}
