import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class Constants {
  static final String APP_TITLE = "Cancionero";
  static final String MASS_TITLE = "Misas";
  static final String PARISH_TITLE = "Parroquias";
  static final String MASS_VIEW_TITLE = "Misa: ";

  static final String SONGS_WAITING = "canciones";
  static final String SONG_WAITING = "cancion";
  static final String PARISH_WAITING = "misas y canciones";

  static final String FILTERING_TEXT = "Filtrando: ";
  static final String FETCHING_TEXT = "Recuperando ";

  static final double APP_RADIUS = 0;

  static final String IS_DARK_TOKEN = "isDark";

  static final String PARISH_ID = "parish_id";
  static final String PARISH_NAME = "parish_name";

  static systemOverlaySetup(ThemeData theme) {
    //Orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    //Statusbar & Navigationbar colors and brightness
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: (theme.brightness == Brightness.dark)
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      statusBarColor: Colors.transparent,
      //statusBarIconBrightness: Brightness.dark
    ));
  }

  static Future<void> systemBarsSetup(ThemeData theme) async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(theme.brightness == Brightness.dark);
    await FlutterStatusbarcolor.setNavigationBarColor(theme.scaffoldBackgroundColor);
    await FlutterStatusbarcolor.setNavigationBarWhiteForeground(
        theme.brightness == Brightness.dark);
  }
}
