import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantry_recipe_flutter/repository/networking_repository.dart';
import '../viewModels/category_view_controller.dart';
import '../viewModels/master_food_view_controller.dart';
import '../viewModels/memo_item_view_controller.dart';
import '../viewModels/pantry_view_controller.dart';
import '../viewModels/user_item_view_controller.dart';
import '../viewModels/user_memo_view_controller.dart';

final userRepository =
    Provider.autoDispose<UserRepository>((ref) => UserRepositoryImpl(ref.read));

abstract class UserRepository {
  Future<dynamic> signInUser(String bodyInput);
  Future<dynamic> signUpUser(String bodyInput);
  Future<dynamic> signOutUser();
  Future<void> passwordForgot(String bodyInput);
  Future<void> passwordReset(String bodyInput);
  Future<void> resetCache();
}

class UserRepositoryImpl implements UserRepository {
  final Reader _read;

  UserRepositoryImpl(this._read);

  final Map<String, String> _userHeader = {
    'content-type': 'application/json',
    "Access-Control_Allow_Origin": "*"
  };

  @override
  Future<void> signInUser(String bodyInput) async {
    await _read(userRepository).resetCache();
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
    _read(networkingRepository).download();
  }

  @override
  Future<void> signUpUser(String bodyInput) async {
    await _read(userRepository).resetCache();
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
    _read(networkingRepository).download();
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
    await _read(userRepository).resetCache();
  }

  @override
  Future<void> passwordForgot(String bodyInput) async {
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.postData(
        urlInput: 'auth/password',
        headerInput: _userHeader,
        bodyInput: bodyInput);
  }

  @override
  Future<void> passwordReset(String bodyInput) async {
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.putData(
        urlInput: 'auth/password',
        headerInput: _userHeader,
        bodyInput: bodyInput);
  }

  @override
  Future<void> resetCache() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _read(categoryViewController).dispose;
    _read(masterFoodViewController).dispose;
    _read(userItemViewController).dispose;
    _read(userMemoViewController).dispose;
    _read(memoItemViewController).dispose;
    _read(pantryViewController).dispose;
  }
}
