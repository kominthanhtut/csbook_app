import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Model/Mass.dart';
import 'package:csbook_app/Model/Parish.dart';
import 'package:csbook_app/Pages/PageInterface.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:intl/intl.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'massViewScreen.dart';

class ParishScreen extends StatefulWidget implements PageInterface {
  @override
  _ParishScreenState createState() => _ParishScreenState();

  @override
  List<Widget> getActions(BuildContext context) {
    return _ParishScreenState().getActions(context);
  }
}

class _ParishScreenState extends State<ParishScreen> {
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
              Navigator.pushNamed(
                context,
                MassScreen.routeName,
                arguments: mass,
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RoundedBlackContainer(
        child: (_filteredMases != null)
            ? makeBody()
            : FetchingWidget(Constants.PARISH_WAITING),
        bottomOnly: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        radius: Constants.APP_RADIUS,
      ),
     
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
