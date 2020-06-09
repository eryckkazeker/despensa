class EanProduct {
  String _barcode;
  String _description;

  EanProduct(this._barcode, this._description);

  String get barcode => this._barcode;
  String get description => this._description;

  set description(String newDescription) {
    this._description = newDescription;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["barcode"] = _barcode;
    map["description"] = _description;

    return map;
  }

  EanProduct.fromObject(dynamic o) {
    this._barcode = o["barcode"] != null ? o["barcode"] : "";
    this._description = o["description"] != null ? o["description"] : "";
  }
}