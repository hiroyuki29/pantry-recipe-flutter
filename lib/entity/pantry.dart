import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'item.dart';
import 'memo_item.dart';

const _uuid = Uuid();

class PantryItem {
  final String id;
  final String name;
  final int itemId;
  final int categoryId;
  final int? masterFoodId;
  final int quantity;
  bool removed;
  bool newCreate;
  bool edited;

  PantryItem({
    required this.id,
    required this.name,
    required this.itemId,
    required this.categoryId,
    this.masterFoodId,
    required this.quantity,
    this.removed = false,
    this.newCreate = false,
    this.edited = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PantryItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          itemId == other.itemId &&
          categoryId == other.categoryId &&
          masterFoodId == other.masterFoodId &&
          quantity == other.quantity &&
          removed == other.removed &&
          newCreate == other.newCreate &&
          edited == other.edited
      );

  @override
  int get hashCode =>
      name.hashCode ^
      id.hashCode ^
      itemId.hashCode ^
      categoryId.hashCode ^
      masterFoodId.hashCode ^
      quantity.hashCode;

  @override
  String toString() {
    return 'PantryItem{' +
        ' name: $name,' +
        ' id: $id,' +
        ' item_id: $itemId,' +
        'category_id: $categoryId,' +
        'master_food_id: $masterFoodId,' +
        'quantity: $quantity,' +
        'removed: $removed,' +
        'newCreate: $newCreate,' +
        'edited: $edited,' +
        '}';
  }

  PantryItem copyWith({
    String? name,
    String? id,
    int? itemId,
    int? categoryId,
    int? masterFoodId,
    int? quantity,
    bool? removed,
    bool? newCreate,
    bool? edited,
  }) {
    return PantryItem(
      name: name ?? this.name,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      categoryId: categoryId ?? this.categoryId,
      masterFoodId: masterFoodId ?? this.masterFoodId,
      quantity: quantity ?? this.quantity,
      removed: removed ?? this.removed,
      newCreate: newCreate ?? this.newCreate,
      edited: edited ?? this.edited,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
      'item_id': this.itemId,
      'category_id': this.categoryId,
      'master_food_id': this.masterFoodId,
      'quantity': this.quantity,
      'removed': this.removed,
      'newCreate': this.newCreate,
      'edited': this.edited,
    };
  }

  factory PantryItem.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null){
      map['id'] = _uuid.v4();
    }
    if (map['removed'] == null){
      map['removed'] = false;
    }
    if (map['newCreate'] == null){
      map['newCreate'] = false;
    }
    if (map['edited'] == null){
      map['edited'] = false;
    }
    return PantryItem(
      name: map['name'] as String,
      id: map['id'].toString(),
      itemId: map['item_id'] as int,
      categoryId: map['category_id'] as int,
      masterFoodId: map['master_food_id'],
      quantity: map['quantity'] as int,
      removed: map['removed'] as bool,
      newCreate: map['newCreate'] as bool,
      edited: map['edited'] as bool,
    );
  }

  factory PantryItem.fromMemoItem(MemoItem item) {
    return PantryItem(
      name: item.name,
      id: _uuid.v4(),
      itemId: item.itemId,
      categoryId: item.categoryId,
      quantity: item.quantity,
      removed: false,
      newCreate: true,
      edited: false,
    );
  }
  factory PantryItem.fromUserItem(Item item) {
    return PantryItem(
      name: item.name,
      id: _uuid.v4(),
      itemId: item.itemId,
      categoryId: item.categoryId,
      masterFoodId: item.masterFoodId,
      quantity: item.unitQuantity,
      removed: false,
      newCreate: true,
      edited: false,
    );
  }
}

class PantryItemList extends StateNotifier<List<PantryItem>> {
  PantryItemList([List<PantryItem>? initialPantryItems]) : super(initialPantryItems ?? []);

  void add(PantryItem pantryItem) {
    state = [
      ...state,
      pantryItem.copyWith(
        id: _uuid.v4(),
        removed: false,
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
            quantity: 0,
            removed: !item.removed,
          )
        else
          item,
    ];
  }

  void increment({required String id, required int addQuantity}) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            quantity: item.quantity + addQuantity,
            newCreate: true,
          )
        else
          item,
    ];
  }

  void edit({required String id, required int quantity}) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            quantity: quantity,
            edited: true,
          )
        else
          item,
    ];
  }

}

