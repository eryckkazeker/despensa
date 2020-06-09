import 'package:despensa/models/scan_mode.dart';
import 'package:despensa/screens/scanner_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Despensa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  final Color _backgroundColor = Colors.grey;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
                  color: _backgroundColor,
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
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Scanner(ScanMode.openProduct)));
                        },
                        child: Text('Inserir Produtos'),
                      ),
                      RaisedButton(
                        onPressed: null,
                        child: Text('Abrir Produtos'),
                      ),
                      RaisedButton(
                        onPressed: null,
                        child: Text('Descartar Produtos'),
                      ),
                      RaisedButton(
                        onPressed: null,
                        child: Text('Calendário'),
                      ),
                      RaisedButton(
                        onPressed: null,
                        child: Text('Lista de Compras'),
                      ),
                      RaisedButton(
                        onPressed: null,
                        child: Text('Configurações'),
                      )
                    ],
                  ),
                ),
                color: _backgroundColor
                )
              ) 
          ],
        ),
      )
      ,
    );
  }
}
