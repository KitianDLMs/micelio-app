import 'dart:convert';

import 'package:micelio/src/models/address.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/models/user.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String? id;
  String? clientId;
  String? deliveryId;
  String? addressId;
  String? status;
  double? lat;
  double? lng;
  int? timestamp;
  List<Product>? products = [];
  User? user;
  User? delivery;
  Address? address;

  Order({
    this.id,
    this.clientId,
    this.deliveryId,
    this.addressId,
    this.status,
    this.lat,
    this.lng,
    this.timestamp,
    this.products,
    this.address,
    this.user,
    this.delivery,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"] ?? json["_id"], // Mapea "id" o "_id"
        clientId: json["clientId"],
        deliveryId: json["id_delivery"],
        addressId: json["addressId"],
        status: json["status"],
        products: (json["products"] as List?)
          ?.map((item) => Product.fromJson(item))
          .toList(),
        lat: (json["lat"] as num?)?.toDouble(),
        lng: (json["lng"] as num?)?.toDouble(),
        timestamp: json["timestamp"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        delivery:
            json["delivery"] != null ? User.fromJson(json["delivery"]) : null,
        address: json["address"] != null ? Address.fromJson(json["address"]) : null,
      );

  static List<Order> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((item) => Order.fromJson(item)).toList();

  Map<String, dynamic> toJson() => {
        "id": id,
        "clientId": clientId,
        "id_delivery": deliveryId,
        "addressId": addressId,
        "status": status,
        "lat": lat,
        "lng": lng,
        "timestamp": timestamp,
        "products": products?.map((p) => p.toJson()).toList(),
        "user": user?.toJson(),
        "delivery": delivery?.toJson(),
        "address": address?.toJson(),
      };
}
