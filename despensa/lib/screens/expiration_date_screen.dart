import 'package:despensa/models/ean_product.dart';
import 'package:flutter/material.dart';

class ExpirationDateScreen extends StatefulWidget {

  final int loopQuantity;
  final EanProduct product;

  ExpirationDateScreen(this.product, this.loopQuantity);

  @override
  ExpirationDateScreenState createState() => ExpirationDateScreenState(this.product, this.loopQuantity);
}

class ExpirationDateScreenState extends State<ExpirationDateScreen> {
  
  int _loopQuantity;
  EanProduct _product;
  DateTime _expirationDate;

  ExpirationDateScreenState(this._product, this._loopQuantity);

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
                _product.description,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
                  Text(this._product.barcode,
                    style: TextStyle(
                      fontSize: 25.0
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:100.0),
                    child: Text('Data de Validade:',
                      style: TextStyle(
                        fontSize: 20.0
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: FlatButton(
                      onPressed: _showDatePicker, 
                      child: Text(_formatDate(_expirationDate),
                        style: TextStyle(
                          fontSize: 20.0
                        ),
                      )
                    )
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

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 730))
    ).then((value) {
      setState(() {
        _expirationDate = value;
      });
    });
  }

  String _formatDate(DateTime date) {
    if (date == null) return "Selecionar";

    return "${date.day}/${date.month}/${date.year}";
  }
}