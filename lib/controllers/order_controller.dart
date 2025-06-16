import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mac_store_app/global_variables.dart';
import 'package:mac_store_app/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/services/manage_http_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  //function to upload orders

  uploadOrders({
    required String id,
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
    required String paymentStatus,
    required String paymentIntentId,
    required String paymentMethod,
    required String productId,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
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
        paymentStatus: paymentStatus,
        paymentIntentId: paymentIntentId,
        paymentMethod: paymentMethod,
        productId: productId
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
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
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      // Send an HTTP GET request to the server
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/by-buyer/$buyerId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
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
      } else if (response.statusCode == 404) {
        return [];
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
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      // Send an HTTP DELETE request to the server
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
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

  //Method to count delivered orders
  Future<int> getDeliveredOrderCount({required String buyerId}) async {
    try {
      //load all order
      List<Order> orders = await getOrderByBuyerId(buyerId: buyerId);
      //Filter the orders to get only delivered orders
      int deliveredCount =
          orders.where((order) => order.delivered == true).length;
      return deliveredCount;
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error fetching delivered order count: $e');
      return 0; // Return 0 or handle the error as needed
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      http.Response response = await http.post(
        Uri.parse('$uri/api/payment-intent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
        body: jsonEncode(<String, dynamic>{
          'amount': amount,
          'currency': currency,
        }),
      );
      if (response.statusCode == 200) {
        // Parse the response body and return it as a Map
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      print('Error creating payment intent: $e');
      return {};
    }
  }

  //retrive payment intent to know if the payment was successful or not
  Future<Map<String, dynamic>> getPaymentIntentStatus(
      {required BuildContext context, required String paymentIntentId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("auth_token");
    try {
      if (paymentIntentId.isEmpty || paymentIntentId.contains('_secret_')) {
        throw Exception('Invalid PaymentIntent ID');
      }

// تحقق إذا فيه _secret_ غلط

      http.Response response = await http.get(
        Uri.parse('$uri/api/payment_intent/$paymentIntentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      if (response.statusCode == 200) {
        // Parse the response body and return it as a Map
        return jsonDecode(response.body);
      } else {
        showSnackBar(context, 'Failed to retrive payment intent');
        throw Exception('Failed to retrive payment intent');
      }
    } catch (e) {
      print('Error retriving payment intent: $e');
      showSnackBar(context, 'Error retriving payment intent: $e');
      return {};
    }
  }
}
