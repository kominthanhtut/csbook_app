import 'dart:async';

import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Model/Chord.dart';
import 'package:csbook_app/Model/Mass.dart';
import 'package:csbook_app/Pages/songfullscreen.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:csbook_app/Widgets/SongTextWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:share/share.dart';

import '../Api.dart';

class MassScreen extends StatefulWidget {
  static const routeName = '/mass_view';
  @override
  _MassScreenState createState() => _MassScreenState();
}

class _MassScreenState extends State<MassScreen> {
  Mass _mass;

  int _currentMoment = 0;
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
            onTap: () {
              _openFullScreenSong(value);
            },
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

  void _openFullScreenSong(MassSong massSong) {
    int transpose = Chord(massSong.getInstance().tone)
        .semiTonesDiferentWith(Chord(massSong.tone));
    Navigator.pushNamed(
      context,
      SongFullScreen.routeName,
      arguments: SongState(transpose, 16, massSong.getInstance()),
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
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _createListView(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: (Theme.of(context).brightness == Brightness.dark)
              ? Colors.white
              : Colors.black),
      child: ListView(
        children: _mass.songs.keys.map((String ms) {
          return ExpansionTile(
            title: ListTile(
              title: Text(
                ms,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _mass.songs[ms].getInstance().song.getTitle(),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.fullscreen),
              onPressed: () {
                _openFullScreenSong(_mass.songs[ms]);
              },
            ),
            //leading: Icon(Icons.arrow_drop_down_circle),
            children: <Widget>[
              InkWell(
                child: SongText(_mass.songs[ms].getInstance().removeChords()),
                onTap: () {
                  _openFullScreenSong(_mass.songs[ms]);
                },
              )
            ],
          );
        }).toList(),
      ),
    );
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
              ? _mass.name
              : Constants.MASS_VIEW_TITLE +
                  formatterFullDate.format(_mass.date),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: () {
              Share.share(Api.BaseUrl + "mass/view/" + _mass.id);
            },
          ),
        ],
      ),
      body: _mass.instancesRecovered()
          ? _createListView(context)
          : FetchingWidget(Constants.SONGS_WAITING),
    );
  }
}
