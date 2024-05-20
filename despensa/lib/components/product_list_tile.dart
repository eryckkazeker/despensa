import 'package:despensa/models/product.dart';
import 'package:despensa/util/formatter.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  final Product _product;
  final Function _openProduct;
  final Function _discardProduct;
  const ProductListTile(this._product, this._openProduct, this._discardProduct, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(8)),
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 8,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(_product.eanInfo!.description,
                                      textScaler: TextScaler.linear(2))),
                            ),
                            Text(
                                'Vencimento ${formatDateTime(_product.expirationDate)}')
                          ],
                        ))),
                Expanded(
                    flex: 2,
                    child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: buildActionColumn(_product, this._discardProduct, this._openProduct)))
              ],
            )));
  }
}

Widget buildActionColumn(Product product, Function discardProduct, Function openProduct) {
  var column = Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
    Card.filled(
        color: Colors.red[900],
        child: IconButton(
          onPressed: () => discardProduct(product),
          icon: Icon(Icons.delete),
        ))
  ]);

  if (!product.isOpen) {
    column.children.insert(
        0,
        Card.filled(
          elevation: 4.0,
          color: Colors.green[900],
          child: IconButton(
            onPressed: () => openProduct(product),
            icon: Icon(Icons.lock_open_rounded),
          ),
        ));
  }
  return column;
}
