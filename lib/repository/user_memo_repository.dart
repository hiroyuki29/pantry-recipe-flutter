import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/entity/memo.dart';

final userMemoRepository = Provider.autoDispose<UserMemoRepository>(
    (ref) => UserMemoRepositoryImpl(ref.read));

abstract class UserMemoRepository {
  Future<List<Memo>> getUserMemoList();

  Future<bool> saveUserMemo(Map<String, dynamic> bodyInputMap);

  Future<bool> searchMemo(Map<String, dynamic> bodyInputMap);

  Future<void> deleteUserMemo(Memo memo);
}

class UserMemoRepositoryImpl implements UserMemoRepository {
  final Reader _read;

  UserMemoRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<List<Memo>> getUserMemoList() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    NetworkHelper networkHelper = NetworkHelper();
    var responseData = await networkHelper.getData(
        urlInput: 'memo_users', headerInput: _userInfo);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    final List<Map<String, dynamic>> memoListJsonList =
        List<Map<String, dynamic>>.from(responseBody['data']);
    return memoListJsonList.map((json) => Memo.fromMap(json)).toList();
  }

  @override
  Future<bool> saveUserMemo(Map<String, dynamic> bodyInputMap) async {
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
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> searchMemo(Map<String, dynamic> bodyInputMap) async {
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
      return true;
    } else {
      return false;
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
    Map<String, dynamic> memoMap = memo.toMap();
    String id = memoMap['id'].toString();
    await networkHelper.deleteData(
        urlInput: 'memos/$id',
        headerInput: _userHeader,
        bodyInput: jsonEncode(_userInfo));
  }
}
