import 'package:flutter/material.dart';
import 'package:flutter_appjarviztech/screens/note_detail.dart';
import 'package:flutter_appjarviztech/model/note.dart';
import 'package:flutter_appjarviztech/utils/database_helper.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class Notelist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<Notelist> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> notelist;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (notelist == null) {
      notelist = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Fab Clicked");
          navigateToDetail(Note('','',2),"Add Note");
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titlestyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.notelist[position].priority),
              child: getPriorityIcon(this.notelist[position].priority),
            ),
            title: Text(
              this.notelist[position].title,
              style: titlestyle,
            ),
            subtitle: Text(this.notelist[position].date),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,),
              onTap: (){
                _delete(context,notelist[position]);
              },
            ),
            onTap: () {
              debugPrint("List Tapped");
              navigateToDetail(this.notelist[position],"Edit Note");
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;

      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.grey;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;

      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, "Note delete successfully");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note,String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note,title);
    }));

    if(result == true){
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
        Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
        noteListFuture.then((notelist){
          setState((){
              this.notelist = notelist;
              this.count = notelist.length;
          });
        });
    });
  }
}
