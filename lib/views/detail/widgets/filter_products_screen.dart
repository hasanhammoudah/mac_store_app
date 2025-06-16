import 'package:flutter/material.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class FilteredProductsScreen extends StatelessWidget {
  final String tag;
  const FilteredProductsScreen({super.key, required this.tag});
  Future<List<Product>> fetchProductsByTag(BuildContext context) async {
    final productController = ProductController();
    return await productController.fetchProductsByTag(
        tag: tag, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for "$tag"')),
      body: FutureBuilder(
        future: fetchProductsByTag(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Text('No products found.');
          final products = snapshot.data as List<Product>;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عدد الأعمدة في الشبكة
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItemWidget(product: product);
            },
          );
        },
      ),
    );
  }
}
