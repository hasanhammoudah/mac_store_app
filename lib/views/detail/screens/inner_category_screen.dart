import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/subcategory_controller.dart';
import 'package:mac_store_app/models/category.dart';
import 'package:mac_store_app/models/subcategory.dart';
import 'package:mac_store_app/views/detail/widgets/inner_banner_widget.dart';
import 'package:mac_store_app/views/detail/widgets/inner_category_content_widget.dart';
import 'package:mac_store_app/views/detail/widgets/inner_header_widget.dart';
import 'package:mac_store_app/views/detail/widgets/subcategory_tile_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/account_screen.dart';
import 'package:mac_store_app/views/screens/nav_screens/cart_screen.dart';
import 'package:mac_store_app/views/screens/nav_screens/category_screen.dart';
import 'package:mac_store_app/views/screens/nav_screens/favorite_screen.dart';
import 'package:mac_store_app/views/screens/nav_screens/stores_screen.dart';

class InnerCategoryScreen extends StatefulWidget {
  const InnerCategoryScreen({super.key, required this.category});
  final Category category;

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      InnerCategoryScreenWidget(
        category: widget.category,
      ),
      const FavoriteScreen(),
      const CategoryScreen(),
      const StoresScreen(),
      const CartScreen(),
      const AccountScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/home.png",
                width: 25,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/love.png",
                width: 25,
              ),
              label: 'Favorite',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
              ),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/mart.png",
                width: 25,
              ),
              label: 'Stores',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/cart.png",
                width: 25,
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/user.png",
                width: 25,
              ),
              label: 'Account',
            ),
          ]),
      body: _pages[_pageIndex],
    );
  }
}
