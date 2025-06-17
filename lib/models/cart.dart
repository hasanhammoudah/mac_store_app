// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Cart {
  final String productName;
  final String category;
  final List<String> image;
  final int productPrice;
  final String vendorId;
  final int productQuantity;
  int quantity;
  final String productId;
  final String description;
  final String fullName;

  // ✅ NEW FIELDS
  final bool hasDiscount;
  final int? discountedPrice;
  final bool isNewProduct;
  final bool hasNextAvailableLabel;

  Cart({
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

    // ✅ INIT NEW FIELDS
    required this.hasDiscount,
    required this.discountedPrice,
    required this.isNewProduct,
    required this.hasNextAvailableLabel,
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
      'hasDiscount': hasDiscount,
      'discountedPrice': discountedPrice,
      'isNewProduct': isNewProduct,
      'hasNextAvailableLabel': hasNextAvailableLabel,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      productName: map['productName'] as String,
      category: map['category'] as String,
      image: List<String>.from((map['image'] as List<dynamic>)),
      productPrice: map['productPrice'] as int,
      vendorId: map['vendorId'] as String,
      productQuantity: map['productQuantity'] as int,
      quantity: map['quantity'] as int,
      productId: map['productId'] as String,
      description: map['description'] as String,
      fullName: map['fullName'] as String,

      // ✅ PARSE NEW FIELDS
      hasDiscount: map['hasDiscount'] as bool? ?? false,
      discountedPrice: map['discountedPrice'] != null ? map['discountedPrice'] as int : null,
      isNewProduct: map['isNewProduct'] as bool? ?? false,
      hasNextAvailableLabel: map['hasNextAvailableLabel'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);
}
