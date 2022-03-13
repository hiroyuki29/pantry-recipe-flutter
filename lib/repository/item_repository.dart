import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:pantry_recipe_flutter/viewModels/item_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final itemRepository =
    Provider.autoDispose<ItemRepository>((ref) => ItemRepositoryImpl(ref.read));

abstract class ItemRepository {
  Future<List<Item>> getItemList();
  Future<int> saveItem(String bodyInput);
  Future<void> deleteItem(Item item);
  Future<void> incrementItemQuantity(String userId);
}

class ItemRepositoryImpl implements ItemRepository {
  final Reader _read;

  ItemRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<List<Item>> getItemList() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    NetworkHelper networkHelper = NetworkHelper();
    var responseData =
        await networkHelper.getData(urlInput: 'items', headerInput: _userInfo);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    final List<Map<String, dynamic>> itemListJsonList =
        List<Map<String, dynamic>>.from(responseBody['data']);
    return itemListJsonList.map((json) => Item.fromMap(json)).toList();
  }

  @override
  Future<int> saveItem(String bodyInput) async {
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, dynamic> response = await networkHelper.postData(
        urlInput: 'items', headerInput: _userHeader, bodyInput: bodyInput);
    dynamic responseBody = response['body'];
    dynamic responseData = jsonDecode(responseBody)['data'];
    return responseData['id'];
  }

  @override
  Future<void> deleteItem(Item item) async {
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
        urlInput: 'items/$id', headerInput: _userHeader, bodyInput: jsonEncode(_userInfo));
  }

  @override
  Future<void> incrementItemQuantity(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    NetworkHelper networkHelper = NetworkHelper();
    var responseData = await networkHelper.getData(urlInput: 'items/$itemId', headerInput: _userInfo);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    Map<String, dynamic> bodyInputBeforeJson = responseBody['data'];
    int beforeQuantity = bodyInputBeforeJson['unit_quantity'] ;
    bodyInputBeforeJson['unit_quantity'] = beforeQuantity + 1;
    bodyInputBeforeJson['access-token'] = prefs.getString('access-token') ?? '';
    bodyInputBeforeJson['uid'] = prefs.getString('uid') ?? '';
    bodyInputBeforeJson['client'] = prefs.getString('client') ?? '';
    await networkHelper.putData(
        urlInput: 'items/$itemId', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputBeforeJson));
  }
}
