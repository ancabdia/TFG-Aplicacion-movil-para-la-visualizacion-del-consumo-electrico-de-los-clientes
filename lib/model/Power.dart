class Power {
  String? cups;
  String? date;
  String? time;
  double? maxPower;
  String? period;

  Power({this.cups, this.date, this.time, this.maxPower, this.period});

  Power.fromJson(Map<String, dynamic> json) {
    cups = json['cups'];
    date = json['date'];
    time = json['time'];
    maxPower = json['maxPower'];
    period = json['period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cups'] = this.cups;
    data['date'] = this.date;
    data['time'] = this.time;
    data['maxPower'] = this.maxPower;
    data['period'] = this.period;
    return data;
  }
}
