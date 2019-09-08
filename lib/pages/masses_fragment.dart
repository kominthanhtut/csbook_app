import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/pages/PageInterface.dart';
import 'package:flutter/material.dart';

import 'package:sticky_headers/sticky_headers.dart';

import '../model/Mass.dart';

class MassesScreen extends StatefulWidget implements PageInterface {
  @override
  _MassesScreenState createState() => _MassesScreenState();

  @override
  List<Widget> getActions(BuildContext context) {
    // TODO: implement getActions
    return [];
  }
}

class _MassesScreenState extends State<MassesScreen> {
  List<Mass> _masses;
  List<Mass> _filteredMases;

initState() {
    Mass.get(0, 0).then((masses) {
      setState(() {
        _masses = masses;
        _filteredMases = masses;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.MASS_TITLE),
        actions: getActions(context),
      ),
      body: new ListView.builder(itemBuilder: (context, index) {
      return new StickyHeader(
        header: new Container(
          height: 50.0,
          color: Theme.of(context).primaryColorLight,
          padding: new EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: new Text('Header #$index',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: new Container(
          child: Padding(
            padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text("test $index"),
          ),
        ),
      );
    }),
    );
  }

  List<Widget> getActions(BuildContext context) {
    return [];
  }
}
