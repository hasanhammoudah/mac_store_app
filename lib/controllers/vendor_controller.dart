import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/global_variables.dart';
import 'package:mac_store_app/models/vendor.dart';

class VendorController {
  Future<List<Vendor>> loadVendors() async {
    try {
      http.Response response =
          await http.get(Uri.parse("$uri/api/vendors"), headers: {
        "Content-Type": "application/json; charset=UTF-8",
      });
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Vendor> vendors =
            data.map((banner) => Vendor.fromJson(banner)).toList();
        return vendors;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load vendors');
      }
    } catch (e) {
      throw Exception('Error loading vendors: $e');
    }
  }
}
