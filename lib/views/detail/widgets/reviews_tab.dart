import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewsTab extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewsTab({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(child: Text('No reviews yet.'));
    }

    // ✅ حساب التقييم المتوسط
    double averageRating =
        reviews.fold(0.0, (sum, r) => sum + (r['rating'] ?? 0)) /
            reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ الشريط العلوي للـ average والتوتال
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 6),
              Text(
                averageRating.toStringAsFixed(1),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${reviews.length} Reviews)',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الاسم + نجوم
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review['fullName'] ?? 'Anonymous',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: List.generate(
                              (review['rating'] ?? 0).toInt(),
                              (i) => const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        review['review'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
