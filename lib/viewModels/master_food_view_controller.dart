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