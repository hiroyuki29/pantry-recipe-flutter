import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:pantry_recipe_flutter/entity/master_food.dart';
import 'memo_item.dart';

const _uuid = Uuid();

class Item {
  final String id;
  final String name;
  final int categoryId;
  final int itemId;
  final int? masterFoodId;
  final int unitQuantity;
  bool removed;
  bool newCreate;

  Item({
    required this.id,
    required this.name,
    required this.itemId,
    required this.categoryId,
    this.masterFoodId,
    required this.unitQuantity,
    this.removed = false,
    this.newCreate = false
  });

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      (other is Item &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          itemId == other.itemId &&
          categoryId == other.categoryId &&
          masterFoodId == other.masterFoodId &&
          unitQuantity == other.unitQuantity &&
          removed == other.removed &&
          newCreate == other.newCreate
      );

  @override
  String toString() {
    return 'Item{' +
        ' name: $name,' +
        ' id: $id,' +
        'itemId: $itemId,' +
        'categoryId: $categoryId,' +
        'masterFoodId: $masterFoodId,' +
        'unitQuantity: $unitQuantity,' +
        '}';
  }

  Item copyWith({
    String? name,
    String? id,
    int? itemId,
    int? categoryId,
    int? masterFoodId,
    int? unitQuantity,
    bool? removed,
    bool? newCreate,
  }) {
    return Item(
      name: name ?? this.name,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      categoryId: categoryId ?? this.categoryId,
      masterFoodId: masterFoodId ?? this.masterFoodId,
      unitQuantity: unitQuantity ?? this.unitQuantity,
      removed: removed ?? this.removed,
      newCreate: newCreate ?? this.newCreate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
      'item_id': this.itemId,
      'category_id': this.categoryId,
      'master_food_id': this.masterFoodId,
      'unit_quantity': this.unitQuantity,
      'removed': this.removed,
      'newCreate': this.newCreate,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null){
      map['id'] = _uuid.v4();
    }
    if (map['removed'] == null){
      map['removed'] = false;
    }
    if (map['newCreate'] == null){
      map['newCreate'] = false;
    }
    return Item(
      name: map['name'] as String,
      id: map['id'].toString(),
      itemId: map['item_id'] as int,
      categoryId: map['category_id'] as int,
      masterFoodId: map['master_food_id'],
      unitQuantity: map['unit_quantity'] as int,
      removed: map['removed'] as bool,
      newCreate: map['newCreate'] as bool,
    );
  }

  factory Item.fromMasterFood(MasterFood masterFood) {
    return Item(
      name: masterFood.name,
      id: _uuid.v4(),
      itemId: masterFood.id,
      categoryId: masterFood.categoryId,
      masterFoodId: masterFood.id,
      unitQuantity: masterFood.unitQuantity,
      removed: false,
      newCreate: true,
    );
  }

  factory Item.fromMemo(MemoItem memoItem) {
    return Item(
      name: memoItem.name,
      id: _uuid.v4(),
      itemId: memoItem.itemId,
      categoryId: memoItem.categoryId,
      masterFoodId: 0,
      unitQuantity: memoItem.quantity,
      removed: false,
      newCreate: true,
    );
  }
}

class ItemList extends StateNotifier<List<Item>> {
  ItemList([List<Item>? initialItems]) : super(initialItems ?? []);

  void add(Item item) {
    state = [
      ...state,
      item.copyWith(
        id: _uuid.v4(),
        newCreate: true,
      ),
    ];
  }

  void remove(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            removed: true,
          )
        else
          item,
    ];
  }

  void toggleRemove(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            removed: !item.removed,
          )
        else
          item,
    ];
  }
}