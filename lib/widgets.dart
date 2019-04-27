import 'package:flutter/material.dart';

class SongText extends StatelessWidget {
  SongText(this.songText);
  final String songText;

  final chordRegex = RegExp(r'\[(.*?)\]');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: new Column(
        children: createWidgetList(songText),
      ),
    );
  }

  List<Widget> createWidgetList(String songText, {transpose: 0}) {
    List<String> parts = process(songText);
    List<Widget> widgets = new List<Widget>();

    parts.forEach((e) {
      if(e.contains("{start_of_chorus}")){
        e = e.replaceAll("{start_of_chorus}", "");
        e = e.replaceAll("{end_of_chorus}", "");
        widgets.add(new Text(e, style: TextStyle(fontWeight: FontWeight.bold),));
      }else 
        widgets.add(new Text(e));
    });

    return widgets;
  }

  List<String> process(String songText, {transpose: 0}) {
    //Remove or modify Chords
    songText = songText.replaceAll(chordRegex, "");

    List<String> parts = songText.split("\r\n\r\n");
    return parts;
    //return parts[0];
  }
}
