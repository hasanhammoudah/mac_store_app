import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/order_controller.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/views/features/checkout/widget/shipping_address_screen.dart';
import 'package:mac_store_app/models/promo_code.dart';

class BottomNavigationBarForCart extends ConsumerStatefulWidget {
  const BottomNavigationBarForCart(this.selectedPaymentMethod,
      {super.key, this.appliedPromo});
  final String selectedPaymentMethod;
  final PromoCode? appliedPromo;

  @override
  ConsumerState<BottomNavigationBarForCart> createState() =>
      _BottomNavigationBarForCartState();
}

class _BottomNavigationBarForCartState
    extends ConsumerState<BottomNavigationBarForCart> {
  final OrderController _orderController = OrderController();
  bool isLoading = false;

  double _calculateDiscountedTotal(Map<String, dynamic> cartData) {
    final originalTotal = cartData.values
        .fold(0.0, (sum, item) => sum + (item.productPrice * item.quantity));
    if (widget.appliedPromo == null) return originalTotal;

    final promo = widget.appliedPromo!;
    if (promo.discountType == 'percentage') {
      return originalTotal - (originalTotal * promo.discountValue / 100);
    } else {
      return originalTotal - promo.discountValue;
    }
  }

  Future<void> handleStripePayment(BuildContext context) async {
    final cartData = ref.read(cartProvider);
    final user = ref.read(userProvider);

    if (cartData.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Information is missing')));
      return;
    }

    try {
      setState(() => isLoading = true);

      final discountedTotal = _calculateDiscountedTotal(cartData);
      if (discountedTotal <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid total amount')));
        return;
      }

      final paymentIntent = await _orderController.createPaymentIntent(
        amount: (discountedTotal * 100).toInt(),
        currency: 'usd',
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Mac Store',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final paymentIntentStatus = await _orderController.getPaymentIntentStatus(
        context: context,
        paymentIntentId: paymentIntent['id'],
      );

      if (paymentIntentStatus['status'] == 'succeeded') {
        for (final entry in cartData.entries) {
          final cartItem = entry.value;
          await _orderController.uploadOrders(
            id: '',
            email: user.email,
            fullName: user.fullName,
            state: user.state,
            city: user.city,
            locality: user.locality,
            productName: cartItem.productName,
            productPrice: cartItem.productPrice,
            quantity: cartItem.quantity,
            category: cartItem.category,
            image: cartItem.image[0],
            vendorId: cartItem.vendorId,
            buyerId: user.id,
            processing: true,
            delivered: false,
            paymentStatus: paymentIntentStatus['status'],
            paymentIntentId: paymentIntent['id'],
            paymentMethod: 'card',
            productId: cartItem.productId,
            context: context,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final cartData = ref.read(cartProvider);

    final totalBefore = cartData.values
        .fold(0.0, (sum, item) => sum + (item.productPrice * item.quantity));
    final totalAfter = _calculateDiscountedTotal(cartData);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.appliedPromo != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      '\$${totalBefore.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '\$${totalAfter.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:',
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text('\$${totalBefore.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          const SizedBox(height: 10),
          user!.state.isEmpty
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShippingAddressScreen()),
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
                    if (widget.selectedPaymentMethod == 'stripe') {
                      await handleStripePayment(context);
                    } else {
                      await Future.forEach(_cartProvider.getCartItems.entries,
                          (entry) async {
                        final cartItem = entry.value;
                        await _orderController.uploadOrders(
                          id: '',
                          email: user.email,
                          fullName: user.fullName,
                          state: user.state,
                          city: user.city,
                          locality: user.locality,
                          productName: cartItem.productName,
                          productPrice: cartItem.productPrice,
                          quantity: cartItem.quantity,
                          category: cartItem.category,
                          image: cartItem.image[0],
                          vendorId: cartItem.vendorId,
                          buyerId: user.id,
                          processing: true,
                          delivered: false,
                          paymentStatus: 'pending',
                          paymentIntentId: 'cod',
                          paymentMethod: 'cod',
                          productId: cartItem.productId,
                          context: context,
                        );
                      });
                      _cartProvider.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Order Successfully Placed')));
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3854EE),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.selectedPaymentMethod == 'stripe'
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
        ],
      ),
    );
  }
}
