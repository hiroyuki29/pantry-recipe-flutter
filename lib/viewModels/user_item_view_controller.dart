import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/user_item_repository.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';

final userItemListState = StateProvider<List<Item>?>((ref) => null);

final userItemViewController =
    Provider.autoDispose((ref) => UserItemViewController(ref.read));

class UserItemViewController {
  final Reader _read;

  UserItemViewController(this._read);

  Future<void> initState() async {
    _read(userItemListState.notifier).state =
        await _read(userItemRepository).getUserItemList();
  }

  void dispose() {
    _read(userItemListState)?.clear();
  }

  String? alreadyIncludeCheck(Map<String, dynamic> inputMap) {
    for (Item userItem in _read(userItemListState.notifier).state ?? []) {
      if (userItem.name == inputMap['name'] &&
          userItem.unitQuantity == inputMap['unit_quantity']) {
        return userItem.id.toString();
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
}
