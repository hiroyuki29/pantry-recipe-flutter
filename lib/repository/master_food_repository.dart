import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'package:pantry_recipe_flutter/api/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

final masterFoodRepository =
Provider.autoDispose<MasterFoodRepository>((ref) => MasterFoodRepositoryImpl(ref.read));

abstract class MasterFoodRepository {
  Future<List<MasterFood>> getMasterFoodList();
  Future<Map<String, dynamic>> toItemMap(MasterFood masterFood);
  Future<Map<String, dynamic>> toUserItemMap(MasterFood masterFood);
}

class MasterFoodRepositoryImpl implements MasterFoodRepository {
  final Reader _read;
  MasterFoodRepositoryImpl(this._read);
  Map<String, String> _userHeader = {'content-type': 'application/json', "Access-Control_Allow_Origin": "*"};

  @override
  Future<List<MasterFood>> getMasterFoodList() async {
    final prefs = await SharedPreferences.getInstance();
    _userHeader = {'access-token': prefs.getString('access-token') ?? ''};
    _userHeader['uid'] = prefs.getString('uid') ?? '';
    _userHeader['client'] = prefs.getString('client') ?? '';
    NetworkHelper networkHelper = NetworkHelper();
    var responseData = await networkHelper.getData(urlInput: 'master_foods', headerInput: _userHeader);
    Map<String, dynamic> responseBody = jsonDecode(responseData['body']);
    final List<Map<String, dynamic>> masterFoodListJsonList =
    List<Map<String, dynamic>>.from(responseBody['data']);
    return masterFoodListJsonList.map((json) => MasterFood.fromMap(json)).toList();
  }

  Future<Map<String, dynamic>> toItemMap(MasterFood masterFood) async{
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> masterFoodMap = masterFood.toMap();
    // masterFoodMap['user_id'] = prefs.getInt('user_id');
    masterFoodMap['access-token'] = prefs.getString('access-token');
    masterFoodMap['client'] = prefs.getString('client');
    masterFoodMap['uid'] = prefs.getString('uid');
    return masterFoodMap;
  }

  Future<Map<String, dynamic>> toUserItemMap(MasterFood masterFood) async{
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> masterFoodMap = masterFood.toMap();
    masterFoodMap['user_id'] = prefs.getInt('user_id');
    masterFoodMap['access-token'] = prefs.getString('access-token');
    masterFoodMap['client'] = prefs.getString('client');
    masterFoodMap['uid'] = prefs.getString('uid');
    return masterFoodMap;
  }
}