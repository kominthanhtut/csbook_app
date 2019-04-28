import 'package:flutter/material.dart';

class SongText extends StatelessWidget {
  SongText(this.songText);
  final String songText;

  final chordRegex = RegExp(r'\[(.*?)\]');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: createWidgetList(songText),
      ),
    );
  }

  List<Widget> createWidgetList(String songText, {transpose: 0}) {
    //songText = songText.replaceAll("\r\n\r\n", "\r\n");
    List<String> parts = songText.split("\r\n");
    List<Widget> widgets = new List<Widget>();

    bool chorus = false;

    parts.forEach((e) {
      if (e.contains("{start_of_chorus}")) {
        chorus = true;
        widgets.add(new Text(""));
      } else if (e.contains("{end_of_chorus}")) {
        chorus = false;
        widgets.add(new Text(""));
      } else {
        processLine(widgets, e, chorus);
      }
    });

    return widgets;
  }

  void processLine(List<Widget> widgets, String line, bool chorus) {
    if (chorus) {
      widgets.add(new Text(
        line,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    } else {
      widgets.add(new Text(line));
    }
  }
}
