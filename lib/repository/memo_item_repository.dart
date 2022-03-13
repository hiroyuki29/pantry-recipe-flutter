import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:pantry_recipe_flutter/viewModels/item_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';

final memoItemRepository =
Provider.autoDispose<MemoItemRepository>((ref) => MemoItemRepositoryImpl(ref.read));

abstract class MemoItemRepository {
  Future<List<MemoItem>> getMemoItemList(int memoId);
  Future<void> saveMemoItem(String bodyInput);
  Future<void> updateMemoItem(Map<String, dynamic> bodyInputMap);
  Future<void> deleteMemoItem(MemoItem memoItem);
  Future<void> incrementMemoItemQuantity(String pantryItemId, int unitQuantity) ;
}

class MemoItemRepositoryImpl implements MemoItemRepository {
  final Reader _read;

  MemoItemRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<List<MemoItem>> getMemoItemList(int memoId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    NetworkHelper networkHelper = NetworkHelper();
    var responseData =
    await networkHelper.getData(urlInput: 'memo_items/${memoId.toString()}/items', headerInput: _userInfo);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    final List<Map<String, dynamic>> memoItemListJsonList =
    List<Map<String, dynamic>>.from(responseBody['data']);
    return memoItemListJsonList.map((json) => MemoItem.fromMap(json)).toList();
  }

  @override
  Future<void> saveMemoItem(String bodyInput) async {
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.postData(
        urlInput: 'memo_items', headerInput: _userHeader, bodyInput: bodyInput);
  }

  @override
  Future<void> updateMemoItem(Map<String, dynamic> bodyInputMap) async {
    NetworkHelper networkHelper = NetworkHelper();
    int memoItemId = bodyInputMap['id'];
    await networkHelper.putData(
        urlInput: 'memo_items/$memoItemId', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
  }

  @override
  Future<void> deleteMemoItem(MemoItem memoItem) async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    Map<String, dynamic> itemMap = memoItem.toMap();
    String id = itemMap['id'].toString();
    _userInfo['memo_id'] = itemMap['memo_id'].toString();
    await networkHelper.deleteData(
        urlInput: 'memo_items/$id', headerInput: _userHeader, bodyInput: jsonEncode(_userInfo));
  }

  @override
  Future<void> incrementMemoItemQuantity(String memoItemId, int unitQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, dynamic> bodyInputBeforeJson = {};
    bodyInputBeforeJson['unit_quantity'] = unitQuantity;
    bodyInputBeforeJson['access-token'] = prefs.getString('access-token') ?? '';
    bodyInputBeforeJson['uid'] = prefs.getString('uid') ?? '';
    bodyInputBeforeJson['client'] = prefs.getString('client') ?? '';
    await networkHelper.putData(
        urlInput: 'memo_items/$memoItemId/increment', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputBeforeJson));
  }
}
