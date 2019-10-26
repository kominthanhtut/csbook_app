import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  static const APP_TITLE = "Cancionero";
  static const MASS_TITLE = "Misas";
  static const PARISH_TITLE = "Parroquias";
  static const MASS_VIEW_TITLE = "Misa: ";

  static const SONGS_WAITING = "canciones";
  static const SONG_WAITING = "cancion";
  static const PARISH_WAITING = "misas y canciones";

  static const FILTERING_TEXT = "Filtrando: ";
  static const FETCHING_TEXT = "Recuperando ";

  static const APP_RADIUS = 8.0;

  static const IS_DARK_TOKEN = "isDark";

  static const PARISH_ID = "parish_id";
  static const PARISH_NAME = "parish_name";

  static Future<void> systemBarsSetup(ThemeData theme) async {
    await statusBarsSetupByColor(theme.brightness, Colors.transparent);
  }

  static Future<void> systemBarsSetupByColor(
      Brightness brightness, Color backgroundColor) async {
    await statusBarsSetupByColor(brightness, backgroundColor);
  }

  static Future<void> statusBarsSetupByColor(
      Brightness brightness, Color backgroundColor) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: (Brightness.dark == brightness)
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: backgroundColor));
  }
}
