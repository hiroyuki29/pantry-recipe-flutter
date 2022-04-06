import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:pantry_recipe_flutter/components/rounded_button.dart';
import 'package:pantry_recipe_flutter/repository/user_repository.dart';
import 'package:pantry_recipe_flutter/screens/singin_and_signup_screen.dart';

class ForgotPasswordScreen extends HookConsumerWidget {

  String? email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantry Recipe'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'パスワード再設定',
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
              RoundedButton(
                buttonName: '再設定用メール送信',
                colour: Colors.lightBlueAccent,
                onTap: () async {
                  var inputs = {
                    'email': email,
                    'redirect_url': '${Uri.base.toString()}password_reset'
                  };
                  await ref
                      .read(userRepository)
                      .passwordForgot(jsonEncode(inputs));
                  Fluttertoast.showToast(msg: "メールを送信しました");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends HookConsumerWidget {
  static const routeName = '/password_reset';
  String? password;
  String? passwordConfirm;
  String? accessToken;
  String? client;
  String? clientId;
  String? uid;

  ResetPasswordScreen({required this.accessToken, required this.client, required this.clientId, required this.uid });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'パスワードリセット',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'パスワード再設定',
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
                  password = value;
                },
                decoration:
                kInputTextDecoration.copyWith(hintText: 'パスワード'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  passwordConfirm = value;
                },
                decoration: kInputTextDecoration.copyWith(hintText: 'パスワード確認用'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonName: '再設定',
                colour: Colors.lightBlueAccent,
                onTap: () async {
                  var inputs = {'password': password, 'password_confirmation': passwordConfirm, 'access-token': accessToken, 'client': client, 'uid': uid};
                  try {
                    await ref
                        .read(userRepository)
                        .passwordReset(jsonEncode(inputs));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInAndSingUpScreen()));
                  } catch (e) {
                    Fluttertoast.showToast(msg: "再設定に失敗しました");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


