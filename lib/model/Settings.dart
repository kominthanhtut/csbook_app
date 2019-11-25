import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Parish.dart';

class Settings {
  static const IS_DARK_TOKEN = "isDark";

  static const PARISH_ID = "parish_id";
  static const PARISH_NAME = "parish_name";

  static const NOTATION_TOKEN = "notation_token";
  static const NOTATION_SPANISH = 0x01;
  static const NOTATION_ENGLISH = 0x02;

  //Settings
  bool darkTheme;
  int parishId;
  String parishName;

  static final Settings _settings = Settings._internal();

  static Settings get instance { return _settings;}

  Settings._internal();

  void fill(SharedPreferences sp){
    this.darkTheme = sp.getBool(IS_DARK_TOKEN);
    this.parishId = sp.get(PARISH_ID);
    this.parishName = sp.get(PARISH_NAME);
  }

  Brightness getBrightness(){
    return (this.darkTheme ?? true)
      ? Brightness.dark
      : Brightness.light;
  }



}

class SettingsProvider extends ChangeNotifier{
  Settings _settings;

  SettingsProvider(this._settings);

  set settings(Settings _settings){
    this._settings = _settings;
    notifyListeners();
  }

  get settings => _settings;

}