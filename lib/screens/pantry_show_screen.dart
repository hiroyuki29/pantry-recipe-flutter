import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/repository/pantry_repository.dart';
import 'package:pantry_recipe_flutter/repository/user_repository.dart';
import 'package:pantry_recipe_flutter/viewModels/pantry_view_controller.dart';
import 'package:pantry_recipe_flutter/screens/pantry_register_screen.dart';
import 'package:pantry_recipe_flutter/screens/singin_and_signup_screen.dart';
import 'package:pantry_recipe_flutter/screens/pantry_edit_screen.dart';

class PantryShowScreen extends HookConsumerWidget {
  const PantryShowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(pantryViewController).initState();
      return ref.read(pantryViewController).dispose;
    }, []);
    final List<PantryItem>? pantryItemList = ref.watch(pantryItemListState);
    if (pantryItemList == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantry'),
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PantryRegisterScreen()),
            );
          }
      ),
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
        title: Text(pantryItem.name),
        subtitle: Text('数量: ${pantryItem.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: () async {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                        child:Container(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: PantryEditScreen(pantryItem),
                        )
                    )
                );
              },
              child: const Text('編集'),
            ),
            const SizedBox(width: 20,),
            OutlinedButton(
              onPressed: () async {
                await ref.read(pantryRepository).deletePantryItem(pantryItem);
                ref.read(pantryViewController).initState();
              },
              child: const Text('削除'),
            ),
          ],
        ),
      ),
    );
  }
}
