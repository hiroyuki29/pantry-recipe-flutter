import 'package:flutter_hooks/flutter_hooks.dart';

class Memo {
  final int id;
  final String name;
  final String password;

//<editor-fold desc="Data Methods">

  Memo({
    required this.id,
    required this.name,
    required this.password
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Memo &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              id == other.id &&
              password == other.password
          );

  @override
  int get hashCode =>
      name.hashCode ^ id.hashCode^ password.hashCode;

  @override
  String toString() {
    return 'Memo{' +
        ' name: $name,' +
        ' id: $id,' +
        ' password: $password,' +
        '}';
  }

  Memo copyWith({
    String? name,
    int? id,
    String? password,
  }) {
    return Memo(
      name: name ?? this.name,
      id: id ?? this.id,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
      'password': this.password,
    };
  }

  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      name: map['name'] as String,
      id: map['id'] as int,
      password: map['password'] as String,
    );
  }
}