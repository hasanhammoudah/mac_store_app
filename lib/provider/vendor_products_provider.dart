import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/product.dart';

class VendorProductsProvider extends StateNotifier<List<Product>> {
  VendorProductsProvider() : super([]);

  //set the list of products

  void setProducts(List<Product> products) {
    state = products;
  }
}

final vendorProductsProvider = StateNotifierProvider<VendorProductsProvider, List<Product>>(
  (ref) => VendorProductsProvider(),
);
