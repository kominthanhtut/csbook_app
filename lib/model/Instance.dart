import 'dart:convert';

import 'package:csbook_app/Api.dart';
import 'package:csbook_app/model/Song.dart';

class Instance {
  final int id;
  final String songText;
  final String capo;
  final String rithm;
  final String choir;
  final String tone;

  Song song;

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
}
