import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'item.dart';

const _uuid = Uuid();

class MemoItem {
  final String id;
  final String name;
  final int itemId;
  final String memoId;
  final int categoryId;
  final int quantity;
  bool done;
  bool removed;
  bool newCreate;

  MemoItem({
    required this.id,
    required this.name,
    required this.itemId,
    required this.memoId,
    required this.categoryId,
    required this.quantity,
    required this.done,
    this.removed = false,
    this.newCreate = false,
  });

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
          done == other.done &&
          removed == other.removed &&
          newCreate == other.newCreate);

  @override
  String toString() {
    return 'MemoItem{' +
        ' name: $name,' +
        ' id: $id,' +
        ' item_id: $itemId,' +
        ' memo_id: $memoId,' +
        'category_id: $categoryId,' +
        'quantity: $quantity,' +
        'done: $done,' +
        'removed: $removed,' +
        'newCreate: $newCreate,' +
        '}';
  }

  MemoItem copyWith({
    String? name,
    String? id,
    int? itemId,
    String? memoId,
    int? categoryId,
    int? quantity,
    bool? done,
    bool? removed,
    bool? newCreate,
  }) {
    return MemoItem(
      name: name ?? this.name,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      memoId: memoId ?? this.memoId,
      categoryId: categoryId ?? this.categoryId,
      quantity: quantity ?? this.quantity,
      done: done ?? this.done,
      removed: removed ?? this.removed,
      newCreate: newCreate ?? this.newCreate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
      'item_id': this.itemId,
      'memo_id': this.memoId,
      'category_id': this.categoryId,
      'quantity': this.quantity,
      'done': this.done,
      'removed': this.removed,
      'newCreate': this.newCreate,
    };
  }

  factory MemoItem.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null){
      map['id'] = _uuid.v4();
    }
    if (map['removed'] == null){
      map['removed'] = false;
    }
    if (map['newCreate'] == null){
      map['newCreate'] = false;
    }
    return MemoItem(
      name: map['name'] as String,
      id: map['id'].toString(),
      itemId: map['item_id'] as int,
      memoId: map['memo_id'].toString(),
      categoryId: map['category_id'] as int,
      quantity: map['quantity'] as int,
      done: map['done'] as bool,
      removed: map['removed'] as bool,
      newCreate: map['newCreate'] as bool,
    );
  }

  factory MemoItem.fromUserItem({required Item item, required String memoId}) {
    return MemoItem(
      name: item.name,
      id: _uuid.v4(),
      itemId: item.itemId,
      memoId: memoId,
      categoryId: item.categoryId,
      quantity: item.unitQuantity,
      done: false,
      removed: false,
      newCreate: true,
    );
  }
}

class MemoItemList extends StateNotifier<List<MemoItem>> {
  MemoItemList([List<MemoItem>? initialMemoItems]) : super(initialMemoItems ?? []);

  void add(MemoItem memoItem) {
    state = [
      ...state,
      memoItem.copyWith(
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
            done: false,
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
            done: false,
          )
        else
          item,
    ];
  }

  void toggleDone(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            done: !item.done,
          )
        else
          item,
    ];
  }
}
