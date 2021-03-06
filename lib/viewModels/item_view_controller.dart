import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';

final itemListState = StateProvider<List<Item>?>((ref) => null);

final itemViewController =
    Provider.autoDispose((ref) => ItemViewController(ref.read));

class ItemViewController {
  final Reader _read;

  ItemViewController(this._read);

  void dispose() {
    _read(itemListState)?.clear();
  }

  Future<Map<String, dynamic>> makeBodyInput(
      {required String name,
      required int categoryId,
      required int unitQuantity}) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': name,
      'category_id': categoryId,
      'user_id': prefs.getInt('user_id'),
      'unit_quantity': unitQuantity,
      'master_food_id': null,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }
}
