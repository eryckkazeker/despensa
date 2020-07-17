import 'package:flutter/material.dart';

import 'package:despensa/models/scan_mode.dart';
import 'package:despensa/screens/scanner_screen.dart';
import '../components/menu_button.dart';

class MainMenu extends StatelessWidget {

  BuildContext _context;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    this._context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('Despensa')
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: Align(
                    child:Text(
                      'Menu Principal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                  width: 100,
                  )
                )
              ),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      MenuButton(
                        'Inserir Produtos',
                        _insertProducts,
                        textColor: Colors.white
                      ),
                      MenuButton(
                        'Abrir Produtos',
                        _openProduct,
                        textColor: Colors.white
                      ),
                      MenuButton(
                        'Descartar Produtos',
                        null,
                        textColor: Colors.white
                      ),
                      MenuButton(
                        'Calendario',
                        null,
                        textColor: Colors.white
                      ),
                      MenuButton(
                        'Lista de Compras',
                        null,
                        textColor: Colors.white
                      ),
                      MenuButton(
                        'Configuracoes',
                        null,
                        textColor: Colors.white
                      )
                    ],
                  ),
                ),
                )
              ) 
          ],
        ),
      )
      ,
    );
  }

  void _openProduct() {
    Navigator.push(this._context, MaterialPageRoute(builder: (context) => Scanner(ScanMode.openProduct)));
  }

  void _insertProducts() {
    Navigator.push(this._context, MaterialPageRoute(builder: (context) => Scanner(ScanMode.insertProduct)));
  }
}
