import 'package:flutter/material.dart';

class DialogManager {
  static Future<void> showGenericDialog(BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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