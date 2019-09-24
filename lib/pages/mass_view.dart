import 'dart:async';

import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/databases/InstanceDatabase.dart';
import 'package:csbook_app/databases/SongDatabase.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/pages/songfullscreen.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';

import 'package:csbook_app/SongTextWidget.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MassScreen extends StatefulWidget {
  static const routeName = '/mass_view';
  @override
  _MassScreenState createState() => _MassScreenState();
}

class _MassScreenState extends State<MassScreen> {
  Mass _mass;

  int _currentMoment = 0;
  int transpose = 0;
  bool _showChords = false;

  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');

  void getInstances(Mass mass) {
    mass.retrieveAllInstances().then((Mass mass) {
      setState(() {
        _mass = mass;
      });
    });
  }

  List<Step> _toSteps(BuildContext context, Mass mass) {
    List<Step> _steps = new List<Step>();
    mass.songs.forEach((key, value) {
      _steps.add(new Step(
          title: Text(
            key,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          subtitle: Text(value.getInstance().song.title),
          content: InkWell(
            onTap: _openFullScreenSong,
            child: SongText((_showChords)
                ? value.getInstance().transposeTo(value.tone)
                : value.getInstance().removeChords()),
          )));
    });

    return _steps;
  }

  bool _endOfSteps() {
    return (_currentMoment >= _mass.songs.values.length - 1);
  }

  void _openFullScreenSong() {
    Navigator.pushNamed(
      context,
      SongFullScreen.routeName,
      arguments: SongState(
          transpose, 16, _mass.songs.values.toList()[_currentMoment].getInstance()),
    );
  }

  Widget _getBottomAppBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text("Acordes"),
          ),
          Switch(
            value: _showChords,
            onChanged: (value) {
              setState(() {
                _showChords = value;
              });
            },
          ),
          (_showChords)
              ? IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      transpose--;
                    });
                  },
                )
              : Container(
                  height: 1,
                ),
          (_showChords)
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      transpose++;
                    });
                  },
                )
              : Container(
                  height: 1,
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    if (_mass == null || !_mass.instancesRecovered()) {
      _mass = ModalRoute.of(context).settings.arguments;
      getInstances(_mass);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _mass.hasName()
              ? Constants.MASS_VIEW_TITLE + _mass.name
              : Constants.MASS_VIEW_TITLE +
                  formatterFullDate.format(_mass.date),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.fullscreen,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _openFullScreenSong,
          ),
        ],
      ),
      body: _mass.instancesRecovered()
          ? Stepper(
              //type: StepperType.horizontal,
              currentStep: _currentMoment,
              steps: _toSteps(context, _mass),
              onStepTapped: (step) {
                setState(() {
                  _currentMoment = step;
                  transpose = 0;
                });
              },
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Container();
              },
            )
          : FetchingWidget(Constants.SONGS_WAITING),
      floatingActionButton: _mass.instancesRecovered()
          ? FloatingActionButton(
              child: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  _currentMoment = (_currentMoment + 1) % _mass.songs.length;
                  transpose = 0;
                });
              },
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _mass.instancesRecovered() ? _getBottomAppBar() : null,
    );
  }
}
