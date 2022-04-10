import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/entity/memo.dart';
import '../viewModels/user_memo_view_controller.dart';

final userMemoRepository = Provider.autoDispose<UserMemoRepository>(
    (ref) => UserMemoRepositoryImpl(ref.read));

abstract class UserMemoRepository {
  Future<List<Memo>> getUserMemoList();
  Future<void> saveMemo();
  Future<String> registerUserMemo(Map<String, dynamic> bodyInputMap);
  Future<String> searchMemo(Map<String, dynamic> bodyInputMap);
  Future<void> deleteUserMemo(Memo memo);
}

const _memoListKey = 'memoListKey';

class UserMemoRepositoryImpl implements UserMemoRepository {
  final Reader _read;

  UserMemoRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<List<Memo>> getUserMemoList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList(_memoListKey) ?? [];
    List<Memo> memoList = result.map((f) => Memo.fromMap(json.decode(f))).toList();
    return memoList;
  }

  @override
  Future<void> saveMemo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemList = _read(userMemoListProvider);
    List<String> itemListForPref = itemList.map((memo) => json.encode(memo.toMap())).toList();
    await prefs.setStringList(_memoListKey, itemListForPref);
  }

  @override
  Future<String> registerUserMemo(Map<String, dynamic> bodyInputMap) async {
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, dynamic> response = await networkHelper.postData(
        urlInput: 'memos',
        headerInput: _userHeader,
        bodyInput: jsonEncode(bodyInputMap));
    Map<String, dynamic> responseBody = jsonDecode(response['body']);
    if (responseBody['status'] == 'SUCCESS') {
      dynamic responseBody = response['body'];
      dynamic responseData = jsonDecode(responseBody)['data'];
      bodyInputMap['memo_id'] = responseData['id'];
      await networkHelper.postData(
          urlInput: 'memo_users',
          headerInput: _userHeader,
          bodyInput: jsonEncode(bodyInputMap));
      return bodyInputMap['memo_id'].toString();
    } else {
      return '';
    }
  }

  @override
  Future<String> searchMemo(Map<String, dynamic> bodyInputMap) async {
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, dynamic> response = await networkHelper.postData(
        urlInput: 'memos/search',
        headerInput: _userHeader,
        bodyInput: jsonEncode(bodyInputMap));
    Map<String, dynamic> responseBody = jsonDecode(response['body']);
    if (responseBody['status'] == 'SUCCESS') {
      dynamic responseBody = response['body'];
      dynamic responseData = jsonDecode(responseBody)['data'];
      bodyInputMap['memo_id'] = responseData['id'];
      await networkHelper.postData(
          urlInput: 'memo_users',
          headerInput: _userHeader,
          bodyInput: jsonEncode(bodyInputMap));
      return bodyInputMap['memo_id'].toString();
    } else {
      return '';
    }
  }

  @override
  Future<void> deleteUserMemo(Memo memo) async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    String id = memo.id.toString();
    await networkHelper.deleteData(
        urlInput: 'memos/$id',
        headerInput: _userHeader,
        bodyInput: jsonEncode(_userInfo));
    _read(userMemoListProvider.notifier).remove(id);
    _read(userMemoRepository).saveMemo();
  }
}
