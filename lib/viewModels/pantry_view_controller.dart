import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/pantry_repository.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';

final pantryItemListProvider =
StateNotifierProvider<PantryItemList, List<PantryItem>>(
        (ref) => PantryItemList(const []));
final filteredPantryItems = Provider<List<PantryItem>>((ref) {
  final pantryItems = ref.watch(pantryItemListProvider);
  if (pantryItems.isNotEmpty) {
    pantryItems.sort((a, b) => a.categoryId.compareTo(b.categoryId));
  }
  return pantryItems.where((item) => !item.removed).toList();
});
final pantryViewController =
    Provider.autoDispose((ref) => PantryViewController(ref.read));

class PantryViewController {
  final Reader _read;

  PantryViewController(this._read);

  Future<void> initState() async {
    _read(pantryItemListProvider.notifier).state =
        await _read(pantryRepository).getPantryItemList();
  }

  void dispose() {
    _read(pantryItemListProvider).clear();
  }

  Future<String?> alreadyIncludeCheck(Item item) async {
    String name = item.name;
    for (PantryItem pantryItem in _read(pantryItemListProvider) ?? []) {
      if (pantryItem.name == name) {
        if (pantryItem.removed) {
          _read(pantryItemListProvider.notifier).toggleRemove(pantryItem.id);
          await _read(pantryRepository).savePantryItem();
        }
        return pantryItem.id;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> makeBodyInput(Item item) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    return {
      'user_id': userId,
      'item_id': item.itemId,
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
    _read(pantryItemListProvider.notifier).edit(id: pantryItem.id, quantity: quantity);
    await _read(pantryRepository).savePantryItem();
  }

  Future<void> moveToPantry(Item item) async {
    String? pantryItemId = await _read(pantryViewController)
        .alreadyIncludeCheck(item);
    if (pantryItemId != null) {
      _read(pantryItemListProvider.notifier)
          .increment(id: pantryItemId, addQuantity: item.unitQuantity);
      await _read(pantryRepository).savePantryItem();
    } else {
      PantryItem addPantryItem = PantryItem.fromUserItem(item);
      _read(pantryItemListProvider.notifier).add(addPantryItem);
      await _read(pantryRepository).savePantryItem();
    }
  }

  Future<void> deletePantryItem(String id) async {
    _read(pantryItemListProvider.notifier).remove(id);
    await _read(pantryRepository).savePantryItem();
  }
}
