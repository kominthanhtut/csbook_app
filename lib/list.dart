import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/song.dart';
import 'package:flutter/material.dart';

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
    Instance.get(song).then((List<Instance> instances) {
      Navigator.pushNamed(
        context,
        SongScreen.routeName,
        arguments: instances[0],
      );
    });
  }

  @override
  void initState() {
    Song.get(0, 0).then((s) => this.songs = s);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new ListView.builder(
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
        ));
  }
}
