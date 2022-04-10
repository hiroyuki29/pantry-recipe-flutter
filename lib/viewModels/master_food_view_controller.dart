import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'package:pantry_recipe_flutter/repository/master_food_repository.dart';

final masterFoodListProvider =
StateNotifierProvider<MasterFoodList, List<MasterFood>>(
        (ref) => MasterFoodList(const []));
final sortedMasterFoods = Provider<List<MasterFood>>((ref) {
  final masterFoods = ref.watch(masterFoodListProvider);
  if (masterFoods.isNotEmpty) {
    masterFoods.sort((a, b) => a.id.compareTo(b.id));
  }
  return masterFoods;
});

final masterFoodViewController =
    Provider.autoDispose((ref) => MasterFoodViewController(ref.read));

class MasterFoodViewController {
  final Reader _read;

  MasterFoodViewController(this._read);

  Future<void> initState() async {
    _read(masterFoodListProvider.notifier).state =
        await _read(masterFoodRepository).getMasterFoodList();
  }

  void dispose() {
    _read(masterFoodListProvider).clear();
  }

}
