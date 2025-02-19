import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  String? id;
  String? address;
  String? neighborhood;
  String? number; 
  String? idUser;
  double? lat;
  double? lng;
  DateTime? createdAt;
  DateTime? updatedAt;

  Address({
    this.id,
    this.address,
    this.neighborhood,
    this.number,
    this.idUser,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["_id"] ?? json["id"], // Manejo de _id
        address: json["address"],
        neighborhood: json["neighborhood"],
        number: json["number"], 
        idUser: json["id_user"],
        lat: json["lat"],
        lng: json["lng"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "neighborhood": neighborhood,
        "number": number,
        "id_user": idUser,
        "lat": lat,
        "lng": lng,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  static List<Address> fromJsonList(dynamic jsonList) {
  if (jsonList is List) {
    return jsonList.map((item) => Address.fromJson(item)).toList();
  } else {
    print("Error: Se esperaba una lista, pero se recibió: $jsonList");
    return [];
  }
}
}
