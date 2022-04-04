import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:pantry_recipe_flutter/components/rounded_button.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/components/icon_button_for_signout.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/memo_item_view_controller.dart';

class ShoppingScreen extends HookConsumerWidget {
  int memoId;

  ShoppingScreen({required this.memoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userItemViewController).initState();
      ref.read(memoItemViewController).initState(memoId: memoId);
      return ref.read(memoItemViewController).dispose;
    }, []);
    final List<Item>? itemList = ref.watch(userItemListState);
    final List<MemoItem>? memoItemList = ref.watch(memoItemListState);
    if (itemList == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }
    if (memoItemList == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('買い物メモ'),
        actions: const [
          IconButtonForSignOut(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              primary: false,
              itemCount: memoItemList.length,
              itemBuilder: (context, int index) => ShoppingListTile(
                  memoItem: memoItemList[index], memoId: memoId),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundedButton(
            buttonName: '買い物完了！',
            colour: Colors.lightBlueAccent,
            onTap: () async {
              await ref
                  .read(memoItemViewController)
                  .moveMemoItemToPantry(memoItemList);
              await ref.read(memoItemViewController).initState(memoId: memoId);
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigator(),
    );
  }
}

class ShoppingListTile extends HookConsumerWidget {
  final MemoItem memoItem;
  final int memoId;
  bool check = false;

  ShoppingListTile({required this.memoItem, required this.memoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: CheckboxListTile(
        tileColor: tileColorList[memoItem.categoryId],
        value: memoItem.done,
        onChanged: (bool? value) async {
          await ref.read(memoItemViewController).toggleDoneStatus(memoItem, memoId);
        },
        title: Text(memoItem.name),
        subtitle: Text('数量:${memoItem.quantity.toString()}'),
      ),
    );
  }
}
