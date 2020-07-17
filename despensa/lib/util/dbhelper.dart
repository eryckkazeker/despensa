import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:despensa/models/ean_info.dart';
import 'package:despensa/models/product.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  String tblEAN = "ean";
  String colBarcode = "barcode";
  String colDescription = "description";
  String colExpirationDays = "expiration_days";

  String tblProduct = "products";
  String colId = "product_id";
  String colProductBarcode = "barcode";
  String colExpiration = "expiration_date";
  String colIsOpen = "is_open";

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
      version: 3,
      onCreate: _createDb,
      onUpgrade: _onUpgrade
    );
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $tblEAN($colBarcode TEXT PRIMARY KEY, $colDescription TEXT, $colExpirationDays INTEGER)");
    await db.execute("CREATE TABLE $tblProduct($colId INTEGER PRIMARY KEY, $colProductBarcode TEXT, $colExpiration INTEGER, $colIsOpen NUMERIC)");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch(oldVersion) {
      case 1:
        await db.execute("ALTER TABLE $tblEAN add $colExpirationDays INTEGER;");
        continue v2;
      v2:
      case 2:
        await db.execute('''CREATE TABLE $tblProduct($colId INTEGER PRIMARY KEY, 
          "$colProductBarcode TEXT, $colExpiration INTEGER, $colIsOpen NUMERIC)''');
    }

  }

  Future<int> insertEanProduct(EanInfo eanProduct) async {
    Database db = await this.db;
    var result = await db.insert(tblEAN, eanProduct.toMap());
    return result;
  }

  Future<EanInfo> getEanProductByBarcode(String barcode) async {
    Database db = await this.db;
    EanInfo product;

    List<String> columnsToSelect = [colBarcode, colDescription, colExpirationDays];
    String whereString = "$colBarcode = ?";
    List<dynamic> args = [barcode];

    var result = await db.query(
      tblEAN,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: args);
    
    result.forEach((row) => product = EanInfo.fromObject(row));

    return product;
  }

  Future<int> insertProduct(Product product) async {
    Database db = await this.db;
    var result = await db.insert(tblProduct, product.toMap());
    return result;
  }

  Future<int> openProduct(Product product) async {
    Database db = await this.db;

    var eanProduct = await getEanProductByBarcode(product.eanInfo.barcode);

    product.expirationDate = DateTime.now().add(Duration(days: eanProduct.expirationDays));
    
    var result = await db.update(
      tblProduct,
      product.toMap(),
      where: "$colId = ?",
      whereArgs: [product.id]
    );

    return result;
  }

  Future<List<EanInfo>> getOpenProductsByBarcode(String barcode) async {
    Database db = await this.db;
    List<EanInfo> products;

    List<String> columnsToSelect = [colId, colProductBarcode, colExpiration, colIsOpen];
    String whereString = "$colProductBarcode = ? and $colIsOpen = ?";
    List<dynamic> args = [barcode, 1];

    var result = await db.query(
      tblProduct,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: args
    );

    result.forEach((element) => products.add(EanInfo.fromObject(element)));

    return products;
  }

  Future<List<Product>> getClosedProductsByBarcode(String barcode) async {
    Database db = await this.db;
    List<Product> products = List();

    List<String> columnsToSelect = [colId, colProductBarcode, colExpiration, colIsOpen];
    String whereString = "$colProductBarcode = ? and $colIsOpen = ?";
    List<dynamic> args = [barcode, 0];

    var result = await db.query(
      tblProduct,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: args
    );

    result.forEach((element) => products.add(Product.fromObject(element)));

    return products;
  }
}