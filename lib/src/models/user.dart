import 'dart:convert';

import 'package:micelio/src/models/Rol.dart';
import 'package:micelio/src/models/Address.dart'; // Asegúrate de importar el modelo Address

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? email;
  String? name;
  String? lastname;
  String? phone;
  String? image;
  String? password;
  String? notification_token;
  String? token;
  String? tradeId;  
  List<Rol>? roles = [];
  Address? address;

  User({
    this.id,
    this.email,
    this.name,
    this.lastname,
    this.phone,
    this.image,
    this.password,
    this.notification_token,
    this.token,
    this.tradeId,
    this.roles,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"] ?? json["_id"],
      email: json["email"],
      name: json["name"],
      lastname: json["lastname"],
      phone: json["phone"],
      image: json["image"],
      password: json["password"],
      notification_token: json["session_token"],
      token: json["token"],
      tradeId: json["tradeId"],      
      roles: json["roles"] != null && json["roles"] is List
          ? List<Rol>.from(json["roles"].map((role) => Rol.fromJson(role)))
          : [],
      address: json["address"] != null ? Address.fromJson(json["address"]) : null,
    );

  static List<User> fromJsonList(List<dynamic> jsonList) {
    List<User> toList = [];

    jsonList.forEach((item) {
      User users = User.fromJson(item);
      toList.add(users);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "lastname": lastname,
        "phone": phone,
        "image": image,
        "password": password,
        "session_token": notification_token,
        "token": token,
        "tradeId": tradeId,
        "roles": roles != null ? roles!.map((role) => role.toJson()).toList() : [],
        "address": address?.toJson(),
      };
}
