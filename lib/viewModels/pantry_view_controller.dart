import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/pantry_repository.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';

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
    for (PantryItem pantryItem in _read(pantryItemListState.notifier).state ?? []) {
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

  Future<Map<String, dynamic>> makeBodyInputForEdit(PantryItem pantryItem) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    return {
      'id':pantryItem.id,
      'user_id': userId,
      'item_id': pantryItem.itemId,
      'quantity': pantryItem.quantity,
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
