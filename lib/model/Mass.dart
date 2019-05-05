import 'dart:convert';

import 'package:csbook_app/Api.dart';

class Mass {
  final int id;
  final DateTime date;
  final String name;
  final String type;
  final String parish;
  final Map<String,int> songs;


  Mass(this.id, this.date, this.name, this.type, this.parish, this.songs);

  factory Mass.fromJson(Map<String, dynamic> json) {
    return new Mass(
      json['id'],
      DateTime.parse(json['date']),
      json['name'],
      json['type'],
      json['parish'],
      Map<String,int>.from(json['songs']),
      );
  }

  static Future<List<Mass>> get(int skip, int take) async {
    var response =
        await Api.get('api/v1/masses');

    final responseJson = json.decode(response.body);
    final items = (responseJson as List).map((i) => new Mass.fromJson(i));

    return items.toList();
  }

  bool hasName(){
    return name != null;
  }

}