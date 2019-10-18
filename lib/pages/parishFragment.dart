import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Model/Mass.dart';
import 'package:csbook_app/Model/Parish.dart';
import 'package:csbook_app/Pages/PageInterface.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:intl/intl.dart';

import 'package:auto_size_text/auto_size_text.dart';

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

  initState() {
    _picked = false;
    Mass.get(0, 0).then((masses) {
      setState(() {
        _picked = false;
        _masses = masses;
        _parishes = _getParish(masses);
        _filteredMases = _masses.where((Mass m) {
          return m.parish.name == _parishes[0];
        }).toList();
        _selectedParish = _parishes[0];
      });
    });
    super.initState();
  }

  List<Widget> getActions(BuildContext context) {
    return [Builder(
              builder: (context) => Container())];
   
  }

  List<String> _getParish(List<Mass> filteredMases) {
    List<String> parishes = [];
    for (Mass mass in filteredMases) {
      String parish = mass.parish.name;
      if (!parishes.contains(parish)) parishes.add(parish);
    }
    return parishes;
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
      body: (_filteredMases != null)
          ? Container(
              color: Colors.black,
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Constants.APP_RADIUS),
                          bottomRight: Radius.circular(Constants.APP_RADIUS))),
                  child: makeBody()))
          : FetchingWidget(Constants.PARISH_WAITING),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: AutoSizeText(
          (_selectedParish == null) ? "Seleccionar Parroquia" : _selectedParish,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          _selectParish();
        },
      ),
    );
  }

  void _selectParish() {
    showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          titlePadding: EdgeInsets.zero,
          title: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(bottom: BorderSide(color: Colors.white))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Parroquias" ,
                //textAlign: TextAlign.center, 
                style: TextStyle(fontWeight: FontWeight.bold),),
              )),
          content: ListView.builder(
            shrinkWrap: true,
            itemCount: _parishes.length,
            itemBuilder: (context, position) {
              return ListTile(
                title: Text(_parishes[position]),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pop();
                    _selectedParish = _parishes[position];
                    _filteredMases = _masses.where((Mass m) {
                      return m.parish.name == _parishes[position];
                    }).toList();
                  });
                },
              );
            },
          ),
        ));
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
