import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/controllers/subcategory_controller.dart';
import 'package:mac_store_app/models/category.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:mac_store_app/models/subcategory.dart';
import 'package:mac_store_app/views/detail/widgets/inner_banner_widget.dart';
import 'package:mac_store_app/views/detail/widgets/inner_header_widget.dart';
import 'package:mac_store_app/views/detail/widgets/subcategory_tile_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class InnerCategoryScreenWidget extends StatefulWidget {
  const InnerCategoryScreenWidget({super.key, required this.category});
  final Category category;

  @override
  State<InnerCategoryScreenWidget> createState() =>
      _InnerCategoryScreenWidgetState();
}

class _InnerCategoryScreenWidgetState extends State<InnerCategoryScreenWidget> {
  late Future<List<Subcategory>> futureSubCategories;
  late Future<List<Product>> futureProducts;
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    super.initState();
    futureSubCategories = _subcategoryController
        .getSubCategoriesByCategoryName(widget.category.name);
    futureProducts =
        ProductController().loadProductByCategory(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const InnerHeaderWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(
              image: widget.category.image,
            ),
            Center(
              child: Text(
                'Shop by Category',
                style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.7),
              ),
            ),
            FutureBuilder(
              future: futureSubCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No Categories Found"),
                  );
                } else {
                  final subCategories = snapshot.data as List<Subcategory>;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    //TODO
                    child: Column(
                      children: List.generate(
                        (subCategories.length / 7).ceil(),
                        (setIndex) {
                          //for each row, calculate the start and end index
                          final start = setIndex * 7;
                          final end = (setIndex + 1) * 7;
                          // create a padding widget to add spacing arround the row
                          return Padding(
                            padding: const EdgeInsets.all(8.9),
                            child: Row(
                              //create a row of the subcategory tile
                              children: subCategories
                                  .sublist(
                                      start,
                                      end > subCategories.length
                                          ? subCategories.length
                                          : end)
                                  .map(
                                    (subcategory) => SubCategoryTileWidget(
                                      image: subcategory.image,
                                      title: subcategory.subCategoryName,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            const ReusableTextWidget(
              title: 'Popular Product',
              subTitle: 'Viwe All',
            ),
            FutureBuilder(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No product under this category'),
                  );
                } else {
                  final products = snapshot.data as List<Product>;
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductItemWidget(
                            product: product,
                          );
                        }),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
