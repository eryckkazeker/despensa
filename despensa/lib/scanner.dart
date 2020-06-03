import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class Scanner extends StatefulWidget {
  Scanner();
  @override
  ScannerState createState() => ScannerState();
}

class ScannerState extends State<Scanner> {
  var _scannedCode = '';
  bool _scanned = false;
  ScannerState();

  @override
  Widget build(BuildContext context) {
    
    if(!this._scanned) {
      barcodeScan();
    }

    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Scanner'),
            Text(_scannedCode)
          ],
        )
      ),
    );
  }

  Future barcodeScan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() {
        this._scannedCode = barcode.rawContent;
        this._scanned = true;
      });
    } on PlatformException catch(e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() => this._scannedCode = 'No camera Permission');
      }
      else {
        setState(() => this._scannedCode = 'Unknown error $e');
      }
    } on FormatException {
      setState(() => this._scannedCode = 'Nothing scanned');
    } catch(e) {
      setState(() => this._scannedCode = 'Unknown error $e');
    }
  }
}