import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/models/promo_code.dart';
import 'package:mac_store_app/views/features/checkout/widget/address_preview_card.dart';
import 'package:mac_store_app/views/features/checkout/widget/bottom_navigation_bar.dart';
import 'package:mac_store_app/views/features/checkout/widget/cart_item_list_view.dart';
import 'package:mac_store_app/views/features/checkout/widget/payment_method.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'stripe';
  PromoCode? _appliedPromo;

  void _onPromoApplied(PromoCode promo) {
    setState(() {
      _appliedPromo = promo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AddressPreviewCard(),
              const SizedBox(height: 10),
              Text(
                'Your Item',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CartItemListView(),
              const SizedBox(height: 10),
              PaymentMethod(
                onRemovePromo: () {
                  setState(() {
                    _appliedPromo = null; // 🔥 إزالة الكود الترويجي
                  });
                },
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
                selectedPaymentMethod: selectedPaymentMethod,
                onPromoApplied: _onPromoApplied, // 🔥 تمرير الدالة
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarForCart(
        selectedPaymentMethod,
        appliedPromo: _appliedPromo, // 🔥 تمرير الكود الترويجي هنا
      ),
    );
  }
}
