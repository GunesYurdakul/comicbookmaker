import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "comicsy_db.db";
  static final _databaseVersion = 1;

  static final comicbooks = 'comicbooks';
  static final pages = 'pages';
  static final images = 'images';

  static final stickers = 'stickers';
  static final speechBubbles = 'speechBubbles';
  static final texts = 'texts';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database comicbooks
  Future _onCreate(Database db, int version) async {
    print('DB CREATE');
    await db.execute('''
          CREATE TABLE $comicbooks (
            comicbookId INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            pages BLOB NOT NULL,
            coverPath TEXT,
          )''');
    await db.execute('''
          CREATE TABLE $pages (
            pageId INTEGER PRIMARY KEY,
            stickersList BLOB NOT NULL,
            speechBubblesList BLOB NOT NULL,
          )''');
    await db.execute('''
          CREATE TABLE $images (
            imgId INTEGER PRIMARY KEY,
            path TEXT NOT NULL,
            type INTEGER NOT NULL
          )''');
    await db.execute('''
          CREATE TABLE $texts (
            textId INTEGER PRIMARY KEY,
            text TEXT NOT NULL,
            font TEXT NOT NULL,
            size REAL NOT NULL
          )''');
    await db.execute('''
          CREATE TABLE $stickers (
            stickerId INTEGER PRIMARY KEY,
            imgId INTEGER NOT NULL,
            position REAL NOT NULL,
            rotation REAL NOT NULL,
            size REAL NOT NULL
          )''');
    await db.execute('''
          CREATE TABLE $speechBubbles (
            speechBubbleId INTEGER PRIMARY KEY,
            imgId INTEGER NOT NULL,
            position REAL NOT NULL,
            rotation REAL NOT NULL,
            size REAL NOT NULL,
            textId INTEGER NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertBook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(comicbooks, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(comicbooks);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $comicbooks'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateBook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['comicbookId'];
    return await db.update(comicbooks, row, where: 'comicbookId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteBook(int id) async {
    Database db = await instance.database;
    return await db.delete(comicbooks, where: 'comicbookId = ?', whereArgs: [id]);
  }
}
 