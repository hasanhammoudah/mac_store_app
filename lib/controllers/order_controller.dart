import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mac_store_app/global_variables.dart';
import 'package:mac_store_app/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/services/manage_http_response.dart';

class OrderController {
  //function to upload orders

  uploadOrders(
      {required String id,
      required String email,
      required String fullName,
      required String state,
      required String city,
      required String locality,
      required String productName,
      required int productPrice,
      required int quantity,
      required String category,
      required String image,
      required String vendorId,
      required String buyerId,
      required bool processing,
      required bool delivered,
      required BuildContext context}) async {
    try {
      final Order order = Order(
        id: id,
        email: email,
        fullName: fullName,
        state: state,
        city: city,
        locality: locality,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        vendorId: vendorId,
        buyerId: buyerId,
        processing: processing,
        delivered: delivered,
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: order.toJson(),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order placed successfully');
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // method to get orders by buyerId
  Future<List<Order>> getOrderByBuyerId({required String buyerId}) async {
    try {
      // Send an HTTP GET request to the server
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/by-buyer/$buyerId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        // Parse the response body and convert it to a list of Order objects
        List<Order> orders = (jsonDecode(response.body) as List)
            .map((order) => Order.fromJson(order))
            .toList();
        return orders;
      } else {
        // Handle error response
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      throw Exception('Error fetching orders: $e');
    }
  }

  // method to delete order by id
  Future<void> deleteOrderById({required String id, required context}) async {
    try {
      // Send an HTTP DELETE request to the server
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order deleted successfully');
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    } catch (e) {
      // Handle any exceptions that occur during the request
      showSnackBar(context, 'Error deleting order: $e');
    }
  }

  
}
