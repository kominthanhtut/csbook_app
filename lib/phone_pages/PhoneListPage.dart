import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Pages/songScreen.dart';
import 'package:csbook_app/SongSearch.dart';
import 'package:csbook_app/Widgets/NavigationDrawer.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/Model/Song.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class PhoneListPage extends StatefulWidget {
  static const routeName = '/song_list';

  PhoneListPage({Key key}) : super(key: key);

  @override
  _PhoneListPageState createState() => _PhoneListPageState();
}

class _PhoneListPageState extends State<PhoneListPage> {
  List<Song> _songs = new List<Song>();

  var index = 0;

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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SongScreen(
              key: Key("0"),
              song: song,
            )));
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(Constants.APP_TITLE),
      actions: getActions(context),
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
      Builder(
          builder: (context) => _songs.length > 0
              ? IconButton(
                  icon: Icon(Icons.search),
                  tooltip: 'Filtrar',
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: SongSearch(_songs, (song) {
                          print(song.title);
                          getInstances(context, song);
                        }));
                  },
                )
              : Container())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(),
      body: RoundedBlackContainer(
        child: makeBody(),
        bottomOnly: true,
        radius: Constants.APP_RADIUS,
      ),
      drawer: NavigationDrawer.drawer(context,
          end: false, currentPage: NavigationDrawer.LIST_PAGE),
      endDrawer: NavigationDrawer.drawer(context,
          end: true, currentPage: NavigationDrawer.LIST_PAGE),
    );
  }
}
