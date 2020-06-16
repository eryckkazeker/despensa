import 'package:despensa/models/ean_product.dart';
import 'package:despensa/models/scan_mode.dart';
import 'package:despensa/screens/ean_product_screen.dart';
import 'package:despensa/screens/product_entry_screen.dart';
import 'package:despensa/util/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class Scanner extends StatefulWidget {
  final ScanMode scanMode;

  Scanner(this.scanMode);

  @override
  ScannerState createState() => ScannerState(scanMode);
}

class ScannerState extends State<Scanner> {

  ScanMode scanMode;
  DbHelper helper = DbHelper();

  var _scannedCode = '';
  bool _scanned = false;
  ScannerState(this.scanMode);

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

      switch(this.scanMode) {
        case ScanMode.openProduct:
          openProduct(this._scannedCode);
        break;
        default:
      }

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

  Future<EanProduct> getEanProduct(String barcode) async {
    await helper.initializeDb();
    
    final eanProduct = await helper.getEanProductByBarcode(barcode);

    return eanProduct;
  }

  void openProduct(String barcode) {
    var eanProduct = getEanProduct(barcode);

    eanProduct.then((product) {
      if(product == null) {
        productNotFoundDialog(context);
      }
      else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEntryScreen(product)));
      }
    });
  }

  void _goBack() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _insertProductData() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => EanProductScreen(EanProduct(this._scannedCode, "", 0))));
  }

  void productNotFoundDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed:  _goBack,
    );
    Widget searchProductButton = FlatButton(
      child: Text("Buscar Online"),
      onPressed:  () {},
    );
    Widget insertProductButton = FlatButton(
      child: Text("Inserir Dados"),
      onPressed:  _insertProductData,
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Produto não encontrado"),
      content: Text("Selecione uma opção"),
      actions: [
        searchProductButton,
        insertProductButton,
        cancelButton
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}