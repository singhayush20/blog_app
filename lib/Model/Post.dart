// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(List<dynamic> str) {
  return List<Post>.from(str.map((x) {
    return Post.fromJson(x);
  }));
}

String postToJson(List<Post> data) {
  return json.encode(List<dynamic>.from(data.map((x) {
    return x.toJson();
  })));
}

class Post {
  Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.addDate,
    required this.image,
  });

  int postId;
  String title;
  String content;
  DateTime addDate;
  String image;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["postId"],
        title: json["title"],
        content: json["content"],
        addDate: DateTime.parse(json["addDate"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "title": title,
        "content": content,
        "addDate": addDate.toIso8601String(),
        "image": image,
      };
}
