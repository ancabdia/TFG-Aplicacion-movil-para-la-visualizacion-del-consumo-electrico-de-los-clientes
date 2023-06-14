class ContractDetail {
  String? cups;
  String? distributor;
  String? marketer;
  String? tension;
  String? accessFare;
  String? province;
  String? municipality;
  String? postalCode;
  List<double>? contractedPowerkW;
  double? contractedPowerkWMin;
  double? contractedPowerkWMax;
  String? timeDiscrimination;
  String? startDate;
  String? modePowerControl;
  String? endDate;
  String? codeFare;

  ContractDetail(
      {this.cups,
        this.distributor,
        this.marketer,
        this.tension,
        this.accessFare,
        this.province,
        this.municipality,
        this.postalCode,
        this.contractedPowerkWMin,
        this.contractedPowerkW,
        this.contractedPowerkWMax,
        this.timeDiscrimination,
        this.modePowerControl,
        this.startDate,
        this.endDate,
        this.codeFare});

  ContractDetail.fromJson(Map<String, dynamic> json) {
    cups = json['cups'];
    distributor = json['distributor'];
    marketer = json['marketer'];
    tension = json['tension'];
    accessFare = json['accessFare'];
    province = json['province'];
    municipality = json['municipality'];
    postalCode = json['postalCode'];
    if(json['contractedPowerkW'] == null){
      contractedPowerkWMin = json['contractedPowerkWMin'];
      contractedPowerkWMax = json['contractedPowerkWMax'];
    }else{
      contractedPowerkW = json['contractedPowerkW'].cast<double>();
      contractedPowerkWMin = json['contractedPowerkW'][0];
      contractedPowerkWMax = json['contractedPowerkW'][1];
    }
    timeDiscrimination = json['timeDiscrimination'];
    modePowerControl = json['modePowerControl'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    codeFare = json['codeFare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cups'] = this.cups;
    data['distributor'] = this.distributor;
    data['marketer'] = this.marketer;
    data['tension'] = this.tension;
    data['accessFare'] = this.accessFare;
    data['province'] = this.province;
    data['municipality'] = this.municipality;
    data['postalCode'] = this.postalCode;
    data['contractedPowerkW'] = [contractedPowerkWMin, contractedPowerkWMax];
    data['timeDiscrimination'] = this.timeDiscrimination;
    data['modePowerControl'] = this.modePowerControl;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['codeFare'] = this.codeFare;
    return data;
  }
}
