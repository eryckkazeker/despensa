import 'package:flutter/material.dart';

class DialogManager {
  static void showGenericDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: (() {
                Navigator.pop(context);
              }), 
              child: Text('OK'))
          ],
        );
      },
    );
  }
}