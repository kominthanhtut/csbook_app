import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/widgets.dart';
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

  _SongScreenState(Song song);

  void getInstances(Song song) {
    Instance.get(song).then((List<Instance> instances) {
      setState(() {
        instance = instances[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (song == null){
      song = ModalRoute.of(context).settings.arguments;
      getInstances(song);
    }
    if (instance == null)
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
          body: FetchingWidget("Fetching song ..."));
    else
      return Scaffold(
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
          /*
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(FontAwesomeIcons.youtube),
          //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
          onPressed: () {
            //_launchURL("https://www.youtube.com/watch?v="+instance.song.youtubeId.toString());
          },
        ),*/
          bottomNavigationBar: BottomAppBar(
            //shape: CircularNotchedRectangle(),
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
          ));
  }
}
