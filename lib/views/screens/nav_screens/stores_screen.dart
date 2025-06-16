import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/vendor_controller.dart';
import 'package:mac_store_app/core/widgets/custom_app_bar.dart';
import 'package:mac_store_app/provider/vendor_provider.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/vendor_products_screen.dart';

class StoresScreen extends ConsumerStatefulWidget {
  const StoresScreen({super.key});

  @override
  ConsumerState<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends ConsumerState<StoresScreen> {
  @override
  void initState() {
    super.initState();
    _fetchVendors();
    // futureBanners = BannerController().loadBanners();
  }

  Future<void> _fetchVendors() async {
    final VendorController _vendorsController = VendorController();
    try {
      final vendors = await _vendorsController.loadVendors();
      // Assuming you have a provider to set the banners
      ref.read(vendorProvider.notifier).setVendors(vendors);
    } catch (e) {
      // Handle error
      print('Error fetching vendors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(vendorProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    //set the number of column in grid base on the screen width
    //if the screen with is less than 600 pixels(e.g.. a phone), use columns
    //if the screen width is greater than 600 pixels(e.g.. a tablet), use 4 columns
    final crossAxisCount = screenWidth < 600 ? 2 : 4;

    //set the aspect ratio(width-to-height ratio) of each grid item base on the screen width
    //for smaller screen(<600 pixels) use a ration of 3.4(taller items)
    //for larger screen(>600 pixels) use a ratio of 4.5(more square-shaped items)

    final childAspectRatio = screenWidth < 600 ? 3 / 4 : 4.5;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Stores',
        length: vendors.length.toString(),
      ),
      body: GridView.builder(
        itemCount: vendors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VendorProductsScreen(
                    vendor,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                vendor.storeImage!.isEmpty
                    ? CircleAvatar(
                        radius: 50,
                        child: Text(
                          vendor.fullName[0].toUpperCase(),
                          style: GoogleFonts.montserrat(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(vendor.storeImage!),
                      ),
                Text(
                  vendor.fullName,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.7,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
