import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:mac_store_app/models/vendor.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/provider/favorite_provider.dart' as j;
import 'package:mac_store_app/provider/product_provider.dart';
import 'package:mac_store_app/provider/related_product_provider.dart';
import 'package:mac_store_app/provider/vendor_products_provider.dart';
import 'package:mac_store_app/provider/vendor_provider.dart';
import 'package:mac_store_app/services/manage_http_response.dart';
import 'package:mac_store_app/views/detail/widgets/overview_tab.dart';
import 'package:mac_store_app/views/detail/widgets/reviews_tab.dart';
import 'package:mac_store_app/views/detail/widgets/shipping_tab.dart';
import 'package:mac_store_app/views/detail/widgets/specifications_tab.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int calculateDiscountPercentage(int originalPrice, int discountedPrice) {
    return (((originalPrice - discountedPrice) / originalPrice) * 100).round();
  }

  List<Widget> buildLabels() {
    final labels = <Widget>[];

    if (widget.product.hasDiscount && widget.product.discountedPrice != null) {
      final percent = calculateDiscountPercentage(
        widget.product.productPrice,
        widget.product.discountedPrice!,
      );
      labels.add(_buildLabel('-$percent%', Colors.red));
    }

    if (widget.product.isNewProduct) {
      labels.add(_buildLabel('New', Colors.green));
    }

    if (widget.product.hasNextAvailableLabel) {
      labels.add(_buildLabel('Coming Soon', Colors.orange));
    }

    return labels;
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  late Future<List<Product>> futurePopularProducts;
  Vendor? vendor;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // futurePopularProducts = ProductController().getProducts();
    _fetchProduct();
    _fetchVendorAndRelatedProducts();
  }

  Future<void> _fetchVendorAndRelatedProducts() async {
    final controller = ProductController();
    try {
      final relatedProducts =
          await controller.loadRelatedProductBySubCategory(widget.product.id);
      ref.read(relatedProductProvider.notifier).setProducts(relatedProducts);
      vendor = await controller.getVendorById(widget.product.vendorId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController _productController = ProductController();
    try {
      final products = await _productController
          .loadRelatedProductBySubCategory(widget.product.id);
      ref.read(relatedProductProvider.notifier).setProducts(products);
    } catch (e) {
      // Handle error
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final relatedProduct = ref.watch(relatedProductProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(j.favoriteProvider.notifier);
    final favoriteProvider = ref.watch(j.favoriteProvider);
    // final vendor = ref.watch(vendorProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Product Detail',
            style: GoogleFonts.quicksand(
                fontSize: 18, fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              onPressed: () {
                final isFavorite = favoriteProviderData.getFavoriteItems
                    .containsKey(widget.product.id);
                if (isFavorite) {
                  favoriteProviderData
                      .removeProductFromFavorite(widget.product.id);
                  showSnackBar(context, 'Removed from favorites');
                } else {
                  favoriteProviderData.addProductToFavorite(
                    productName: widget.product.productName,
                    category: widget.product.category,
                    image: widget.product.images,
                    productPrice: widget.product.productPrice,
                    vendorId: widget.product.vendorId,
                    productQuantity: widget.product.quantity,
                    quantity: 1,
                    productId: widget.product.id,
                    description: widget.product.description,
                    fullName: widget.product.fullName,
                  );
                  showSnackBar(context,
                      'added ${widget.product.productName} to favorite');
                }

                favoriteProvider;
              },
              icon: favoriteProviderData.getFavoriteItems
                          .containsKey(widget.product.id) ==
                      true
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                    ),
            ),
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 260,
                  height: 275,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        top: 50,
                        child: Container(
                          width: 260,
                          height: 260,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8DDFF),
                            borderRadius: BorderRadius.circular(130),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 22,
                        child: Container(
                          width: 216,
                          height: 274,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9CA8FF),
                            borderRadius: BorderRadius.circular(
                              14,
                            ),
                          ),
                          child: SizedBox(
                            height: 300,
                            child: PageView.builder(
                                itemCount: widget.product.images.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    widget.product.images[index],
                                    width: 198,
                                    height: 225,
                                    fit: BoxFit.cover,
                                  );
                                }),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        right: 8,
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: buildLabels(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.productName,
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            letterSpacing: 1,
                            color: const Color(0xFF3C55Ef),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.product.hasDiscount &&
                                widget.product.discountedPrice != null
                            ? Row(
                                children: [
                                  Text(
                                    '\$${widget.product.discountedPrice!.toStringAsFixed(2)}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '\$${widget.product.productPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                '\$${widget.product.productPrice.toStringAsFixed(2)}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.store, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          vendor == null
                              ? 'Sold by: Unknown'
                              : 'Sold by: ${vendor!.fullName}',
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.product.category,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              widget.product.totalRating == 0
                  ? const Text('')
                  : Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          // const Icon(
                          //   Icons.star,
                          //   color: Colors.amber,
                          // ),
                          // const SizedBox(
                          //   width: 4,
                          // ),
                          // Text(
                          //   widget.product.averageRating.toStringAsFixed(1),
                          //   style: GoogleFonts.montserrat(
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 4,
                          // ),
                          // Text(
                          //   "(${widget.product.totalRating} Reviews)",
                          //   style: GoogleFonts.montserrat(
                          //       fontWeight: FontWeight.bold, fontSize: 16),
                          // ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Overview'),
                        Tab(text: 'Specifications'),
                        Tab(text: 'Shipping'),
                        Tab(text: 'Reviews'),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        children: [
                          OverviewTab(
                            description: widget.product.description,
                            tags: widget.product.tags!,
                          ),
                          SpecificationsTab(
                            brand: widget.product.brand,
                            origin: widget.product.originCountry,
                            warrantyPeriod: widget.product.warrantyPeriod,
                          ),
                          ShippingTab(
                            shippingInfo: widget.product.shippingInfo,
                            returnPolicy: widget.product.returnPolicy,
                            originCountry: widget.product.originCountry,
                          ),
                          ReviewsTab(
                            reviews: widget.product.reviews,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const ReusableTextWidget(
                title: 'Related Products',
                subTitle: '',
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedProduct.length,
                  itemBuilder: (context, index) {
                    final product = relatedProduct[index];
                    return ProductItemWidget(
                      product: product,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(24),
          child: InkWell(
            onTap: () {
              if (widget.product.hasNextAvailableLabel) {
                showSnackBar(context, 'This product is not yet available.');
                return;
              }
              _cartProvider.addProductToCart(
                productName: widget.product.productName,
                category: widget.product.category,
                image: widget.product.images,
                productPrice: widget.product.productPrice,
                vendorId: widget.product.vendorId,
                productQuantity: widget.product.quantity,
                quantity: 1,
                productId: widget.product.id,
                description: widget.product.description,
                fullName: widget.product.fullName,
              );
              showSnackBar(context, widget.product.productName);
            },
            child: Container(
              height: 46,
              width: 386,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: widget.product.hasNextAvailableLabel == false
                    ? const Color(0xFF3B54EE)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: widget.product.hasNextAvailableLabel == false
                    ? Text(
                        'ADD TO CART',
                        style: GoogleFonts.mochiyPopOne(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        'Available Soon',
                        style: GoogleFonts.mochiyPopOne(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ));
  }
}
