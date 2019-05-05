import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/pages/PageInterface.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

import 'dart:async';

import 'package:intl/intl.dart';

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
  bool _picked=false;

  String filteringText = "Filtrando: ";
  String notFilteringText = "Filtrar";

  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');

  initState() {
    _picked = false;
    Mass.get(0, 0).then((masses) {
      _masses = masses;
      _filteredMases = masses;
    });
    super.initState();
  }

  List<Widget> getActions(BuildContext context) {
    return [];
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100));
    return picked == null? _date: picked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        /*
        Calendar(
          isExpandable: true,
          onDateSelected: (_selectedDate) {
            setState(() {
              //_date = _selectedDate;
              _filteredMases = _masses.where((m){
                return m.date == _selectedDate;
              }).toList();
            });
          },
        ),*/
        Row(children: [
          Expanded(
              child: FlatButton(
            child: Text(_picked ? filteringText + formatterFullDate.format(_date): notFilteringText),
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
          )),
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _picked = false;
                  _filteredMases = _masses;
                });
              }),
        ]),
        Expanded(
          child: ListView.builder(
              itemCount: _filteredMases != null ? _filteredMases.length : 0,
              itemBuilder: (BuildContext context, int position) {
                return MassTile(
                  _filteredMases[position],
                  onTap: (mass) {
                    print(mass.songs);
                  },
                );
              }),
        ),
      ]),
    );
  }
}
