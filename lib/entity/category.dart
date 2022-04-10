import 'package:hooks_riverpod/hooks_riverpod.dart';

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id);

  @override
  String toString() {
    return 'Item{' + ' name: $name,' + ' id: $id,' + '}';
  }

  Category copyWith({
    String? name,
    int? id,
  }) {
    return Category(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] as String,
      id: map['id'] as int,
    );
  }
}

class CategoryList extends StateNotifier<List<Category>> {
  CategoryList([List<Category>? initialCategory]) : super(initialCategory ?? []);
}
