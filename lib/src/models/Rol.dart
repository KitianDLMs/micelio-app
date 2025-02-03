import 'dart:convert';

Rol rolFromJson(String str) => Rol.fromJson(json.decode(str));

String rolToJson(Rol data) => json.encode(data.toJson());

class Rol {
  String? idUser;
  String? idRol;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  String? name;
  String? route;

  Rol({
    this.idUser,
    this.idRol,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.route,
  });

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
    idUser: json["id_user"] ?? "",
    idRol: json["id_rol"] ?? "", 
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
    image: json["image"] ?? "", 
    name: json["name"] ?? "", 
    route: json["route"] ?? "", 
  );

  Map<String, dynamic> toJson() => {
    "id_user": idUser,
    "id_rol": idRol,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image": image,
    "name": name,
    "route": route,
  };
}
