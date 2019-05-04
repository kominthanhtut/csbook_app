import 'package:csbook_app/list.dart';
import 'package:csbook_app/song.dart';
import 'package:csbook_app/songfullscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'csbook',
      theme: ThemeData(
        //brightness: Brightness.dark,
        //scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.brown
        //bottomAppBarColor: Colors.black
      ),
      home: ListScreen(title: 'Catholic Song Book'),
      routes: {
        SongScreen.routeName: (context) => SongScreen(),
        ListScreen.routeName: (context) => ListScreen(),
        SongFullScreen.routeName: (context) => SongFullScreen()
      },  
    );
  }
}