
import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {

  String appBarTitle;

  NoteDetail(this.appBarTitle, {super.key});

  @override
  State<StatefulWidget> createState() {

    return NoteDetailState(this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {

  static final _priorities = ['High', 'Low'];

  String appBarTitle;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .titleMedium ?? TextStyle();

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
                  value: 'Low',
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
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
    Navigator.pop(context);
  }
}