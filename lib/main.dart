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

    bool BLACK_THEME = false;

    ThemeData blackTheme = ThemeData(
      brightness: Brightness.dark,
      accentColor: Colors.black,
      primaryColor: Color(0xff424242),
      primaryColorLight: Color(0xff6d6d6d),
      primaryColorDark: Color(0xff1b1b1b),
      //backgroundColor: Colors.black,
    );

    ThemeData whiteTheme = ThemeData(
      brightness: Brightness.light,
      accentColor: Colors.black,
      primaryColor: Color(0xff424242),
      primaryColorLight: Color(0xff6d6d6d),
      primaryColorDark: Color(0xff1b1b1b),
      backgroundColor: Colors.white,
      textTheme: TextTheme(title: TextStyle(color: Colors.black)),
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            subhead: TextStyle(color: Colors.black),
              title: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24))),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'csbook',
      theme: (BLACK_THEME)? blackTheme: whiteTheme,
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
