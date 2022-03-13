import 'package:flutter_hooks/flutter_hooks.dart';

class PantryItem {
  final int id;
  final String name;
  final int itemId;
  final int categoryId;
  final int? masterFoodId;
  final int quantity;

//<editor-fold desc="Data Methods">

  PantryItem({
    required this.id,
    required this.name,
    required this.itemId,
    required this.categoryId,
    this.masterFoodId,
    required this.quantity,
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
              quantity == other.quantity
          );

  @override
  int get hashCode =>
      name.hashCode ^ id.hashCode^ itemId.hashCode ^ categoryId.hashCode ^ masterFoodId.hashCode ^ quantity.hashCode;

  @override
  String toString() {
    return 'PantryItem{' +
        ' name: $name,' +
        ' id: $id,' +
        ' item_id: $itemId,' +
        'category_id: $categoryId,' +
        'master_food_id: $masterFoodId,' +
        'quantity: $quantity,' +
        '}';
  }

  PantryItem copyWith({
    String? name,
    int? id,
    int? itemId,
    int? categoryId,
    int? masterFoodId,
    int? quantity,
  }) {
    return PantryItem(
      name: name ?? this.name,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      categoryId: categoryId ?? this.categoryId,
      masterFoodId: masterFoodId ?? this.masterFoodId,
      quantity: quantity ?? this.quantity,
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
    };
  }

  factory PantryItem.fromMap(Map<String, dynamic> map) {
    return PantryItem(
      name: map['name'] as String,
      id: map['id'] as int,
      itemId: map['item_id'] as int,
      categoryId: map['category_id'] as int,
      masterFoodId: map['master_food_id'],
      quantity: map['quantity'] as int,
    );
  }
}