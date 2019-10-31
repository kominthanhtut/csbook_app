
import 'package:csbook_app/Model/Mass.dart';
import 'package:csbook_app/tablet_pages/TabletMassScreen.dart';
import 'package:flutter/material.dart';

class MassScreen extends StatelessWidget {
  final Mass mass;
  MassScreen(this.mass);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) => TabletMassScreen(mass),);
  }
  
}
