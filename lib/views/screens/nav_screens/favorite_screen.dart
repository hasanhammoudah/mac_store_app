import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/core/widgets/custom_app_bar.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:mac_store_app/provider/favorite_provider.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  Product? product;
  @override
  Widget build(BuildContext context) {
    final wishItemData = ref.watch(favoriteProvider);
    final wishItemProvider = ref.read(favoriteProvider.notifier);

    return Scaffold(
        appBar: CustomAppBar(
          title: 'My Wishlist',
          length: wishItemData.length.toString(),
        ),
        body: wishItemData.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'your wishlist is empty\n you can add product to your wishlist from the button below',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        letterSpacing: 1.7,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MainScreen();
                        }));
                      },
                      child: const Text('Shop Now'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: wishItemData.length,
                itemBuilder: (context, index) {
                  final wishData = wishItemData.values.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Container(
                        width: 335,
                        height: 96,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 336,
                                  height: 97,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFFEFF0F2),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 13,
                                top: 9,
                                child: Container(
                                  width: 78,
                                  height: 78,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFBCC5FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 255,
                                top: 16,
                                child: Text(
                                  '\$${wishData.productPrice.toStringAsFixed(2)}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0B0C1F),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 101,
                                top: 14,
                                child: SizedBox(
                                  width: 162,
                                  child: Text(
                                    wishData.productName,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 23,
                                top: 14,
                                child: Image.network(
                                  wishData.image[0],
                                  width: 56,
                                  height: 67,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                left: 284,
                                top: 47,
                                child: IconButton(
                                  onPressed: () {
                                    wishItemProvider
                                        .removeProductFromFavorite(wishData.productId);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
