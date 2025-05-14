import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]); // Initialize with an empty list of orders

  // set the list of orders
  void setOrders(List<Order> orders) {
    state = orders;
  }

  // delete an order
  void removeOrder(String orderId) {
    state = state.where((order) => order.id != orderId).toList();
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) {
  return OrderProvider();
});
