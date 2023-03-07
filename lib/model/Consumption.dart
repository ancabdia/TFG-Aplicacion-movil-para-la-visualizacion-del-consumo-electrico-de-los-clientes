class Consumption {
  String? cups;
  String? date;
  String? time;
  double? consumptionKWh;
  String? obtainMethod;

  Consumption(
      {this.cups,
        this.date,
        this.time,
        this.consumptionKWh,
        this.obtainMethod});

  Consumption.fromJson(Map<String, dynamic> json) {
    cups = json['cups'];
    date = json['date'];
    time = json['time'];
    consumptionKWh = json['consumptionKWh'];
    obtainMethod = json['obtainMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cups'] = this.cups;
    data['date'] = this.date;
    data['time'] = this.time;
    data['consumptionKWh'] = this.consumptionKWh;
    data['obtainMethod'] = this.obtainMethod;
    return data;
  }
}
