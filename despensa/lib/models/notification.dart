import 'package:despensa/models/product.dart';

class Notification {
  int _id;
  Product _product;

  Notification(this._id, this._product);

  int get id => this._id;
  Product get product => this._product;

  set product(Product newProduct) {
    this._product = newProduct;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['product_id'] = this._product.id;
    return map;
  }

  Notification.fromObject(dynamic o) {
    this._id = o['id'];
    this._product = Product.withId(o['product_id'], null, null, false);
  }
}