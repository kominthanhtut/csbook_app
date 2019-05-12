import 'dart:async';

import 'package:csbook_app/model/Song.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class SongDatabase {
  static final String DATABASE_NAME = "songsdb.db";
  static final SongDatabase _instance = SongDatabase._();
  static Database _database;

  SongDatabase._();

  factory SongDatabase() {
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
    CREATE TABLE Songs(
      id INTEGER PRIMARY KEY,
      title TEXT,
      subtitle TEXT,
      author TEXT,
      type TEXT,
      time TEXT,
      youtubeId TEXT,
      cached INTEGER)
  ''');
    print("Song Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<int> addSong(Song car) async {
    var client = await db;
    return client.insert('Songs', car.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Song> fetchSong(int id) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('Songs', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;

    if (maps.length != 0) {
      return Song.fromDb(maps.first);
    }

    return null;
  }

  Future<int> updateSong(Song newCar) async {
    var client = await db;
    return client.update('Songs', newCar.toMapForDb(),
        where: 'id = ?',
        whereArgs: [newCar.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeSong(int id) async {
    var client = await db;
    return client.delete('Songs', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Song>> fetchAll() async{
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('Songs');
    var maps = await futureMaps;

    final items = maps.map((i) => new Song.fromJson(i));

    return items.toList();
  }

  Future<int> saveOrUpdateSong(Song song) async{
    int updateResult = await updateSong(song);
    return (updateResult > 0)? updateResult : await addSong(song);
  }

  Future<int> saveOrUpdateAll(List<Song> songs) async{
    int retVal = 0;
    for(Song s in songs){
      retVal += await saveOrUpdateSong(s);
    }
    return retVal;
  }
}
