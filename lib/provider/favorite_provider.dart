import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteProvider, Map<String, Favorite>>((ref) {
  return FavoriteProvider();
});

class FavoriteProvider extends StateNotifier<Map<String, Favorite>> {
  FavoriteProvider() : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteString = prefs.getString('favorites');
    if (favoriteString != null) {
      final Map<String, dynamic> favoriteMap = jsonDecode(favoriteString);
      final favorites = favoriteMap
          .map((key, value) => MapEntry(key, Favorite.fromJson(value)));
      state = favorites;
    }
  }

  // A private method that saves the current list of favorite items to sharedPreferences
  Future<void> _saveFavoritesToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteString = jsonEncode(state);
    await prefs.setString('favorites', favoriteString);
  }

  void addProductToFavorite({
    required String productName,
    required String category,
    required List<String> image,
    required int productPrice,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) async {
    state[productId] = Favorite(
      productName: productName,
      category: category,
      image: image,
      productPrice: productPrice,
      vendorId: vendorId,
      productQuantity: productQuantity,
      quantity: quantity,
      productId: productId,
      description: description,
      fullName: fullName,
    );
    //notify listeners the state has changed
    state = {...state};
    _saveFavoritesToSharedPreferences();
  }

  void removeProductFromFavorite(String productId) {
    state.remove(productId);
    //notify listeners the state has changed
    state = {...state};
    _saveFavoritesToSharedPreferences();
  }

  Map<String, Favorite> get getFavoriteItems => state;
}
