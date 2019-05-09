import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/pages/PageInterface.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.MASS_TITLE),
        actions: getActions(context),
      ),
      body: Container(),
    );
  }

  List<Widget> getActions(BuildContext context) {
    return [];
  }
}