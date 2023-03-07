class Supply {
  String? address;
  String? cups;
  String? postalCode;
  String? province;
  String? municipality;
  String? distributor;
  String? validDateFrom;
  String? validDateTo;
  int? pointType;
  String? distributorCode;

  Supply(
      {this.address,
        this.cups,
        this.postalCode,
        this.province,
        this.municipality,
        this.distributor,
        this.validDateFrom,
        this.validDateTo,
        this.pointType,
        this.distributorCode});

  Supply.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    cups = json['cups'];
    postalCode = json['postalCode'];
    province = json['province'];
    municipality = json['municipality'];
    distributor = json['distributor'];
    validDateFrom = json['validDateFrom'];
    validDateTo = json['validDateTo'];
    pointType = json['pointType'];
    distributorCode = json['distributorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['cups'] = this.cups;
    data['postalCode'] = this.postalCode;
    data['province'] = this.province;
    data['municipality'] = this.municipality;
    data['distributor'] = this.distributor;
    data['validDateFrom'] = this.validDateFrom;
    data['validDateTo'] = this.validDateTo;
    data['pointType'] = this.pointType;
    data['distributorCode'] = this.distributorCode;
    return data;
  }
}
