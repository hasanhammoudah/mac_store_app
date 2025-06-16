// overview_tab.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/views/detail/widgets/filter_products_screen.dart';

class OverviewTab extends StatelessWidget {
  final String description;
  final List<String> tags;

  const OverviewTab({super.key, required this.description, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.roboto(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Text(
            'Tags',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: tags
                .map(
                  (tag) => ActionChip(
                    label: Text(tag),
                    backgroundColor: Colors.grey.shade200,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FilteredProductsScreen(tag: tag),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
