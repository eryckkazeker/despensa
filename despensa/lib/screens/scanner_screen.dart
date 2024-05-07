import 'dart:convert';

import 'package:despensa/database/ean_info_dao.dart';
import 'package:despensa/database/notification_dao.dart';
import 'package:despensa/database/product_dao.dart';
import 'package:despensa/models/product.dart';
import 'package:despensa/models/scan_mode.dart';
import 'package:despensa/screens/product_list_screen.dart';
import 'package:despensa/util/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/ean_info.dart';
import '../screens/ean_product_screen.dart';
import '../screens/product_entry_screen.dart';
import '../util/dialog_manager.dart';
import '../util/formatter.dart';

class Scanner extends StatefulWidget {
  final ScanMode scanMode;

  Scanner(this.scanMode);

  @override
  ScannerState createState() => ScannerState(scanMode);
}

class ScannerState extends State<Scanner> {

  ScanMode scanMode;
  EanInfoDao _eanInfoDao = EanInfoDao();
  ProductDao _productDao = ProductDao();
  NotificationDao _notificationDao = NotificationDao();

  final MobileScannerController controller = MobileScannerController();

  bool _isScanned = false;

  var _scannedCode = '';
  ScannerState(this.scanMode);

  @override
  void initState() {
    super.initState();
    controller.start();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leia o código de barras'),
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              MobileScanner(
                controller: controller,
                errorBuilder: (
                  BuildContext context,
                  MobileScannerException error,
                  Widget? child,
                ) {
                  return ScannerErrorWidget(error: error);
                },
                fit: BoxFit.contain,
                onDetect: (BarcodeCapture barcode) {
                  if (!_isScanned) {
                    barcodeScan(barcode.barcodes.first.displayValue!);
                    _isScanned = true;
                  }
                  
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  Future barcodeScan(String code) async {
    
    try {
      setState(() {
        this._scannedCode = code;
      });

      switch(this.scanMode) {
        case ScanMode.insertProduct:
          insertProduct(this._scannedCode);
        break;
        case ScanMode.openProduct:
          openProduct(this._scannedCode);
        break;
        case ScanMode.discardProduct:
          discardProduct(this._scannedCode);
          break;
        default:
      }

    } on PlatformException catch(e) {
      setState(() => this._scannedCode = 'Unknown error $e');
    } on FormatException {
      setState(() => this._scannedCode = 'Nothing scanned');
    } catch(e) {
      setState(() => this._scannedCode = 'Unknown error $e');
    }
  }

  Future<void> openProduct(String barcode) async {
    var result = -1;
    var products = await _productDao.getClosedProductsByBarcode(barcode);
    
    if(products.length == 0)
    {
      await DialogManager.showGenericDialog(context,'Atenção', 'Produto não cadastrado');
      Navigator.pop(context);
      return;
    }

    Product? selectedProduct = products[0];

    if(products.length > 1)
    {
      selectedProduct  = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsListScreen(products)));
      if (selectedProduct == null) {
        Navigator.pop(context);
        return;
      }
    }

    result = await _productDao.openProduct(selectedProduct);

    if(result < 0)  {
      DialogManager.showGenericDialog(context, 'Erro', 'Erro ao abrir produto. Tente novamente');
      return;
    }

    await DialogManager.showGenericDialog(context, 'Sucesso', '''Produto aberto ${selectedProduct.eanInfo!.description}
    \nConsumir até ${formatDateTime(selectedProduct.expirationDate)}''');

    Navigator.pop(context);
  }

  void insertProduct(String barcode) async {
    var info = await _eanInfoDao.getEanInfoByBarcode(barcode);

    if(info == null) {
        productNotFoundDialog(context);
      }
      else {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEntryScreen(info)));
      }
  }

  void discardProduct(String barcode) async {
    var productList = await _productDao.getOpenProductsByBarcode(barcode);

    if(productList.isEmpty) {
      await DialogManager.showGenericDialog(context, 'Erro', 'Esse produto não está aberto ou não foi cadastrado');
      Navigator.pop(context);
      return;
    }

    // For now, we'll discard the first item found
    var notifications = await _notificationDao.getNotificationsForProduct(productList[0]);

    notifications.forEach((notification) async {
      await NotificationHelper().removeScheduledNotification(notification.id);
      await _notificationDao.deleteNotification(notification);
    });
    var result = await _productDao.deleteProduct(productList[0]);

    if(result < 0) {
      DialogManager.showGenericDialog(context, 'Erro', 'Erro ao descartar produto');
      Navigator.pop(context);
      return;
    }

    await DialogManager.showGenericDialog(context, 'Sucesso', 'Produto descartado!');
    Navigator.pop(context);
  }


  void searchOnline() async {
    var product = await getProductOnline();
    if(product == null) {
      _insertProductData();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EanProductScreen(product)));
    }
  }

  Future<EanInfo?> getProductOnline() async {
    try {
      Uri uri = Uri(scheme: 'https',
                    host: 'api.cosmos.bluesoft.com.br',
                    path: 'gtins/$_scannedCode');

      //TODO: fetch token from secret
      final response = await http.get(uri,headers:{'X-Cosmos-Token':'VXz2Sj1q8VgkOaxEFksc_w'});
      if(response.statusCode == 200) {
        return EanInfo.fromJSON(jsonDecode(response.body));
      }
      else {
        return null;
      }
    } catch (e) {
      await DialogManager.showGenericDialog(context, 'Erro', '''Erro ao buscar dados online.
      \nInsira os dados manualmente''');
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
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  _goBack,
    );
    Widget searchProductButton = TextButton(
      child: Text("Buscar Online"),
      onPressed:  searchOnline,
    );
    Widget insertProductButton = TextButton(
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

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}