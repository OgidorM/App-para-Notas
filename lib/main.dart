import 'package:estudosqlite/screens/note_detail.dart';
import 'package:estudosqlite/screens/note_list.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext) {

    return MaterialApp(
      title: 'Notas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:  Colors.blueAccent
      ),
      home: NoteList(),
    );
  }
}
