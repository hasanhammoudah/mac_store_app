import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/controllers/order_controller.dart';
import 'package:mac_store_app/services/manage_http_response.dart';

class DeliveredOrderCountProvider extends StateNotifier<int> {
  DeliveredOrderCountProvider()
      : super(0); // Initialize with 0 delivered orders

  Future<void> fetchedDeliveredOrderCount(
      String buyerId, BuildContext context) async {
    try {
      OrderController orderController = OrderController();
      int count =
          await orderController.getDeliveredOrderCount(buyerId: buyerId);
      state = count;
    } catch (e) {
      showSnackBar(context, "Error fetching delivered order count: $e");
      state = 0; // Set to 0 in case of an error
    }
  }
  //Method to rest the count
  void resetCount() {
    state = 0;
  }
}

final deliveredOrderCountProvider =
    StateNotifierProvider<DeliveredOrderCountProvider, int>((ref) {
  return DeliveredOrderCountProvider();
});
