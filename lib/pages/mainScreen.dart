import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Model/Song.dart';
import 'package:csbook_app/Pages/listFragment.dart';
import 'package:csbook_app/Pages/parishFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'PageInterface.dart';

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

  bool _parish = false;

  _MainState();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      _onTabChanged(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Theme.of(context).scaffoldBackgroundColor));
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    _pages = [_listScreen, _parishScreen];

    _currentActions = _parish
        ? (_pages[1] as PageInterface).getActions(context)
        : (_pages[0] as PageInterface).getActions(context);

    _currentTitle = _parish ? "Misas" : "Cancionero";

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _currentTitle,
            style: TextStyle(fontSize: 24),
          ),
          actions: _currentActions,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        drawer: _drawer(),
        body: Container(
            color: Colors.black,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: _parish ? _pages[1] : _pages[0])));
  }

  Widget _drawer() {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
color: Theme.of(context).primaryColorDark,
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
color: Theme.of(context).primaryColorDark,
              child: ListTile(
                title: Text(
                  "CSBook",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColorLight,
              height: 2,
            ),
            ListTile(
              leading: new Icon(
                FontAwesomeIcons.music,
              ),
              title: new Text(
                'Canciones',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _parish = false;
                });
              },
            ),
            ListTile(
              leading: new Icon(
                FontAwesomeIcons.church,
              ),
              title: new Text(
                'Parroquias',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _parish = true;
                });
              },
            ),
            ListTile(
              leading: new Icon(
                Icons.settings,
              ),
              title: new Text(
                'Ajustes',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            ),
            Expanded(
              child: Container(),
            ),

          ],
        ),
      ),
    );
  }

  void _onTabChanged(BuildContext context) {
    setState(() {
      //_currentTitle = _pages[_tabController.index].key.toString();
      _currentActions =
          (_pages[_tabController.index] as PageInterface).getActions(context);
    });
  }
}
