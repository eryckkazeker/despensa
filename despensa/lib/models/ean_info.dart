class EanInfo {
  
  late String _barcode;
  late String _description;
  late int _expirationDays;

  EanInfo(this._barcode, this._description, this._expirationDays);

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

  EanInfo.fromObject(dynamic o) {
    this._barcode = o["barcode"] != null ? o["barcode"] : "";
    this._description = o["description"] != null ? o["description"] : "";
    this._expirationDays = o["expiration_days"] != null ? o["expiration_days"] : 0;
  }

  EanInfo.fromJSON(Map<String, dynamic> json) {
    this._barcode = json['gtin'].toString();
    this._description = json['description'];
    this._expirationDays = 0;
  }
}