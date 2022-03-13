import 'package:flutter/material.dart';
import 'package:pantry_recipe_flutter/screens/item_register_screen.dart';
import 'package:pantry_recipe_flutter/screens/pantry_show_screen.dart';
import 'package:pantry_recipe_flutter/screens/memo_index_screen.dart';
import 'package:pantry_recipe_flutter/screens/home_screen.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavigationButton(
            screenName: 'Home',
            nextScreen: const HomeScreen(),
          ),
          NavigationButton(
            screenName: 'Pantry',
            nextScreen: const PantryShowScreen(),
          ),
          NavigationButton(
            screenName: 'Memo',
            nextScreen: const MemoIndexScreen(),
          ),
          NavigationButton(
            screenName: 'Item',
            nextScreen: const ItemRegisterScreen(),
          ),
        ],
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  Widget nextScreen;
  String screenName;

  NavigationButton({required this.screenName, required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        },
        child: Text(screenName),
      ),
    );
  }
}
