class MasterFood {
  final int id;
  final String name;
  final int categoryId;
  final int unitQuantity;

  MasterFood({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.unitQuantity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasterFood &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          categoryId == other.categoryId &&
          unitQuantity == other.unitQuantity);

  @override
  String toString() {
    return 'Item{' +
        ' name: $name,' +
        ' id: $id,' +
        'category_id: $categoryId,' +
        'unit_quantity: $unitQuantity,' +
        '}';
  }

  MasterFood copyWith({
    String? name,
    int? id,
    int? categoryId,
    int? unitQuantity,
  }) {
    return MasterFood(
      name: name ?? this.name,
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      unitQuantity: unitQuantity ?? this.unitQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'master_food_id': this.id,
      'category_id': this.categoryId,
      'unit_quantity': this.unitQuantity,
    };
  }

  factory MasterFood.fromMap(Map<String, dynamic> map) {
    return MasterFood(
      name: map['name'] as String,
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      unitQuantity: map['unit_quantity'] as int,
    );
  }
}
