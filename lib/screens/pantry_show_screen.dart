import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/components/icon_button_for_signout.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/viewModels/pantry_view_controller.dart';
import 'package:pantry_recipe_flutter/screens/pantry_register_screen.dart';
import 'package:pantry_recipe_flutter/screens/pantry_edit_screen.dart';
import '../components/icon_button_for_download.dart';
import '../components/icon_button_for_upload.dart';

class PantryShowScreen extends HookConsumerWidget {
  const PantryShowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(pantryViewController).initState();
      return ref.read(pantryViewController).dispose;
    }, []);
    final pantryItemList = ref.watch(filteredPantryItems);

    return Scaffold(
      appBar: AppBar(
        title: const Text('パントリー'),
        actions: const [
          IconButtonForUpload(),
          IconButtonForDownload(),
          IconButtonForSignOut(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PantryRegisterScreen()),
            );
          }),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              primary: false,
              itemCount: pantryItemList.length,
              itemBuilder: (context, int index) =>
                  PantryItemTile(pantryItem: pantryItemList[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class PantryItemTile extends HookConsumerWidget {
  final PantryItem pantryItem;

  const PantryItemTile({required this.pantryItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        tileColor: tileColorList[pantryItem.categoryId],
        title: Text(pantryItem.name),
        subtitle: Text('数量: ${pantryItem.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                            child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: PantryEditScreen(pantryItem),
                        )));
              },
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await ref.read(pantryViewController).deletePantryItem(pantryItem.id);
                ref.read(pantryViewController).initState();
              },
            ),
          ],
        ),
      ),
    );
  }
}
