import 'dart:async';

import 'package:csbook_app/databases/SongDatabase.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class InstanceDatabase {
  static final String DATABASE_NAME = "instancesdb.db";
  static final InstanceDatabase _instance = InstanceDatabase._();
  static Database _database;

  InstanceDatabase._();

  factory InstanceDatabase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, DATABASE_NAME);
    var database = openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE Instances(
      id INTEGER PRIMARY KEY,
      songId INTEGER,
      songText TEXT,
      capo TEXT,
      rithm TEXT,
      choir TEXT,
      tone TEXT)
  ''');

    print("Instances Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<int> addInstance(Instance instance) async {
    var client = await db;
    return client.insert('Instances', instance.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Instance>> fetchInstancesForSong(int id) async {
    SongDatabase songdb = SongDatabase();
    Song song = await songdb.fetchSong(id);

    //No we get the instances
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('Instances', where: 'songId = ?', whereArgs: [id]);
    var maps = await futureMaps;

    final items = maps.map((i) => new Instance.fromDb(song,i));

    return items.toList();
  }

  Future<int> updateInstance(Instance instance) async {
    var client = await db;
    return client.update('Instances', instance.toMapForDb(),
        where: 'id = ?',
        whereArgs: [instance.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeInstance(int id) async {
    var client = await db;
    return client.delete('Instances', where: 'id = ?', whereArgs: [id]);
  }


  Future<int> saveOrUpdateInstance(Instance song) async{
    SongDatabase songdb = new SongDatabase();
    await songdb.updateSong(song.song.setCached());
    int updateResult = await updateInstance(song);
    return (updateResult > 0)? updateResult : await addInstance(song);
  }
}
