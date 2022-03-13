import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/item_repository.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';

final itemListState = StateProvider<List<Item>?>((ref) => null);

final itemViewController =
    Provider.autoDispose((ref) => ItemViewController(ref.read));

class ItemViewController {
  final Reader _read;

  ItemViewController(this._read);

  Future<void> initState() async {
    _read(itemListState.notifier).state =
        await _read(itemRepository).getItemList();
  }

  void dispose() {
    _read(itemListState)?.clear();
  }

  String? alreadyIncludeCheck(Map<String, dynamic> inputMap) {
    for (Item item in _read(itemListState.notifier).state ?? []) {
      if (item.name == inputMap['name'] &&
          item.categoryId == inputMap['category_id']) {
        return item.id.toString();
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> makeBodyInput(
      {required String name,
      required int categoryId,
      required int unitQuantity}) async {
    final prefs = await SharedPreferences.getInstance();
    // int? userId = prefs.getInt('user_id');
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

// Future<void> addTodo(TextEditingController textController) async {
//   final String text = textController.text;
//   if (text.trim().isEmpty) {
//     return;
//   }
//   textController.text = '';
//   final now = DateTime.now();
//   final newTodo = Todo(
//     content: text,
//     done: false,
//     timestamp: now,
//     id: "${now.millisecondsSinceEpoch}",
//   );
//   final List<Todo> newTodoList = [newTodo, ...(_read(_todoListState) ?? [])];
//   _read(_todoListState.notifier).state = newTodoList;
//   await _read(todoRepository).saveTodoList(newTodoList);
// }

// Future<void> toggleDoneStatus(Todo todo) async {
//   final List<Todo> newTodoList = [
//     ...(_read(_todoListState) ?? [])
//         .map((e) => (e.id == todo.id) ? e.copyWith(done: !e.done) : e)
//   ];
//   _read(_todoListState.notifier).state = newTodoList;
//   await _read(todoRepository).saveTodoList(newTodoList);
// }
//
// void toggleSortOrder() {
//   _read(_sortOrderState.notifier).state =
//   _read(_sortOrderState) == SortOrder.ASC
//       ? SortOrder.DESC
//       : SortOrder.ASC;
// }
}
