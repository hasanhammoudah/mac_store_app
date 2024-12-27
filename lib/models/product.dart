// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final String id;
  final String productName;
  final int productPrice;
  final int quantity;
  final String description;
  final String category;
  final String vendorId;
  final String fullName;
  final String subCategory;
  final List<String> images;

  Product(
      {required this.id,
      required this.productName,
      required this.productPrice,
      required this.quantity,
      required this.description,
      required this.category,
      required this.vendorId,
      required this.fullName,
      required this.subCategory,
      required this.images});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'vendorId': vendorId,
      'fullName': fullName,
      'subCategory': subCategory,
      'images': images,
    };
  }

 factory Product.fromMap(Map<String, dynamic> map) {
  return Product(
    id: map['_id']?.toString() ?? '',
    productName: map['productName']?.toString() ?? 'Unknown Product',
    productPrice: int.tryParse(map['productPrice']?.toString() ?? '0') ?? 0,
    quantity: int.tryParse(map['quantity']?.toString() ?? '0') ?? 0,
    description: map['description']?.toString() ?? 'No description available',
    category: map['category']?.toString() ?? 'Uncategorized',
    vendorId: map['vendorId']?.toString() ?? '',
    fullName: map['fullName']?.toString() ?? 'Unknown Vendor',
    subCategory: map['subCategory']?.toString() ?? 'General',
    images: List<String>.from(
      (map['images'] as List<dynamic>? ?? []).map((e) =>
        e.toString(),
      ),
    ),
  );
}



  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
