import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String? id; // Campo público para el identificador
  String? name;
  String? tradeId;
  String? description;
  String? image1;
  String? image2;
  String? image3;
  String? idCategory;
  double? price;
  int? quantity;
  int? stock;

  Product({
    this.id,
    this.name,
    this.tradeId,
    this.description,
    this.image1,
    this.image2,
    this.image3,
    this.idCategory,
    this.price,
    this.quantity,
    this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] ?? json["_id"], // Mapea "id" o "_id"
        name: json["name"],
        tradeId: json["tradeId"],        
        description: json["description"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
        idCategory: json["id_category"],
        price: json["price"] != null && json["price"] is num
            ? (json["price"] as num).toDouble()
            : 0.0,
        quantity: json["quantity"],
        stock: json["stock"] ?? 0,
      );

  // Función para convertir una lista de mapas en una lista de productos
  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Product.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tradeId": tradeId,        
        "description": description,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "id_category": idCategory,
        "price": price,
        "quantity": quantity,
        "stock": stock,
      };

  /// Método copyWith para crear una copia modificada del producto
  Product copyWith({
    String? id,
    String? name,
    String? tradeId,
    String? description,
    String? image1,
    String? image2,
    String? image3,
    String? idCategory,
    double? price,
    int? quantity,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      tradeId: tradeId ?? this.tradeId,
      description: description ?? this.description,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      idCategory: idCategory ?? this.idCategory,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
    );
  }

  static List<Product> fromJsonListSafe(List<dynamic> jsonList) {
    return jsonList
        .where((item) => item != null && item is Map<String, dynamic>) // Filtra datos válidos
        .map((item) {
          try {
            return Product.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            print("Error al deserializar producto: $e");
            return null; // Devuelve null si hay un error
          }
        })
        .where((product) => product != null) // Elimina los valores nulos
        .cast<Product>()
        .toList();
  }
}
