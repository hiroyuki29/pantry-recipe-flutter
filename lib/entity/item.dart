import 'package:flutter_hooks/flutter_hooks.dart';

class Item {
  final int id;
  final String name;
  final int categoryId;
  final int? masterFoodId;
  final int unitQuantity;

//<editor-fold desc="Data Methods">

  Item({
    required this.id,
    required this.name,
    required this.categoryId,
    this.masterFoodId,
    required this.unitQuantity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Item &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              id == other.id &&
              categoryId == other.categoryId &&
              masterFoodId == other.masterFoodId &&
              unitQuantity == other.unitQuantity
          );

  @override
  int get hashCode =>
      name.hashCode ^ id.hashCode ^ categoryId.hashCode ^ masterFoodId.hashCode ^ unitQuantity.hashCode;

  @override
  String toString() {
    return 'Item{' +
        ' name: $name,' +
        ' id: $id,' +
        'categoryId: $categoryId,' +
        'masterFoodId: $masterFoodId,' +
        'unitQuantity: $unitQuantity,' +
        '}';
  }

  Item copyWith({
    String? name,
    int? id,
    int? categoryId,
    int? masterFoodId,
    int? unitQuantity,
  }) {
    return Item(
      name: name ?? this.name,
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      masterFoodId: masterFoodId ?? this.masterFoodId,
      unitQuantity: unitQuantity ?? this.unitQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
      'category_id': this.categoryId,
      'master_food_id': this.masterFoodId,
      'unit_quantity': this.unitQuantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] as String,
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      masterFoodId: map['master_food_id'],
      unitQuantity: map['unit_quantity'] as int,
    );
  }
}