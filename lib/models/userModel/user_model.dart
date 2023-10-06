import 'package:flutter/material.dart';

class UserModel {
  String id;
  String? image;
  String name;
  String email;
  String phoneNumber;

  UserModel({
    required this.id,
    this.image,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
      };
  UserModel copyWith({
    String? name,
    String? image,
  }) =>
      UserModel(
        id: id,
        image: image?? this.image,
        name: name ?? this.name,
        email: email,
        phoneNumber: phoneNumber,
      );
}
