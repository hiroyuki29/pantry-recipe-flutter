import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/components/rounded_button.dart';
import 'package:pantry_recipe_flutter/components/icon_button_for_signout.dart';
import 'package:pantry_recipe_flutter/screens/memo_index_screen.dart';
import 'package:pantry_recipe_flutter/screens/pantry_show_screen.dart';
import 'package:pantry_recipe_flutter/screens/item_register_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
        actions: const [
          IconButtonForSignOut(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text('Recipe'),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PantryShowScreen()),
                      );
                    },
                    child: const Text('Pantry'),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MemoIndexScreen()),
                      );
                    },
                    child: const Text('Memo'),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundedButton(
            buttonName: 'Item登録',
            colour: Colors.lightBlueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ItemRegisterScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
