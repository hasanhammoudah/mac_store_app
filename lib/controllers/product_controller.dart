import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mac_store_app/global_variables.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/models/promo_code.dart';
import 'package:mac_store_app/models/vendor.dart';

class ProductController {
  Future<List<Product>> getProducts() async {
    // Fetch products from the server
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/popular-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  Future<List<Product>> fetchProductsByTag(
      {required String tag, required BuildContext context}) async {
    // Fetch products from the server
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products-by-tag/$tag'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  Future<Product> fetchProductsById(
      {required String productId, required BuildContext context}) async {
    // Fetch products from the server
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/product/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromMap(data);
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http
          .get(Uri.parse('$uri/api/products-by-category/$category'), headers: {
        "Content-Type": "application/json; charset=UTF-8",
      });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Product> products =
            data.map((product) => Product.fromMap(product)).toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  Future<List<Product>> loadRelatedProductBySubCategory(
      String productId) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/related-products-by-subcategory/$productId'),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
          });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print('Product JSON: ${json.decode(response.body)}');

        List<Product> relatedProduct =
            data.map((product) => Product.fromMap(product)).toList();
        return relatedProduct;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load related products');
      }
    } catch (e) {
      throw Exception('Error loading related products: $e');
    }
  }

  Future<List<Product>> loadTopRatedProducts() async {
    try {
      http.Response response =
          await http.get(Uri.parse('$uri/api/top-rated-products'), headers: {
        "Content-Type": "application/json; charset=UTF-8",
      });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Product> topRatedProducts =
            data.map((product) => Product.fromMap(product)).toList();
        return topRatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load top rated products');
      }
    } catch (e) {
      throw Exception('Error loading top rated products: $e');
    }
  }

  Future<List<Product>> loadProductBySubCategory(String subCategory) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/products-by-subcategory/$subCategory'),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
          });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Product> products =
            data.map((product) => Product.fromMap(product)).toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load subcategory products');
      }
    } catch (e) {
      throw Exception('Error loading subcategory products: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      http.Response response = await http
          .get(Uri.parse('$uri/api/search-products?query=$query'), headers: {
        "Content-Type": "application/json; charset=UTF-8",
      });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Product> searchedProducts =
            data.map((product) => Product.fromMap(product)).toList();
        return searchedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load searched products');
      }
    } catch (e) {
      throw Exception('Error loading searched products: $e');
    }
  }

  Future<List<Product>> loadProductsByVendorId(String vendorId) async {
    try {
      http.Response response = await http
          .get(Uri.parse('$uri/api/products/vendor/$vendorId'), headers: {
        "Content-Type": "application/json; charset=UTF-8",
      });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Product> vendorProducts =
            data.map((product) => Product.fromMap(product)).toList();
        return vendorProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load vendors products');
      }
    } catch (e) {
      throw Exception('Error loading vendors products: $e');
    }
  }

  Future<Vendor> getVendorById(String vendorId) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/products/vendor/$vendorId'),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          return Vendor.fromJson(data[0]); // ✅ أول عنصر في القائمة
        } else {
          throw Exception('Vendor not found or empty list returned');
        }
      } else {
        throw Exception('Vendor not found');
      }
    } catch (e) {
      throw Exception('Error fetching vendor: $e');
    }
  }

  Future<PromoCode> getPromoCodeByCode(String code) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/promoCode/$code'),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PromoCode.fromJson(data);
      } else {
        throw Exception('Promo code not found');
      }
    } catch (e) {
      throw Exception('Error fetching Promo code : $e');
    }
  }
}
