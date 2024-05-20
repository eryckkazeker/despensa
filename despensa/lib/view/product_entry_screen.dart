import 'package:despensa/controller/expiration_date_screen_controller.dart';
import 'package:despensa/database/notification_dao.dart';
import 'package:despensa/database/product_dao.dart';
import 'package:despensa/models/ean_info.dart';
import 'package:despensa/services/product_service.dart';
import 'package:despensa/view/expiration_date_screen.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ProductEntryScreen extends StatefulWidget {

  final EanInfo eanProduct;
  final Function? saveProductCallback;

  ProductEntryScreen(this.eanProduct, {this.saveProductCallback});

  @override
  ProductEntryScreenState createState() => ProductEntryScreenState(this.eanProduct, saveProductCallback: saveProductCallback);
}

class ProductEntryScreenState extends State<ProductEntryScreen> {

  EanInfo _eanProduct;
  int _quantity = 1;
  Function? saveProductCallback;

  ProductEntryScreenState(this._eanProduct, {this.saveProductCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quantidade de Produtos'),
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
                  Text(this._eanProduct.barcode,
                    style: TextStyle(
                      fontSize: 25.0
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: Text(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                      'Quantidade:')
                  ),
                  NumberPicker(
                    selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0
                    ),
                    value: _quantity,
                    minValue: 1,
                    maxValue: 10,
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
                  ElevatedButton(
                    style: ButtonStyle(
                          elevation: MaterialStatePropertyAll<double>(2),
                          backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.secondary)
                        ),
                    onPressed: _continue,
                    child: Text('Continuar'),
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

  void _continue() {
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ExpirationDateScreen(this._eanProduct,
                                                                    this._quantity,
                                                                    ExpirationDateScreenController(
                                                                      ProductService(
                                                                        ProductDao(),
                                                                        NotificationDao()
                                                                      )
                                                                    ),
                                                                    saveProductCallback: this.saveProductCallback)));
  }
}