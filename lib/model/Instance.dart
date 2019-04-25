import 'dart:convert';

import 'package:csbruno_app/Api.dart';
import 'package:csbruno_app/model/Song.dart';

class Instance {
  final int id;
  final String songText;
  final String capo;
  final String rithm;
  final String choir;
  final String tone;
  
  Song song;

  Instance(this.id, this.songText, this.capo, this.rithm, this.choir, this.tone);

  factory Instance.fromJson(Map<String, dynamic> json) {
    return new Instance(
      json['id'],
      json['songText'],
      json['capo'],
      json['rithm'],
      json['choir'],
      json['tone']
      );
  }

  static Future<Instance> get(int instance_id) async {
    var response =
        await Api.get('api/v1/instance/45');

    final responseJson = json.decode(response.body);
    return new Instance.fromJson(responseJson['instance']);
  }

  void setSong(Song song){
    this.song = song;
  }
}