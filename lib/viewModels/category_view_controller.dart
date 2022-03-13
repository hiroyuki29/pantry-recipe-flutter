import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/category.dart';
import 'package:pantry_recipe_flutter/repository/category_repository.dart';

final categoryListState = StateProvider<List<Category>?>((ref) => null);

final isSelectedState = StateProvider<List<bool>>(
    (ref) => [true, false, false, false, false, false, false]);

final categoryViewController =
    Provider.autoDispose((ref) => CategoryViewController(ref.read));

class CategoryViewController {
  final Reader _read;

  CategoryViewController(this._read);

  Future<void> initState() async {
    _read(categoryListState.notifier).state =
        await _read(categoryRepository).getCategoryList();
  }

  void dispose() {
    _read(categoryListState)?.clear();
  }

  int toggleCategorySelect(index) {
    // final List<String> categoryList = ['野菜', '肉', '魚', '加工品', '飲み物', '日用品', 'その他'];
    List<bool> selectedState = _read(isSelectedState.notifier).state;
    selectedState = [
      for (var i = 0; i < selectedState.length; i++)
        if (i == index) selectedState[i] = true else false
    ];
    _read(isSelectedState.notifier).state = selectedState;
    return selectedState.indexOf(true);
  }

  void resetCategorySelect() {
    _read(isSelectedState.notifier).state = [
      true,
      false,
      false,
      false,
      false,
      false,
      false
    ];
  }
}
