import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String? id; // Campo público para el identificador
  String? name;
  String? description;
  String? image1;
  String? image2;
  String? image3;
  String? idCategory;
  double? price;
  int? quantity;

  Product({
    this.id,
    this.name,
    this.description,
    this.image1,
    this.image2,
    this.image3,
    this.idCategory,
    this.price,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] ?? json["_id"], // Mapea "id" o "_id"
        name: json["name"],
        description: json["description"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
        idCategory: json["id_category"],
        price: json["price"] != null && json["price"] is num
            ? (json["price"] as num).toDouble()
            : 0.0,
        quantity: json["quantity"],
      );

  // Función para convertir una lista de mapas en una lista de productos
  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Product.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "id_category": idCategory,
        "price": price,
        "quantity": quantity,
      };

  /// Método copyWith para crear una copia modificada del producto
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? image1,
    String? image2,
    String? image3,
    String? idCategory,
    double? price,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      idCategory: idCategory ?? this.idCategory,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
