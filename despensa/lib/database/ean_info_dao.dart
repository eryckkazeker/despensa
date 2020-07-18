import 'package:sqflite/sqflite.dart';

import './dbhelper.dart';
import '../models/ean_info.dart';

class EanInfoDao {
  static const String createTable = "CREATE TABLE $tblEAN($colBarcode TEXT PRIMARY KEY, $colDescription TEXT, $colExpirationDays INTEGER)";

  static const String tblEAN = "ean";
  static const String colBarcode = "barcode";
  static const String colDescription = "description";
  static const String colExpirationDays = "expiration_days";

  final DbHelper helper = DbHelper();

  Future<int> insertEanInfo(EanInfo eanInfo) async {
    Database db = await helper.initializeDb();
    var result = await db.insert(tblEAN, eanInfo.toMap());
    return result;
  }

  Future<EanInfo> getEanInfoByBarcode(String barcode) async {
    Database db = await helper.initializeDb();
    EanInfo info;

    List<String> columnsToSelect = [colBarcode, colDescription, colExpirationDays];
    String whereString = "$colBarcode = ?";
    List<dynamic> args = [barcode];

    var result = await db.query(
      tblEAN,
      columns: columnsToSelect,
      where: whereString,
      whereArgs: args);
    
    result.forEach((row) => info = EanInfo.fromObject(row));

    return info;
  }
}