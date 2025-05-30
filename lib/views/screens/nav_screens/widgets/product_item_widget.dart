import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/provider/favorite_provider.dart' as j;
import 'package:mac_store_app/services/manage_http_response.dart';
import 'package:mac_store_app/views/detail/widgets/product_detail_screen.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  const ProductItemWidget({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(j.favoriteProvider.notifier);
    final favoriteProvider = ref.watch(j.favoriteProvider);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ProductDetailScreen(product: widget.product);
          }),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: const Color(
                  0xffF2F2F2,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Image.network(
                    widget.product.images[0],
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 5,
                    right: 0,
                    child: InkWell(
                      onTap: () {
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
                        showSnackBar(
                          context,
                          'added ${widget.product.productName} to favorite',
                        );
                        favoriteProvider;
                      },
                      child: favoriteProviderData.getFavoriteItems
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
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
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
                      child: Image.asset(
                        'assets/icons/cart.png',
                        height: 26,
                        width: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 8,
            // ),
            Text(
              widget.product.productName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: const Color(0xFF212121),
                fontWeight: FontWeight.bold,
              ),
            ),
            widget.product.averageRating == 0
                ? const SizedBox()
                : Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.product.averageRating.toStringAsFixed(1),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),

            Text(
              widget.product.category,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                color: const Color(0xFF868D94),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${widget.product.productPrice.toStringAsFixed(2)}',
              style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
}
