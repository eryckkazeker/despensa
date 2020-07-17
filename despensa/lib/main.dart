import 'package:flutter/material.dart';

import './screens/main_menu.dart';

void main() => runApp(DespensaApp());

class DespensaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Despensa',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent[100],
        accentColor: Colors.brown[600]
      ),
      home: MainMenu(),
    );
  }
}

