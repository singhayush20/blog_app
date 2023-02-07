// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(List<dynamic> str) {
  return List<Comment>.from(str.map((x) {
    return Comment.fromJson(x);
  }));
}

String commentToJson(List<Comment> data) {
  return json.encode(List<dynamic>.from(data.map((x) {
    return x.toJson();
  })));
}

class Comment {
  Comment({
    required this.commentId,
    required this.content,
    required this.user,
  });

  int commentId;
  String content;
  User user;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["commentId"],
        content: json["content"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "content": content,
        "user": user.toJson(),
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
