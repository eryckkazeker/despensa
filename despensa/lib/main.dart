import 'package:despensa/util/notification_helper.dart';
import 'package:flutter/material.dart';

import './screens/main_menu.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper().initNotification();
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
      home: MainMenu(),
    );
  }
}