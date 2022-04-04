import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:pantry_recipe_flutter/components/rounded_button.dart';
import 'package:pantry_recipe_flutter/repository/user_repository.dart';
import 'package:pantry_recipe_flutter/screens/home_screen.dart';
import 'package:pantry_recipe_flutter/screens/read_me_screen.dart';

class SignInAndSingUpScreen extends HookConsumerWidget {
  String? email;
  String? password;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  '買い物メモとパントリーを一緒に管理しよう',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Pantry Recipe',
                  style: TextStyle(
                    fontSize: 70,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kInputTextDecoration.copyWith(hintText: 'メールアドレス'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputTextDecoration,
              ),
              const SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButton(
                    buttonName: 'ログイン',
                    colour: Colors.lightBlueAccent,
                    onTap: () async {
                      var inputs = {'email': email, 'password': password};
                      try {
                        await ref
                            .read(userRepository)
                            .signInUser(jsonEncode(inputs));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      } catch (e) {
                        Fluttertoast.showToast(msg: "ログインに失敗しました");
                      }
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  RoundedButton(
                    buttonName: '新規登録',
                    colour: Colors.lightBlueAccent,
                    onTap: () async {
                      var inputs = {'email': email, 'password': password};
                      try {
                        await ref
                            .read(userRepository)
                            .signUpUser(jsonEncode(inputs));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      } catch (e) {
                        Fluttertoast.showToast(msg: "新規登録に失敗しました");
                      }
                    },
                  ),
                ],
              ),
              RoundedButton(
                buttonName: 'アプリ説明',
                colour: Colors.grey.shade500,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReadMeScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
