import 'package:flutter/material.dart';
import 'package:flutter_appjarviztech/model/note.dart';
import 'package:flutter_appjarviztech/utils/database_helper.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  NoteDetail(this.note,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note,this.appBarTitle);
  }
}
class NoteDetailState extends State<NoteDetail> {

  static var _priorities = ["High", "Low"];

  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  String appBarTitle;
  Note note;

  NoteDetailState(this.note,this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;


    titleController.text = note.title;
    discriptionController.text = note.description;

    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(icon: Icon(
          Icons.arrow_back),
          onPressed: (){
            moveToLastScreen();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: textStyle,

                value: getPriorityAsString(note.priority),

                onChanged: (valueSelectedByUser) {
                  setState(() {
                    debugPrint("User Selected $valueSelectedByUser");
                    updatePriorityAsInt(valueSelectedByUser);
                  });
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("Something Change in title text field");
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: "Title",
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
                controller: discriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("Something Change in discription text field");
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: "Discription",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),

            Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme
                            .of(context)
                            .primaryColorLight,
                        textColor: Theme
                            .of(context)
                            .primaryColorDark,
                        child: Text("Save", textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save Button clicked");
                            _save();
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 25.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme
                            .of(context)
                            .primaryColorLight,
                        textColor: Theme
                            .of(context)
                            .primaryColorDark,
                        child: Text("Delete", textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    ));
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  void updatePriorityAsInt(String value){
    switch(value){
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }
  String getPriorityAsString(int value){
    String priority;
    switch(value){
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
    note.description = discriptionController.text;
  }

  void _save() async{

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null){
      result = await databaseHelper.updateNote(note);
    }else{
      result = await databaseHelper.insertNote(note);
    }

    if(result != 0){
      _showAlertDialog("Status","Note Saved Successfully");
    }else{
      _showAlertDialog("Status","Update Saving Note");
    }
  }

  void _delete() async{

    moveToLastScreen();

    if(note.id != null){
      _showAlertDialog("Status","No Note was deleted");
      return;
    }
    int result = await databaseHelper.deleteNote(note.id);
    if(result != 0){
      _showAlertDialog("Status","Note Delete Successfully");
    }else{
      _showAlertDialog("Status","Error Occured while Deleting Note");
    }
  }
  void _showAlertDialog(String title,String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context,
    builder: (_)=>alertDialog
    );
  }
}