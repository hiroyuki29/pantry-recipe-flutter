import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/viewModels/pantry_view_controller.dart';
import 'package:pantry_recipe_flutter/repository/memo_item_repository.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';

final memoItemListProvider =
    StateNotifierProvider<MemoItemList, List<MemoItem>>(
        (ref) => MemoItemList(const []));
final filteredMemoItems = Provider<List<MemoItem>>((ref) {
  final memoItems = ref.watch(memoItemListProvider);
  if (memoItems.isNotEmpty) {
    memoItems.sort((a, b) => a.categoryId.compareTo(b.categoryId));
  }
  return memoItems.where((item) => !item.removed).toList();
});

final memoItemViewController =
    Provider.autoDispose((ref) => MemoItemViewController(ref.read));

class MemoItemViewController {
  final Reader _read;

  MemoItemViewController(this._read);

  Future<void> initState({required String memoId}) async {
    _read(memoItemListProvider.notifier).state =
        await _read(memoItemRepository).getMemoItemList(memoId);
  }

  void dispose() {
    _read(memoItemListProvider).clear();
  }

  Future<String?> alreadyIncludeCheck(
      {required Item item, required String memoId}) async {
    Map<String, dynamic> inputMap = item.toMap();
    for (MemoItem memoItem in _read(memoItemListProvider) ?? []) {
      if (memoItem.name == inputMap['name']) {
        if (memoItem.removed) {
          _read(memoItemListProvider.notifier).toggleRemove(memoItem.id);
          await _read(memoItemRepository).saveMemoItem(memoId);
        }
        return memoItem.id;
      }
    }
    return null;
  }

  Future<void> moveMemoItemToPantry({required List<MemoItem> memoItemList, required String memoId}) async {
    for (MemoItem memoItem in memoItemList) {
      if (memoItem.done) {
        Item item = Item.fromMemo(memoItem);
        await _read(pantryViewController).moveToPantry(item);
        _read(memoItemListProvider.notifier).remove(memoItem.id);
        await _read(memoItemRepository).saveMemoItem(memoId);
      }
    }
  }

  Future<void> moveItemToMemo(Item item, String memoId) async {
    String? memoItemId = await _read(memoItemViewController)
        .alreadyIncludeCheck(item: item, memoId: memoId);
    if (memoItemId != null) {
      _read(memoItemListProvider.notifier)
          .increment(id: memoItemId, addQuantity: item.unitQuantity);
      await _read(memoItemRepository).saveMemoItem(memoId);
    } else {
      MemoItem addMemoItem = MemoItem.fromUserItem(item: item, memoId: memoId);
      _read(memoItemListProvider.notifier).add(addMemoItem);
      await _read(memoItemRepository).saveMemoItem(memoId);
    }
  }

  Future<void> deleteMemoItem(MemoItem item, String memoId) async {
    _read(memoItemListProvider.notifier).remove(item.id);
    await _read(memoItemRepository).saveMemoItem(memoId);
  }
}
