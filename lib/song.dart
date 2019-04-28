import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SongScreen extends StatefulWidget {
  static const routeName = '/song_view';
  SongScreen({Key key, this.instance}) : super(key: key);
  final Instance instance;

  @override
  _SongScreenState createState() => _SongScreenState(instance);
}

class _SongScreenState extends State<SongScreen> {
  _SongScreenState(this.instance);
  final Instance instance;

  @override
  Widget build(BuildContext context) {
    final Instance instance = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(instance.song.title.toString()),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Row(children: [
            Expanded(
              child: SongText(instance.removeChords()),
            ),
          ])
        ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
          onPressed: () {
            _launchURL("https://www.youtube.com/watch?v="+instance.song.youtubeId.toString());
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {},
              ),
            ],
          ),
        ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
