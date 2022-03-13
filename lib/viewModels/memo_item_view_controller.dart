import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/memo_item_repository.dart';
import 'package:pantry_recipe_flutter/repository/pantry_repository.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';

final memoItemListState = StateProvider<List<MemoItem>?>((ref) => null);

final memoItemViewController =
    Provider.autoDispose((ref) => MemoItemViewController(ref.read));

class MemoItemViewController {
  final Reader _read;

  MemoItemViewController(this._read);

  Future<void> initState({required int memoId}) async {
    _read(memoItemListState)?.clear();
    _read(memoItemListState.notifier).state =
        await _read(memoItemRepository).getMemoItemList(memoId);
  }

  void dispose() {
    _read(memoItemListState)?.clear();
  }

  String? alreadyIncludeCheck(Map<String, dynamic> inputMap) {
    for (MemoItem memoItem in _read(memoItemListState.notifier).state ?? []) {
      if (memoItem.name == inputMap['name']) {
        return memoItem.id.toString();
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> makeBodyInput(Item item, int memoId) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'memo_id': memoId,
      'item_id': item.id,
      'quantity': item.unitQuantity,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  Future<Map<String, dynamic>> makeBodyInputForToggle(MemoItem memoItem) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': memoItem.id,
      'memo_id': memoItem.memoId,
      'item_id': memoItem.itemId,
      'quantity': memoItem.quantity,
      'done': memoItem.done,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  Future<Map<String, dynamic>> makeBodyInputFromMemo(MemoItem memoItem) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    return {
      'user_id': userId,
      'item_id': memoItem.itemId,
      'quantity': memoItem.quantity,
      'access-token': prefs.getString('access-token'),
      'client': prefs.getString('client'),
      'uid': prefs.getString('uid'),
    };
  }

  Future<void> toggleDoneStatus(MemoItem memoItem) async {
    memoItem.done = !memoItem.done;
    Map<String, dynamic> bodyInput =
        await _read(memoItemViewController).makeBodyInputForToggle(memoItem);
    await _read(memoItemRepository).updateMemoItem(bodyInput);
  }

  Future<void> moveMemoItemToPantry(List<MemoItem> memoItemList) async {
    for (MemoItem memoItem in memoItemList) {
      if (memoItem.done) {
        Map<String, dynamic> bodyInput =
            await _read(memoItemViewController).makeBodyInputFromMemo(memoItem);
        await _read(pantryRepository).moveFromMemo(bodyInput);
        await _read(memoItemRepository).deleteMemoItem(memoItem);
      }
    }
  }
}
