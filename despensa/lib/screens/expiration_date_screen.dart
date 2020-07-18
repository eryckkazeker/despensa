import 'package:despensa/database/product_dao.dart';
import 'package:flutter/material.dart';

import '../models/ean_info.dart';
import '../models/product.dart';
import '../util/dialog_manager.dart';

class ExpirationDateScreen extends StatefulWidget {

  final int loopQuantity;
  final EanInfo product;

  ExpirationDateScreen(this.product, this.loopQuantity);

  @override
  ExpirationDateScreenState createState() => ExpirationDateScreenState(this.product, this.loopQuantity);
}

class ExpirationDateScreenState extends State<ExpirationDateScreen> {
  
  ProductDao _dao = ProductDao();

  int _loopQuantity;
  EanInfo _product;
  DateTime _expirationDate;

  ExpirationDateScreenState(this._product, this._loopQuantity);

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
                        fontSize: 20.0
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:50.0),
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
                  RaisedButton(
                    onPressed: _saveProduct,
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

  void _saveProduct() async {

    if(_expirationDate == null) {
      DialogManager.showGenericDialog(context, "Selecione a data de validade");
      return;
    }

    Product product = Product(
      this._product,
      this._expirationDate,
      false);

    if (await _dao.insertProduct(product) < 0)
    {
      DialogManager.showGenericDialog(context, 'Erro ao salvar produto, tente novamente');
    }

    setState(() {
      this._loopQuantity--;
      this._loopCount++;
    });

    if(this._loopQuantity == 0)
    {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Text _formatDate(DateTime date) {
    if (date == null) {
      return Text("Clique para Selecionar",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.blue
        ),
      );
    }
    return Text("${date.day}/${date.month}/${date.year}",
      style: TextStyle(
        fontSize: 20.0,
      ),
    );
  }
}