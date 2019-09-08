import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/pages/PageInterface.dart';
import 'package:csbook_app/pages/mass_view.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:intl/intl.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sticky_headers/sticky_headers.dart';

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

  DateTime _date = DateTime.now();
  bool _picked = false;

  String filteringText = "Filtrando: ";
  String notFilteringText = "Filtrar";

  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');

  initState() {
    _picked = false;
    Mass.get(0, 0).then((masses) {
      setState(() {
        _picked = false;
        _masses = masses;
        _filteredMases = masses;
      });
    });
    super.initState();
  }

  List<Widget> getActions(BuildContext context) {
    return [];
    /*
    return [
      (!_picked)
          ? IconButton(
              icon: Icon(FontAwesomeIcons.calendarAlt),
              onPressed: () {
                _selectDate(context).then((_newDate) {
                  setState(() {
                    _date = _newDate;
                    _picked = true;
                    _filteredMases = _masses.where((m) {
                      return m.date == _newDate;
                    }).toList();
                  });
                });
              },
            )
          : IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _picked = false;
                  _filteredMases = _masses;
                });
              })
    ];
    */
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100));
    return picked == null ? _date : picked;
  }

  Widget makeBodyHeaders() {
    Map<String, List<Mass>> mapped = _sortMasses(_filteredMases);
    return new ListView.builder(
        itemCount: _filteredMases != null ? mapped.keys.length : 0,
        itemBuilder: (context, index) {
          return new StickyHeader(
            header: new Container(
              color: Theme.of(context).primaryColorLight,
              padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              alignment: Alignment.centerLeft,
              child: new Text(
                "Parroquia de " + mapped.keys.elementAt(index),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            content: new Container(
                child: Column(
                    children: mapped[mapped.keys.elementAt(index)]
                        .map((m) => MassTile(
                              m,
                              onTap: (mass) {
                                print(mass.songs);
                                Navigator.pushNamed(
                                  context,
                                  MassScreen.routeName,
                                  arguments: mass,
                                );
                              },
                            ))
                        .toList())),
          );
        });
  }

  Widget makeBody() {
    return ListView.builder(
        itemCount: _filteredMases != null ? _filteredMases.length : 0,
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
      /*
          appBar: AppBar(
            title: Text((!_picked)
                ? Constants.PARISH_TITLE
                : Constants.FILTERING_TEXT + formatterFullDate.format(_date)),
            actions: getActions(context),
          ),
          */
      body: (_filteredMases != null)
          ? makeBodyHeaders()
          : FetchingWidget(Constants.PARISH_WAITING),
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
