import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/models/subcategory.dart';
import 'package:mac_store_app/provider/product_provider.dart';
import 'package:mac_store_app/provider/subcategory_product_provider.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class SubCategoryProductScreen extends ConsumerStatefulWidget {
  const SubCategoryProductScreen({super.key, required this.subcategory});
  final Subcategory subcategory;

  @override
  ConsumerState<SubCategoryProductScreen> createState() =>
      _SubCategoryProductScreenState();
}

class _SubCategoryProductScreenState
    extends ConsumerState<SubCategoryProductScreen> {
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // futurePopularProducts = ProductController().getProducts();
    final products = ref.read(subcategoryProductProvider);
    if (products.isEmpty) {
      _fetchProduct();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController _productController = ProductController();
    try {
      final products = await _productController
          .loadProductBySubCategory(widget.subcategory.subCategoryName);
      ref
          .read(subcategoryProductProvider.notifier)
          .setSubcategoryProducts(products);
    } catch (e) {
      // Handle error
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(subcategoryProductProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    //set the number of column in grid base on the screen width
    //if the screen with is less than 600 pixels(e.g.. a phone), use columns
    //if the screen width is greater than 600 pixels(e.g.. a tablet), use 4 columns
    final crossAxisCount = screenWidth < 600 ? 2 : 4;

    //set the aspect ratio(width-to-height ratio) of each grid item base on the screen width
    //for smaller screen(<600 pixels) use a ration of 3.4(taller items)
    //for larger screen(>600 pixels) use a ratio of 4.5(more square-shaped items)

    final childAspectRatio = screenWidth < 600 ? 3 / 4 : 4.5;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subcategory.subCategoryName,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItemWidget(product: product);
                },
              ),
            ),
    );
  }
}
