import 'package:hooks_riverpod/hooks_riverpod.dart';

class Memo {
  final String id;
  final String name;
  final String password;

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
  String toString() {
    return 'Memo{' +
        ' name: $name,' +
        ' id: $id,' +
        ' password: $password,' +
        '}';
  }

  Memo copyWith({
    String? name,
    String? id,
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
      id: map['id'].toString(),
      password: map['password'] as String,
    );
  }
}

class MemoList extends StateNotifier<List<Memo>> {
  MemoList([List<Memo>? initialMemo]) : super(initialMemo ?? []);

  void add({required String id, required String name, required String password}) {
    state = [
      ...state,
      Memo(id: id, name: name, password: password),
    ];
  }

  void remove(String id) {
    state = state.where((memo) => memo.id != id).toList();
  }
}