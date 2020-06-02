import 'package:flutter/material.dart';

class Scanner extends StatefulWidget {
  Scanner();
  @override
  ScannerState createState() => ScannerState();
}

class ScannerState extends State<Scanner> {
  ScannerState();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Scanner')
      ),
    );
  }
}