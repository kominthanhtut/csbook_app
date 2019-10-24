import 'package:csbook_app/Model/Parish.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        _parish = Parish(sp.get(Constants.PARISH_ID),
            sp.get(Constants.PARISH_NAME), null, null, null);
        _parish = (_parish.id != null) ? _parish : null;
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
      body: ListView(
        children: <Widget>[
          Divider(),
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
                value: DynamicTheme.of(context).brightness == Brightness.dark),
            title: new Text(
              'Tema oscuro',
            ),
            onTap: () {},
          ),
          Divider(),
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
          )
        ],
      ),
    );
  }

  void _selectParish(List<Parish> parishes) {
    showDialog(
        context: context,
        child: AlertDialog(
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
          content: ListView.builder(
            shrinkWrap: true,
            itemCount: parishes.length,
            itemBuilder: (context, position) {
              return ListTile(
                title: Text(parishes[position].name),
                onTap: () {
                  SharedPreferences.getInstance().then((sp) {
                    sp.setInt(Constants.PARISH_ID, parishes[position].id);
                    sp.setString(
                        Constants.PARISH_NAME, parishes[position].name);
                    setState(() {
                      _parish = parishes[position];
                    });
                    Navigator.of(context).pop();
                  });
                },
              );
            },
          ),
        ));
  }
}
