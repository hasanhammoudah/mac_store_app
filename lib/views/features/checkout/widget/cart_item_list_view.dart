import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/provider/cart_provider.dart';

class CartItemListView extends ConsumerWidget {
  const CartItemListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartData = ref.read(cartProvider);
    return Flexible(
      child: ListView.builder(
        itemCount: cartData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final cartItem = cartData.values.toList()[index];
          return InkWell(
              onTap: () {},
              child: Container(
                width: 336,
                height: 91,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFEFF0F2),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 6,
                      top: 6,
                      child: SizedBox(
                        width: 311,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 78,
                              height: 78,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                color: Color(0xFFBCC5FF),
                              ),
                              child: Image.network(
                                cartItem.image[0],
                              ),
                            ),
                            const SizedBox(
                              width: 11,
                            ),
                            Expanded(
                              child: Container(
                                height: 78,
                                alignment: const Alignment(0, -0.51),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          cartItem.productName,
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          cartItem.category,
                                          style: GoogleFonts.lato(
                                            color: Colors.blueGrey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            cartItem.hasDiscount &&
                                    cartItem.discountedPrice != null
                                ? Row(
                                    children: [
                                      Text(
                                        '\$${cartItem.discountedPrice!.toStringAsFixed(2)}',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  )
                                : Text(
                                    "\$${cartItem.productPrice.toStringAsFixed(2)}",
                                    style: GoogleFonts.roboto(
                                      color: Colors.pink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}
