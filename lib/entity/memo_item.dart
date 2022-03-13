class MemoItem {
  final int id;
  final String name;
  final int itemId;
  final int memoId;
  final int categoryId;
  final int quantity;
  bool done;

  MemoItem(
      {required this.id,
      required this.name,
      required this.itemId,
      required this.memoId,
      required this.categoryId,
      required this.quantity,
      required this.done});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          itemId == other.itemId &&
          memoId == other.memoId &&
          categoryId == other.categoryId &&
          quantity == other.quantity &&
          done == other.done);

  @override
  String toString() {
    return 'MemoItem{' +
        ' name: $name,' +
        ' id: $id,' +
        ' item_id: $itemId,' +
        ' memo_id: $memoId,' +
        'category_id: $categoryId,' +
        'quantity: $quantity,' +
        'quantity: $done,' +
        '}';
  }

  MemoItem copyWith(
      {String? name,
      int? id,
      int? itemId,
      int? memoId,
      int? categoryId,
      int? quantity,
      bool? done}) {
    return MemoItem(
        name: name ?? this.name,
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        memoId: memoId ?? this.memoId,
        categoryId: categoryId ?? this.categoryId,
        quantity: quantity ?? this.quantity,
        done: done ?? this.done);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
      'item_id': this.itemId,
      'memo_id': this.memoId,
      'category_id': this.categoryId,
      'quantity': this.quantity,
      'done': this.done
    };
  }

  factory MemoItem.fromMap(Map<String, dynamic> map) {
    return MemoItem(
        name: map['name'] as String,
        id: map['id'] as int,
        itemId: map['item_id'] as int,
        memoId: map['memo_id'] as int,
        categoryId: map['category_id'] as int,
        quantity: map['quantity'] as int,
        done: map['done'] as bool);
  }
}
