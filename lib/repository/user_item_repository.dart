import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewModels/user_item_view_controller.dart';

final userItemRepository =
Provider.autoDispose<UserItemRepository>((ref) => UserItemRepositoryImpl(ref.read));

abstract class UserItemRepository {
  Future<List<Item>> getUserItemList();
  Future<void> saveUserItem();
}

const _userItemListKey = 'userItemListKey';

class UserItemRepositoryImpl implements UserItemRepository {
  final Reader _read;

  UserItemRepositoryImpl(this._read);

  @override
  Future<List<Item>> getUserItemList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList(_userItemListKey) ?? [];
    List<Item> itemList = result.map((f) => Item.fromMap(json.decode(f))).toList();
    return itemList;
  }

  @override
  Future<void> saveUserItem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemList = _read(userItemListProvider);
    List<String> itemListForPref = itemList.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList(_userItemListKey, itemListForPref);
  }
}
