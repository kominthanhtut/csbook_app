import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Model/Song.dart';
import 'package:csbook_app/Pages/listFragment.dart';
import 'package:csbook_app/Pages/parishFragment.dart';
import 'package:csbook_app/Pages/settingsScreen.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        drawer: _drawer(false),
        endDrawer: _drawer(true),
        body: RoundedBlackContainer(
          child: _parish ? _pages[1] : _pages[0],
          bottomOnly: true,
          radius: Constants.APP_RADIUS,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ));
  }

  Widget _drawer(bool end) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              end ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            end
                ? Expanded(
                    child: Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).backgroundColor,
                    ),
                  )
                : Container(),
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).backgroundColor,
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).backgroundColor,
              child: ListTile(
                title: Text(
                  "CSBook",
                  style:
                      Theme.of(context).textTheme.title.copyWith(fontSize: 32),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColorLight,
              height: 2,
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.music,
              ),
              title: new Text(
                'Canciones',
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
                FontAwesomeIcons.bible,
              ),
              title: new Text(
                'Misas',
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
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            end
                ? Container(
                    height: 64,
                  )
                : Expanded(
                    child: Container(),
                  ),
            Padding(
              child: Opacity(
                  opacity: 0.4,
                  child: Text(
                    "hkfuertes",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )),
              padding: EdgeInsets.all(16),
            )
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
