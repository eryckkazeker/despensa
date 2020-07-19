import 'package:sqflite/sqflite.dart';

import './dbhelper.dart';
import './ean_info_dao.dart';
import '../models/product.dart';
import '../models/ean_info.dart';

class ProductDao {

  static const String createTable = "CREATE TABLE $tblProduct($colId INTEGER PRIMARY KEY, $colProductBarcode TEXT, $colExpiration INTEGER, $colIsOpen NUMERIC)";

  static const String tblProduct = "products";
  static const String colId = "product_id";
  static const String colProductBarcode = "barcode";
  static const String colExpiration = "expiration_date";
  static const String colIsOpen = "is_open";

  DbHelper helper = DbHelper();
  EanInfoDao _infoDao = EanInfoDao();

  Future<int> insertProduct(Product product) async {
    Database db = await helper.initializeDb();
    var result = await db.insert(tblProduct, product.toMap());
    return result;
  }

  Future<int> openProduct(Product product) async {
    Database db = await helper.initializeDb();

    var eanProduct = await _infoDao.getEanInfoByBarcode(product.eanInfo.barcode);

    product.expirationDate = DateTime.now().add(Duration(days: eanProduct.expirationDays));
    product.isOpen = true;
    
    var result = await db.update(
      tblProduct,
      product.toMap(),
      where: "$colId = ?",
      whereArgs: [product.id]
    );

    return result;
  }

  Future<List<EanInfo>> getOpenProductsByBarcode(String barcode) async {
    Database db = await helper.initializeDb();
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
    Database db = await helper.initializeDb();
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

    for(var element in result) {
      var product = Product.fromObject(element);
      var info = await _infoDao.getEanInfoByBarcode(element["barcode"]);
      product.eanInfo = info;
      products.add(product);
    }

    return products;
  }
}