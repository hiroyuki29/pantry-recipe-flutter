import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/repository/master_food_repository.dart';
import 'package:pantry_recipe_flutter/repository/user_item_repository.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import '../entity/master_food.dart';

final userItemListProvider = StateNotifierProvider.autoDispose<ItemList, List<Item>>((ref) => ItemList(const []));
final filteredUsersItems = Provider.autoDispose<List<Item>>((ref) {
  final items = ref.watch(userItemListProvider);
  if (items.isNotEmpty){
    items.sort((a, b) => a.categoryId.compareTo(b.categoryId));
  }
  return items.where((item) => !item.removed).toList();
});

final userItemViewController =
    Provider.autoDispose((ref) => UserItemViewController(ref.read));

class UserItemViewController {
  final Reader _read;

  UserItemViewController(this._read);

  Future<void> initState() async {
    _read(userItemListProvider.notifier).state =
        await _read(userItemRepository).getUserItemList();
  }

  void dispose() {
    _read(userItemListProvider).clear();
  }

  Future<void> add(Item addItem) async {
    _read(userItemListProvider.notifier).add(addItem);
    await _read(userItemRepository).saveUserItem();
  }

  Future<String?> alreadyIncludeCheck(MasterFood masterFood) async {
    Map<String, dynamic> inputMap = await _read(masterFoodRepository).toUserItemMap(masterFood);
    for (Item userItem in _read(userItemListProvider) ?? []) {
      if (userItem.name == inputMap['name'] &&
          userItem.unitQuantity == inputMap['unit_quantity']) {
        if (userItem.removed){
          _read(userItemListProvider.notifier).toggleRemove(userItem.id);
          await _read(userItemRepository).saveUserItem();
        }
        return userItem.itemId.toString();
      }
    }
    return null;
  }

  Future<void> deleteItem(String id) async {
    _read(userItemListProvider.notifier).remove(id);
    await _read(userItemRepository).saveUserItem();
  }
}
