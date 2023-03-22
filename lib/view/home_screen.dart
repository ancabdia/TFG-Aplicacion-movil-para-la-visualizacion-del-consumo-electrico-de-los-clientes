import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tfgproyecto/components/formatter.dart';
import '../API/API.dart';
import '../model/Prices.dart';

class HomeScreenOld extends StatefulWidget {
  const HomeScreenOld({Key? key}) : super(key: key);

  @override
  State<HomeScreenOld> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreenOld> {
  List<Price> _prices = [];
  double price = 0.0;
  dynamic hour = 0;

  late final PriceController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = PriceController();
    API.fetchPrices().then((prices) {
      setState(() {
        _prices = prices;
        updateData();
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
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
    // var indexWhere = _prices.indexWhere((element) {
    //   if (element.hour.substring(0, 2) == DateTime.now().hour.toString()) {
    //     return true;
    //   }
    //   return false;
    // });
    // Price priceNow = _prices[indexWhere];

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder(
                  future: API.fetchPrice("min"),
                  builder: (context, snapshot) {
                    Price? minPrice = snapshot.data;
                    return SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Card(
                        child: Column(
                          children: [
                            Text('Minimo'),
                            Text(
                                '${minPrice?.price.toStringAsPrecision(3)} €/kWh ',
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.more_time),
                                Text('${minPrice?.hour}h'),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              // SizedBox(
              //   height: 80,
              //   width: MediaQuery.of(context).size.width / 3,
              //   child: Card(
              //     child: Column(
              //       children: [
              //         Text('Actual'),
              //         Text('${priceNow.price.toStringAsPrecision(3)} €/kWh ',
              //             style: const TextStyle(
              //                 color: Colors.green,
              //                 fontWeight: FontWeight.bold)),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const Icon(Icons.more_time),
              //             Text('${priceNow.hour}h'),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              FutureBuilder(
                  future: API.fetchPrice("max"),
                  builder: (context, snapshot) {
                    Price? maxPrice = snapshot.data;
                    return SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Card(
                        child: Column(
                          children: [
                            Text('Maximo'),
                            Text(
                                '${maxPrice?.price.toStringAsPrecision(3)} €/kWh ',
                                style: const TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.more_time),
                                Text('${maxPrice?.hour}h'),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })
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
                        child: _buildChart(context)),
                    Text('PUNTO SELECCIONADO'),
                    Text('HORA ${Duration(hours: hour)}'),
                    Text('PRECIO ${price.toStringAsPrecision(3)} €/kWh'),
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
          'Precios ${DateTime.now().formatter()}',
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
