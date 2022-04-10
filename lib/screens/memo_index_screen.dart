import 'package:flutter/material.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pantry_recipe_flutter/components/bottom_navigator.dart';
import 'package:pantry_recipe_flutter/components/icon_button_for_signout.dart';
import 'package:pantry_recipe_flutter/entity/memo.dart';
import 'package:pantry_recipe_flutter/repository/user_memo_repository.dart';
import 'package:pantry_recipe_flutter/viewModels/user_memo_view_controller.dart';
import 'package:pantry_recipe_flutter/screens/shopping_screen.dart';
import 'package:pantry_recipe_flutter/screens/memo_item_register_screen.dart';
import '../components/icon_button_for_download.dart';
import '../components/icon_button_for_upload.dart';

class MemoIndexScreen extends HookConsumerWidget {
  const MemoIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userMemoViewController).initState();
      return ref.read(userMemoViewController).dispose;
    }, []);
    final List<Memo>? userMemoList = ref.watch(userMemoListProvider);
    if (userMemoList == null) {
      return const Center(child: CircularProgressIndicator());
    }
    String memoName = '';
    String password = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('買い物メモリスト'),
        actions: const [
          IconButtonForUpload(),
          IconButtonForDownload(),
          IconButtonForSignOut(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              primary: false,
              itemCount: userMemoList.length,
              itemBuilder: (context, int index) =>
                  UserMemoTile(memo: userMemoList[index]),
            ),
          ),
          SizedBox(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    memoName = value;
                  },
                  decoration: kInputTextDecoration.copyWith(hintText: 'Name'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      kInputTextDecoration.copyWith(hintText: 'password'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        if (memoName == '' || password == '') {
                          Fluttertoast.showToast(msg: "空欄があります");
                        } else {
                          bool checkResult = await ref.read(userMemoViewController).memoRegister(memoName, password);
                          if (checkResult) {
                            Fluttertoast.showToast(msg: "登録成功");
                          } else {
                            Fluttertoast.showToast(msg: "登録に失敗しました");
                          }
                        }
                      },
                      child: const Text('登録'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (memoName == '' || password == '') {
                          Fluttertoast.showToast(msg: "空欄があります");
                        } else {
                          bool checkResult = await ref.read(userMemoViewController).memoSearch(memoName, password);
                          if (checkResult) {
                            Fluttertoast.showToast(msg: "検索成功");
                          } else {
                            Fluttertoast.showToast(msg: "検索に失敗しました");
                          }
                        }
                      },
                      child: const Text('検索'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: const BottomNavigator(),
    );
  }
}

class UserMemoTile extends HookConsumerWidget {
  final Memo memo;

  const UserMemoTile({required this.memo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        tileColor: Colors.grey.shade100,
        title: Text(memo.name),
        subtitle: Text('password: ${memo.password}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MemoItemRegisterScreen(memoId: memo.id)),
                );
              },
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await ref.read(userMemoRepository).deleteUserMemo(memo);
                ref.read(userMemoViewController).initState();
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShoppingScreen(memoId: memo.id)),
          );
        },
      ),
    );
  }
}
