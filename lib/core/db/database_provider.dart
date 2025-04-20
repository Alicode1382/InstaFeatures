import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

import '../utils/utils.dart';

class DatabaseProvider {
  static DatabaseProvider? _dbProviderInstance;

  DatabaseProvider._();

  static DatabaseProvider? getInstance() {
    _dbProviderInstance ??= DatabaseProvider._();
    return _dbProviderInstance;
  }

  static final DatabaseProvider _instance = DatabaseProvider.internal();
  final _lock = Lock();
  factory DatabaseProvider() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();

    return _db!;
  }

  DatabaseProvider.internal();

  initDb() async {
    String path = await initAppDb(
        "projectdb.db");
    await _lock.synchronized(() async {
      // Check again once entering the synchronized block
      _db ??= await openDatabase(path,
          version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    });

    return _db;
  }

  Future<String> initAppDb(String dbName) async {
    final String databasePath = await getDatabasesPath();
    // print(databasePath);
    final String path = join(databasePath, dbName);

    // make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        Utils.logWarning(e.toString());
      }
    }
    return path;
  }

  void _onCreate(Database db, int newVersion) async {
    var batch = db.batch();
    __createTable(batch);

    await batch.commit();
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();
    _mainUpdate(batch);
  }

  Future<void> _mainUpdate(Batch batch) async {
  
    await batch.commit();
  }

  void __createTable(Batch batch) {
    //create table LocalFile
    batch.execute(
        "CREATE TABLE LocalFile(sql_Lac_Id INTEGER PRIMARY KEY autoincrement,filedata BLOB,filename TEXT,fileDateTime DATETIME)");
    
  }
}
