import 'dart:async';

import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Widgets/SongTextWidget.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/Model/Chord.dart';
import 'package:csbook_app/Model/Instance.dart';
import 'package:csbook_app/Model/Song.dart';
import 'package:csbook_app/Pages/songfullscreen.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SongScreen extends StatefulWidget {
  static const routeName = '/song_view';

  Song song;
  SongScreen({Key key, this.song}) : super(key: key);

  @override
  _SongScreenState createState() => _SongScreenState(song);
}

class _SongScreenState extends State<SongScreen> {
  Song _song;
  Instance _instance;

  int transpose = 0;
  double defaultFontSize = 16;
  double initfontSize, fontSize = 16;

  var searchBar;

  bool _controlDisplayed = false;

  _SongScreenState(this._song);

  void getInstances(Song song) {
    _retrieveInstances(song).then((List<Instance> instances) {
      setState(() {
        _instance = instances[0];
      });
    });
  }

  void initState() {
    super.initState();
    getInstances(_song);
  }

  Future<List<Instance>> _retrieveInstances(Song song) async {
    CSDB db = CSDB();
    List<Instance> instances = new List<Instance>();
    for (int id in song.instances.keys) {
      Instance instance = await db.fetchInstance(id);
      if (instance == null) {
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
          Navigator.pushNamed(
            context,
            SongFullScreen.routeName,
            arguments: SongState(transpose, fontSize, _instance),
          );
        });
      },
      child: SingleChildScrollView(
        child: SongText(
          _instance.transpose(transpose),
          textSize: fontSize,
        ),
      ),
    );
  }

  Widget _loadingAppBar() {
    return AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(Constants.APP_TITLE));
  }

  Widget _loadedAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
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
              _instance.getTone(Chord.CHORD_SET_SPANISH),
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

    //Constants.systemBarsSetup(Theme.of(context));
    
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
