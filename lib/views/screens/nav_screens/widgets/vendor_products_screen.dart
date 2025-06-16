import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/core/widgets/custom_app_bar.dart';
import 'package:mac_store_app/models/vendor.dart';
import 'package:mac_store_app/provider/vendor_products_provider.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class VendorProductsScreen extends ConsumerStatefulWidget {
  const VendorProductsScreen(this.vendor, {super.key});
  final Vendor? vendor;

  @override
  ConsumerState<VendorProductsScreen> createState() =>
      _VendorProductsScreenState();
}

class _VendorProductsScreenState extends ConsumerState<VendorProductsScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // futurePopularProducts = ProductController().getProducts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProductsIfNeeded();
    });
  }

  void _fetchProductsIfNeeded() {
    final products = ref.read(vendorProductsProvider);
    if(products.isEmpty || products.first.vendorId!= widget.vendor?.id) {
      ref.read(vendorProductsProvider.notifier).setProducts([]);
      _fetchVendorProducts();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchVendorProducts() async {
    final ProductController _productController = ProductController();
    try {
      final products =
          await _productController.loadProductsByVendorId(widget.vendor!.id);
      ref.read(vendorProductsProvider.notifier).setProducts(products);
    } catch (e) {
      // Handle error
      print('Error fetching vendors products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(vendorProductsProvider);
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
      appBar: CustomAppBar(
        title: widget.vendor?.fullName.toUpperCase() ?? 'Vendor Products',
        length: products.length.toString(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              widget.vendor?.storeImage! != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.vendor!.storeImage!),
                    )
                  : CircleAvatar(
                      radius: 50,
                      child: Text(
                        widget.vendor?.fullName[0].toUpperCase() ??
                            'V', // Display first letter of vendor name
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              widget.vendor?.storeDescription != null
                  ? Text(
                      widget.vendor!.storeDescription!,
                      style: GoogleFonts.montserrat(
                        letterSpacing: 1.7,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 10),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.blue))
                  :products.isEmpty? Text('No Products Found',style: GoogleFonts.montserrat(),): Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
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
            ],
          ),
        ),
      ),
    );
  }
}
