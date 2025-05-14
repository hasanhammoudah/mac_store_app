import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    super.key,
    required this.onChanged,
    required this.selectedPaymentMethod,
  });
  final ValueChanged<String> onChanged;
  final String selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Payment Method',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile<String>(
            title: Text(
              'Stripe',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            value: 'stripe',
            groupValue: selectedPaymentMethod,
            onChanged: (value) => onChanged(value!)),
        RadioListTile<String>(
            title: Text(
              'Cash on Delivery',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
            ),
            value: 'cashOnDelivery',
            groupValue: selectedPaymentMethod,
            onChanged: (value) => onChanged(value!)),
      ],
    );
  }
}
