import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'package:shared_preferences/shared_preferences.dart';

final masterFoodRepository = Provider.autoDispose<MasterFoodRepository>(
    (ref) => MasterFoodRepositoryImpl(ref.read));

abstract class MasterFoodRepository {
  Future<List<MasterFood>> getMasterFoodList();
  Future<Map<String, dynamic>> toUserItemMap(MasterFood masterFood);
}

const _masterFoodListKey = 'masterFoodListKey';

class MasterFoodRepositoryImpl implements MasterFoodRepository {
  final Reader _read;

  MasterFoodRepositoryImpl(this._read);

  @override
  Future<List<MasterFood>> getMasterFoodList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList(_masterFoodListKey) ?? [];
    List<MasterFood> masterFoodList = result.map((f) => MasterFood.fromMap(json.decode(f))).toList();
    return masterFoodList;
  }

  @override
  Future<Map<String, dynamic>> toUserItemMap(MasterFood masterFood) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> masterFoodMap = masterFood.toMap();
    masterFoodMap['item_id'] = masterFood.id;
    masterFoodMap['user_id'] = prefs.getInt('user_id');
    masterFoodMap['access-token'] = prefs.getString('access-token');
    masterFoodMap['client'] = prefs.getString('client');
    masterFoodMap['uid'] = prefs.getString('uid');
    return masterFoodMap;
  }
}
