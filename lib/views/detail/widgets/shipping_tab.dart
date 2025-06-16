import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingTab extends StatelessWidget {
  final String originCountry;
  final String shippingInfo;
  final String returnPolicy;

  const ShippingTab({
    super.key,
    required this.originCountry,
    required this.shippingInfo,
    required this.returnPolicy,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildShippingRow('Country of Origin', originCountry),
        _buildShippingRow('Shipping Info', shippingInfo),
        _buildShippingRow('Return Policy', returnPolicy),
      ],
    );
  }

  Widget _buildShippingRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.montserrat(
                  color: Colors.grey[700], fontSize: 14))
        ],
      ),
    );
  }
}
