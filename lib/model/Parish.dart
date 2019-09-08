import 'package:csbook_app/Api.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/model/Song.dart';

class Parish {
  final int id;
  final String name;
  final List<String> timetable;
  final String address;
  final String logo;

Parish(
      this.id, this.name, this.timetable, this.address, this.logo);


factory Parish.fromJson(Map<String, dynamic> json) {
    return new Parish(json['id'], json['name'], json['timetable'],
        json['address'], json['logo']);
  }

  factory Parish.fromSimpleJson(Map<String, dynamic> json) {
    return new Parish(json['id'], json['name'],null, "", "");
  }
}
