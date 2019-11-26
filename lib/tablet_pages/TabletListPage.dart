import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/pages/SongScreen.dart';
import 'package:csbook_app/SongSearch.dart';
import 'package:csbook_app/Widgets/NavigationDrawer.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/model/Song.dart';
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


  void getInstances(BuildContext context, Song song) {
    setState(() {
      _selectedSong = SongScreen(
        key: Key(song.id.toString()),
        song: song,
        standAlone: false,
      );
    });
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
    return Scrollbar(
      child: FutureBuilder<List<Song>>(
          future: Song.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null &&
                snapshot.data?.length == 0) {
              return FetchingWidget(Constants.SONGS_WAITING);
            } else {
              return ListView.builder(
                  itemCount: snapshot.data==null ? 0: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SongTile(snapshot.data[index], onTap: (song) {
                      getInstances(context, song);
                      print(song);
                    });
                  });
            }
          }),
    );
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SongScreen(
                                    key: Key(song.id.toString()),
                                    song: song,
                                  )));
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
              width: MediaQuery.of(context).size.width * 0.3,
              child: Scaffold(
                appBar: makeAppBar(_scaffoldKey),
                body: makeBody(),
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
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
