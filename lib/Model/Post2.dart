// To parse this JSON data, do
//
//     final post2 = post2FromJson(jsonString);

import 'dart:convert';

List<Post2> post2FromJson(List<dynamic> str) =>
    List<Post2>.from(str.map((x) => Post2.fromJson(x)));

String post2ToJson(List<Post2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post2 {
  Post2({
    required this.postId,
    required this.title,
    required this.content,
    required this.addDate,
    required this.image,
    required this.user,
    required this.category,
  });

  int postId;
  String title;
  String content;
  DateTime addDate;
  String image;
  User user;
  Category category;

  factory Post2.fromJson(Map<String, dynamic> json) => Post2(
        postId: json["postId"],
        title: json["title"],
        content: json["content"],
        addDate: DateTime.parse(json["addDate"]),
        image: json["image"],
        user: User.fromJson(json["user"]),
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "title": title,
        "content": content,
        "addDate": addDate.toIso8601String(),
        "image": image,
        "user": user.toJson(),
        "category": category.toJson(),
      };
}

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
  });

  int categoryId;
  String categoryName;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
      };
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  int id;
  String firstName;
  String lastName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
      };
}
