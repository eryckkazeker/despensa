import 'package:despensa/models/ean_product.dart';
import 'package:despensa/util/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class EanProductScreen extends StatefulWidget {

  final EanProduct eanProduct;

  EanProductScreen(this.eanProduct);

  @override
  EanProductScreenState createState() => EanProductScreenState(this.eanProduct);
}

class EanProductScreenState extends State<EanProductScreen> {

  EanProductScreenState(this._eanProduct);

  EanProduct _eanProduct;
  int _days = 1;

  DbHelper _dbHelper = DbHelper();

  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    descriptionController.text = _eanProduct.description;
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
                'Novo Produto',
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
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: descriptionController,
                      onChanged: ((value) => _eanProduct.description = descriptionController.text),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        hintText: 'Descrição do Produto'
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: Text('Após aberto, consumir em')
                  ),
                  NumberPicker.integer(
                    initialValue: _days,
                    minValue: 0,
                    maxValue: 180,
                    onChanged: ((newValue) {
                      setState(() {
                        _days = newValue;
                        _eanProduct.expirationDays = _days;
                      });
                    })
                  ),
                  Text('dias')
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
                    onPressed: (() => _saveProduct(_eanProduct)),
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

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();

  }

  void _goBack() {
    Navigator.pop(context);
  }

  void _saveProduct(EanProduct eanProduct) async {
    if(eanProduct.barcode == '' || eanProduct.description == '')
    {
      _showErrorDialog('Preencha todos os dados');
      Navigator.pop(context);
      return;
    }

    await _dbHelper.initializeDb();
    
    int result = await _dbHelper.insertEanProduct(_eanProduct);

    if(result <= 0) {
      _showErrorDialog('Erro ao salvar produto, tente novamente.');
    }

  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: (() {
                Navigator.pop(context);
              }), 
              child: Text('OK'))
          ],
        );
      },
    );
  }
}