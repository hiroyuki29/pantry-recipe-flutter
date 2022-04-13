import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:pantry_recipe_flutter/viewModels/category_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/master_food_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/pantry_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';
import '../entity/category.dart';
import '../entity/item.dart';
import 'package:pantry_recipe_flutter/entity/memo.dart';
import '../entity/master_food.dart';
import '../entity/pantry.dart';
import '../viewModels/memo_item_view_controller.dart';
import '../viewModels/user_item_view_controller.dart';
import '../viewModels/user_memo_view_controller.dart';

final networkingRepository = Provider.autoDispose<NetworkingRepository>(
    (ref) => NetworkingRepositoryImpl(ref.read));

abstract class NetworkingRepository {
  Future<String> download();
  Future<void> upload();
  Future<Map<String, dynamic>> makeBodyUserItem(Item item);
  Future<Map<String, dynamic>> makeBodyMemoItem(MemoItem item, String memoId);
  Future<Map<String, dynamic>> makeBodyPantryItem(PantryItem pantryItem);
  void resetCache();
}

const _categoryListKey = 'categoryListKey';
const _masterFoodListKey = 'masterFoodListKey';
const _userItemListKey = 'userItemListKey';
const _memoItemListKey = 'memoItemListKey';
const _memoListKey = 'memoListKey';
const _pantryItemListKey = 'pantryItemListKey';

class NetworkingRepositoryImpl implements NetworkingRepository {
  final Reader _read;

  NetworkingRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<String> download() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access-token') ?? '';
    String uid = prefs.getString('uid') ?? '';
    String client = prefs.getString('client') ?? '';
    Map<String, String> _userInfo = {
      'access-token': accessToken,
      'uid': uid,
      'client': client
    };

    NetworkHelper networkHelper = NetworkHelper();
    //get categories
    var responseCategoryData = await networkHelper.getData(
        urlInput: 'categories', headerInput: _userHeader);
    Map<String, dynamic> responseCategoryBody = jsonDecode(responseCategoryData['body']);
    final List<Map<String, dynamic>> categoryListJsonList =
    List<Map<String, dynamic>>.from(responseCategoryBody['data']);
    final categoryList =  categoryListJsonList.map((json) => Category.fromMap(json)).toList();
    List<String> categoryListForPref =
    categoryList.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList(_categoryListKey, categoryListForPref);

    //get master_foods
    var responseMasterFoodData = await networkHelper.getData(
        urlInput: 'master_foods', headerInput: _userHeader);
    Map<String, dynamic> responseMasterFoodBody = jsonDecode(responseMasterFoodData['body']);
    final List<Map<String, dynamic>> masterFoodListJsonList =
    List<Map<String, dynamic>>.from(responseMasterFoodBody['data']);
    final masterFoodList = masterFoodListJsonList.map((json) => MasterFood.fromMap(json)).toList();
    List<String> masterFoodListForPref =
    masterFoodList.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList(_masterFoodListKey, masterFoodListForPref);

    //get user_items
    var responseUserItemData = await networkHelper.getData(
        urlInput: 'user_items', headerInput: _userInfo);
    Map<String, dynamic> responseUserItemBody =
        jsonDecode(responseUserItemData['body']);
    final List<Map<String, dynamic>> itemListJsonList =
        List<Map<String, dynamic>>.from(responseUserItemBody['data']);
    final userItemList =
        itemListJsonList.map((json) => Item.fromMap(json)).toList();
    List<String> itemListForPref =
        userItemList.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList(_userItemListKey, itemListForPref);
    await _read(userItemViewController).initState();

    //get memo_list
    var responseMemoData = await networkHelper.getData(
        urlInput: 'memo_users', headerInput: _userInfo);
    Map<String, dynamic> responseMemoBody =
        jsonDecode(responseMemoData['body']);
    final List<Map<String, dynamic>> memoListJsonList =
        List<Map<String, dynamic>>.from(responseMemoBody['data']);
    final userMemoList =
        memoListJsonList.map((json) => Memo.fromMap(json)).toList();
    List<String> memoListForPref =
        userMemoList.map((memo) => json.encode(memo.toMap())).toList();
    await prefs.setStringList(_memoListKey, memoListForPref);
    await _read(userMemoViewController).initState();

    // get memo_items
    for (Memo memo in userMemoList) {
      var responseMemoItemData = await networkHelper.getData(
          urlInput: 'memo_items/${memo.id}/items', headerInput: _userInfo);
      Map<String, dynamic> responseMemoItemBody =
          jsonDecode(responseMemoItemData['body']);
      final List<Map<String, dynamic>> memoItemListJsonList =
          List<Map<String, dynamic>>.from(responseMemoItemBody['data']);
      final memoItemList =
          memoItemListJsonList.map((json) => MemoItem.fromMap(json)).toList();
      List<String> memoItemListForPref =
          memoItemList.map((item) => json.encode(item.toMap())).toList();
      String editMemoItemListKey = _memoItemListKey + memo.id;
      await prefs.setStringList(editMemoItemListKey, memoItemListForPref);
      await _read(memoItemViewController).initState(memoId: memo.id);
    }

    // get pantry_items
    var responsePantryData = await networkHelper.getData(
        urlInput: 'pantries', headerInput: _userInfo);
    Map<String, dynamic> responsePantryBody =
        jsonDecode(responsePantryData['body']);
    final List<Map<String, dynamic>> pantryItemListJsonList =
        List<Map<String, dynamic>>.from(responsePantryBody['data']);
    final pantryItemList =
        pantryItemListJsonList.map((json) => PantryItem.fromMap(json)).toList();
    List<String> pantryItemListForPref =
        pantryItemList.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList(_pantryItemListKey, pantryItemListForPref);
    await _read(pantryViewController).initState();

    return 'finish';
  }

  @override
  Future<void> upload() async {
    Map<String, int> newItemID = {};

    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access-token') ?? '';
    String uid = prefs.getString('uid') ?? '';
    String client = prefs.getString('client') ?? '';
    Map<String, String> _userInfo = {
      'access-token': accessToken,
      'uid': uid,
      'client': client
    };

    NetworkHelper networkHelper = NetworkHelper();

    //upload user_items
    await _read(userItemViewController).initState();
    final userItemList = _read(userItemListProvider);
    for (Item userItem in userItemList){
      if(userItem.removed == false && userItem.newCreate){
        Map<String, dynamic> bodyInputMap = await _read(networkingRepository).makeBodyUserItem(userItem);
        if(userItem.itemId == 0){
          Map<String, dynamic> response = await networkHelper.postData(
              urlInput: 'items', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
          dynamic responseBody = response['body'];
          dynamic responseData = jsonDecode(responseBody)['data'];
          bodyInputMap['item_id'] =  responseData['id'];
          newItemID[userItem.name] = bodyInputMap['item_id'];
        }
          await networkHelper.postData(
              urlInput: 'user_items', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
      } else if (userItem.removed && userItem.newCreate == false){
        await networkHelper.deleteData(
            urlInput: 'user_items/${userItem.id}', headerInput: _userHeader, bodyInput: jsonEncode(_userInfo));
      }
    }

    //upload memo_items
    await _read(userMemoViewController).initState();
    final memoList = _read(userMemoListProvider);
    for (Memo memo in memoList) {
      String editMemoItemListKey = _memoItemListKey + memo.id;
      var result = prefs.getStringList(editMemoItemListKey) ?? [];
      List<MemoItem> itemList = result.map((f) =>
          MemoItem.fromMap(json.decode(f))).toList();
      for (MemoItem memoItem in itemList) {
        Map<String, dynamic> bodyInputMap = await _read(networkingRepository)
            .makeBodyMemoItem(memoItem, memo.id);
        if (memoItem.itemId == 0){
          bodyInputMap['item_id'] = newItemID[memoItem.name];
        }
        if(memoItem.removed == false){
          if (memoItem.newCreate){
            await networkHelper.postData(
                urlInput: 'memo_items', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
          } else if(memoItem.edited) {
            await networkHelper.putData(
                urlInput: 'memo_items/${memoItem.id}',
                headerInput: _userHeader,
                bodyInput: jsonEncode(bodyInputMap));
          }
        } else if (memoItem.removed && memoItem.newCreate == false){
          await networkHelper.deleteData(
              urlInput: 'memo_items/${memoItem.id}',
              headerInput: _userHeader,
              bodyInput: jsonEncode(bodyInputMap));
        }
      }
    }

    //upload pantry_items
    await _read(pantryViewController).initState();
    final pantryItemList = _read(pantryItemListProvider);
    for (PantryItem pantryItem in pantryItemList){
      Map<String, dynamic> bodyInputMap = await _read(networkingRepository).makeBodyPantryItem(pantryItem);
      if (pantryItem.itemId == 0){
        bodyInputMap['item_id'] = newItemID[pantryItem.name];
      }
      if(pantryItem.removed == false){
        if (pantryItem.newCreate){
          await networkHelper.postData(
              urlInput: 'pantries', headerInput: _userHeader, bodyInput: jsonEncode(bodyInputMap));
        } else if(pantryItem.edited) {
          await networkHelper.putData(
              urlInput: 'pantries/${pantryItem.id}',
              headerInput: _userHeader,
              bodyInput: jsonEncode(bodyInputMap));
        }
      } else if (pantryItem.removed && pantryItem.newCreate == false){
        await networkHelper.deleteData(
            urlInput: 'pantries/${pantryItem.id}',
            headerInput: _userHeader,
            bodyInput: jsonEncode(_userInfo));
      }
    }
    await _read(networkingRepository).download();
  }

  @override
  Future<Map<String, dynamic>> makeBodyUserItem(Item item) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    return {
      'user_id': userId,
      'name': item.name,
      'item_id': item.itemId,
      'category_id': item.categoryId,
      'unit_quantity': item.unitQuantity,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  @override
  Future<Map<String, dynamic>> makeBodyMemoItem(MemoItem item, String memoId) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'memo_id': memoId,
      'item_id': item.itemId,
      'quantity': item.quantity,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  @override
  Future<Map<String, dynamic>> makeBodyPantryItem(PantryItem pantryItem) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    return {
      'id': pantryItem.id,
      'user_id': userId,
      'item_id': pantryItem.itemId,
      'quantity': pantryItem.quantity,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  @override
  void resetCache() {
    _read(categoryViewController).dispose;
    _read(masterFoodViewController).dispose;
    _read(userItemViewController).dispose;
    _read(userMemoViewController).dispose;
    _read(memoItemViewController).dispose;
    _read(pantryViewController).dispose;
  }
}
