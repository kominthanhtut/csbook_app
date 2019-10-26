import 'package:csbook_app/Pages/mainScreen.dart';
import 'package:csbook_app/Pages/songScreen.dart';
import 'package:csbook_app/Pages/songfullscreen.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:csbook_app/pages/MassScreen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';

void main() async {
  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness = (prefs.getBool(Constants.IS_DARK_TOKEN) ?? false)
      ? Brightness.dark
      : Brightness.light;
  runApp(MyApp(brightness));
}

class MyApp extends StatelessWidget {
  Brightness brightness;

  MyApp(this.brightness) : super();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool BLACK_THEME = true;

    ThemeData blackTheme = ThemeData(
      brightness: Brightness.dark,
      accentColor: Colors.black,
      primaryColor: Color(0xff424242),
      primaryColorLight: Color(0xff6d6d6d),
      primaryColorDark: Color(0xff1b1b1b),
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              title: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24))),
      backgroundColor: Color(0xff1b1b1b),
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

    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brigthness) =>
            (Brightness.dark == brigthness) ? blackTheme : whiteTheme,
        themedWidgetBuilder: (context, theme) {
          Constants.systemBarsSetup(theme);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'csbook',
            theme: theme,
            home: MainScreen(),
            routes: {
              SongScreen.routeName: (context) => SongScreen(),
              MainScreen.routeName: (context) => MainScreen(),
              MassScreen.routeName: (context) => MassScreen(),
              SongFullScreen.routeName: (context) => SongFullScreen()
            },
          );
        });
  }

  
}
