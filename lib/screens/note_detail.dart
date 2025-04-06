import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../utils/databse_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetail extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  const NoteDetail(this.note, this.appBarTitle, {super.key});

  @override
  State<StatefulWidget> createState() {

    return NoteDetailState(note, appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {

  static final _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .titleMedium ?? TextStyle();

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(

      onWillPop: () async{
        moveToLastScreen();
        return false;
      },

      child:Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
          onPressed: () {
            moveToLastScreen();
          },
        ),
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[

            ListTile(
                title: DropdownButton(items: _priorities.map((
                    String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),

                  style: textStyle,

                  value: getPriorityAsString(note.priority),

                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
                      updatePriorityAsInt(valueSelectedByUser!);
                    });
                  },
                )),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Algo mudou no campo de texto do título');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Algo mudou no campo de texto de descrição');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Theme
                                .of(context)
                                .primaryColorDark,
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            Colors.white, // Forçando branco para teste
                          ),
                        ),
                        child: Text(
                          'Guardar',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('Botão Guardar pressionado');
                            _save();
                          });
                        },
                      )
                  ),

                  Container(width: 5.0,),

                  Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Theme
                                .of(context)
                                .primaryColorDark,
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        child: Text(
                          'Apagar',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('Botão Apagar pressionado');
                            _delete();
                          });
                        },
                      )
                  )
                ],
              ),
            )

          ],
        ),
      ),
      ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  //converter de string para int
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //converter de int para string
  String getPriorityAsString(int value){
    String priority = _priorities[1];
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle(){
    note.title = titleController.text;
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
      _showAlertDialog('Status', 'Nota salva com sucesso');
    }else {
      _showAlertDialog('Status', 'Problema ao salvar a nota');
    }
  }

  void _delete() async {

    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog('Status', 'Não foi possível apagar a nota');
      return;
    }

    int result = await helper.deleteNote(note.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Nota apagada com sucesso');
    }else {
      _showAlertDialog('Status', 'Problema ao apagar a nota');
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