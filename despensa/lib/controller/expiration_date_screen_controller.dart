import 'package:despensa/models/ean_info.dart';
import 'package:despensa/services/product_service.dart';
import 'package:flutter/material.dart';

class ExpirationDateScreenController {

  ProductService _productService;

  ExpirationDateScreenController(this._productService);


  void saveProduct(EanInfo? eanInfo, DateTime? expirationDate, BuildContext context) async {
    _productService.saveProduct(eanInfo, expirationDate, context);
  }

}