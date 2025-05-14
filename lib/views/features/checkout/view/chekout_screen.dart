import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 15,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: const AddressPreviewCard(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Your Item',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CartItemListView(),
              const SizedBox(
                height: 10,
              ),
              PaymentMethod(
                onChanged: (value) => {
                  setState(() {
                    selectedPaymentMethod = value;
                  })
                },
                selectedPaymentMethod: selectedPaymentMethod,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarForCart(selectedPaymentMethod),
    );
  }
}
