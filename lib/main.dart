import 'package:csbook_app/mainScreen.dart';
import 'package:csbook_app/pages/song.dart';
import 'package:csbook_app/pages/songfullscreen.dart';
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
      home: MainScreen(title: 'Catholic Song Book'),
      routes: {
        SongScreen.routeName: (context) => SongScreen(),
        MainScreen.routeName: (context) => MainScreen(),
        SongFullScreen.routeName: (context) => SongFullScreen()
      },  
    );
  }
}