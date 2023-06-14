import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/API/API.dart';
import 'package:tfgproyecto/components/app_bar.dart';
import 'package:tfgproyecto/model/Consumption.dart';
import 'package:tfgproyecto/view/tableComparison.dart';

import '../API/db.dart';

class CompararScreen extends StatefulWidget {
  String date;
  String cups;
  List<Consumption> consumptions;

  CompararScreen({super.key, required this.date, required this.cups, required this.consumptions});

  @override
  State<CompararScreen> createState() => _CompararScreenState();
}

class _CompararScreenState extends State<CompararScreen> {
  //create lists
  var provinces = [];
  var municipalities = [];

  //values of dropdown
  String? provinceSelected;
  String? municipalitySelected;

  var isLoading = true;

  populateDropdowns() async {
    var temp1 = await DB.getProvinces();
    setState(() {
      provinces = temp1;
      isLoading = false;
    });
  }

  @override
  initState() {
    populateDropdowns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Selecciona una provincia: "),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton<dynamic>(
                        hint: Text("selecciona provincia"),
                        value: provinceSelected,
                        isExpanded: true,
                        items: provinces
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (newValue) async {
                          var lista =
                              await DB.getMunicipalities(newValue.toString());
                          setState(() {
                            municipalitySelected = null;
                            municipalities = lista;
                            provinceSelected = newValue.toString();
                          });
                        }),
                  ),
                  const Divider(),
                  Text("Selecciona un municipio: "),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton<dynamic>(
                        hint: Text("selecciona municipio"),
                        value: municipalitySelected,
                        isExpanded: true,
                        items: municipalities
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            municipalitySelected = newValue.toString();
                          });
                        }),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            var suppliesFilter = await DB.getSuppliesFilter(provinceSelected!, municipalitySelected ?? '', widget.date, widget.cups);

                            var comparison = <String,double>{};
                            for (var element in suppliesFilter) {
                              if(comparison.containsKey(element["time"])){
                                debugPrint("elemento ya incluido");
                                var new_value = comparison["${element["time"]}"]! + element["consumptionKWh"];
                                comparison.remove(element["time"]);
                              }
                              comparison.putIfAbsent(element["time"], () => element["consumptionKWh"]); 
                            }

                            List<double> comparisonList = [];
                            comparison.forEach((key, value) {comparisonList.add(value);});

                            // for (var element in widget.consumptions) {
                            //   print("${element.time} -- ${element.consumptionKWh} \t  ${comparison[element.time]} ");
                            // }
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => TableComparison(consumption: widget.consumptions, comparison: comparisonList),
                            ));
                          }, child: Text('comparar suministros'))
                    ],
                  )
                ],
              );
  }
}
