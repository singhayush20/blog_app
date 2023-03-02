import 'dart:developer';

import 'package:blog_app/Model/Category.dart';
import 'package:blog_app/Model/Post2.dart' as posts;
import 'package:blog_app/Model/SubscribedCategory.dart';
import 'package:blog_app/Service/CategoryService.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  SharedPreferences? sharedPreferences;
  late LoadingStatus loadingStatus;
  late CategoryService _categoryService;
  List<Category>? allCategories;
  List<SubscribedCategory> _subscribedCategories = [];
  List<int> _subscribedCategoryIDs = [];
  late API _api;
  late FirebaseMessaging messaging;
  List<SubscribedCategory> get subscribedCategories => _subscribedCategories;
  List<int> get subscribedCategoriesIDs => _subscribedCategoryIDs;

  CategoryProvider.initialze(SharedPreferences sf) {
    _initializePrefs(sf);
    loadingStatus = LoadingStatus.NOT_STARTED;
    _categoryService = CategoryService();
    _api = API();
    messaging = FirebaseMessaging.instance; //for firebase messaging
  }
  void _initializePrefs(SharedPreferences sf) {
    log('Initializing sharedPreferences');
    sharedPreferences = sf;
    log('Shared preference initialized');
  }

  void fetchAllCategories() async {
    allCategories = [];
    loadingStatus = LoadingStatus.LOADING;
    Map<String, dynamic> result = await _categoryService.fetchAllCategories(
      token: sharedPreferences!.getString(BEARER_TOKEN) ?? 'null',
    );
    if (result[CODE] == '2000') {
      allCategories = categoryFromJson(result['data']);
      log('allCategories: $allCategories');
    } else {
      log('No categories: code: $result');
      allCategories = [];
    }

    loadingStatus = LoadingStatus.COMPLETED;
    await loadSubscribedCategories();
    await saveDeviceFCMToken();
    notifyListeners();
  }

  Future<void> reloadAllCategories() async {
    Map<String, dynamic> result = await _categoryService.fetchAllCategories(
      token: sharedPreferences!.getString(BEARER_TOKEN) ?? 'null',
    );
    if (result[CODE] == '2000') {
      allCategories = categoryFromJson(result['data']);
      log('allCategories: $allCategories');
    } else {
      log('No categories: code: $result');
      allCategories = [];
    }
    await loadSubscribedCategories();

    notifyListeners();
  }

  Future<void> loadSubscribedCategories() async {
    // {required String token, required int userid}
    Map<String, dynamic> result = await _api.getSubscribedCategories(
        token: sharedPreferences!.getString(BEARER_TOKEN)!,
        userid: sharedPreferences!.getInt(USER_ID)!);
    if (result[CODE] == '2000') {
      _subscribedCategories = subscribedCategoryFromJson(result['data']);
      _subscribedCategoryIDs = [];
      for (var value in _subscribedCategories) {
        _subscribedCategoryIDs.add(value.categoryId);
      }
    }
    // else {
    //   _subscribedCategories = [];
    //   _subscribedCategoryIDs=[];
    // }
    log('subscribed categories loaded: $_subscribedCategories');

    notifyListeners();
  }

  Future<bool> subscribeToCategory(
      {required String token, required int userid, required categoryid}) async {
    bool res = false;
    Map<String, dynamic> result = await _api.subscribeToCategory(
        token: token,
        userid: userid,
        categoryid: categoryid,
        fcmToken: sharedPreferences!.getString(FCM_TOKEN)!);
    if (result[CODE] == '2000') {
      res = true;
      loadSubscribedCategories();
    }
    return res;
  }

  Future<bool> unsubscribeFromCategory(
      {required String token, required int userid, required categoryid}) async {
    bool res = false;
    Map<String, dynamic> result = await _api.unsubscribeFromCategory(
        token: token,
        userid: userid,
        categoryid: categoryid,
        fcmToken: sharedPreferences!.getString(FCM_TOKEN)!);
    if (result[CODE] == '2000') {
      res = true;
      loadSubscribedCategories();
    }
    return res;
  }

  Future<void> saveDeviceFCMToken() async {
    try {
      String? token = await messaging.getToken();
      log('Token obtained: $token');
      sharedPreferences!.setString(FCM_TOKEN, token!);
    } catch (err) {
      log('error when obtaining fcm token ${err.toString()}');
    }
  }

  void clear() {
    allCategories = null;
    loadingStatus = LoadingStatus.NOT_STARTED;
  }

  //For Search

  List<ListTile> searchedPosts = <ListTile>[];

  Future<void> searchForPosts({required String keyword}) async {
    searchedPosts = [];
    Map<String, dynamic> result = await _api.fetchSearchQueryPosts(
        token: sharedPreferences!.getString(BEARER_TOKEN)!, keyword: keyword);
    if (result[CODE] == '2000') {
      List<posts.Post2> res = posts.post2FromJson(result['data']);
      res.map((e) {
        log('adding ${e.title}');
        return ListTile(
          tileColor: Colors.amber,
          title: Text(
            '${e.title}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }).toList();
    }
    notifyListeners();
    log('notifylisteners called');
  }
}
