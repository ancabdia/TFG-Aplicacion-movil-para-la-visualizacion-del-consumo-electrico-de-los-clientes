import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:tfgproyecto/API/API.dart';
import 'package:tfgproyecto/API/db.dart';

import '../components/app_bar.dart';
import '../model/ContractDetail.dart';

class ContractDetailScreen extends StatelessWidget {
  const ContractDetailScreen(
      {super.key, required this.cups, required this.distributorCode});

  final String cups;
  final String distributorCode;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBars(title: Text(cups), context: context),
        body: FutureBuilder<ContractDetail>(
          future: getContractDetail(cups, distributorCode),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return contractDetail(context, snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
}

Future<ContractDetail> getContractDetail(
    String cups, String distributorCode) async {
  Database database = await DB.openDB();
  var list = await database.query('contracts', where: 'cups = ?', whereArgs: [cups]);
  if(list.isEmpty){
    ContractDetail contractDetail = await API.getContractDetail(cups, distributorCode);
    var value = {
     'cups': contractDetail.cups,
     'distributor': contractDetail.distributor,
     'marketer': contractDetail.marketer,
     'tension': contractDetail.tension,
     'accessFare': contractDetail.accessFare,
     'province': contractDetail.province,
     'municipality': contractDetail.municipality,
     'postalCode': contractDetail.postalCode,
     'contractedPowerkWMin': contractDetail.contractedPowerkWMin,
     'contractedPowerkWMax': contractDetail.contractedPowerkWMax,
     'timeDiscrimination': contractDetail.timeDiscrimination,
     'startDate': contractDetail.startDate,
    };
    database.insert('contracts', value);
    return contractDetail;
  }else{
    ContractDetail contrato =  ContractDetail.fromJson(list.first);
    return contrato;
  }
}

Widget contractDetail(BuildContext context, ContractDetail contract) {
  return Column(
    //crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Datos contractuales", style: Theme.of(context).textTheme.headline5),
      Row(
        children: [
          const Text(
            "CUPS: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.cups!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      const Divider(),
      Row(
        children: [
          const Text(
            "Distributor: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.distributor!,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      const Divider(),
      Row(
        children: [
          const Text(
            "Comercializadora: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.marketer!,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      SizedBox(height: 10),
      Text("Localizacion", style: Theme.of(context).textTheme.headline5),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Provincia: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.province!,
              style: Theme.of(context).textTheme.bodySmall),
          const Divider(),
          const Text(
            "Municipio: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.municipality!,
              style: Theme.of(context).textTheme.bodySmall),
          const Divider(),
          const Text(
            "Codigo Postal: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.postalCode!,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      const SizedBox(height: 10),
      Text("Suministro", style: Theme.of(context).textTheme.headline5),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tarifa de Acceso: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.accessFare!,
              style: Theme.of(context).textTheme.bodySmall),
          const Divider(),
          const Text(
            "Tension de conexion: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.tension!, style: Theme.of(context).textTheme.bodySmall),
          const Divider(),
          const Text(
            "Potencia Contratada: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "${contract.contractedPowerkWMin} - ${contract.contractedPowerkWMax}",
              style: Theme.of(context).textTheme.bodySmall),
          const Divider(),
          const Text(
            "Discriminacion Horaria: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(contract.timeDiscrimination!,
              style: Theme.of(context).textTheme.bodySmall),
          const Divider(),
          const Text(
            "Fecha contracto: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("${contract.startDate}",
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ],
  );
}
