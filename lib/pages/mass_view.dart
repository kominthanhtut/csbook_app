import 'dart:async';

import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/databases/InstanceDatabase.dart';
import 'package:csbook_app/databases/SongDatabase.dart';
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
  Map<String, Instance> _instances;

  int _currentMoment = 0;
  int transpose = 0;
  bool _showChords = false;

  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');

  void getInstances(Mass mass) {
    _retrieveInstances(mass).then((Map<String, Instance> instances) {
      setState(() {
        _instances = instances;
        print(instances);
      });
    });
  }

  List<Step> _toSteps(BuildContext context, Map<String, Instance> songs) {
    List<Step> _steps = new List<Step>();
    songs.forEach((key, value) {
      _steps.add(new Step(
          title: Text(
            key,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          subtitle: Text(value.song.title),
          content: InkWell(
            onTap: _openFullScreenSong,
            child: SongText((_showChords)
                ? value.transpose(transpose)
                : value.removeChords()),
          )));
    });

    return _steps;
  }

  bool _recovered() {
    return (_instances != null && _instances.length > 0);
  }

  bool _endOfSteps() {
    return (_currentMoment >= _instances.length - 1);
  }

  void _openFullScreenSong() {
    Navigator.pushNamed(
      context,
      SongFullScreen.routeName,
      arguments: SongState(
          transpose, 16, _instances[_instances.keys.toList()[_currentMoment]]),
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

  Future<Map<String, Instance>> _retrieveInstances(Mass mass) async {
    InstanceDatabase instancesdb = new InstanceDatabase();
    List<String> songs_keys = mass.songs.keys.toList();

    Map<String, Instance> recovered = new Map<String, Instance>();

    for (String element in songs_keys) {
      int song_id = mass.songs[element];
      Instance instance;
      List<Instance> instances =
          (await instancesdb.fetchInstancesForSong(song_id));
      if (instances == null || instances.length == 0) {
        instance = (await Instance.getBySongId(song_id))[0];
        instancesdb.saveOrUpdateInstance(instance);
      } else {
        instance = instances[0];
      }

      recovered[element] = instance;
    }

    return recovered;
  }

  @override
  Widget build(BuildContext context) {
    if (_mass == null || _instances == null) {
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
      body: _recovered()
          ? Stepper(
              //type: StepperType.horizontal,
              currentStep: _currentMoment,
              steps: _toSteps(context, _instances),
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
          : FetchingWidget(Constants.SONG_WAITING),
      floatingActionButton: _recovered()
          ? FloatingActionButton(
              child: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  _currentMoment = (_currentMoment + 1) % _instances.length;
                  transpose = 0;
                });
              },
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _recovered() ? _getBottomAppBar() : null,
    );
  }
}
