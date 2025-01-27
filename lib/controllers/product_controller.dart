import 'dart:convert';

import 'package:mac_store_app/global_variables.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:http/http.dart' as http;

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
      } else {
        throw Exception('Failed to load products');
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
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }
}
