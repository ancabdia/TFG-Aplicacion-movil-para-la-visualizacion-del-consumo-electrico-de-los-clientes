import 'package:flutter/material.dart';
import 'package:tfgproyecto/components/app_bar.dart';
import 'package:tfgproyecto/model/Consumption.dart';

class TableComparison extends StatefulWidget {
  List<Consumption> consumption;
  List<double> comparison;

  TableComparison({super.key, required this.consumption, required this.comparison});

  @override
  State<TableComparison> createState() => _TableComparisonState();
}

class _TableComparisonState extends State<TableComparison> {
  List<DataRow> rows = [];
  prepareData(){
    List<DataCell> horas = widget.consumption.map((e) => DataCell(Text(e.time!))).toList();
    List<DataCell> consumo =  widget.consumption.map((e) => DataCell(Text(e.consumptionKWh.toString()))).toList();
    List<DataCell> comparado = widget.comparison.map((e) => DataCell(Text(e.toString()))).toList();
    for (var i = 0; i < 24; i++) {
      switch (widget.consumption[i].consumptionKWh! > widget.comparison[i]) {
        case true:
          rows.add(DataRow(cells: [horas[i], consumo[i], comparado[i]], color: MaterialStateColor.resolveWith((states) => Colors.red)));
          break;
        case false:
          rows.add(DataRow(cells: [horas[i], consumo[i], comparado[i]], color: MaterialStateColor.resolveWith((states) => Colors.green)));
          break;
        default:
      }
    }
  }

  @override
  void initState() {
    if(widget.comparison.isNotEmpty)
    prepareData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Leyenda'),
              Column(
                children: [
                  Icon(Icons.square, color: Colors.red,),
                  Text('peor'),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.square, color: Colors.green,),
                  Text('mejor'),
                ],
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text("hora")),
                  DataColumn(label: Text("consumo"), numeric: true),
                  DataColumn(label: Text("comparado"), numeric: true)
                ], 
                rows: rows
              ),
            ),
          ),
        ],
      ),
    );
  }
}