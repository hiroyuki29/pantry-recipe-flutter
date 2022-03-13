import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/repository/user_repository.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/pantry_view_controller.dart';
import 'package:pantry_recipe_flutter/screens/singin_and_signup_screen.dart';
import 'package:pantry_recipe_flutter/repository/pantry_repository.dart';

class PantryRegisterScreen extends HookConsumerWidget {
  const PantryRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userItemViewController).initState();
      ref.read(pantryViewController).initState();
      return ref.read(userItemViewController).dispose;
    }, []);
    final textController = useTextEditingController();
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
        title: const Text('Pantry登録'),
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
                    itemCount: pantryItemList.length,
                    itemBuilder: (context, int index) =>
                        PantryRegisterTile(pantryItem: pantryItemList[index]),
                  ),
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
      bottomNavigationBar: BottomNavigator(),
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
        title: Text(item.name),
        leading: Text('単位:${item.unitQuantity}'),
        onTap: () async {
          String? pantryItemId =
          ref.read(pantryViewController).alreadyIncludeCheck(item.toMap());
          if (pantryItemId != null) {
            await ref.read(pantryRepository).incrementPantryItemQuantity(pantryItemId, item.unitQuantity);
          } else {
            Map<String, dynamic> bodyInput = await ref.read(pantryViewController).makeBodyInput(item);
            await ref.read(pantryRepository).savePantryItem(jsonEncode(bodyInput));
          }
          ref.read(pantryViewController).initState();
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
        title: Text(pantryItem.name),
        // leading: Text('id:${pantryItem.id} category:${pantryItem.categoryId.toString()}'),
        trailing: Text('数量:${pantryItem.quantity.toString()}'),

      ),
    );
  }
}
