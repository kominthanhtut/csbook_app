import 'package:csbook_app/Api.dart';
import 'package:csbook_app/model/Parish.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Parish _parish;

  int _notation = Constants.NOTATION_SPANISH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        _parish = Parish(sp.get(Constants.PARISH_ID),
            sp.get(Constants.PARISH_NAME), null, null, null);
        _parish = (_parish.id != null) ? _parish : null;
        var savedNotation = sp.get(Constants.NOTATION_TOKEN);
        if (savedNotation != null && savedNotation is int)
          _notation = savedNotation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajustes"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: RoundedBlackContainer(
        bottomOnly: true,
        radius: Constants.APP_RADIUS,
        child: ListView(
          children: <Widget>[
            //Divider(),
            ListTile(
              leading: Icon(FontAwesomeIcons.paintBrush),
              trailing: Switch(
                  activeColor: Colors.white,
                  activeTrackColor: Theme.of(context).primaryColorLight,
                  onChanged: (value) {
                    SharedPreferences.getInstance().then((sp) {
                      sp.setBool(Constants.IS_DARK_TOKEN, value);
                      DynamicTheme.of(context).setBrightness(
                          (value) ? Brightness.dark : Brightness.light);
                    });
                  },
                  value:
                      DynamicTheme.of(context).brightness == Brightness.dark),
              title: new Text(
                'Tema oscuro',
              ),
              onTap: () {
                bool value =
                    !(DynamicTheme.of(context).brightness == Brightness.dark);
                SharedPreferences.getInstance().then((sp) {
                  sp.setBool(Constants.IS_DARK_TOKEN, value);
                  DynamicTheme.of(context).setBrightness(
                      (value) ? Brightness.dark : Brightness.light);
                });
              },
            ),
            //Divider(),
            ListTile(
              title: Text("Parroquia"),
              subtitle:
                  Text((_parish == null) ? "No seleccionado" : _parish.name),
              leading: Icon(FontAwesomeIcons.church),
              onTap: () {
                Parish.getAll().then((parishes) {
                  _selectParish(parishes);
                });
              },
            ),
            //Divider(),
            ListTile(
              title: Text("Notación"),
              subtitle: Text((_notation == Constants.NOTATION_SPANISH)
                  ? "Española"
                  : "Inglesa"),
              leading: Icon(FontAwesomeIcons.music),
              onTap: () {
                _selectNotation();
              },
            ),
            Divider(),
            ListTile(
              dense: false,
              title: Text("Direccion"),
              subtitle: Text(Api.BaseUrl),
              leading: Icon(FontAwesomeIcons.globe),
            ),
          ],
        ),
      ),
    );
  }

  void _selectParish(List<Parish> parishes) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: EdgeInsets.all(0.0),
        titlePadding: EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Parroquias",
            //textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        children: parishes
            .map((parish) => ListTile(
                  title: Text(parish.name),
                  onTap: () {
                    SharedPreferences.getInstance().then((sp) {
                      sp.setInt(Constants.PARISH_ID, parish.id);
                      sp.setString(Constants.PARISH_NAME, parish.name);
                      setState(() {
                        _parish = parish;
                      });
                      Navigator.of(context).pop();
                    });
                  },
                ))
            .toList(),
      ),
    );
  }

  void _selectNotation() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: EdgeInsets.all(0.0),
        titlePadding: EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Notacion",
            //textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          RadioListTile(
            groupValue: _notation,
            value: Constants.NOTATION_ENGLISH,
            title: Text("Inglesa"),
            subtitle: Text("A, B, C, D, E, F, G"),
            onChanged: (value) {
              setState(() {
                _notation = value;
                SharedPreferences.getInstance().then((sp) {
                  sp.setInt(Constants.NOTATION_TOKEN, value);
                  Navigator.of(context).pop();
                });
              });
            },
          ),
          RadioListTile(
            groupValue: _notation,
            value: Constants.NOTATION_SPANISH,
            title: Text("Española"),
            subtitle: Text("La, Si, Do, Re, Mi, Fa, Sol"),
            onChanged: (value) {
              setState(() {
                _notation = value;
                SharedPreferences.getInstance().then((sp) {
                  sp.setInt(Constants.NOTATION_TOKEN, value);
                  Navigator.of(context).pop();
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
