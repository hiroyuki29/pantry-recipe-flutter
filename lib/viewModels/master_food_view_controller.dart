import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'package:pantry_recipe_flutter/repository/master_food_repository.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/repository/user_item_repository.dart';
import 'package:pantry_recipe_flutter/repository/item_repository.dart';

final masterFoodListState = StateProvider<List<MasterFood>?>((ref) => null);

final masterFoodViewController =
    Provider.autoDispose((ref) => MasterFoodViewController(ref.read));

class MasterFoodViewController {
  final Reader _read;

  MasterFoodViewController(this._read);

  Future<void> initState() async {
    _read(masterFoodListState.notifier).state =
        await _read(masterFoodRepository).getMasterFoodList();
  }

  void dispose() {
    _read(masterFoodListState)?.clear();
  }

  Future<bool> moveToItem(MasterFood masterFood) async {
    Map<String, dynamic> newItemMap =
        await _read(masterFoodRepository).toItemMap(masterFood);
    Map<String, dynamic> newUserItemMap =
        await _read(masterFoodRepository).toUserItemMap(masterFood);
    String? checkedResult =
        _read(userItemViewController).alreadyIncludeCheck(newItemMap);
    if (checkedResult != null) {
      return true;
    } else {
      int registerItemId =
          await _read(itemRepository).saveItem(jsonEncode(newItemMap));
      newUserItemMap['item_id'] = registerItemId;
      await _read(userItemRepository).saveUserItem(newUserItemMap);
      _read(userItemViewController).initState();
      return false;
    }
  }
}
