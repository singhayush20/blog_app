import 'dart:developer';

import 'package:blog_app/Service/Category.dart';
import 'package:blog_app/Service/CategoryService.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  SharedPreferences? sharedPreferences;
  late LoadingStatus loadingStatus;
  late CategoryService _categoryService;
  List<Category>? allCategories;
  CategoryProvider.initialze(SharedPreferences sf) {
    _initializePrefs(sf);
    loadingStatus = LoadingStatus.NOT_STARTED;
    _categoryService = CategoryService();
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
        token: sharedPreferences!.getString(BEARER_TOKEN) ?? 'null');
    if (result['code'] == '2000') {
      allCategories = categoryFromJson(result['data']);
      log('allCategories: $allCategories');
    } else {
      log('No categories: code: $result');
      allCategories = [];
    }
    loadingStatus = LoadingStatus.COMPLETED;
    notifyListeners();
  }

  void clear() {
    allCategories = null;
    loadingStatus = LoadingStatus.NOT_STARTED;
  }
}
