import 'package:despensa/models/ean_product.dart';
import 'package:flutter/material.dart';

class EanProductScreen extends StatefulWidget {

  final EanProduct eanProduct;

  EanProductScreen(this.eanProduct);

  @override
  EanProductScreenState createState() => EanProductScreenState(this.eanProduct);
}

class EanProductScreenState extends State<EanProductScreen> {

  EanProduct _eanProduct;

  EanProductScreenState(this._eanProduct);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despensa'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text('Novo Produto')
          ),
          Expanded(
            flex: 5,
            child: Text('Content')
          ),
          Expanded(
            flex: 3,
            child: Text('Buttons')
          ),
        ],
      )
    );
  }
}