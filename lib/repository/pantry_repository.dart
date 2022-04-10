import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewModels/pantry_view_controller.dart';

final pantryRepository = Provider.autoDispose<PantryRepository>(
    (ref) => PantryRepositoryImpl(ref.read));

abstract class PantryRepository {
  Future<List<PantryItem>> getPantryItemList();
  Future<void> savePantryItem();
}

const _pantryItemListKey = 'pantryItemListKey';

class PantryRepositoryImpl implements PantryRepository {
  final Reader _read;

  PantryRepositoryImpl(this._read);

  @override
  Future<List<PantryItem>> getPantryItemList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList(_pantryItemListKey) ?? [];
    List<PantryItem> itemList = result.map((f) => PantryItem.fromMap(json.decode(f))).toList();
    return itemList;
  }

  @override
  Future<void> savePantryItem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemList = _read(pantryItemListProvider);
    List<String> pantryItemListForPref = itemList.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList(_pantryItemListKey, pantryItemListForPref);
  }
}
