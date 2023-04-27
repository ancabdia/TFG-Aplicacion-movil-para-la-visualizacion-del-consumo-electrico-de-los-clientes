import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../components/app_bar.dart';
import '../model/Consumption.dart';

class GraficoConsumo extends StatelessWidget {
  List<Consumption> data;
  final String type;
  GraficoConsumo({super.key, required this.data, required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == "date") {
      Map<String, List<Consumption>> consumptionsByDate = data.fold({},
          (Map<String, List<Consumption>> accumulator,
              Consumption consumption) {
        String date = consumption.date!;

        if (!accumulator.containsKey(date)) {
          accumulator[date] = [];
        }

        accumulator[date]!.add(consumption);

        return accumulator;
      });

      // calcular la suma de los consumos para cada fecha
      Map<String, double> totalConsumptionsByDate = {};
      consumptionsByDate.forEach((date, dateConsumptions) {
        double total = dateConsumptions.fold(0,
            (double accumulator, Consumption consumption) {
          return accumulator + (consumption.consumptionKWh!);
        });

        totalConsumptionsByDate[date] = total;
      });
      totalConsumptionsByDate.forEach((key, value) {
        data.add(Consumption.date(date: key, consumptionKWh: value));
      });
    }

    List<charts.Series<Consumption, String>> seriesList = [
      charts.Series<Consumption, String>(
        id: 'Consumo',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Consumption consumo, _) =>
            type == "time" ? consumo.time! : consumo.date!,
        measureFn: (Consumption consumo, _) => consumo.consumptionKWh,
        labelAccessorFn: (Consumption consumo, _) =>
            consumo.consumptionKWh!.toStringAsFixed(3),
        data: data,
      )
    ];

     maxTickProviderSpec(){
      double maxvalue = 0;
      data.forEach((element) {
        if(element.consumptionKWh! > maxvalue){
          maxvalue = element.consumptionKWh!;
        }
      });
      return maxvalue;
    }

    return Scaffold(
        appBar: AppBars(title: data.first.cups!),
        body: Column(
          children: 
            [SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                margin: const EdgeInsets.all(10),
                width: type == "time" ? data.length * 60 : data.length * 6,
                child: charts.BarChart(
                  seriesList,
                  animate: true,
                  barRendererDecorator: charts.BarLabelDecorator<String>(),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    // renderSpec: charts.GridlineRendererSpec(
                    //   labelStyle: charts.TextStyleSpec(
                    //     fontSize: 11,
                    //     color: charts.MaterialPalette.gray.shade800,
                    //   ),
                    //   lineStyle: const charts.LineStyleSpec(
                    //       thickness: 1, color: charts.Color.black),
                    // ),
                    tickProviderSpec: charts.StaticNumericTickProviderSpec(
                      <charts.TickSpec<num>>[
                        const charts.TickSpec<num>(0),
                        charts.TickSpec<num>(maxTickProviderSpec() / 8),
                        charts.TickSpec<num>(maxTickProviderSpec() / 4),
                        charts.TickSpec<num>(maxTickProviderSpec() / 2.6),
                        charts.TickSpec<num>(maxTickProviderSpec() / 2),
                        charts.TickSpec<num>(maxTickProviderSpec() / 1.5),
                        charts.TickSpec<num>(maxTickProviderSpec() / 1.2),
                        charts.TickSpec<num>(maxTickProviderSpec()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text('PUNTO SELECCIONADO'),
            Text('HORA '),
            Text('PRECIO '),
          ],
        ));
  }
}
