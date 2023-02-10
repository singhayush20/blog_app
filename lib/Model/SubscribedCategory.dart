// To parse this JSON data, do
//
//     final subscribedCategory = subscribedCategoryFromJson(jsonString);

import 'dart:convert';

List<SubscribedCategory> subscribedCategoryFromJson(List<dynamic> str) =>
    List<SubscribedCategory>.from(
        str.map((x) => SubscribedCategory.fromJson(x)));

String subscribedCategoryToJson(List<SubscribedCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscribedCategory {
  SubscribedCategory({
    required this.categoryId,
    required this.categoryName,
  });

  int categoryId;
  String categoryName;

  factory SubscribedCategory.fromJson(Map<String, dynamic> json) =>
      SubscribedCategory(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
      };
}
