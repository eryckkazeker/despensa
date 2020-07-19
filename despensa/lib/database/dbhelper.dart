import 'package:despensa/database/ean_info_dao.dart';
import 'package:despensa/database/product_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }

    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "despensa.db";
    var dbTodos = await openDatabase(path,
      version: 1,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
      onDowngrade: onDatabaseDowngradeDelete
    );
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(EanInfoDao.createTable);
    await db.execute(ProductDao.createTable);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  

  
}