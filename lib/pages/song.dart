import 'dart:async';

import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/SongTextWidget.dart';
import 'package:csbook_app/databases/InstanceDatabase.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/pages/songfullscreen.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:screen/screen.dart';

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
    InstanceDatabase db = new InstanceDatabase();
    List<Instance> instances = await db.fetchInstancesForSong(song.id);
    if ((instances == null) || (instances.length == 0)) {
      //Retrieve from Internet
      for(var instanceId in song.instances.keys){
        instances.add(await Instance.get(instanceId));
      }
      //Save all to db
      instances.forEach((i)=> db.saveOrUpdateInstance(i));
      print("Saved ${instances.map((i)=> i.song.title)}");
    }
    return instances;
  }

  Widget getWaitingApp() {
    return Scaffold(
        appBar: AppBar(
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(song.title.toString()),
                Text(
                  song.author.toString(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic),
                ),
              ]),
        ),
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
