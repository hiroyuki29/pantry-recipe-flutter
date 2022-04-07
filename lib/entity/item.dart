class Item {
  final int id;
  final String name;
  final int categoryId;
  final int itemId;
  final int? masterFoodId;
  final int unitQuantity;

  Item({
    required this.id,
    required this.name,
    required this.itemId,
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
          itemId == other.itemId &&
          categoryId == other.categoryId &&
          masterFoodId == other.masterFoodId &&
          unitQuantity == other.unitQuantity);

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
    int? id,
    int? itemId,
    int? categoryId,
    int? masterFoodId,
    int? unitQuantity,
  }) {
    return Item(
      name: name ?? this.name,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      categoryId: categoryId ?? this.categoryId,
      masterFoodId: masterFoodId ?? this.masterFoodId,
      unitQuantity: unitQuantity ?? this.unitQuantity,
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
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] as String,
      id: map['id'] as int,
      itemId: map['item_id'] as int,
      categoryId: map['category_id'] as int,
      masterFoodId: map['master_food_id'],
      unitQuantity: map['unit_quantity'] as int,
    );
  }
}
