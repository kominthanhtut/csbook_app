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
  Song song;
  Instance instance;

  int transpose = 0;
  double defaultFontSize = 16;
  double initfontSize, fontSize = 16;

  var searchBar;

  bool _controlDisplayed = false;

  _SongScreenState(Song song);

  void getInstances(Song song) {
    _retrieveInstances(song).then((List<Instance> instances) {
      setState(() {
        instance = instances[0];
      });
    });
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

  Widget getWaitingApp() {
    return Scaffold(
        appBar: AppBar(title: Text(Constants.APP_TITLE)),
        body: FetchingWidget(Constants.SONG_WAITING));
  }

  Widget getNormalApp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(instance.song.title.toString()),
              instance.song.author == null
                  ? Container()
                  : Text(
                      instance.song.author.toString(),
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
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            Navigator.pushNamed(
              context,
              SongFullScreen.routeName,
              arguments: SongState(transpose, fontSize, instance),
            );
          });
        },
        child: Row(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                SongText(
                  instance.transpose(transpose),
                  textSize: fontSize,
                ),
                Container(
                  height: 32,
                )
              ]),
            ),
          ),
        ]),
      ),
      floatingActionButtonLocation: _controlDisplayed
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: !_controlDisplayed
          ? FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(Icons.settings),
              onPressed: () {
                setState(() {
                  _controlDisplayed = true;
                });
              },
            )
          : FloatingActionButton.extended(
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
                      instance.getTone(Chord.CHORD_SET_SPANISH),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    if (song == null) {
      song = ModalRoute.of(context).settings.arguments;
      getInstances(song);
    }
    return Theme(
      data: ThemeData(
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: Theme.of(context).scaffoldBackgroundColor, elevation: 0)),
      child: (instance == null) ? getWaitingApp() : getNormalApp(context),
    );
  }
}
