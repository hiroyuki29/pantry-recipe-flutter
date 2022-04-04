import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/components/icon_button_for_signout.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/pantry_view_controller.dart';

class PantryRegisterScreen extends HookConsumerWidget {
  const PantryRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userItemViewController).initState();
      ref.read(pantryViewController).initState();
      return ref.read(userItemViewController).dispose;
    }, []);
    final List<Item>? itemList = ref.watch(userItemListState);
    final List<PantryItem>? pantryItemList = ref.watch(pantryItemListState);
    if (itemList == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }
    if (pantryItemList == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('パントリー登録'),
        actions: const [
          IconButtonForSignOut(),
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
                        child: Text('現在の状況'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          primary: false,
                          itemCount: pantryItemList.length,
                          itemBuilder: (context, int index) =>
                              PantryRegisterTile(
                                  pantryItem: pantryItemList[index]),
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
                        child: Text('登録用アイテム'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          primary: false,
                          itemCount: itemList.length,
                          itemBuilder: (context, int index) =>
                              ItemToPantryTile(item: itemList[index]),
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

class ItemToPantryTile extends HookConsumerWidget {
  final Item item;

  const ItemToPantryTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        tileColor: tileColorList[item.categoryId],
        title: Text(item.name),
        trailing: Text('数量:${item.unitQuantity}'),
        onTap: () {
          ref.read(pantryViewController).moveToPantry(item);
        },
      ),
    );
  }
}

class PantryRegisterTile extends HookConsumerWidget {
  final PantryItem pantryItem;

  const PantryRegisterTile({required this.pantryItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        tileColor: tileColorList[pantryItem.categoryId],
        title: Text(pantryItem.name),
        trailing: Text('数量:${pantryItem.quantity.toString()}'),
      ),
    );
  }
}
