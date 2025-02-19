import 'dart:convert';

class Trade {
  final String? id;
  final String? name;
  final String description;
  final String? address;
  final String? phone;
  final String? image;
  final String? logo;
  final String? userId;
  final bool? isOpen; 
  final String? mercadoPagoACTK;
  final String? tradeFacebook;
  final String? tradeInstagram;
  final String? tradeWsp;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? additionalInfo;
  final bool? featured;
  final String? openingHours;
  final String? closingHours; 
  
  Trade({
    this.id,
    this.name,
    this.description = '',
    this.address,
    this.phone,
    this.image,
    this.logo,
    this.userId,
    this.isOpen,
    this.mercadoPagoACTK,
    this.tradeFacebook,
    this.tradeInstagram,
    this.tradeWsp,
    this.createdAt,
    this.updatedAt,
    this.additionalInfo,
    this.featured,
    this.openingHours,
    this.closingHours,
  });
  
  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'],
      phone: json['phone'],
      image: json['image'],
      logo: json['logo'],
      userId: json['userId'],
      isOpen: json['isOpen'],
      mercadoPagoACTK: json['mercadoPagoACTK'],
      tradeFacebook: json['tradeFacebook'],
      tradeInstagram: json['tradeInstagram'],
      tradeWsp: json['tradeWsp'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      additionalInfo: json['additionalInfo'],
      featured: json['featured'],
      openingHours: json['openingHours'],
      closingHours: json['closingHours'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'image': image,
      'logo': logo,
      'userId': userId,
      'isOpen': isOpen,
      'mercadoPagoACTK': mercadoPagoACTK,
      'tradeFacebook': tradeFacebook,
      'tradeInstagram': tradeInstagram,
      'tradeWsp': tradeWsp,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'additionalInfo': additionalInfo,
      'featured': featured,
      'openingHours': openingHours,
      'closingHours': closingHours,
    };
  }
    
  static Trade fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return Trade.fromJson(jsonData);
  }

  static List<Trade> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Trade.fromJson(item)).toList();
  }
    
  String toJsonString() {
    return json.encode(toJson());
  }
}
