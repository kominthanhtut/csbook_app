import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/model/Parish.dart';
import 'package:csbook_app/Widgets/NavigationDrawer.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:csbook_app/pages/MassScreen.dart';
import 'package:csbook_app/pages/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:async';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ParishPage extends StatefulWidget {
  @override
  _ParishPageState createState() => _ParishPageState();
}

class _ParishPageState extends State<ParishPage> {
  List<Mass> _masses;
  List<Mass> _filteredMases;
  List<String> _parishes;

  DateTime _date = DateTime.now();
  bool _picked = false;

  String filteringText = "Filtrando: ";
  String notFilteringText = "Filtrar";

  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');

  String _selectedParish;

  Parish _parish;

  @override
  void initState() {
    _picked = false;
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      _parish = Parish(sp.get(Constants.PARISH_ID),
          sp.get(Constants.PARISH_NAME), null, null, null);
      _parish = (_parish.id != null) ? _parish : null;
      if (_parish != null) {
        Mass.get(0, 0).then((masses) {
          setState(() {
            _picked = false;
            _masses = masses;
            _filteredMases = _masses.where((Mass m) {
              return m.parish.name == _parish.name;
            }).toList();
          });
        });
      }
    });
  }

  List<Widget> getActions(BuildContext context) {
    return [Builder(builder: (context) => Container())];
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100));
    return picked == null ? _date : picked;
  }

  Widget makeBody() {
    return ListView.builder(
        itemCount: (_filteredMases != null ? _filteredMases.length : 0),
        itemBuilder: (BuildContext context, int position) {
          return MassTile(
            _filteredMases[position],
            onTap: (mass) {
              print(mass.songs);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MassScreen(mass))
              );
            },
          );
        });
  }

  Widget _selectParishWidget(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.download,
            size: 128,
            color: Theme.of(context).primaryColorLight,
          ),
          Container(
            height: 32,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Constants.FETCHING_TEXT + Constants.PARISH_WAITING + " ...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
          FlatButton(
            child: Text("Seleccionar parroquia",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Theme.of(context).primaryColorLight,
                )),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SettingsScreen()));
            },
          ),
          FlatButton(
            child: Text("Refrescar",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Theme.of(context).primaryColorLight,
                )),
            onPressed: () {
              SharedPreferences.getInstance().then((sp) {
                _parish = Parish(sp.get(Constants.PARISH_ID),
                    sp.get(Constants.PARISH_NAME), null, null, null);
                _parish = (_parish.id != null) ? _parish : null;
                if (_parish != null) {
                  Mass.get(0, 0).then((masses) {
                    setState(() {
                      _picked = false;
                      _masses = masses;
                      _filteredMases = _masses.where((Mass m) {
                        return m.parish.name == _parish.name;
                      }).toList();
                    });
                  });
                }
              });
            },
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    //Constants.systemBarsSetup(Theme.of(context));

    return Scaffold(
      appBar: AppBar(
        title: Text("Misas"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: getActions(context),
      ),
      body: RoundedBlackContainer(
        bottomOnly: true,
        radius: Constants.APP_RADIUS,
        child: (_filteredMases != null)
            ? makeBody()
            : _selectParishWidget(context),
      ),
      drawer: NavigationDrawer.drawer(context,
          end: false, currentPage: NavigationDrawer.PARISH_PAGE),
      endDrawer: NavigationDrawer.drawer(context,
          end: true, currentPage: NavigationDrawer.PARISH_PAGE),
    );
  }

  Map<String, List<Mass>> _sortMasses(List<Mass> filteredMases) {
    Map<String, List<Mass>> sortedMasses = new Map();
    for (var mass in _filteredMases) {
      if (sortedMasses[mass.parish.name] == null)
        sortedMasses[mass.parish.name] = new List<Mass>();
      sortedMasses[mass.parish.name].add(mass);
    }
    return sortedMasses;
  }
}
