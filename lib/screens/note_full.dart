import 'dart:async';
import 'package:estudosqlite/screens/note_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../utils/databse_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteFullScreen extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  const NoteFullScreen(this.note, this.appBarTitle, {super.key});

  @override
  State<StatefulWidget> createState() {

    return NoteFullScreenState(note, appBarTitle);
  }
}

class NoteFullScreenState extends State<NoteFullScreen> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteFullScreenState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .titleMedium ?? TextStyle();

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(

        onWillPop: () async {
          moveToLastScreen();
          return false;
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(titleController.text),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed:  done,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: TextField(
              controller: descriptionController,
              style: textStyle,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: 'Escreve aqui...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                debugPrint('Texto alterado: $value');
              },
            ),
          ),
        ),
    );
  }

  void done () {
      updateDescription();
      _save();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateDescription(){
    note.description = descriptionController.text;

  }

  void _save() async {

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    }else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
    }else {
      _showAlertDialog('Status', 'Problema ao salvar a nota');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
}