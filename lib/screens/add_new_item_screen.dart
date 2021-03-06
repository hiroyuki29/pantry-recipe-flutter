import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pantry_recipe_flutter/viewModels/category_view_controller.dart';
import 'package:pantry_recipe_flutter/entity/category.dart';
import 'package:pantry_recipe_flutter/viewModels/user_item_view_controller.dart';
import 'package:pantry_recipe_flutter/viewModels/item_view_controller.dart';
import 'package:pantry_recipe_flutter/constants.dart';

import '../entity/item.dart';
import '../entity/master_food.dart';

class AddNewItemScreen extends HookConsumerWidget {
  int categoryId = 1;
  String newItemName = '';
  String name = 'デフォルト';
  int unitQuantity = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(categoryViewController).initState();
      return ref.read(categoryViewController).dispose;
    }, []);
    final List<Category>? categoryList = ref.watch(sortedCategories);
    if (categoryList == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isSelectedList = ref.watch(isSelectedState);

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(10.0),
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
            const Text(
              'アイテム追加',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                name = value;
              },
              decoration: kInputTextDecoration.copyWith(hintText: 'アイテム名'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                unitQuantity = int.tryParse(value) ?? 0;
              },
              decoration: kInputTextDecoration.copyWith(hintText: '基準となる個数'),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ToggleButtons(
                children: const [
                  Text('野菜'),
                  Text('肉'),
                  Text('魚'),
                  Text('加工品'),
                  Text('飲み物'),
                  Text('日用品'),
                  Text('その他'),
                ],
                onPressed: (int index) {
                  categoryId = ref
                          .read(categoryViewController)
                          .toggleCategorySelect(index) +
                      1;
                },
                isSelected: isSelectedList,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              onPressed: () async {
                if (unitQuantity == 0) {
                  Fluttertoast.showToast(msg: "数量は数値を入力してください");
                } else {
                  Map<String, dynamic> bodyInput = await ref
                      .read(itemViewController)
                      .makeBodyInput(
                          name: name,
                          categoryId: categoryId,
                          unitQuantity: unitQuantity);
                  bodyInput['id'] = 0;
                  MasterFood masterFood = MasterFood.fromMap(bodyInput);
                  String? checkedResult = await ref
                      .read(userItemViewController)
                      .alreadyIncludeCheck(masterFood);
                  if (checkedResult != null) {
                    if (checkedResult != '0'){
                      Fluttertoast.showToast(msg: "すでにあります");
                    }
                  } else {
                    bodyInput['item_id'] = 0;
                    bodyInput['removed'] = false;
                    bodyInput['newCreate'] = true;
                    Item addItem = Item.fromMap(bodyInput);
                    await ref.read(userItemViewController).add(addItem);
                  }
                  ref.read(categoryViewController).resetCategorySelect();
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
