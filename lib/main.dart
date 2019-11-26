import 'package:csbook_app/MainScreen.dart';
import 'package:csbook_app/model/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //I get system Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Create/Instanciate settings object and fill the preferences in.
  Settings _settings = Settings.instance;
  _settings.setDefaults();
  _settings.fill(prefs);
  //Run the app with the proper brightness
  //runApp(MyApp(_settings.getBrightness()));

  runApp(ChangeNotifierProvider<Settings>(
      builder: (context) => _settings,
      child: MyApp()));
}

class MyApp extends StatelessWidget {

  MyApp() : super();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData blackTheme = ThemeData(
      brightness: Brightness.dark,
      accentColor: Colors.black,
      primaryColor: Color(0xff424242),
      primaryColorLight: Color(0xff6d6d6d),
      primaryColorDark: Color(0xff1b1b1b),
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              title: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
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

    return Consumer<Settings>(
      builder: (context, settings, _){
        return  MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'csbook',
              theme: ( settings?.darkTheme ?? true) ? blackTheme : whiteTheme,
              home: MainScreen(),
            );
          });
  }
}
