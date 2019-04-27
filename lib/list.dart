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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: Song.get(0, 0),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new Text('loading...');
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data[index].hasAuthor()) {
                        return new ListTile(
                          title: new Text(snapshot.data[index].getTitle()),
                          subtitle: new Text(snapshot.data[index].getAuthor()),
                          onTap: () {
                            getInstances(context,snapshot.data[index]);
                          },
                        );
                      } else {
                        return new ListTile(
                          title: new Text(snapshot.data[index].getTitle()),
                          onTap: () {
                            getInstances(context, snapshot.data[index]);
                          },
                        );
                      }
                    },
                  );
                ;
            }
          },
        ));
  }
}
