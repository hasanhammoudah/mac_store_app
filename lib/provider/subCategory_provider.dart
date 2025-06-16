import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/subcategory.dart';

class SubcategoryProvider extends StateNotifier<List<Subcategory>>{
  SubcategoryProvider():super([]);



  //set the list of subcategories
  void setSubCategories(List<Subcategory> subcategories){
    state = subcategories;
  }
}
final subcategoryProvider = StateNotifierProvider<SubcategoryProvider, List<Subcategory>>(
      (ref) => SubcategoryProvider(),
);