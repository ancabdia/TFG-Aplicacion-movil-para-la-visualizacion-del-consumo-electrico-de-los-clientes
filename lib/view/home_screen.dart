import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfgproyecto/components/formatter.dart';
import '../API/API.dart';
import '../model/Prices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreenOld extends StatefulWidget {
  const HomeScreenOld({Key? key}) : super(key: key);

  @override
  State<HomeScreenOld> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreenOld> {
  List<Price> _prices = [];
  double price = 0.0;
  int hour = 0;
  Price? minPrice, maxPrice;

  late final PriceController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = PriceController();
    API.pricesToday().then((prices) {
      setState(() {
        _prices = prices;
        minPrice = prices.reduce((curr, next) => curr.price <= next.price? curr: next);
        maxPrice = prices.reduce((curr, next) => curr.price >= next.price? curr: next);
        updateData();
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  Future<Price> actualPrice() async {
    var indexWhere = _prices.indexWhere((element) {
      if (int.parse(element.hour) == DateTime.now().hour) {
        return true;
      }
      return false;
    });
    return _prices[indexWhere];
  }

  void updateData() {
    if (_prices.isNotEmpty) {
      hour = int.parse(_prices.last.hour.substring(0, 2));
      price = _prices.last.price;
      _priceController.updatePrice(price);
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Card(
                        child: Column(
                          children: [
                            Text(AppLocalizations.of(context)!.minimum),
                            Text(
                                '${minPrice?.price.toStringAsPrecision(3)} €/kWh',
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.more_time),
                                Text(' ${minPrice?.hour} h'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
              FutureBuilder(
                future: actualPrice(),
                builder: (context, snapshot) {
                  Price? p = snapshot.data as Price?;
                  return SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width / 3,
                  child: Card(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.actual),
                        Text('${p?.price.toStringAsPrecision(3)} €/kWh',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.more_time),
                            Text(' ${p?.hour} h'),
                          ],
                        )
                      ],
                    ),
                  ),
                );
                },
              ),
              SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Card(
                        child: Column(
                          children: [
                            Text(AppLocalizations.of(context)!.maximum),
                            Text(
                                '${maxPrice?.price.toStringAsPrecision(3)} €/kWh',
                                style: const TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.more_time),
                                Text(' ${maxPrice?.hour} h'),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
          StreamBuilder(
              stream: _priceController.priceStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height / 2,
                        margin: const EdgeInsets.all(10),
                        child: _buildChart(context)
                    ),
                    Text(AppLocalizations.of(context)!.point_selected),
                    Text(AppLocalizations.of(context)!.hour(Duration(hours: hour).toHoursMinutes())),
                    Text(AppLocalizations.of(context)!.price(price.toStringAsFixed(3))),
                  ],
                );
              })
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    var data = [
      charts.Series<Price, int>(
        id: 'Price',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Price p, _) => int.parse(p.hour.substring(0, 2)),
        measureFn: (Price p, _) => p.price,
        data: _prices,
      )
    ];

    double getMaxValue(List<charts.Series<Price, int>> data) {
      double maxValue = 0;
      for (var series in data) {
        for (var datum in series.data) {
          if (datum.price > maxValue) {
            maxValue = datum.price;
          }
        }
      }
      return maxValue;
    }

    return charts.LineChart(
      data,
      animate: false,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      domainAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 12),
        viewport: charts.NumericExtents(0, 23),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: const charts.BasicNumericTickProviderSpec(
            desiredTickCount: 6, dataIsInWholeNumbers: false, zeroBound: false),
        viewport: charts.NumericExtents(0, getMaxValue(data)),
      ),
      behaviors: [
        charts.ChartTitle(
          AppLocalizations.of(context)!.price(DateFormat.yMd(AppLocalizations.of(context)!.localeName).format(DateTime.now()))
        ),
        charts.LinePointHighlighter(),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) {
            setState(() {
              hour = ((model.selectedSeries[0]
                  .domainFn(model.selectedDatum[0].index)));
              price = (model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index)) as double;
            });
          }
        })
      ],
    );
  }
}

class PriceController {
  final _priceStreamController = StreamController<double?>.broadcast();

  Stream<double?> get priceStream => _priceStreamController.stream;

  void updatePrice(double? price) {
    _priceStreamController.add(price);
  }

  void dispose() {
    _priceStreamController.close();
  }
}
