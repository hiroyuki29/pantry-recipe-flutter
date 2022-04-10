import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/category.dart';
import 'package:pantry_recipe_flutter/repository/category_repository.dart';

final categoryListProvider =
StateNotifierProvider<CategoryList, List<Category>>(
        (ref) => CategoryList(const []));
final sortedCategories = Provider<List<Category>>((ref) {
  final categories = ref.watch(categoryListProvider);
  if (categories.isNotEmpty) {
    categories.sort((a, b) => a.id.compareTo(b.id));
  }
  return categories;
});

final isSelectedState = StateProvider<List<bool>>(
    (ref) => [true, false, false, false, false, false, false]);

final categoryViewController =
    Provider.autoDispose((ref) => CategoryViewController(ref.read));

class CategoryViewController {
  final Reader _read;

  CategoryViewController(this._read);

  Future<void> initState() async {
    _read(categoryListProvider.notifier).state =
        await _read(categoryRepository).getCategoryList();
  }

  void dispose() {
    _read(categoryListProvider.notifier).state.clear();
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
