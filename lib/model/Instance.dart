import 'dart:convert';
import 'dart:core';

import 'package:csbook_app/Api.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/model/Song.dart';

class Instance {
  final int id;
  final String songText;
  final String capo;
  final String rithm;
  final String choir;
  final String tone;

  Song song;

  final chordRegex = RegExp(r'\[(.*?)\]');

  Instance(
      this.id, this.songText, this.capo, this.rithm, this.choir, this.tone);

  factory Instance.fromJson(Map<String, dynamic> json) {
    return new Instance(json['id'], json['songText'], json['capo'],
        json['rithm'], json['choir'], json['tone']);
  }

  static Future<List<Instance>> get(Song song) async {
    var response = await Api.get('api/v1/song/' + song.id.toString());

    final responseJson = json.decode(response.body);
    Instance current;
    final items = (responseJson['instances'] as List).map((i) {
      current = new Instance.fromJson(i);
      current.setSong(song);
      return current;
    });

    return items.toList();
  }

  void setSong(Song song) {
    this.song = song;
  }

  String removeChords() {
    return songText.replaceAll(chordRegex, "");
  }

  String getTone(List<String> chordset) {
    return Chord(tone).paint(chordset);
  }

  String transpose(int semiTone) {
    return songText.replaceAllMapped(Chord.chordRegex, (match) {
      return "[" +
          Chord(match.group(1))
              .transpose(semiTone)
              .paint(Chord.CHORD_SET_SPANISH) +
          "]";
    });
  }

  static Future<Map<String, Instance>> getForMass(Mass mass) async {
    Map<String, Instance> _songs = new Map<String, Instance>();
    for (String key in mass.songs.keys) {
      var response = await Api.get('api/v1/song/' + mass.songs[key].toString());
      final responseJson = json.decode(response.body);
      Instance current = Instance.fromJson((responseJson['instances'] as List)[0]);
      current.song = Song.fromJson(responseJson['song']);
      _songs.putIfAbsent(
          key, () => current);
    }
    ;

    return _songs;
  }
}
