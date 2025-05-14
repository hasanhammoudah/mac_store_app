import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/category_controller.dart';
import 'package:mac_store_app/models/category.dart';
import 'package:mac_store_app/provider/category_provider.dart';
import 'package:mac_store_app/views/detail/screens/inner_category_screen.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class CategoryItemWidget extends ConsumerStatefulWidget {
  const CategoryItemWidget({super.key});

  @override
  ConsumerState<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends ConsumerState<CategoryItemWidget> {
  // A future that will hold the list of categories from the API call
  late Future<List<Category>> futureCategories;
  @override
  void initState() {
    super.initState();
    // futureCategories = CategoryController().loadCategory();
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    final CategoryController _categoryProvider = CategoryController();
    try {
      final category = await _categoryProvider.loadCategory();
      ref.read(categoryProvider.notifier).setCategories(category);
    } catch (e) {
      // Handle error
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReusableTextWidget(
          title: 'Categories',
          subTitle: 'View all',
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InnerCategoryScreen(
                      category: categories[index],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.network(
                    categories[index].image,
                    height: 47,
                    width: 47,
                  ),
                  Text(
                    categories[index].name,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
