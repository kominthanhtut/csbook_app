import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Model/Mass.dart';
import 'package:csbook_app/Model/Song.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final void Function(Song) onTap;
  SongTile(this.song, {this.onTap});

  @override
  Widget build(BuildContext context) {
    if (song.hasAuthor()) {
      return new ListTile(
        trailing: song.cached ? Icon(Icons.cached): null,
        title: new Text(song.getTitle()),
        subtitle: new Text(song.getAuthor()),
        onTap: () {
          if (onTap != null) onTap(song);
        },
      );
    } else {
      return new ListTile(
        trailing: song.cached ? Icon(Icons.cached): null,
        title: new Text(song.getTitle()),
        onTap: () {
          if (onTap != null) onTap(song);
        },
      );
    }
  }
}

class MassTile extends StatelessWidget {
  final Mass mass;
  final void Function(Mass) onTap;
  MassTile(this.mass, {this.onTap});

  final List<String> weekDays = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ];
  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');
  final DateFormat formatterDayOfWeek = new DateFormat('EEEE');

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
          mass.hasName() ? mass.name : weekDays[mass.date.weekday-1]),
      subtitle: new Text(formatterFullDate.format(mass.date)),
      onTap: () {
        if (onTap != null) onTap(mass);
      },
    );
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
            color: Theme.of(context).primaryColorLight,
          ),
          Container(
            height: 32,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Constants.FETCHING_TEXT + text + " ...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          )
        ]);
  }
}
