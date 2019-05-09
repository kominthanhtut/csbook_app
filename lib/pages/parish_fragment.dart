import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/pages/PageInterface.dart';
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
    return [(!_picked) ? IconButton(
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
            ):
            IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _picked = false;
                    _filteredMases = _masses;
                  });
                })
            ];
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
      return  new ListView.builder(itemBuilder: (context, index) {
      return new StickyHeader(
        header: new Container(
          height: 50.0,
          color: Colors.blueGrey[700],
          padding: new EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: new Text(_filteredMases[index].parish,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        content: new Container(
          child: Column(children: _filteredMases.map((m)=>MassTile(m)).toList())
        ),
      );
    });
  }

Widget makeBody(){
  return ListView.builder(
          itemCount: _filteredMases != null ? _filteredMases.length : 0,
          itemBuilder: (BuildContext context, int position) {
            return MassTile(
              _filteredMases[position],
              onTap: (mass) {
                print(mass.songs);
              },
            );
          });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((!_picked)?Constants.PARISH_TITLE: Constants.FILTERING_TEXT + formatterFullDate.format(_date)),
        actions: getActions(context),
      ),
      body: (_filteredMases != null) ?
      makeBody()
      : FetchingWidget(Constants.PARISH_WAITING),
    );
  }
}
