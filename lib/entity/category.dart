import 'package:flutter_hooks/flutter_hooks.dart';

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
              id == other.id
          );

  @override
  int get hashCode =>
      name.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'Item{' +
        ' name: $name,' +
        ' id: $id,' +
        '}';
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