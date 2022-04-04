import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/pantry_repository.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';

final pantryItemListState = StateProvider<List<PantryItem>?>((ref) => null);

final pantryViewController =
    Provider.autoDispose((ref) => PantryViewController(ref.read));

class PantryViewController {
  final Reader _read;

  PantryViewController(this._read);

  Future<void> initState() async {
    _read(pantryItemListState.notifier).state =
        await _read(pantryRepository).getPantryItemList();
  }

  void dispose() {
    _read(pantryItemListState)?.clear();
  }

  String? alreadyIncludeCheck(Map<String, dynamic> inputMap) {
    for (PantryItem pantryItem
        in _read(pantryItemListState.notifier).state ?? []) {
      if (pantryItem.name == inputMap['name']) {
        return pantryItem.id.toString();
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> makeBodyInput(Item item) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    return {
      'user_id': userId,
      'item_id': item.id,
      'quantity': item.unitQuantity,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  Future<Map<String, dynamic>> makeBodyInputForEdit(
      PantryItem pantryItem) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    return {
      'id': pantryItem.id,
      'user_id': userId,
      'item_id': pantryItem.itemId,
      'quantity': pantryItem.quantity,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  Future<void> quantityEdit(PantryItem pantryItem, int quantity) async {
    Map<String, dynamic> bodyInputMap =
        await _read(pantryViewController).makeBodyInputForEdit(pantryItem);
    bodyInputMap['quantity'] = quantity;
    await _read(pantryRepository).updatePantryItem(bodyInputMap);
    await _read(pantryViewController).initState();
  }
}
