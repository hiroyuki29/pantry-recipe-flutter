import 'package:flutter/material.dart';
import 'package:pantry_recipe_flutter/constants.dart';
import 'package:pantry_recipe_flutter/read_me/read_me.dart';
import 'package:pantry_recipe_flutter/read_me/read_me_text.dart';

class ReadMeScreen extends StatelessWidget {
  const ReadMeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ReadMe> readMeList = readMeListBase;

    return Scaffold(
      appBar: AppBar(
        title: const Text('アプリ説明'),
      ),
      body: ListView.builder(
        primary: false,
        itemCount: readMeList.length,
        itemBuilder: (context, int index) =>
            ReadMeTile(readMe: readMeList[index]),
      ),
    );
  }
}

class ReadMeTile extends StatelessWidget {
  final ReadMe readMe;

  const ReadMeTile({required this.readMe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: tileColorList[readMe.id % 7],
        subtitle: Text(readMe.main),
        title: Text(readMe.leading),
      ),
    );
  }
}
