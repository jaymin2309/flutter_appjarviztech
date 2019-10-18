import 'package:flutter/material.dart';
import 'package:flutter_appjarviztech/screens/note_detail.dart';
import 'package:flutter_appjarviztech/screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.black
      ),
      home: Notelist(),
    );
  }
}
