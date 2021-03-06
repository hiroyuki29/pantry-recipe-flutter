import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/components/icon_button_for_signout.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/memo_item_view_controller.dart';
import '../components/icon_button_for_download.dart';
import '../components/icon_button_for_upload.dart';

class MemoItemRegisterScreen extends HookConsumerWidget {
  String memoId;

  MemoItemRegisterScreen({required this.memoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userItemViewController).initState();
      ref.read(memoItemViewController).initState(memoId: memoId);
      return ref.read(memoItemViewController).dispose;
    }, []);
    final itemList = ref.watch(filteredUsersItems);
    final memoItemList = ref.watch(filteredMemoItems);

    return Scaffold(
      appBar: AppBar(
        title: const Text('買い物メモ登録'),
        actions: [
          IconButtonForUpload(memoId: memoId),
          IconButtonForDownload(memoId: memoId),
          const IconButtonForSignOut(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('買い物リスト'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          primary: false,
                          itemCount: memoItemList.length,
                          itemBuilder: (context, int index) =>
                              MemoRegisterTile(memoItem: memoItemList[index], memoId: memoId),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('登録アイテム'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          primary: false,
                          itemCount: itemList.length,
                          itemBuilder: (context, int index) => ItemToMemoTile(
                            item: itemList[index],
                            memoId: memoId,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigator(),
    );
  }
}

class ItemToMemoTile extends HookConsumerWidget {
  final Item item;
  final String memoId;

  const ItemToMemoTile({required this.item, required this.memoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        tileColor: tileColorList[item.categoryId],
        title: Text(item.name),
        subtitle: Text('数量:${item.unitQuantity}'),
        onTap: () {ref.read(memoItemViewController).moveItemToMemo(item, memoId);},
      ),
    );
  }
}

class MemoRegisterTile extends HookConsumerWidget {
  final MemoItem memoItem;
  final String memoId;

  const MemoRegisterTile({required this.memoItem, required this.memoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        tileColor: tileColorList[memoItem.categoryId],
        title: Text(memoItem.name),
        subtitle: Text('数量:${memoItem.quantity.toString()}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ref.read(memoItemViewController).deleteMemoItem(memoItem, memoId);
          },
        ),
      ),
    );
  }
}
