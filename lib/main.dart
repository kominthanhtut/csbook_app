import 'package:csbook_app/list.dart';
import 'package:csbook_app/song.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'csbook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListScreen(title: 'Catholic Song Book'),
      routes: {
        SongScreen.routeName: (context) => SongScreen(),
        ListScreen.routeName: (context) => ListScreen(),
      },  
    );
  }
}