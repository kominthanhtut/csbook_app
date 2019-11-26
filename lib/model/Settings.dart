import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Parish.dart';

class Settings extends ChangeNotifier {
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
  int notation;

  static final Settings _settings = Settings._internal();

  static Settings get instance {
    return _settings;
  }

  Settings._internal();

  void fill(SharedPreferences sp) {
    this.notation = sp.getInt(NOTATION_TOKEN);
    this.darkTheme = sp.getBool(IS_DARK_TOKEN);
    this.parishId = sp.get(PARISH_ID);
    this.parishName = sp.getString(PARISH_NAME);

    notifyListeners();
  }

  Brightness getBrightness() {
    return (this.darkTheme ?? true) ? Brightness.dark : Brightness.light;
  }

  Parish getParish() {
    return (parishId != null)
        ? Parish(parishId, parishName, null, null, null)
        : null;
  }

  void setDarkTheme(bool value) {
    this.darkTheme = value;

    SharedPreferences.getInstance().then((sp) {
      sp.setBool(IS_DARK_TOKEN, value);

      notifyListeners();
    });
  }

  Parish setParish(Parish parish) {
    SharedPreferences.getInstance().then((sp) {
      sp.setInt(PARISH_ID, parish.id);
      sp.setString(PARISH_NAME, parish.name);

      notifyListeners();
    });
    return parish;
  }

  int setNotation(int notation) {
    SharedPreferences.getInstance().then((sp) {
      sp.setInt(NOTATION_TOKEN, notation);

      notifyListeners();
    });
    return notation;
  }
}
