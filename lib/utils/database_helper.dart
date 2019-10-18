import 'dart:async' as prefix0;

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_appjarviztech/model/note.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String notetable = "note_table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  DatabaseHelper._createInstance();
  factory DatabaseHelper(){

    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  prefix0.Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";

    var notesDatabase = await openDatabase(path,version: 1,onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute("CREATE TABLE $notetable($colId  INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,"
        "$colDescription TEXT,$colPriority INTEGER,$colDate TEXT");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $notetable ORDER BY $colPriority ASC');
    var result = await db.query(notetable, orderBy: '$colPriority ASC');
    return result;
  }

  //insert
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(notetable, note.toMap());
    return result;
  }

  //update
  Future<int> updateNote(Note note) async{
    var db = await this.database;
    var result = await db.update(notetable, note.toMap(),where: '$colId = ?',whereArgs: [note.id]);
    return result;
  }

  //delete
  Future<int> deleteNote(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $notetable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $notetable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();
    for(int i=0;i<count;i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}