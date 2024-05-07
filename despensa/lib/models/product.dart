import 'package:despensa/models/ean_info.dart';

class Product {
  
  late int _id;
  late EanInfo? _eanInfo;
  late DateTime? _expirationDate;
  late bool _isOpen;


  Product(this._eanInfo, this._expirationDate, this._isOpen);
  Product.withId(this._id, this._eanInfo, this._expirationDate, this._isOpen);

  int get id => this._id;
  EanInfo? get eanInfo => this._eanInfo;
  DateTime? get expirationDate => this._expirationDate;
  bool get isOpen => this._isOpen;

  set eanInfo(EanInfo? newEanInfo) {
    this._eanInfo = newEanInfo;
  }

  set expirationDate(DateTime? newExpirationDate) {
    this._expirationDate = newExpirationDate;
  }

  set isOpen(bool newIsOpen) {
    this._isOpen = newIsOpen;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["barcode"] = _eanInfo!.barcode;
    map["expiration_date"] = _expirationDate!.millisecondsSinceEpoch;
    map["is_open"] = _isOpen ? 1 : 0;

    return map;
  }

  Product.fromObject(dynamic o) {
    this._id = o["product_id"] != null ? o["product_id"] : "";
    this.eanInfo = o["barcode"] != null ? EanInfo(o["barcode"], "", 0) : null;
    this._isOpen = o["is_open"] == 1 ? true : false;
    this._expirationDate = o["expiration_date"] != null ? DateTime.fromMillisecondsSinceEpoch(o["expiration_date"]) : null;
  }
}