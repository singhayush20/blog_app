// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

List<Category> categoryFromJson(List<dynamic> str) {
  return List<Category>.from(str.map((x) {
    return Category.fromJson(x);
  }));
}

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
  });

  int categoryId;
  String categoryName;
  String categoryDescription;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      categoryDescription: json["categoryDescription"],
    );
  }

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "categoryDescription": categoryDescription,
      };
}
