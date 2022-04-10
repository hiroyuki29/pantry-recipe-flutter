import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/user_memo_repository.dart';
import 'package:pantry_recipe_flutter/entity/memo.dart';

final userMemoListProvider =
StateNotifierProvider<MemoList, List<Memo>>(
        (ref) => MemoList(const []));

final userMemoViewController =
    Provider.autoDispose((ref) => UserMemoViewController(ref.read));

class UserMemoViewController {
  final Reader _read;

  UserMemoViewController(this._read);

  Future<void> initState() async {
    _read(userMemoListProvider.notifier).state =
        await _read(userMemoRepository).getUserMemoList();
  }

  void dispose() {
    _read(userMemoListProvider).clear();
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
    String memoId = await _read(userMemoRepository)
        .registerUserMemo(bodyInput);
    if (memoId != '') {
      _read(userMemoListProvider.notifier).add(id: memoId, name: memoName, password: password);
      _read(userMemoRepository).saveMemo();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> memoSearch(String memoName, String password) async {
    Map<String, dynamic> bodyInput = await _read(userMemoViewController)
        .makeBodyInput(
        name: memoName, password: password);
    String memoId = await _read(userMemoRepository)
        .searchMemo(bodyInput);
    if (memoId != '') {
      _read(userMemoListProvider.notifier).add(id: memoId, name: memoName, password: password);
      _read(userMemoRepository).saveMemo();
      return true;
    } else {
      return false;
    }
  }

}
