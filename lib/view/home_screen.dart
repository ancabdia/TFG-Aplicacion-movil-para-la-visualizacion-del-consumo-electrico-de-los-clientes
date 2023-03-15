import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/src/text_element.dart' as element;
import 'package:path/path.dart';
import 'package:tfgproyecto/view/profile.dart';

import '../API/API.dart';
import '../model/Prices.dart';

class HomeScreenOld extends StatefulWidget {
  const HomeScreenOld({Key? key}) : super(key: key);

  @override
  State<HomeScreenOld> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreenOld> {
  List<Price> _prices = [];

  @override
  void initState() {
    super.initState();
    API.fetchPrices().then((prices) {
      setState(() {
        _prices = prices;
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            FutureBuilder(
                future: API.fetchMinPrice(),
                builder: (context, snapshot) {
                    Price? minPrice = snapshot.data;
                    return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Precio minimo: ${minPrice?.price.toStringAsPrecision(3)} €/kWh '),
                      Row(
                        children: [
                          const Icon(Icons.more_time),
                          Text(minPrice?.hour ?? ''),
                        ],
                      )
                    ],
                  );
                }),
            FutureBuilder(
                future: API.fetchMaxPrice(),
                builder: (context, snapshot) {
                  Price? maxPrice = snapshot.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Precio maximo: ${maxPrice?.price.toStringAsPrecision(3)} €/kWh '),
                      Row(
                        children: [
                          const Icon(Icons.more_time),
                          Text(maxPrice?.hour ?? ''),
                        ],
                      )
                    ],
                  );
                }),
            Expanded(
              child: _prices.isNotEmpty
                  ? Container(child: _buildChart(context))
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
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

    var value;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: charts.LineChart(
        data,
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
        domainAxis: const charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 24),
          viewport: charts.NumericExtents(0, 23),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
              desiredTickCount: _prices.length ~/ 4),
        ),
        behaviors: [
          charts.LinePointHighlighter(
            ////////////////////// notice ////////////////////////////
            symbolRenderer:
                TextSymbolRenderer(() => value.toStringAsFixed(4), context),
            ////////////////////// notice ////////////////////////////
          ),
        ],
        selectionModels: [
          SelectionModelConfig(changedListener: (SelectionModel model) {
            if (model.hasDatumSelection) {
              value = (model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index));
            }
          })
        ],
      ),
    );
  }
}

typedef GetText = String Function();

class TextSymbolRenderer extends CircleSymbolRenderer {
  TextSymbolRenderer(this.getText, this.context,
      {this.marginBottom = 8, this.padding = const EdgeInsets.all(8)});

  final GetText getText;
  final double marginBottom;
  final EdgeInsets padding;
  final BuildContext context;

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    style.TextStyle textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;

    // print(getText.call());

    element.TextElement textElement = element.TextElement(
        '${getText.call().padRight(3)} €/kWh',
        style: textStyle);
    double width = textElement.measurement.horizontalSliceWidth;
    double height = textElement.measurement.verticalSliceWidth;

    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = bounds.top +
        bounds.height / 2 -
        marginBottom -
        (padding.top + padding.bottom);

    canvas.drawRRect(
      Rectangle(
        centerX - (width / 2) - padding.left,
        centerY - (height / 2) - padding.top,
        width + (padding.left + padding.right),
        height + (padding.top + padding.bottom),
      ),
      fill: Color.white,
      radius: 16,
      roundTopLeft: true,
      roundTopRight: true,
      roundBottomRight: true,
      roundBottomLeft: true,
    );
    canvas.drawText(
      textElement,
      (centerX - (width / 2)).round(),
      (centerY - (height / 2)).round(),
    );
  }
}
