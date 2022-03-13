import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/category.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

final categoryRepository =
Provider.autoDispose<CategoryRepository>((ref) => CategoryRepositoryImpl(ref.read));

abstract class CategoryRepository {
  Future<List<Category>> getCategoryList();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final Reader _read;
  CategoryRepositoryImpl(this._read);
  Map<String, String> _userHeader = {'content-type': 'application/json', "Access-Control_Allow_Origin": "*"};

  @override
  Future<List<Category>> getCategoryList() async {
    final prefs = await SharedPreferences.getInstance();
    _userHeader = {'access-token': prefs.getString('access-token') ?? ''};
    _userHeader['uid'] = prefs.getString('uid') ?? '';
    _userHeader['client'] = prefs.getString('client') ?? '';
    NetworkHelper networkHelper = NetworkHelper();
    var responseData = await networkHelper.getData(urlInput: 'categories', headerInput: _userHeader);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    final List<Map<String, dynamic>> categoryListJsonList =
    List<Map<String, dynamic>>.from(responseBody['data']);
    return categoryListJsonList.map((json) => Category.fromMap(json)).toList();
  }
}