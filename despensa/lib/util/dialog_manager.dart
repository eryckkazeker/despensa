import 'package:flutter/material.dart';

class DialogManager {
  static Future<void> showGenericDialog(
      BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                child: Text('OK'))
          ],
        );
      },
    );
  }

  static Future<bool?> showConfirmationDialog(
      BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            Card.filled(
                color: Colors.red[900],
                child: IconButton(
                  onPressed: (() {
                    Navigator.pop(context, false);
                  }),
                  icon: Icon(Icons.cancel_rounded),
                )),
            Card.filled(
                color: Colors.green[900],
                child: IconButton(
                  onPressed: (() {
                    Navigator.pop(context, true);
                  }),
                  icon: Icon(Icons.check_circle),
                )),
          ],
        );
      },
    );
  }
}
