import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'note_detail.dart';
import '../models/note.dart';
import '../utils/databse_helper.dart';
import 'note_full.dart';


class NoteList extends StatefulWidget {

  int count = 0;

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        centerTitle: true,
      ),

      body: getNoteListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB Clicked');
          navigateToDetail(Note('', '', 2), 'Adicionar Nota');
        },
        tooltip: 'Adicionar Nota',
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.titleSmall ??
        TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[position].priority),
              child: getPriorityIcon(noteList[position].priority),
            ),

            title: Text(noteList[position].title, style: titleStyle,),
            subtitle: Text(noteList[position].date),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),

            onTap: () {
              debugPrint('ListTile Tapped');
              navigateToDetailEdit(noteList[position], 'Editar Nota');
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority){
      case 1:
        return Colors.red;
        break;

      case 2:
        return Colors.blue;
        break;

      default:
        return Colors.blue;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.push_pin_sharp);
        break;

      case 2:
        return Icon(Icons.arrow_forward);
        break;

      default:
        return Icon(Icons.arrow_forward);

    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _delete(BuildContext context, Note note) async {

    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Nota apagada');
      updateListView();
    }
  }

  void navigateToDetailEdit(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteFullScreen(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}