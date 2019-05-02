import 'package:csbook_app/model/Chord.dart';
import 'package:flutter/material.dart';

class SongText extends StatelessWidget {
  SongText(this.songText);
  final String songText;

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

  //Primero simplemente ASCII;
  void processLine(List<Widget> widgets, String line, bool chorus) {
    //Tenemos troceada la cadena sin notas...
    List<String> parts = line.split(Chord.chordRegex);
    //... y las notas
    List<Match> matches = Chord.chordRegex.allMatches(line).toList();
    //matches.forEach((m) => print(m.group(1)));

    String chordLine = "";
    for(var i = 0; i< matches.length; i++){
      String currentChord = matches[i].group(1);
      chordLine += currentChord;
      for(var k = 0; k < (parts[i+1].length - currentChord.length); k++){
        chordLine+=" ";
      }
    }


    if (chorus) {
      //ChordLine
      widgets.add(new Text(
        chordLine,
        style: TextStyle(fontWeight: FontWeight.bold,),
      ));

      //Line
      widgets.add(new Text(
        parts.join(""),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    } else {
      //ChordLine
      widgets.add(new Text(chordLine));

      //Line
      widgets.add(new Text(parts.join("")));
    }
  }
}
