import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/widgets.dart';
import 'package:flutter/material.dart';

class SongScreen extends StatefulWidget {
  static const routeName = '/song_view';
  SongScreen({Key key, this.instance}) : super(key: key);
  final Instance instance;

  @override
  _SongScreenState createState() => _SongScreenState(instance);
}

class _SongScreenState extends State<SongScreen> {
  _SongScreenState(this.instance);
  final Instance instance;

  @override
  Widget build(BuildContext context) {
    final Instance instance = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(instance.song.title.toString()),
        ),
        body: SingleChildScrollView(
            child: SongText(instance.songText.toString())));
  }
}
