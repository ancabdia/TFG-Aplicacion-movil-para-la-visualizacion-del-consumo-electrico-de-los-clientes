class Supply {
  String? _address;
  String _cups = '';
  String? _postalCode;
  String? _province;
  String? _municipality;
  String? _distributor;
  String? _validDateFrom;
  String? _validDateTo;
  int? _pointType;
  String? _distributorCode;

  Supply(
      {String? address,
      String? cups,
      String? postalCode,
      String? province,
      String? municipality,
      String? distributor,
      String? validDateFrom,
      String? validDateTo,
      int? pointType,
      String? distributorCode}) {
    if (address != null) {
      this._address = address;
    }
    if (cups != null) {
      this._cups = cups;
    }
    if (postalCode != null) {
      this._postalCode = postalCode;
    }
    if (province != null) {
      this._province = province;
    }
    if (municipality != null) {
      this._municipality = municipality;
    }
    if (distributor != null) {
      this._distributor = distributor;
    }
    if (validDateFrom != null) {
      this._validDateFrom = validDateFrom;
    }
    if (validDateTo != null) {
      this._validDateTo = validDateTo;
    }
    if (pointType != null) {
      this._pointType = pointType;
    }
    if (distributorCode != null) {
      this._distributorCode = distributorCode;
    }
  }

  String? get address => _address;
  set address(String? address) => _address = address;
  String get cups => _cups;
  set cups(String cups) => _cups = cups;
  String? get postalCode => _postalCode;
  set postalCode(String? postalCode) => _postalCode = postalCode;
  String? get province => _province;
  set province(String? province) => _province = province;
  String? get municipality => _municipality;
  set municipality(String? municipality) => _municipality = municipality;
  String? get distributor => _distributor;
  set distributor(String? distributor) => _distributor = distributor;
  String? get validDateFrom => _validDateFrom;
  set validDateFrom(String? validDateFrom) => _validDateFrom = validDateFrom;
  String? get validDateTo => _validDateTo;
  set validDateTo(String? validDateTo) => _validDateTo = validDateTo;
  int? get pointType => _pointType;
  set pointType(int? pointType) => _pointType = pointType;
  String? get distributorCode => _distributorCode;
  set distributorCode(String? distributorCode) =>
      _distributorCode = distributorCode;

  Supply.fromJson(Map<String, dynamic> json) {
    _address = json['address'];
    _cups = json['cups'];
    _postalCode = json['postalCode'];
    _province = json['province'];
    _municipality = json['municipality'];
    _distributor = json['distributor'];
    _validDateFrom = json['validDateFrom'];
    _validDateTo = json['validDateTo'];
    _pointType = json['pointType'];
    _distributorCode = json['distributorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this._address;
    data['cups'] = this._cups;
    data['postalCode'] = this._postalCode;
    data['province'] = this._province;
    data['municipality'] = this._municipality;
    data['distributor'] = this._distributor;
    data['validDateFrom'] = this._validDateFrom;
    data['validDateTo'] = this._validDateTo;
    data['pointType'] = this._pointType;
    data['distributorCode'] = this._distributorCode;
    return data;
  }
}
