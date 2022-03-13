import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'package:pantry_recipe_flutter/repository/master_food_repository.dart';

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
}
