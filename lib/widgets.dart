import 'package:csbook_app/model/Chord.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SongText extends StatelessWidget {
  SongText(this.songText, {this.textSize = 16});
  final String songText;
  final double textSize;

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

  List<Widget> createWidgetList(String songText) {
    List<String> paragraphs = songText.split("\r\n\r\n");
    List<String> parts;
    List<Widget> widgets = new List<Widget>();

    bool chorus = false;

    paragraphs.forEach((f) {
      parts = f.split("\r\n");
      parts.forEach((e) {
        if (e.contains("{start_of_chorus}")) {
          chorus = true;
        } else if (e.contains("{end_of_chorus}")) {
          chorus = false;
        } else {
          processLine(widgets, e, chorus);
        }
      });
      widgets.add(new Text("\r\n"));
    });

    return widgets;
  }

  //Primero simplemente ASCII;
  void processLine(List<Widget> widgets, String line, bool chorus) {
    List<Widget> currentLine = List<Widget>();

    //Tenemos troceada la cadena sin notas...
    List<String> parts = line.split(Chord.chordRegex);
    //... y las notas
    List<Match> matches = Chord.chordRegex.allMatches(line).toList();

    //if (parts[0] == "") parts.removeAt(0);
    if (parts.length == 1) {
      widgets.add(Wrap(children: [
        Text(parts[0],
            style: TextStyle(
              fontSize: textSize,
              fontWeight: chorus ? FontWeight.bold : FontWeight.normal,
            ))
      ]));
    } else {
      for (var i = 0; i < parts.length; i++) {
        String currentChord;
        String currentPart;

        if (parts.length > matches.length) {
          currentChord = (i == 0) ? "" : matches[i - 1].group(1);
        } else {
          currentChord = matches[i].group(1);
        }

        currentPart = parts[i];
        currentLine.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(currentChord,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: textSize,
                  fontWeight: chorus ? FontWeight.bold : FontWeight.normal,
                )),
            Text(currentPart,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: chorus ? FontWeight.bold : FontWeight.normal,
                ))
          ],
        ));
      }

      widgets.add(Wrap(children: currentLine));
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