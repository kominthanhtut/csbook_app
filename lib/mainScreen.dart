import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/pages/list_fragment.dart';
import 'package:csbook_app/pages/masses_fragment.dart';
import 'package:csbook_app/pages/parish_fragment.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  List<Song> songs = new List<Song>();

  var index = 0;

  _MainState();



  @override
  Widget build(BuildContext context) {
    List pages = [ListScreen(), ParishScreen(), MassesScreen()];

    return Scaffold(
      
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("List")),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), title: Text("Parish")),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_play), title: Text("Masses")),
        ],
      ),
    );
  }
}
