import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

final categoryRepository = Provider.autoDispose<CategoryRepository>(
    (ref) => CategoryRepositoryImpl(ref.read));

abstract class CategoryRepository {
  Future<List<Category>> getCategoryList();
}

const _categoryListKey = 'categoryListKey';

class CategoryRepositoryImpl implements CategoryRepository {
  final Reader _read;
  CategoryRepositoryImpl(this._read);

  @override
  Future<List<Category>> getCategoryList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList(_categoryListKey) ?? [];
    List<Category> categoryList = result.map((f) => Category.fromMap(json.decode(f))).toList();
    return categoryList;
  }
}
