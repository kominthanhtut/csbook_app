import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final void Function(Song) onTap;
  SongTile(this.song, {this.onTap});

  @override
  Widget build(BuildContext context) {
    if (song.hasAuthor()) {
      return new ListTile(
        title: new Text(song.getTitle()),
        subtitle: new Text(song.getAuthor()),
        onTap: () {
          if (onTap != null) onTap(song);
        },
      );
    } else {
      return new ListTile(
        title: new Text(song.getTitle()),
        onTap: () {
          if (onTap != null) onTap(song);
        },
      );
    }
  }
}

class FetchingWidget extends StatelessWidget {
  final text;

  FetchingWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.download,
            size: 128,
            color: Colors.grey,
          ),
          Container(
            height: 32,
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          )
        ]);
  }
}
