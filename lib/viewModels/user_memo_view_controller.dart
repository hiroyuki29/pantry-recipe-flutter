import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/user_memo_repository.dart';
import 'package:pantry_recipe_flutter/entity/memo.dart';

final userMemoListState = StateProvider<List<Memo>?>((ref) => null);

final userMemoViewController =
    Provider.autoDispose((ref) => UserMemoViewController(ref.read));

class UserMemoViewController {
  final Reader _read;

  UserMemoViewController(this._read);

  Future<void> initState() async {
    _read(userMemoListState.notifier).state =
        await _read(userMemoRepository).getUserMemoList();
  }

  void dispose() {
    _read(userMemoListState)?.clear();
  }

  String? alreadyIncludeCheck(Map<String, dynamic> inputMap) {
    for (Memo userMemo in _read(userMemoListState.notifier).state ?? []) {
      if (userMemo.name == inputMap['name']) {
        return userMemo.id.toString();
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> makeBodyInput({required String name, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': name,
      'password': password,
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
