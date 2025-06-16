import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/controllers/banner_controller.dart';
import 'package:mac_store_app/models/banner.dart';
import 'package:mac_store_app/provider/banner_provider.dart';

class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  late Future<List<BannerModel>> futureBanners;
  @override
  void initState() {
    super.initState();
    _fetchBanners();
    // futureBanners = BannerController().loadBanners();
  }

  Future<void> _fetchBanners() async {
    final BannerController _bannerController = BannerController();
    try {
      final banners = await _bannerController.loadBanners();
      // Assuming you have a provider to set the banners
      ref.read(bannerProvider.notifier).setBanners(banners);
    } catch (e) {
      // Handle error
      print('Error fetching banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 170,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  banners[index].image!,
                  fit: BoxFit.cover,
                ),
              );
            },
          )),
    );
  }
}
