import 'package:csbook_app/SongTextWidget.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:screen/screen.dart';

class SongFullScreen extends StatefulWidget {
  static const routeName = '/song_view_fs';

  SongFullScreen({Key key}) : super(key: key);

  @override
  _SongFullScreenState createState() => _SongFullScreenState();
}

class SongState {
  final int transpose;
  final double fontsize;
  final Instance instance;

  SongState(this.transpose, this.fontsize, this.instance);
}

class _SongFullScreenState extends State<SongFullScreen> {
  SongState songState;
  Instance instance;

  int transpose = 0;
  double defaultFontSize = 16;
  double initfontSize, fontSize = 16;

  _SongFullScreenState();

@override
  void initState() {
    // Prevent screen from going into sleep mode:
    Screen.keepOn(true);
    super.initState();
  }
  

  Widget getFullscreenApp(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Screen.keepOn(false);
        Navigator.of(context).pop();
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          //brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            body1: TextStyle(color: Colors.white)
          )
          ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 32, left: 10, right: 10),
              child: Column(children: [
                Text(
                  instance.song.title,
                  style: TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                Text(
                  instance.song.author,
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                (instance.song.subtitle != null && instance.song.subtitle != "")
                    ? Text(
                        "(" + instance.song.subtitle + ")",
                        style: TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                Row(children: [
                  Expanded(
                    child: SongText(
                      instance.transpose(transpose),
                      textSize: fontSize,
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    if (songState == null) {
      songState = ModalRoute.of(context).settings.arguments;
      instance = songState.instance;
      transpose = songState.transpose;
      fontSize = songState.fontsize;
    }
    return getFullscreenApp(context);
  }
}
