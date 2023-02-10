import 'dart:developer';

import 'package:blog_app/GetController/SubscribedCategoriesController.dart';
import 'package:blog_app/Model/Category.dart';
import 'package:blog_app/Model/SubscribedCategory.dart';
import 'package:blog_app/Service/CategoryService.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  SharedPreferences? sharedPreferences;
  late LoadingStatus loadingStatus;
  late CategoryService _categoryService;
  List<Category>? allCategories;
  List<SubscribedCategory> _subscribedCategories = [];
  List<int> _subscribedCategoryIDs = [];
  late API _api;
  List<SubscribedCategory> get subscribedCategories => _subscribedCategories;
  List<int> get subscribedCategoriesIDs => _subscribedCategoryIDs;
  CategoryProvider.initialze(SharedPreferences sf) {
    _initializePrefs(sf);
    loadingStatus = LoadingStatus.NOT_STARTED;
    _categoryService = CategoryService();
    _api = API();
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
    await loadSubscribedCategories(
        token: sharedPreferences!.getString(BEARER_TOKEN) ?? 'null',
        userid: sharedPreferences!.getInt(USER_ID)!);
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
    await loadSubscribedCategories(
        token: sharedPreferences!.getString(BEARER_TOKEN) ?? 'null',
        userid: sharedPreferences!.getInt(USER_ID)!);

    notifyListeners();
  }

  Future<void> loadSubscribedCategories(
      {required String token, required int userid}) async {
    Map<String, dynamic> result =
        await _api.getSubscribedCategories(token: token, userid: userid);
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
        token: token, userid: userid, categoryid: categoryid);
    if (result[CODE] == '2000') {
      res = true;
      loadSubscribedCategories(token: token, userid: userid);
    }
    return res;
  }

  Future<bool> unsubscribeFromCategory(
      {required String token, required int userid, required categoryid}) async {
    bool res = false;
    Map<String, dynamic> result = await _api.unsubscribeFromCategory(
        token: token, userid: userid, categoryid: categoryid);
    if (result[CODE] == '2000') {
      res = true;
      loadSubscribedCategories(token: token, userid: userid);
    }
    return res;
  }

  void clear() {
    allCategories = null;
    loadingStatus = LoadingStatus.NOT_STARTED;
  }
}
