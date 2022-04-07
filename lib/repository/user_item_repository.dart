import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userItemRepository =
Provider.autoDispose<UserItemRepository>((ref) => UserItemRepositoryImpl(ref.read));

abstract class UserItemRepository {
  Future<List<Item>> getUserItemList();
  Future<void> saveUserItem(Map<String, dynamic> bodyInputMap);
  Future<void> deleteUserItem(Item item);
}

class UserItemRepositoryImpl implements UserItemRepository {
  final Reader _read;

  UserItemRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<List<Item>> getUserItemList() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    NetworkHelper networkHelper = NetworkHelper();
    var responseData =
    await networkHelper.getData(urlInput: 'user_items', headerInput: _userInfo);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    final List<Map<String, dynamic>> itemListJsonList =
    List<Map<String, dynamic>>.from(responseBody['data']);
    return itemListJsonList.map((json) => Item.fromMap(json)).toList();
  }

  @override
  Future<void> saveUserItem(Map<String, dynamic> bodyInputMap) async {
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.postData(
        urlInput: 'user_items', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
  }

  @override
  Future<void> deleteUserItem(Item item) async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    Map<String, dynamic> itemMap = item.toMap();
    String id = itemMap['id'].toString();
    await networkHelper.deleteData(
        urlInput: 'user_items/$id', headerInput: _userHeader, bodyInput: jsonEncode(_userInfo));
  }
}
