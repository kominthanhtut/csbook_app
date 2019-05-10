import 'dart:convert';

import 'package:csbook_app/Api.dart';

class Song {
  final int id;
  final String title;
  final String subtitle;
  final String author;
  final String type;
  final String time;
  final String youtubeId;

  Song(this.id, this.title, this.subtitle, this.author, this.type, this.time,
      this.youtubeId);

  factory Song.fromJson(Map<String, dynamic> json) {
    return new Song(json['id'], json['title'], json['subtitle'], json['author'],
        json['type'], json['time'], json['youtubeId']);
  }

  static Future<List<Song>> get(int skip, int take) async {
    var response = await Api.get('api/v1/songs');

    final responseJson = json.decode(response.body);
    final items = (responseJson as List).map((i) => new Song.fromJson(i));

    return items.toList();
  }

  String getTitle() {
    return title;
  }

  String getSubTitle() {
    return subtitle;
  }

  String getAuthor() {
    return hasAuthor() ? author : "";
  }

  bool hasAuthor() {
    return author != null;
  }

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['subtitle'] = this.subtitle;
    map['author'] = this.author;
    map['type'] = this.type;
    map['time'] = this.time;
    map['youtubeId'] = this.youtubeId;
    return map;
  }
  factory Song.fromDb(Map<String, dynamic> json) {
    return new Song.fromJson(json);
  }

}
