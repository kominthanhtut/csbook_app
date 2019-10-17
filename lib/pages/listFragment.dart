import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Pages/PageInterface.dart';
import 'package:csbook_app/Pages/songScreen.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/Model/Song.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class ListScreen extends StatefulWidget implements PageInterface {
  static const routeName = '/song_list';
  ListScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListState createState() => _ListState();

  @override
  List<Widget> getActions(BuildContext context) {
    return _ListState().getActions(context);
  }
}

class _ListState extends State<ListScreen> {
  List<Song> _songs = new List<Song>();

  var index = 0;

  _ListState() {
    Song.get(0, 0).then((s) {
      this._songs = s;
      
      /*
      _updateSongsDB().then((s) {
        this._songs = s;
      });
      */
    });
  }

  Future<List<Song>> _retrieveSongs() async {
    CSDB db = CSDB();
    List<Song> songs = await db.fetchAllSongs();
    if (songs == null) {
      songs = await Song.get(0, 0);
      db.saveOrUpdateAll(songs);
    }
    return songs;
  }

  Future<List<Song>> _updateSongsDB() async {
    CSDB db = CSDB();
    List<Song> songs = await Song.get(0, 0);
    db.saveOrUpdateAll(songs);
    return songs;
  }

  void getInstances(BuildContext context, Song song) {
    Navigator.pushNamed(
      context,
      SongScreen.routeName,
      arguments: song,
    );
  }

  @override
  void initState() {
    //We recover the songs from db
    Song.get(0, 0).then((s) {
      setState(() {
        this._songs = s;
      });
      
      /*
      //We update database from web
      _updateSongsDB().then((s) {
        setState(() {
          this._songs = s;
        });
      });
      */
    });

    super.initState();
  }

  Widget makeAppBar() {
    return AppBar(
      title: Text(Constants.APP_TITLE),
      actions: (this._songs.length > 0) ? getActions(context) : [],
    );
  }

  Widget makeBody() {
    if (this._songs.length > 0) {
      return Scrollbar(
        child: ListView.builder(
            itemCount: _songs.length,
            itemBuilder: (BuildContext context, int index) {
              return SongTile(_songs[index], onTap: (song) {
                getInstances(context, song);
              });
            }),
      );
    } else {
      return FetchingWidget(Constants.SONGS_WAITING);
    }
  }

  List<Widget> getActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        tooltip: 'Filter',
        onPressed: () {
          showSearch(
              context: context,
              delegate: SongSearch(_songs, (song) {
                print(song.title);
                getInstances(context, song);
              }));
        },
      ),
      /*
      IconButton(
        icon: Icon(Icons.refresh),
        tooltip: 'Refresh list',
        onPressed: () {
          _updateSongs().then((s)=> this.songs = s);
        },
      ),
      */
    ];
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold(appBar: makeAppBar(), body: makeBody());
    return makeBody();
  }
}

class SongSearch extends SearchDelegate<Song> {
  final List<Song> songs;
  final void Function(Song) callBack;

  SongSearch(this.songs, this.callBack);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show results based on selection
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // We dont have any suggestion for songs... Maybe Recents...

    final List<Song> suggestionList = query.isEmpty
        ? []
        : songs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()) ||
                (song.author != null &&
                    song.author.toLowerCase().contains(query.toLowerCase())) ||
                (song.subtitle != null &&
                    song.subtitle.toLowerCase().contains(query.toLowerCase())))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) =>
            SongTile(suggestionList[index], onTap: (song) {
              close(context, null);
              callBack(suggestionList[index]);
            }));
  }
}
