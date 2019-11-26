import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/pages/SongScreen.dart';
import 'package:csbook_app/SongSearch.dart';
import 'package:csbook_app/Widgets/NavigationDrawer.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/model/Song.dart';
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

  void getInstances(BuildContext context, Song song) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SongScreen(
              key: Key("0"),
              song: song,
            )));
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
