import 'package:despensa/models/ean_product.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ProductEntryScreen extends StatefulWidget {

  final EanProduct eanProduct;

  ProductEntryScreen(this.eanProduct);

  @override
  ProductEntryScreenState createState() => ProductEntryScreenState(this.eanProduct);
}

class ProductEntryScreenState extends State<ProductEntryScreen> {

  EanProduct _eanProduct;
  int _quantity = 1;

  ProductEntryScreenState(this._eanProduct);

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
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                _eanProduct.description,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                )
              )
            )
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 70.0,
                      right: 70.0
                    ),
                    child: Image(
                      image: AssetImage('assets/images/barcode.png'),
                    )
                  ),
                  Text(this._eanProduct.barcode,
                    style: TextStyle(
                      fontSize: 25.0
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: Text('Quantidade:')
                  ),
                  NumberPicker.integer(
                    initialValue: _quantity,
                    minValue: 0,
                    maxValue: 99,
                    onChanged: ((newValue) {
                      setState(() {
                        _quantity = newValue;
                      });
                    })
                  ),
                ]
              )
            )
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                    onPressed: null,
                    child: Text('Salvar'),
                  ),
                  RaisedButton(
                    onPressed: _goBack,
                    child: Text('Cancelar'),
                  )
                ],
              )
            )
          ),
        ],
      )
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }
}