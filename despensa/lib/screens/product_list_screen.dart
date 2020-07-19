import 'package:flutter/material.dart';

import '../models/product.dart';
import '../util/formatter.dart';

class ProductsListScreen extends StatelessWidget {

  final List<Product> _productList;

  ProductsListScreen(this._productList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione o Produto"),
      ),
      body: ListView.builder(
        itemCount: _productList.length,
        itemBuilder: (context, index) {
          final product = _productList[index];
          return ProductListItem(product);
        }
      )
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product _product;

  ProductListItem(this._product);

  @override
  Widget build(BuildContext context) {
    //TODO: implementar Material para efeito click
    return GestureDetector(
          onTap: () => Navigator.pop(context, this._product),
          child: Card(
          child: ListTile(
        title: Text(_product.eanInfo.description),
        subtitle: Text(formatDateTime(_product.expirationDate)),
      )),
    );
  }
}
