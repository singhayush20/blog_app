import 'dart:developer';

import 'package:blog_app/Model/SubscribedCategory.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:get/get.dart';

import '../constants/app_constants.dart';

class SubscribedCategoriesController extends GetxController {
  final API _api = API();
  List<SubscribedCategory> _subscribedCategories = [];
  List<SubscribedCategory> get subscribedCategories => _subscribedCategories;
  Future<void> loadSubscribedCategories(
      {required String token, required int userid}) async {
    Map<String, dynamic> result =
        await _api.getSubscribedCategories(token: token, userid: userid);
    if (result[CODE] == '2000') {
      _subscribedCategories = subscribedCategoryFromJson(result['data']);
    } else {
      _subscribedCategories = [];
    }
    log('subscribed categories loaded: $_subscribedCategories');
    update();
  }

  Future<bool> subscribeToCategory(
      {required String token, required int userid, required categoryid}) async {
    bool res = false;
    Map<String, dynamic> result = await _api.subscribeToCategory(
        token: token, userid: userid, categoryid: categoryid);
    if (result[CODE] == '2000') {
      res = true;
      await loadSubscribedCategories(token: token, userid: userid);
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
      await loadSubscribedCategories(token: token, userid: userid);
    }
    return res;
  }
}
