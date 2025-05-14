import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/views/features/checkout/widget/shipping_address_screen.dart';

class AddressPreviewCard extends ConsumerWidget {
  const AddressPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const ShippingAddressScreen();
            },
          ),
        );
        // Handle tap event
      },
      child: SizedBox(
        width: 335,
        height: 74,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 335,
                height: 74,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFEEE0F2),
                  ),
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 17,
              left: 70,
              child: SizedBox(
                width: 215,
                height: 41,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -1,
                      left: -1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 114,
                              child: user!.state.isNotEmpty
                                  ? const Text(
                                      'Address',
                                      style: TextStyle(
                                        height: 1.1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Text(
                                      'Add Address',
                                      style: TextStyle(
                                        height: 1.1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: user!.state.isNotEmpty
                                ? Text(
                                    user.state,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.3,
                                    ),
                                  )
                                : Text(
                                    'Jordan, Amman',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: user.state.isNotEmpty
                                ? Text(
                                    user.city,
                                    style: GoogleFonts.lato(
                                        color: const Color(0xFF7F808C),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  )
                                : Text(
                                    'Enter City',
                                    style: GoogleFonts.lato(
                                        color: const Color(0xFF7F808C),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: SizedBox.square(
                dimension: 42,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 43,
                        height: 43,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF7F5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Positioned(
                              left: 11,
                              top: 11,
                              child: Image.network(
                                height: 26,
                                width: 26,
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQw7Ruc3aDfDuCbY_FFQ-23U1on7qndeh-dNw&s',
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 305,
              top: 25,
              child: Image.network(
                height: 20,
                width: 20,
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQw7Ruc3aDfDuCbY_FFQ-23U1on7qndeh-dNw&s',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
