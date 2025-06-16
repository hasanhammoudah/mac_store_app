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
  final double averageRating;
  final int totalRating;

  final bool hasDiscount;
  final int? discountedPrice;

  final bool isNewProduct;
  final bool recommend;
  final bool popular;
  final bool hasNextAvailableLabel;
  final bool isPublished;

  final String? nextAvailableLabel;
  final List<String> labels;

  // New fields
  final String brand;
  final String warrantyPeriod;
  final String originCountry;
  final String shippingInfo;
  final String returnPolicy;
   List<String>? tags;
  final List<Map<String, dynamic>> reviews;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.description,
    required this.category,
    required this.vendorId,
    required this.fullName,
    required this.subCategory,
    required this.images,
    required this.averageRating,
    required this.totalRating,
    required this.hasDiscount,
    this.discountedPrice,
    required this.isNewProduct,
    required this.recommend,
    required this.popular,
    required this.hasNextAvailableLabel,
    required this.isPublished,
    this.nextAvailableLabel,
    this.labels = const [],
    required this.brand,
    required this.warrantyPeriod,
    required this.originCountry,
    required this.shippingInfo,
    required this.returnPolicy,
    required this.tags,
    required this.reviews,
  });

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
      'averageRating': averageRating,
      'totalRating': totalRating,
      'hasDiscount': hasDiscount,
      'discountedPrice': discountedPrice,
      'isNewProduct': isNewProduct,
      'recommend': recommend,
      'popular': popular,
      'hasNextAvailableLabel': hasNextAvailableLabel,
      'isPublished': isPublished,
      'nextAvailableLabel': nextAvailableLabel,
      'labels': labels,
      'brand': brand,
      'warrantyPeriod': warrantyPeriod,
      'originCountry': originCountry,
      'shippingInfo': shippingInfo,
      'returnPolicy': returnPolicy,
      'tags': tags,
      'reviews': reviews,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as String,
      productName: map['productName'] as String,
      productPrice: map['productPrice'] is int
          ? map['productPrice']
          : (map['productPrice'] as double).toInt(),
      quantity: map['quantity'] is int
          ? map['quantity']
          : (map['quantity'] as double).toInt(),
      description: map['description'] as String,
      category: map['category'] as String,
      vendorId: map['vendorId'] as String,
      fullName: map['fullName'] as String,
      subCategory: map['subCategory'] as String,
      images: List<String>.from((map['images'] as List<dynamic>)),
      averageRating: map['averageRating'] is int
          ? (map['averageRating'] as int).toDouble()
          : map['averageRating'] as double,
      totalRating: map['totalRating'] is int
          ? map['totalRating']
          : (map['totalRating'] as double).toInt(),
      hasDiscount: map['hasDiscount'] == true,
      discountedPrice: map['discountedPrice'] != null
          ? (map['discountedPrice'] is int
              ? map['discountedPrice']
              : (map['discountedPrice'] as double).toInt())
          : null,
      isNewProduct: map['isNewProduct'] == true,
      recommend: map['recommend'] == true,
      popular: map['popular'] == true,
      hasNextAvailableLabel: map['hasNextAvailableLabel'] == true,
      isPublished: map['isPublished'] != false,
      nextAvailableLabel: map['nextAvailableLabel'] as String?,
      labels:
          map['labels'] != null ? List<String>.from(map['labels'] as List) : [],
      brand: map['brand'] ?? '',
      warrantyPeriod: map['warrantyPeriod'] ?? '',
      originCountry: map['originCountry'] ?? '',
      shippingInfo: map['shippingInfo'] ?? '',
      returnPolicy: map['returnPolicy'] ?? '',
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      reviews: map['reviews'] != null
          ? List<Map<String, dynamic>>.from(
              (map['reviews'] as List).map((e) => Map<String, dynamic>.from(e)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
