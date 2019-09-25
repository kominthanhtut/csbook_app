import 'dart:convert';

import 'package:csbook_app/Api.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/model/Parish.dart';

import 'Instance.dart';

class Mass {
  final String id;
  final DateTime date;
  final String name;
  final String type;
  final Parish parish;
  Map<String, MassSong> songs;

  bool retrieved = false;
  bool recovered = false;

  CSDB _db = CSDB();

  Mass(this.id, this.date, this.name, this.type, this.parish, this.songs);

  factory Mass.fromJson(Map<String, dynamic> json) {
    return new Mass(json['id'], DateTime.parse(json['date']), json['name'],
        json['type'], Parish.fromSimpleJson(json['parish']),
        //Map<String,int>.from(json['songs'])
        {});
  }

  static Future<List<Mass>> get(int skip, int take) async {
    var response = await Api.get('api/v1/masses');

    final responseJson = json.decode(response.body);
    final items = (responseJson as List).map((i) => new Mass.fromJson(i));

    return items.toList();
  }

  bool hasName() {
    return name != null;
  }

  bool songsRecovered() {
    return recovered;
  }

  bool instancesRecovered() {
    return retrieved;
  }

  Future<Mass> retrieveAllData() async {
    var response = await Api.get('api/v1/mass/' + id);
    final responseJson = json.decode(response.body);

    this.songs = (responseJson['songs'] as Map).map((key, value) =>
        new MapEntry<String, MassSong>(key, MassSong.fromJson(value)));

    this.recovered = true;
    return this;
  }

  Future<Mass> retrieveAllInstances() async{
    if(!this.songsRecovered()) await this.retrieveAllData();

    for(MassSong ms in this.songs.values){
      Instance instance = await _db.fetchInstance(ms.instanceId);
      //If not found local, then check internet.
      if (instance == null) {
        instance = await Instance.get(ms.instanceId);
        await _db.saveOrUpdateInstance(instance);
      }
      ms.setInstance(instance);
    }
    this.retrieved = true;
    return this;
  }

}

class MassSong {
  final int instanceId;
  final String tone;
  final int capo;

  Instance instance;

  MassSong(this.instanceId, this.tone, this.capo);

  void setInstance(Instance instance){this.instance = instance;}
  Instance getInstance(){return this.instance;}

  factory MassSong.fromJson(Map<String, dynamic> json) {
    return new MassSong(json['instanceId'], json['tone'], json['capo']);
  }
}
