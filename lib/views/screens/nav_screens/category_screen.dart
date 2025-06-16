import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/category_controller.dart';
import 'package:mac_store_app/controllers/subcategory_controller.dart';
import 'package:mac_store_app/models/category.dart';
import 'package:mac_store_app/provider/category_provider.dart';
import 'package:mac_store_app/provider/subCategory_provider.dart';
import 'package:mac_store_app/views/detail/widgets/subcategory_tile_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/subCategory_product_screen.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  // late Future<List<Category>> futureCategories;
  Category? selectedCategory;
  @override
  void initState() {
    super.initState();
    //load the categories
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await CategoryController().loadCategory();
    ref.read(categoryProvider.notifier).setCategories(categories);

    //set the default selected category
    for (var category in categories) {
      if (category.name == "Clothes") {
        setState(() {
          selectedCategory = category;
        });
        //load the subcategories for the default selected category
        await _fetchSubCategories(category.name);
      }
    }
  }

  Future<void> _fetchSubCategories(String categoryName) async {
    final subcategories = await SubcategoryController()
        .getSubCategoriesByCategoryName(categoryName);
    ref.read(subcategoryProvider.notifier).setSubCategories(subcategories);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final subCategories = ref.watch(subcategoryProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const HeaderWidget(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //left side - Display categories
          Expanded(
              flex: 2,
              child: Container(
                  color: Colors.grey.shade200,
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            selectedCategory = categories[index];
                          });
                          _fetchSubCategories(categories[index].name);
                        },
                        title: Text(
                          categories[index].name,
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selectedCategory == categories[index]
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ))),

          //right side - Display selected category details
          Expanded(
            flex: 5,
            child: selectedCategory != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            selectedCategory!.name,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.7,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  selectedCategory!.banner,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        subCategories.isNotEmpty
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: subCategories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 2 / 3,
                                ),
                                itemBuilder: (context, index) {
                                  final subcategory = subCategories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubCategoryProductScreen(
                                            subcategory: subcategory,
                                          ),
                                        ),
                                      );
                                    },
                                    child: SubCategoryTileWidget(
                                      image: subcategory.image,
                                      title: subcategory.subCategoryName,
                                    ),
                                  );
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'No subcategories found',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.7,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.white,
                  ),
          ),
        ],
      ),
    );
  }
}
