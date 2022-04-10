import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pantry_recipe_flutter/entity/pantry.dart';
import 'package:pantry_recipe_flutter/viewModels/pantry_view_controller.dart';
import 'package:pantry_recipe_flutter/constants.dart';

class PantryEditScreen extends HookConsumerWidget {
  PantryItem pantryItem;

  PantryEditScreen(this.pantryItem);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    int quantity = pantryItem.quantity;

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '数量変更　${pantryItem.name}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                quantity = int.tryParse(value) ?? 0;
              },
              decoration: kInputTextDecoration.copyWith(hintText: '数量'),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              child: const Text(
                'edit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              onPressed: () async {
                if (quantity == 0) {
                  Fluttertoast.showToast(msg: "数量は数値を入力してください");
                } else {
                  ref.read(pantryViewController).quantityEdit(pantryItem, quantity);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
