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

  Future<Map<String, dynamic>> makeBodyInput(
      {required String name, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': name,
      'password': password,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  Future<bool> memoRegister(String memoName, String password) async {
    Map<String, dynamic> bodyInput = await _read(userMemoViewController)
        .makeBodyInput(
        name: memoName, password: password);
    bool registerResult = await _read(userMemoRepository)
        .saveUserMemo(bodyInput);
    if (registerResult) {
      _read(userMemoViewController).initState();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> memoSearch(String memoName, String password) async {
    Map<String, dynamic> bodyInput = await _read(userMemoViewController)
        .makeBodyInput(
        name: memoName, password: password);
    bool registerResult = await _read(userMemoRepository)
        .searchMemo(bodyInput);
    if (registerResult) {
      _read(userMemoViewController).initState();
      return true;
    } else {
      return false;
    }
  }

}
