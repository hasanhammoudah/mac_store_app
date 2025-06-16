import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecificationsTab extends StatelessWidget {
  final String brand;
  final String warrantyPeriod;
  final String origin;

  const SpecificationsTab(
      {super.key,
      required this.brand,
      required this.warrantyPeriod,
      required this.origin});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSpecRow('Brand', brand),
        _buildSpecRow('Warranty Period', warrantyPeriod),
        _buildSpecRow('origin', warrantyPeriod),
      ],
    );
  }

  Widget _buildSpecRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          Text(value,
              style:
                  GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 14))
        ],
      ),
    );
  }
}
