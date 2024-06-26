import 'package:despensa/database/notification_dao.dart';
import 'package:despensa/database/product_dao.dart';
import 'package:despensa/services/notification_service.dart';
import 'package:despensa/services/product_service.dart';
import 'package:despensa/view/new_main_menu.dart';
import 'package:flutter/material.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(DespensaApp());
} 

class DespensaApp extends StatelessWidget {
  final ThemeData themeData = ThemeData();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Despensa',
      theme: themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(
          primary: Colors.orangeAccent[100], 
          secondary: Colors.brown[600]
        )
      ),
      home: NewMainMenu (ProductService(ProductDao(), NotificationDao())),
    );
  }
}