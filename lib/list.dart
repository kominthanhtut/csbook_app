import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/song.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/song_list';
  ListScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ListScreen> {
  List<Song> songs = new List<Song>();

  void getInstances(BuildContext context, Song song) {
      Navigator.pushNamed(
        context,
        SongScreen.routeName,
        arguments: song,
      );
  }

  @override
  void initState() {
    Song.get(0, 0).then((s){
      setState(() {
       this.songs = s; 
      });
    });
    super.initState();
  }

  Widget makeBody() {
    if (this.songs.length > 0) {
      return Scrollbar(
        child: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (BuildContext context, int index) {
            if (songs[index].hasAuthor()) {
              return new ListTile(
                title: new Text(songs[index].getTitle()),
                subtitle: new Text(songs[index].getAuthor()),
                onTap: () {
                  getInstances(context, songs[index]);
                },
              );
            } else {
              return new ListTile(
                title: new Text(songs[index].getTitle()),
                onTap: () {
                  getInstances(context, songs[index]);
                },
              );
            }
          },
        ),
      );
    } else {
      return FetchingWidget("Fetching list ...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh list',
              onPressed: () {
                Song.get(0, 0).then((s) {
                  setState(() {
                    this.songs = s;
                  });
                });
              },
            ),
          ],
        ),
        body: makeBody());
  }
}
