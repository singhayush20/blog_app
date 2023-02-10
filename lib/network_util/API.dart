import 'dart:developer';
import 'dart:io';

import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/constants/urls.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  //upload image for creating or updating post
  Future<http.StreamedResponse> uploadImage(
      {XFile? data,
      required String token,
      required int postid,
      required bool isUpdatingPost}) async {
    // Map<String, dynamic> queryParams = {
    //   "postid": postid,
    //   "isUpdatingPost": isUpdatingPost
    // };
    final uri = Uri.https(domain2, uploadArticleImageUrl, {
      "postid": postid.toString(),
      "isUpdatingPost": isUpdatingPost.toString()
    });
    log('Uploading image to: ${uri.toString()}');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers.addAll(<String, String>{'Authorization': token});

    if (GetPlatform.isMobile && data != null) {
      File file = File(data.path);
      request.files.add(http.MultipartFile(
          'file', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }
    http.StreamedResponse response = await request.send();
    log('Image upload response: $response');
    return response;
  }

  //create a new post
  Future<Map<String, dynamic>> createPost(
      {required int userid,
      required int categoryid,
      required String token,
      required Map<String, String> post}) async {
    Map<String, dynamic> queryParam = {
      "userid": userid,
      "categoryid": categoryid
    };
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});

    log('Creating post for: $queryParam');
    Response response = await _dio.post(createPostUrl,
        queryParameters: queryParam, options: options, data: post);

    log('Create post response: $response');
    return response.data;
  }

  //get all the categories
  Future<Map<String, dynamic>> getAllCategories({required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Fetching all categories');
    Response response = await _dio.get(getAllCategoriesUrl, options: options);
    log('All categories response: $response');
    return response.data;
  }

  //get all posts by user
  Future<Map<String, dynamic>> getAllPostsByUser(
      {required String token, required int userid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    Map<String, dynamic> queryParam = {"userid": userid};
    log('Fetching posts for $queryParam');
    Response response = await _dio.get(getAllPostsByUserUrl,
        options: options, queryParameters: queryParam);
    log('User articles fetch response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> getAllCommentsForPost(
      {required String token, required int postid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Fetching comments for $postid');
    Response response = await _dio.get(getAllCommentsByPostUrl,
        options: options, queryParameters: {"postid": postid});
    log('Comments for post response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> deletePost(
      {required String token, required int postid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Deleting post: $postid');
    Response response = await _dio.delete(deletePostUrl,
        options: options, queryParameters: {"postid": postid});
    log('Delete post response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> updatePostContent(
      {required String token,
      required String content,
      required String title,
      required int postid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    Map<String, dynamic> data = {"title": title, "content": content};
    log('Updating post: $postid');
    Response response = await _dio.put(updatePostUrl,
        options: options, data: data, queryParameters: {"postid": postid});
    log('Post update response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> getSubscribedCategories(
      {required String token, required int userid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Fetching subscribed categories');
    Response response = await _dio.get(getSubscribedCategoriesUrl,
        options: options, queryParameters: {"userid": userid});
    log('Subscribed categories response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> subscribeToCategory(
      {required String token,
      required int userid,
      required int categoryid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Subscribing to category: userid: $userid, categoryid: $categoryid');
    Response response = await _dio.put(subscribeToCategoryUrl,
        options: options,
        queryParameters: {"userid": userid, "categoryid": categoryid});
    log('Subscribe response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> unsubscribeFromCategory(
      {required String token,
      required int userid,
      required int categoryid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Unsubscribing from category: userid: $userid, categoryid: $categoryid');
    Response response = await _dio.delete(unsubscribeFromCategoryUrl,
        options: options,
        queryParameters: {"userid": userid, "categoryid": categoryid});
    log('Unsubscribe response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> loadArticles(
      {required String token, required int categoryid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Loading articles: $categoryid and url: $loadArticlesByCategoryUrl');
    Response response = await _dio.get(loadArticlesByCategoryUrl,
        options: options, queryParameters: {"categoryid": categoryid});
    log('Load articles response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> writeComment(
      {required String token,
      required int userid,
      required int postid,
      required String content}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    Map<String, dynamic> queryParam = {"userid": userid, "postid": postid};
    Map<String, dynamic> data = {"content": content};
    log('Posting comment');
    Response response = await _dio.post(writeCommentUrl,
        options: options, data: data, queryParameters: queryParam);
    log('Comment post response: $response');
    return response.data;
  }
}
