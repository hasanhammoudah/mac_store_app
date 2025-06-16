import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mac_store_app/global_variables.dart';
import 'package:mac_store_app/models/subcategory.dart';

class SubcategoryController {
// load the uploaded subCategory
  Future<List<Subcategory>> getSubCategoriesByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/category/$categoryName/sub_category"),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
          });
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          List<Subcategory> subcategories = data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
          return subcategories;
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      throw Exception('Error loading subcategories: $e');
    }
  }
}
