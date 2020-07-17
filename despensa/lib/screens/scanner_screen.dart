import 'dart:convert';

import 'package:despensa/models/ean_info.dart';
import 'package:despensa/models/product.dart';
import 'package:despensa/models/scan_mode.dart';
import 'package:despensa/screens/ean_product_screen.dart';
import 'package:despensa/screens/product_entry_screen.dart';
import 'package:despensa/util/dbhelper.dart';
import 'package:despensa/util/dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
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
        case ScanMode.insertProduct:
          insertProduct(this._scannedCode);
        break;
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

  Future<EanInfo> getEanProduct(String barcode) async {
    
    final eanProduct = await helper.getEanProductByBarcode(barcode);

    return eanProduct;
  }

  Future<void> openProduct(String barcode) async {
    var products = await helper.getClosedProductsByBarcode(barcode);

    if(products.length > 1)
    {
      //TODO:Show list for user to select from
      return;
    }

    if(products.length == 0)
    {
      DialogManager.showGenericDialog(context, 'Produto nao encontrado');
      return;
    }

    var result = await helper.openProduct(products[0]);

    if(result < 0)  {
      DialogManager.showGenericDialog(context, 'Erro ao abrir produto. Tente novamente');
      return;
    }
    
  }

  void insertProduct(String barcode) {
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

  void searchOnline() async {
    var product = await getProductOnline();
    if(product == null) {
      _insertProductData();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EanProductScreen(product)));
    }
  }

  Future<EanInfo> getProductOnline() async {
    final response = await http.get('https://api.cosmos.bluesoft.com.br/gtins/$_scannedCode',
      headers:{'X-Cosmos-Token':'lSoJVyRyMPZNJ6szebz3sw'});
    if(response.statusCode == 200) {
      return EanInfo.fromJSON(jsonDecode(response.body));
    }
    else {
      return null;
    }
}

  void _goBack() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _insertProductData() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => EanProductScreen(EanInfo(this._scannedCode, "", 0))));
  }

  void productNotFoundDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed:  _goBack,
    );
    Widget searchProductButton = FlatButton(
      child: Text("Buscar Online"),
      onPressed:  searchOnline,
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