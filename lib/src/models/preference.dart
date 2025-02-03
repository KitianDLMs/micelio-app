import 'dart:convert';

class Preference {
  String id;
  String name;
  String description;
  String image1;
  String? image2;
  String? image3;
  String idCategory;
  double price;
  int quantity;

  Preference({
    required this.id,
    required this.name,
    required this.description,
    required this.image1,
    this.image2,
    this.image3,
    required this.idCategory,
    required this.price,
    required this.quantity,
  });

  // Método para convertir JSON a un objeto Preference
  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      image1: json['image1'] as String,
      image2: json['image2'] as String?,
      image3: json['image3'] as String?,
      idCategory: json['id_category'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }

  // Método para convertir un objeto Preference a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'id_category': idCategory,
      'price': price,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'Preference(id: $id, name: $name, description: $description, price: $price, quantity: $quantity)';
  }
}

// Función para manejar una lista de Preferences
List<Preference> preferencesFromJson(String jsonString) {
  final data = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  return data.map((item) => Preference.fromJson(item)).toList();
}

String preferencesToJson(List<Preference> preferences) {
  final data = preferences.map((item) => item.toJson()).toList();
  return jsonEncode(data);
}
