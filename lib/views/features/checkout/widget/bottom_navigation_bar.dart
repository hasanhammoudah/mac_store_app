import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/order_controller.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/views/features/checkout/widget/shipping_address_screen.dart';

class BottomNavigationBarForCart extends ConsumerWidget {
  const BottomNavigationBarForCart(this.selectedPaymentMethod, {super.key});
  final String selectedPaymentMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final OrderController _orderController = OrderController();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: user!.state.isEmpty
          ? TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ShippingAddressScreen();
                    },
                  ),
                );
              },
              child: Text(
                'Please Enter Shipping Address',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 17),
              ),
            )
          : InkWell(
              onTap: () async {
                if (selectedPaymentMethod == 'stripe') {
                  // Handle Stripe payment
                } else {
                  await Future.forEach(_cartProvider.getCartItems.entries,
                      (entry) {
                    final cartItem = entry.value;
                    _orderController.uploadOrders(
                      id: '',
                      email: ref.read(userProvider)!.email,
                      fullName: ref.read(userProvider)!.fullName,
                      state: 'Jordan',
                      city: 'Amman',
                      locality: 'test states',
                      // state: ref.read(userProvider)!.state,
                      // city: ref.read(userProvider)!.city,
                      // locality: ref.read(userProvider)!.locality,
                      productName: cartItem.productName,
                      productPrice: cartItem.productPrice,
                      quantity: cartItem.quantity,
                      category: cartItem.category,
                      image: cartItem.image[0],
                      vendorId: cartItem.vendorId,
                      buyerId: ref.read(userProvider)!.id,
                      processing: true,
                      delivered: false,
                      context: context,
                    );
                  });
                }
              },
              child: Container(
                width: 338,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF3854EE,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    selectedPaymentMethod == 'stripe'
                        ? 'Pay Now'
                        : 'Place Order',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
