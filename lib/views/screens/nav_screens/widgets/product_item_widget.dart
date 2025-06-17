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

  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(j.favoriteProvider.notifier);
    final favoriteProvider = ref.watch(j.favoriteProvider);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: widget.product),
          ),
        );
      },
      child: Container(
        width: 180,
        constraints: const BoxConstraints(minHeight: 260),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Product Image ----------
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: widget.product.images.isNotEmpty
                        ? Image.network(
                            widget.product.images[0],
                            height: 160,
                            width: 170,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 160,
                            width: 170,
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.grey),
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
                  Positioned(
                    top: 5,
                    right: 0,
                    child: InkWell(
                      onTap: () {
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
                              'Added ${widget.product.productName} to favorites');
                        }
                      },
                      child: favoriteProviderData.getFavoriteItems
                              .containsKey(widget.product.id)
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: InkWell(
                      onTap: () {
                        if (!widget.product.hasNextAvailableLabel) {
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
                              hasDiscount: widget.product.hasDiscount,
                              discountedPrice: widget.product.discountedPrice,
                              isNewProduct: widget.product.isNewProduct,
                              hasNextAvailableLabel:
                                  widget.product.hasNextAvailableLabel);
                          showSnackBar(context, widget.product.productName);
                        }
                      },
                      child: Image.asset(
                        'assets/icons/cart.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // ---------- Name + Rating ----------
            // ---------- Name + Rating ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: const Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.product.averageRating > 0) ...[
                  const SizedBox(width: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        widget.product.averageRating.toStringAsFixed(1),
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),

            const SizedBox(height: 2),

            // ---------- Category ----------
            Text(
              widget.product.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                color: const Color(0xFF868D94),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 2),

            // ---------- Price ----------
            widget.product.hasDiscount && widget.product.discountedPrice != null
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
      ),
    );
  }
}
