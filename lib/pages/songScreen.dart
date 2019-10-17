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
    for(int id in song.instances.keys){
      Instance instance = await db.fetchInstance(id);
      if (instance == null){
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
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pushNamed(
            context,
            SongFullScreen.routeName,
            arguments: SongState(transpose, fontSize, instance),
          );
        });
      },
      child: Scaffold(
          appBar: AppBar(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(instance.song.title.toString()),
                  instance.song.author == null ? Container():
                  Text(
                    instance.song.author.toString(),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),
                  ),
                ]),
            actions: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.minusSquare),
                onPressed: () {
                  setState(() {
                    fontSize--;
                  });
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.plusSquare),
                onPressed: () {
                  setState(() {
                    fontSize++;
                  });
                },
              ),
            ],
          ),
          body: Row(children: [
            Expanded(
              child: SingleChildScrollView(
                child: SongText(
                  instance.transpose(transpose),
                  textSize: fontSize,
                ),
              ),
            ),
          ]),
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      "Original " + instance.getTone(Chord.CHORD_SET_SPANISH)),
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
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    if (song == null) {
      song = ModalRoute.of(context).settings.arguments;
      getInstances(song);
    }
    if (instance == null)
      return getWaitingApp();
    else {
      return getNormalApp(context);
    }
  }
}
