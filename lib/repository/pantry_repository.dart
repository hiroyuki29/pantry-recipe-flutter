import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:pantry_recipe_flutter/viewModels/item_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final pantryRepository =
Provider.autoDispose<PantryRepository>((ref) => PantryRepositoryImpl(ref.read));

abstract class PantryRepository {
  Future<List<PantryItem>> getPantryItemList();
  Future<void> savePantryItem(String bodyInput);
  Future<void> updatePantryItem(Map<String, dynamic> bodyInputMap);
  Future<void> moveFromMemo(Map<String, dynamic> bodyInputMap);
  Future<void> deletePantryItem(PantryItem pantryItem);
  Future<void> incrementPantryItemQuantity(String pantryItemId, int unitQuantity) ;
}

class PantryRepositoryImpl implements PantryRepository {
  final Reader _read;

  PantryRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<List<PantryItem>> getPantryItemList() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    NetworkHelper networkHelper = NetworkHelper();
    var responseData =
    await networkHelper.getData(urlInput: 'pantries', headerInput: _userInfo);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    final List<Map<String, dynamic>> pantryItemListJsonList =
    List<Map<String, dynamic>>.from(responseBody['data']);
    return pantryItemListJsonList.map((json) => PantryItem.fromMap(json)).toList();
  }

  @override
  Future<void> savePantryItem(String bodyInput) async {
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.postData(
        urlInput: 'pantries', headerInput: _userHeader, bodyInput: bodyInput);
  }

  @override
  Future<void> updatePantryItem(Map<String, dynamic> bodyInputMap) async {
    NetworkHelper networkHelper = NetworkHelper();
    int pantryId = bodyInputMap['id'];
    await networkHelper.putData(
        urlInput: 'pantries/$pantryId', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
  }

  @override
  Future<void> moveFromMemo(Map<String, dynamic> bodyInputMap) async {
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.postData(
        urlInput: 'pantries/move_from_memo', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
  }

  @override
  Future<void> deletePantryItem(PantryItem pantryItem) async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, String> _userInfo = {
      'access-token': prefs.getString('access-token') ?? ''
    };
    _userInfo['uid'] = prefs.getString('uid') ?? '';
    _userInfo['client'] = prefs.getString('client') ?? '';
    Map<String, dynamic> itemMap = pantryItem.toMap();
    String id = itemMap['id'].toString();
    await networkHelper.deleteData(
        urlInput: 'pantries/$id', headerInput: _userHeader, bodyInput: jsonEncode(_userInfo));
  }

  @override
  Future<void> incrementPantryItemQuantity(String pantryItemId, int unitQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, dynamic> bodyInputBeforeJson = {};
    bodyInputBeforeJson['unit_quantity'] = unitQuantity;
    bodyInputBeforeJson['access-token'] = prefs.getString('access-token') ?? '';
    bodyInputBeforeJson['uid'] = prefs.getString('uid') ?? '';
    bodyInputBeforeJson['client'] = prefs.getString('client') ?? '';
    await networkHelper.putData(
        urlInput: 'pantries/$pantryItemId/increment', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputBeforeJson));
  }
}
