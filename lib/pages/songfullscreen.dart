import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Widgets/SongTextWidget.dart';
import 'package:csbook_app/Model/Instance.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:screen/screen.dart';

import 'dart:async';

class SongFullScreen extends StatefulWidget {
  static const routeName = '/song_view_fs';

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

  Future<bool> _prepareExit() {
    Screen.keepOn(false);
    //Constants.systemBarsSetup(Theme.of(context));
    return Future.value(true);
  }

  Widget getFullscreenApp(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
        child: WillPopScope(
          onWillPop: _prepareExit,
          child: Scaffold(
            body: GestureDetector(
              onTap: () {
                Screen.keepOn(false);
                Navigator.of(context).pop();
              },
              child: Stack(
                children: <Widget>[ 
                  
                  Container(
                  color: Colors.black,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                          left: 10,
                          right: 10),
                      child: Column(children: [
                        Text(
                          instance.song.title,
                          style: TextStyle(fontSize: 32),
                          textAlign: TextAlign.center,
                        ),
                        instance.song.author == null
                            ? Container()
                            : Text(
                                instance.song.author,
                                style: TextStyle(
                                    fontSize: 24, fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                        (instance.song.subtitle != null &&
                                instance.song.subtitle != "")
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
                Container(height: MediaQuery.of(context).padding.top, color: Colors.black,),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (songState == null) {
      songState = ModalRoute.of(context).settings.arguments;
      instance = songState.instance;
      transpose = songState.transpose;
      fontSize = songState.fontsize;
    }
    // Constants.systemBarsSetupByColor(Brightness.dark, Colors.black).then((_){});

    return getFullscreenApp(context);
  }
}
