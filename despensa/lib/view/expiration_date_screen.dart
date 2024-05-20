import 'package:despensa/controller/expiration_date_screen_controller.dart';
import 'package:flutter/material.dart';

import '../util/formatter.dart';
import '../models/ean_info.dart';

class ExpirationDateScreen extends StatefulWidget {

  final int loopQuantity;
  final EanInfo product;
  final ExpirationDateScreenController expirationDateScreenController;
  final Function? saveProductCallback;

  ExpirationDateScreen(this.product, this.loopQuantity, this.expirationDateScreenController, {this.saveProductCallback});

  @override
  ExpirationDateScreenState createState() => ExpirationDateScreenState(this.product, 
                                                                      this.loopQuantity,
                                                                      this.expirationDateScreenController,
                                                                      saveProductCallback: this.saveProductCallback);
}

class ExpirationDateScreenState extends State<ExpirationDateScreen> {

  final ExpirationDateScreenController expirationDateScreenController;
  
  int _loopQuantity;
  EanInfo _product;
  DateTime? _expirationDate;
  Function? saveProductCallback;

  ExpirationDateScreenState(this._product, this._loopQuantity, this.expirationDateScreenController, {this.saveProductCallback});

  int _loopCount = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Data de Validade'),
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
                    padding: EdgeInsets.only(top:50.0),
                    child: Text('Item $_loopCount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:50.0),
                    child: Text(
                      'Data de Validade:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: TextButton(
                      onPressed: _showDatePicker, 
                      child: _formatDate(this._expirationDate)
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
                  ElevatedButton(
                    style: ButtonStyle(
                          elevation: MaterialStatePropertyAll<double>(2),
                          backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.secondary)
                        ),
                    onPressed: _saveProduct,
                    child: Text('Salvar'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                          elevation: MaterialStatePropertyAll<double>(2),
                          backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.secondary)
                        ),
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

  void _saveProduct() async {

    this.expirationDateScreenController.saveProduct(this._product, this._expirationDate, context);

    if (saveProductCallback != null) {
      saveProductCallback!();
    }

    setState(() {
      this._loopQuantity--;
      this._loopCount++;
    });

    if(this._loopQuantity == 0)
    {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Text _formatDate(DateTime? date) {
    if (date == null) {
      return Text("Clique para Selecionar",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.blue
        ),
      );
    }
    return Text(formatDateTime(date),
      style: TextStyle(
        fontSize: 20.0,
      ),
    );
  }
}