import 'package:flutter/material.dart';
import 'note_detail.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  int count = 0;

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
          navigateToDetail('Adicionar Nota');
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
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),

            title: Text('Teste', style: titleStyle,),
            subtitle: Text('Teste'),
            trailing: Icon(Icons.delete, color: Colors.grey,),

            onTap: () {
              debugPrint('ListTile Tapped');
              navigateToDetail('Editar Nota');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title);
    }));
  }
}