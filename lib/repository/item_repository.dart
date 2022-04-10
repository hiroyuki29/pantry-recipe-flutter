import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';

final itemRepository =
    Provider.autoDispose<ItemRepository>((ref) => ItemRepositoryImpl(ref.read));

abstract class ItemRepository {
  Future<int> saveItem(Map<String, dynamic> bodyInputMap);
}

class ItemRepositoryImpl implements ItemRepository {
  final Reader _read;

  ItemRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<int> saveItem(Map<String, dynamic> bodyInputMap) async {
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, dynamic> response = await networkHelper.postData(
        urlInput: 'items', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
    dynamic responseBody = response['body'];
    dynamic responseData = jsonDecode(responseBody)['data'];
    return responseData['id'];
  }
}
