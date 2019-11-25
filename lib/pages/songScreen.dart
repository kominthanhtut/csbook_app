import 'dart:async';

import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Widgets/SongTextWidget.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/pages/songfullscreen.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongScreen extends StatefulWidget {

  final Song song;
  final bool standAlone;
  final Instance instance;
  final int transpose;
  SongScreen({Key key, this.song, this.standAlone = true, this.instance, this.transpose = 0}) : super(key: key);

  @override
  _SongScreenState createState() => _SongScreenState(song, standAlone, instance: instance, transpose: transpose);
}

class _SongScreenState extends State<SongScreen> {
  Song _song;
  final bool _standAlone;
  Instance _instance;
  final Instance instance;

  int transpose = 0;
  double defaultFontSize = 16;
  double initfontSize, fontSize = 16;

  int _notation = Constants.NOTATION_SPANISH;

  var searchBar;

  bool _controlDisplayed = false;

  _SongScreenState(this._song, this._standAlone, {this.instance, this.transpose});

  void getInstances(Song song) {
    _retrieveInstances(song).then((List<Instance> instances) {
      setState(() {
        _instance = instances[0];
      });
    });
  }

  void initState() {
    super.initState();
    if(instance != null){
      _instance = instance;
      return;
    }
    getInstances(_song);
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        var savedNotation = sp.get(Constants.NOTATION_TOKEN);
        if (savedNotation != null && savedNotation is int)
          _notation = savedNotation;
      });
    });
  }

  Future<List<Instance>> _retrieveInstances(Song song, {bool forceOnline = false}) async {
    CSDB db = CSDB();
    List<Instance> instances = new List<Instance>();
    for (int id in song.instances.keys) {
      Instance instance = await db.fetchInstance(id);
      if (instance == null || forceOnline) {
        instance = await Instance.get(id);
        db.saveOrUpdateInstance(instance);
      }
      instances.add(instance);
    }
    return instances;
  }

  Widget _loadedBody() {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SongFullScreen(SongState(transpose, fontSize, _instance)))
          );
        });
      },
      child: SingleChildScrollView(
        child: SongText(_instance.transpose(transpose),
            textSize: fontSize, notation: _notation),
      ),
    );
  }

  Widget _loadingAppBar() {
    return AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: _standAlone,
        title: Text(Constants.APP_TITLE));
  }

  Widget _loadedAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: _standAlone,
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_instance.song.title.toString()),
            _instance.song.author == null
                ? Container()
                : Text(
                    _instance.song.author.toString(),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),
                  ),
          ]),
      actions: <Widget>[
        Opacity(
          opacity: 0.8,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.searchMinus),
            onPressed: () {
              setState(() {
                fontSize--;
              });
            },
          ),
        ),
        Opacity(
          opacity: 0.8,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.searchPlus),
            onPressed: () {
              setState(() {
                fontSize++;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _floatingActionButtonExtended() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.black,
      label: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _retrieveInstances(_song, forceOnline: true).then((List<Instance> instances) {
                setState(() {
                  _instance = instances[0];
                });
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                transpose--;
              });
            },
          ),
          FlatButton(
            child: Text(
              //"Original " +
              _instance.getTone(_notation == Constants.NOTATION_SPANISH ? Chord.CHORD_SET_SPANISH: Chord.CHORD_SET_ENGLISH),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              setState(() {
                transpose = 0;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                transpose++;
              });
            },
          ),
          IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  setState(() {
                    _controlDisplayed = false;
                  });
                });
              }),
        ],
      ),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_instance == null) ? _loadingAppBar() : _loadedAppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RoundedBlackContainer(
              child: (_instance == null)
                  ? FetchingWidget(Constants.SONG_WAITING)
                  : _loadedBody(),
              bottomOnly: true,
              radius: Constants.APP_RADIUS,
              displayBorder: _standAlone,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (_instance == null)
          ? Container()
          : !_controlDisplayed
              ? FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.settings),
                  onPressed: () {
                    setState(() {
                      _controlDisplayed = true;
                    });
                  },
                )
              : _floatingActionButtonExtended(),
    );
  }
}
