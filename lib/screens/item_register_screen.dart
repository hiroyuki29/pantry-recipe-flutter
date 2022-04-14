import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/components/icon_button_for_signout.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'package:pantry_recipe_flutter/entity/item.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/master_food_view_controller.dart';
import 'package:pantry_recipe_flutter/screens/add_new_item_screen.dart';
import '../components/icon_button_for_download.dart';
import '../components/icon_button_for_upload.dart';

class ItemRegisterScreen extends HookConsumerWidget {
  const ItemRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userItemViewController).initState();
      ref.read(masterFoodViewController).initState();
      return ref.read(userItemViewController).dispose;
    }, []);
    final itemList = ref.watch(filteredUsersItems);
    final List<MasterFood>? masterFoodList = ref.watch(sortedMasterFoods);
    if (masterFoodList == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('アイテム登録'),
        actions: const [
          IconButtonForUpload(memoId: null),
          IconButtonForDownload(memoId: null),
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
                          itemBuilder: (context, int index) =>
                              ItemTile(item: itemList[index]),
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
                        child: Text('ベース食材'),
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
        tileColor: tileColorList[item.categoryId],
        title: Text(item.name),
        subtitle: Text('[単位] ${item.unitQuantity.toString()}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ref.read(userItemViewController).deleteItem(item.id);
          },
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
        tileColor: tileColorList[masterFood.categoryId],
        title: Text(masterFood.name),
        subtitle: Text('[単位] ${masterFood.unitQuantity.toString()}'),
        onTap: () async {
          String? alreadyExist = await ref
              .read(userItemViewController)
              .alreadyIncludeCheck(masterFood);
          if (alreadyExist == null) {
            Item addItem = Item.fromMasterFood(masterFood);
            await ref.read(userItemViewController).add(addItem);
          }
        },
      ),
    );
  }
}
