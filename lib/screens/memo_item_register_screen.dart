import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/repository/user_repository.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/entity/memo_item.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/memo_item_view_controller.dart';
import 'package:pantry_recipe_flutter/screens/singin_and_signup_screen.dart';
import 'package:pantry_recipe_flutter/repository/memo_item_repository.dart';

class MemoItemRegisterScreen extends HookConsumerWidget {
  int memoId;

  MemoItemRegisterScreen({required this.memoId});

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
        title: const Text('買い物メモ登録'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ref.read(userRepository).signOutUser();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInAndSingUpScreen(),
                ),
              );
            },
          )
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
                  child: ListView.builder(
                    primary: false,
                    itemCount: memoItemList.length,
                    itemBuilder: (context, int index) =>
                        MemoRegisterTile(memoItem: memoItemList[index]),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    primary: false,
                    itemCount: itemList.length,
                    itemBuilder: (context, int index) =>
                        ItemToPantryTile(item: itemList[index], memoId: memoId,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class ItemToPantryTile extends HookConsumerWidget {
  final Item item;
  final int memoId;

  const ItemToPantryTile({required this.item, required this.memoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        trailing: Text('数量:${item.unitQuantity}'),
        onTap: () async {
          String? memoItemId =
          ref.read(memoItemViewController).alreadyIncludeCheck(item.toMap());
          if (memoItemId != null) {
            await ref.read(memoItemRepository).incrementMemoItemQuantity(memoItemId, item.unitQuantity);
          } else {
            Map<String, dynamic> bodyInput = await ref.read(memoItemViewController).makeBodyInput(item, memoId);
            await ref.read(memoItemRepository).saveMemoItem(jsonEncode(bodyInput));
          }
          ref.read(memoItemViewController).initState(memoId: memoId);
        },
      ),
    );
  }
}

class MemoRegisterTile extends HookConsumerWidget {
  final MemoItem memoItem;

  const MemoRegisterTile({required this.memoItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(memoItem.name),
        // leading: Text('id:${memoItem.id} category:${memoItem.categoryId.toString()}'),
        trailing: Text('数量:${memoItem.quantity.toString()}'),

      ),
    );
  }
}
