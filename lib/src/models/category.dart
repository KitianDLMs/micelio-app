import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  String? id;
  String? name;
  String? tradeId;  
  String? description;

  Category({
    this.id,
    this.name,
    this.tradeId,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"], // Cambiado a "_id"
        name: json["name"],
        tradeId: json['tradeId'],
        description: json["description"],
      );

  static List<Category> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Category.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "tradeId": tradeId,        
        "description": description,
      };
}

