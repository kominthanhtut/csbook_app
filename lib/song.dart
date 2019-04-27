import 'package:csbruno_app/model/Instance.dart';
import 'package:csbruno_app/model/Song.dart';
import 'package:flutter/material.dart';

class SongScreen extends StatefulWidget {
  static const routeName = '/song_view';
  SongScreen({Key key,  this.instance}) : super(key: key);
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
        body: Text(instance.songText.toString()));
  }
}
