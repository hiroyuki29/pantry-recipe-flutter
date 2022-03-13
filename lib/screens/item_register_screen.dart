import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/components/icon_button_for_signout.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'package:pantry_recipe_flutter/repository/item_repository.dart';
import 'package:pantry_recipe_flutter/repository/master_food_repository.dart';
import 'package:pantry_recipe_flutter/repository/user_item_repository.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/master_food_view_controller.dart';
import 'package:pantry_recipe_flutter/screens/add_new_item_screen.dart';

class ItemRegisterScreen extends HookConsumerWidget {
  const ItemRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userItemViewController).initState();
      ref.read(masterFoodViewController).initState();
      return ref.read(userItemViewController).dispose;
    }, []);
    final textController = useTextEditingController();
    final List<Item>? itemList = ref.watch(userItemListState);
    final List<MasterFood>? masterFoodList = ref.watch(masterFoodListState);
    if (itemList == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }
    if (masterFoodList == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item登録'),
        actions: const [
          IconButtonForSignOut(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddNewItemScreen(),
                    )));
          }),
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
                    itemCount: itemList.length,
                    itemBuilder: (context, int index) =>
                        ItemTile(item: itemList[index]),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    primary: false,
                    itemCount: masterFoodList.length,
                    itemBuilder: (context, int index) =>
                        MasterFoodTile(masterFood: masterFoodList[index]),
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

class ItemTile extends HookConsumerWidget {
  final Item item;

  const ItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('[単位] ${item.unitQuantity.toString()}'),
        trailing: OutlinedButton(
          onPressed: () async {
            await ref.read(itemRepository).deleteItem(item);
            ref.read(userItemViewController).initState();
          },
          child: const Text('削除'),
        ),
      ),
    );
  }
}

class MasterFoodTile extends HookConsumerWidget {
  final MasterFood masterFood;

  const MasterFoodTile({required this.masterFood});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(masterFood.name),
        subtitle: Text('[単位] ${masterFood.unitQuantity.toString()}'),
        onTap: () async {
          Map<String, dynamic> newItemMap =
              await ref.read(masterFoodRepository).toItemMap(masterFood);
          Map<String, dynamic> newUserItemMap =
              await ref.read(masterFoodRepository).toUserItemMap(masterFood);
          String? checkedResult =
              ref.read(userItemViewController).alreadyIncludeCheck(newItemMap);
          if (checkedResult != null) {
            Fluttertoast.showToast(msg: "すでにあります");
          } else {
            int registerItemId =
                await ref.read(itemRepository).saveItem(jsonEncode(newItemMap));
            newUserItemMap['item_id'] = registerItemId;
            await ref.read(userItemRepository).saveUserItem(newUserItemMap);
          }
          ref.read(userItemViewController).initState();
        },
      ),
    );
  }
}
