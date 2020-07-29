import 'package:despensa/models/notification.dart';
import 'package:despensa/models/product.dart';
import 'package:sqflite/sqflite.dart';

import './dbhelper.dart';

class NotificationDao {

  static const String tblNotifications = 'notifications';
  static const String colId = 'id';
  static const String colProductId = 'product_id';

  static const String createTable = 'CREATE TABLE $tblNotifications($colId INTEGER PRIMARY KEY, $colProductId INTEGER)';

  DbHelper helper = DbHelper();

  Future<int> insertNotification(Notification notification) async {
    Database db = await helper.initializeDb();
    var result = await db.insert(tblNotifications, notification.toMap());
    return result;
  }


  Future<int> deleteNotification(Notification notification) async {
    var db = await helper.initializeDb();
    return db.delete(
      tblNotifications,
      where: '$colId = ?',
      whereArgs: [notification.id]);
  }

  Future<int> deleteNotificationsForProduct(Product product) async {
    var db = await helper.initializeDb();
    return db.delete(
      tblNotifications,
      where: '$colProductId = ?',
      whereArgs: [product.id]);
  }

  Future<List<Notification>> getNotificationsForProduct(Product product) async {
    List<Notification> notificationList = List();
    var db = await helper.initializeDb();
    var result = await db.query(
      tblNotifications,
      where: 'product_id = ?',
      whereArgs: [product.id]
    );

    result.forEach((element) {
      notificationList.add(Notification.fromObject(element));
    });

    return notificationList;
  }


}