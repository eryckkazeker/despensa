class EanProduct {
  String _barcode;
  String _description;
  int _expirationDays;

  EanProduct(this._barcode, this._description, this._expirationDays);

  String get barcode => this._barcode;
  String get description => this._description;
  int get expirationDays => this._expirationDays;

  set description(String newDescription) {
    this._description = newDescription;
  }

  set expirationDays(int newExpirationDays) {
    this._expirationDays = newExpirationDays;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["barcode"] = _barcode;
    map["description"] = _description;
    map["expiration_days"] = _expirationDays;

    return map;
  }

  EanProduct.fromObject(dynamic o) {
    this._barcode = o["barcode"] != null ? o["barcode"] : "";
    this._description = o["description"] != null ? o["description"] : "";
    this._description = o["expiration_days"] != null ? o["expiration_days"] : 0;
  }
}