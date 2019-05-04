import 'package:csbook_app/pages/PageInterface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class ParishScreen extends StatefulWidget implements PageInterface {
  @override
  _ParishScreenState createState() => _ParishScreenState();

  @override
  List<Widget> getActions(BuildContext context) {
    // TODO: implement getActions
    return [];
  }
}

class _ParishScreenState extends State<ParishScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(children: [
        Calendar(isExpandable: true),
        
        ]),
    );
  }
}
