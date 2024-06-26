import 'dart:convert';

import 'package:despensa/database/ean_info_dao.dart';
import 'package:despensa/database/product_dao.dart';
import 'package:despensa/models/ean_info.dart';
import 'package:despensa/models/product.dart';
import 'package:despensa/models/scan_mode.dart';
import 'package:despensa/services/product_service.dart';
import 'package:despensa/util/dialog_manager.dart';
import 'package:despensa/view/ean_product_screen.dart';
import 'package:despensa/view/product_entry_screen.dart';
import 'package:despensa/view/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScannerScreenController {
  final EanInfoDao _eanInfoDao;
  final ProductDao _productDao;
  final ProductService _productService;
  Function? saveProductCallback;

  ScannerScreenController(this._eanInfoDao, this._productDao, this._productService, {this.saveProductCallback});

  Future<void> scanBarcode(String barcode, ScanMode scanMode, BuildContext context) {

      switch(scanMode) {
        case ScanMode.insertProduct:
          return insertProduct(barcode, context);
        case ScanMode.openProduct:
          return openProduct(barcode, context);
        case ScanMode.discardProduct:
          return discardProduct(barcode, context);
        default:
          return Future.error(Error());
      }

  }

  Future<void> insertProduct(String barcode, BuildContext context) async {
    var info = await _eanInfoDao.getEanInfoByBarcode(barcode);

    if(info == null) {
        productNotFoundDialog(barcode, context);
      }
      else {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEntryScreen(info, saveProductCallback: this.saveProductCallback)));
      }
  }

  void productNotFoundDialog(String barcode, BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () => _goBack(context),
    );
    Widget searchProductButton = TextButton(
      child: Text("Buscar Online"),
      onPressed:  () => searchOnline(barcode, context),
    );
    Widget insertProductButton = TextButton(
      child: Text("Inserir Dados"),
      onPressed:  () => _insertProductData(barcode, context),
    );
    AlertDialog alert = AlertDialog(
      title: Text("Produto não encontrado"),
      content: Text("Selecione uma opção"),
      actions: [
        searchProductButton,
        insertProductButton,
        cancelButton
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _goBack(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void searchOnline(String barcode, BuildContext context) async {
    var product = await getProductOnline(barcode, context);
    if(product == null) {
      _insertProductData(barcode, context);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => EanProductScreen(product, saveProductCallback: this.saveProductCallback)));
    }
  }

  Future<EanInfo?> getProductOnline(String barcode, BuildContext context) async {
    try {
      Uri uri = Uri(scheme: 'https',
                    host: 'api.cosmos.bluesoft.com.br',
                    path: 'gtins/$barcode');

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

   void _insertProductData(String barcode, BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => EanProductScreen(EanInfo(barcode, "", 0), saveProductCallback: this.saveProductCallback)));
  }

  Future<void> openProduct(String barcode, BuildContext context) async {
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

    await _productService.openProduct(selectedProduct, context);

    Navigator.pop(context);
  }

  Future<void> discardProduct(String barcode, BuildContext context) async {
    var productList = await _productDao.getOpenProductsByBarcode(barcode);

    if(productList.isEmpty) {
      await DialogManager.showGenericDialog(context, 'Erro', 'Esse produto não está aberto ou não foi cadastrado');
      Navigator.pop(context);
      return;
    }

    // For now, we'll discard the first item found
    _productService.discardProduct(productList[0], context);
    Navigator.pop(context);
  }
}