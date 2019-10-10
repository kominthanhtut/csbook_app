import 'dart:async';

import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/pages/songfullscreen.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';

import 'package:csbook_app/SongTextWidget.dart';
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

  Widget _createSteper(BuildContext context) {
    return Stepper(
      //type: StepperType.horizontal,
      currentStep: _currentMoment,
      steps: _toSteps(context, _mass),
      onStepTapped: (step) {
        setState(() {
          _currentMoment = step;
        });
      },
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Container();
      },
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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
        //automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              Share.share(Api.BaseUrl+"mass/view/"+_mass.id);
            },
          ),
        ],
      ),
      body:  Container(
            color: Colors.black,
            child:Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16)
                ),
              child: _mass.instancesRecovered() ? _createSteper(context) : FetchingWidget(Constants.SONGS_WAITING)
              )
           )
          ,
      floatingActionButton: _mass.instancesRecovered()
          ? FloatingActionButton(
              child: Icon(Icons.fast_forward),
              backgroundColor: Theme.of(context).primaryColorLight,
              onPressed: () {
                setState(() {
                  _currentMoment = (_currentMoment + 1) % _mass.songs.length;
                });
              },
            )
          : Container(),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      //bottomNavigationBar: _mass.instancesRecovered() ? _getBottomAppBar() : null,
    );
  }
}
