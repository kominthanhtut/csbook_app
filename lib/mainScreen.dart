import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/pages/PageInterface.dart';
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

class _MainState extends State<MainScreen> with TickerProviderStateMixin {
  List<Song> songs = new List<Song>();

  var index = 0;
  List<Widget> _pages;

  TabController _tabController;
  String _currentTitle = Constants.APP_TITLE;
  List<Widget> _currentActions = [];

  ListScreen _listScreen = ListScreen();
  ParishScreen _parishScreen = ParishScreen();

  _MainState();

   @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {_onTabChanged(context);});
  }

  @override
  Widget build(BuildContext context) {
    _pages = [_listScreen, _parishScreen];

    _currentActions = (_pages[_tabController.index] as PageInterface).getActions(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
        actions: _currentActions,
        bottom: TabBar(
          controller: _tabController, 
          indicatorColor: Colors.white,
          tabs: [
          Tab(
            text: "Canciones",
            //icon: Icon(Icons.list),
          ),
          Tab(
            text: "Misas",
            //icon: Icon(Icons.people),
          )
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages,
      ),
    );
  }

  void _onTabChanged(BuildContext context) {
    setState(() {
      //_currentTitle = _pages[_tabController.index].key.toString();
      _currentActions = (_pages[_tabController.index] as PageInterface).getActions(context);
    });
  }
}
