import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Pages/songScreen.dart';
import 'package:csbook_app/SongSearch.dart';
import 'package:csbook_app/Widgets/NavigationDrawer.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/Model/Song.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class TabletListPage extends StatefulWidget {
  static const routeName = '/song_list';

  TabletListPage({Key key}) : super(key: key);

  @override
  _TabletListPageState createState() => _TabletListPageState();
}

class _TabletListPageState extends State<TabletListPage> {
  List<Song> _songs = new List<Song>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _selectedSong = Container();

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
    setState(() {
      _selectedSong = SongScreen(
        key: Key(song.id.toString()),
        song: song,
      );
      _selectedSong = Container();
    });
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

  Widget makeAppBar(GlobalKey<ScaffoldState> parentScaffoldKey) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(Constants.APP_TITLE),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          parentScaffoldKey.currentState.openDrawer();
        },
      ),
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
                setState(() {
                  _selectedSong = SongScreen(
                    key: Key(song.id.toString()),
                    song: song,
                    standAlone: false,
                  );
                });
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
      key: _scaffoldKey,
      body: RoundedBlackContainer(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          color: Theme.of(context).primaryColorLight, width: 0)),
                  ),
              width: MediaQuery.of(context).size.width * 0.35,
              child: Scaffold(
                appBar: makeAppBar(_scaffoldKey),
                body: makeBody(),
              )),
          Container(
            
              width: MediaQuery.of(context).size.width * 0.65,
              child: _selectedSong)
        ]),
        bottomOnly: true,
        radius: Constants.APP_RADIUS,
      ),
      drawer: NavigationDrawer.drawer(context,
          end: false, currentPage: NavigationDrawer.LIST_PAGE),
    );
  }
}
