import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userRepository =
    Provider.autoDispose<UserRepository>((ref) => UserRepositoryImpl(ref.read));

abstract class UserRepository {
  Future<dynamic> signInUser(String bodyInput);

  Future<dynamic> signUpUser(String bodyInput);

  Future<dynamic> signOutUser();
}

const _userKey = 'userKey';

class UserRepositoryImpl implements UserRepository {
  final Reader _read;

  UserRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<void> signInUser(String bodyInput) async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, dynamic> responseData = await networkHelper.postData(
        urlInput: 'auth/sign_in',
        headerInput: _userHeader,
        bodyInput: bodyInput);
    await prefs.setString(
        'access-token', responseData['headers']['access-token']);
    await prefs.setString('uid', responseData['headers']['uid']);
    await prefs.setString('client', responseData['headers']['client']);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    await prefs.setInt('user_id', responseBody['data']['id']);
  }

  @override
  Future<void> signUpUser(String bodyInput) async {
    final prefs = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, dynamic> responseData = await networkHelper.postData(
        urlInput: 'auth', headerInput: _userHeader, bodyInput: bodyInput);
    await prefs.setString(
        'access-token', responseData['headers']['access-token']);
    await prefs.setString('uid', responseData['headers']['uid']);
    await prefs.setString('client', responseData['headers']['client']);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    await prefs.setInt('user_id', responseBody['data']['id']);
  }

  @override
  Future<void> signOutUser() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> _userInfo = {
      'access-token': prefs.getString('access-token')
    };
    _userInfo['uid'] = prefs.getString('uid');
    _userInfo['client'] = prefs.getString('client');
    String bodyInput = jsonEncode(_userInfo);
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.deleteData(
        urlInput: 'auth/sign_out',
        headerInput: _userHeader,
        bodyInput: bodyInput);
    await prefs.remove('access-token');
    await prefs.remove('uid');
    await prefs.remove('client');
    await prefs.remove('user_id');
  }
}
