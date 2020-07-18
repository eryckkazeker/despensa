import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import './product_entry_screen.dart';
import '../models/ean_info.dart';
import '../database/ean_info_dao.dart';
import '../util/dialog_manager.dart';

class EanProductScreen extends StatefulWidget {
  final EanInfo eanProduct;

  EanProductScreen(this.eanProduct);

  @override
  EanProductScreenState createState() => EanProductScreenState(this.eanProduct);
}

class EanProductScreenState extends State<EanProductScreen> {
  EanProductScreenState(this._eanInfo);

  EanInfo _eanInfo;
  int _days = 1;

  EanInfoDao _dao = EanInfoDao();

  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    descriptionController.text = _eanInfo.description;
    return Scaffold(
        appBar: AppBar(
          title: Text('Inserir Dados do Produto'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text('Novo Produto',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold))),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 70.0, right: 70.0),
                        child: Image(
                          image: AssetImage('assets/images/barcode.png'),
                        )),
                    Text(this._eanInfo.barcode,
                        style: TextStyle(fontSize: 25.0)),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextField(
                          controller: descriptionController,
                          onChanged: ((value) => _eanInfo.description =
                              descriptionController.text),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5.0))),
                              hintText: 'Descrição do Produto'),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text('Após aberto, consumir em')),
                    NumberPicker.integer(
                        initialValue: _days,
                        minValue: 0,
                        maxValue: 180,
                        onChanged: ((newValue) {
                          setState(() {
                            _days = newValue;
                            _eanInfo.expirationDays = _days;
                          });
                        })),
                    Text('dias')
                  ])),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: (() => _saveProduct(_eanInfo)),
                        child: Text('Salvar'),
                      ),
                      RaisedButton(
                        onPressed: _goBack,
                        child: Text('Cancelar'),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.pop(context);
  }

  void _saveProduct(EanInfo eanProduct) async {
    if (eanProduct.barcode == '' || eanProduct.description == '') {
      _showErrorDialog('Preencha todos os dados');
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductEntryScreen(eanProduct)));
      return;
    }

    int result = await _dao.insertEanInfo(_eanInfo);

    if (result <= 0) {
      _showErrorDialog('Erro ao salvar produto, tente novamente.');
      return;
    }

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEntryScreen(_eanInfo)));
    
  }

  void _showErrorDialog(String message) {
    DialogManager.showGenericDialog(context, message);
  }
}
