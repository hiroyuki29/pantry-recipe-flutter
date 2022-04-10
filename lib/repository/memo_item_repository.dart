import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';

import '../viewModels/memo_item_view_controller.dart';

final memoItemRepository = Provider.autoDispose<MemoItemRepository>(
    (ref) => MemoItemRepositoryImpl(ref.read));

abstract class MemoItemRepository {
  Future<List<MemoItem>> getMemoItemList(String memoId);
  Future<void> saveMemoItem(String memoId);
}

const _memoItemListKey = 'memoItemListKey';

class MemoItemRepositoryImpl implements MemoItemRepository {
  final Reader _read;

  MemoItemRepositoryImpl(this._read);

  @override
  Future<List<MemoItem>> getMemoItemList(String memoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String editMemoItemListKey = _memoItemListKey + memoId.toString();
    var result = prefs.getStringList(editMemoItemListKey) ?? [];
    List<MemoItem> itemList = result.map((f) => MemoItem.fromMap(json.decode(f))).toList();
    return itemList;
  }

  @override
  Future<void> saveMemoItem(String memoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemList = _read(memoItemListProvider);
    List<String> memoItemListForPref = itemList.map((item) => json.encode(item.toMap())).toList();
    String editMemoItemListKey = _memoItemListKey + memoId;
    await prefs.setStringList(editMemoItemListKey, memoItemListForPref);
  }
}
