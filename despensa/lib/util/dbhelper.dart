import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:despensa/models/ean_product.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  String tblEAN = "ean";
  String colBarcode = "barcode";
  String colDescription = "description";

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
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $tblEAN($colBarcode TEXT PRIMARY KEY, $colDescription TEXT)"
    );
  }

  Future<int> insertEanProduct(EanProduct eanProduct) async {
    Database db = await this.db;
    var result = await db.insert(tblEAN, eanProduct.toMap());
    return result;
  }

  Future<EanProduct> getEanProductByBarcode(String barcode) async {
    Database db = await this.db;
    EanProduct product;

    List<String> columnsToSelect = [colBarcode, colDescription];
    String whereString = "$colBarcode = ?";
    List<dynamic> args = [barcode];

    var result = await db.query(
      tblEAN,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: args);
    
    result.forEach((row) => product = EanProduct.fromObject(row));

    return product;
  }
}