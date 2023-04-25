import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/provider/locale_provider.dart';
import 'package:tfgproyecto/view/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../API/API.dart';
import '../API/db.dart';
import '../model/Supply.dart';
import 'contractDetail.dart';

class SuppliesScreen extends StatefulWidget {
  const SuppliesScreen({Key? key}) : super(key: key);

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

Future<List<Supply>> getSupplies() async {
  Database database = await DB.openDB();
  final prefs = await SharedPreferences.getInstance();
  List<Map<String, Object?>> list = await database.query('supplies', where: 'userId = ?', whereArgs: [prefs.getString("email")]);

  final supplies =List<Map<String, dynamic>>.from(list);          

  List<Supply> fetchSupplies = await API.getSupplies();

  if(fetchSupplies.length > supplies.length){
    for (var s in fetchSupplies) {
      var value = {
      'cups': s.cups,
      'address': s.address,
      'postalCode': s.postalCode,
      'province': s.province,
      'municipality': s.municipality,
      'validDateFrom': s.validDateFrom,
      'validDateTo': s.validDateTo,
      'pointType': s.pointType,
      'distributorCode': s.distributorCode,
      'distributor': s.distributor,
      'userId': prefs.getString("email")
      };
    database.insert('supplies', value, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
  return supplies.map((supply) => Supply.fromJson(supply)).toList();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  @override
  Widget build(BuildContext context) => 
    Scaffold(body: FutureBuilder<List<Supply>>(
        future: getSupplies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return SupplyList(supplies: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
}



class SupplyList extends StatefulWidget {
  const SupplyList({super.key, required this.supplies});

  final List<Supply> supplies;

  @override
  State<SupplyList> createState() => _SupplyListState();
}

class _SupplyListState extends State<SupplyList> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: widget.supplies.length,
        itemBuilder: (context, index) {
          final item = widget.supplies[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lightbulb, color: Colors.orange),
                  title: Text(
                    item.cups!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text(AppLocalizations.of(context)!.date_contract(item.validDateFrom!)),
                  subtitle: Text('subtitulo'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('${item.address}'),
                      Text('${item.municipality}'),
                      Text('${item.province}'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContractDetailScreen(cups: item.cups!, distributorCode: item.distributorCode!)
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.view_contract),
                  ),
                  const Padding(padding: EdgeInsets.all(16.0)),
                  ElevatedButton(
                    onPressed: () async {
                      debugPrint("Consultar consumos con cups ${item.cups}");
                      // List<Consumption> data = await API.getConsumptionData(item.cups!, item.distributorCode!, "2023/01", "2023/02", item.pointType!);
                      // var database = await DB.openDB();
                      // var batch = database.batch();
                      // data.forEach((c) => batch.insert("consumptions",
                      //   {
                      //     'supplyId':c.cups,
                      //     'date':c.date,
                      //     'time':c.time,
                      //     'consumptionKWh':c.consumptionKWh,
                      //     'obtainMethod':c.obtainMethod
                      //   },
                      //   conflictAlgorithm: ConflictAlgorithm.ignore,
                      // ));
                      // await batch.commit(noResult: true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarPage(supply: item)
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.view_consumption),
                  ),
                ],)
                
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _refresh() async {
    debugPrint('Haciendo refresh');
    //fetchSupplies();
    setState(() {
      
    });
  }
}