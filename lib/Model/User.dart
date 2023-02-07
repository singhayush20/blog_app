// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(Map<String, dynamic> str) => User.fromJson(str);

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.about,
    required this.roles,
    required this.firstName,
    required this.lastName,
  });

  int id;
  String email;
  String password;
  String about;
  List<Role> roles;
  String firstName;
  String lastName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        about: json["about"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "about": about,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "firstName": firstName,
        "lastName": lastName,
      };
}

class Role {
  Role({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
