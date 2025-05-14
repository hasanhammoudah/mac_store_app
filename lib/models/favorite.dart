// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Favorite {
  final String productName;
  final String category;
  final List<String> image;
  final int productPrice;
  final String vendorId;
  final int productQuantity;
  final int quantity;
  final String productId;
  final String description;
  final String fullName;

  Favorite({
    required this.productName,
    required this.category,
    required this.image,
    required this.productPrice,
    required this.vendorId,
    required this.productQuantity,
    required this.quantity,
    required this.productId,
    required this.description,
    required this.fullName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'category': category,
      'image': image,
      'productPrice': productPrice,
      'vendorId': vendorId,
      'productQuantity': productQuantity,
      'quantity': quantity,
      'productId': productId,
      'description': description,
      'fullName': fullName,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      productName: map['productName'] as String,
      category: map['category'] as String,
      image: List<String>.from(
        (map['image'] as List<dynamic>),
      ),
      productPrice: map['productPrice'] as int,
      vendorId: map['vendorId'] as String,
      productQuantity: map['productQuantity'] as int,
      quantity: map['quantity'] as int,
      productId: map['productId'] as String,
      description: map['description'] as String,
      fullName: map['fullName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Favorite.fromJson(String source) =>
      Favorite.fromMap(json.decode(source) as Map<String, dynamic>);
}
