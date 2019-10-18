import 'package:csbook_app/Pages/mainScreen.dart';
import 'package:csbook_app/Pages/massViewScreen.dart';
import 'package:csbook_app/Pages/songScreen.dart';
import 'package:csbook_app/Pages/songfullscreen.dart';
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
          brightness: Brightness.dark,
          //scaffoldBackgroundColor: Colors.black,
          //primarySwatch: Colors.brown
          accentColor: Colors.black,
          primaryColor: Color(0xff424242),
          primaryColorLight: Color(0xff6d6d6d),
          primaryColorDark: Color(0xff1b1b1b),
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
