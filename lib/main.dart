import 'package:csbook_app/mainScreen.dart';
import 'package:csbook_app/pages/mass_view.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'csbook',
      theme: ThemeData(
          //brightness: Brightness.dark,
          //scaffoldBackgroundColor: Colors.black,
          //primarySwatch: Colors.brown
          primaryColor: Color(0xff424242),
          primaryColorLight: Color(0xff6d6d6d),
          primaryColorDark: Color(0xff1b1b1b),
          primaryTextTheme: TextTheme(body1: TextStyle(color: Colors.white)),
          //bottomAppBarColor: Colors.black
          ),
      home: MainScreen(title: 'Catholic Song Book'),
      routes: {
        SongScreen.routeName: (context) => SongScreen(),
        MainScreen.routeName: (context) => MainScreen(),
        MassScreen.routeName: (context) => MassScreen(),
        SongFullScreen.routeName: (context) => SongFullScreen()
      },
    );
  }
}
