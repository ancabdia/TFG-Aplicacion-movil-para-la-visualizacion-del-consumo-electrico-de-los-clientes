import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/provider/locale_provider.dart';
import 'package:tfgproyecto/view/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tfgproyecto/view/comparar.dart';

import '../API/API.dart';
import '../API/db.dart';
import '../model/Supply.dart';
import 'contractDetail.dart';

class SuppliesScreen extends StatefulWidget {
  const SuppliesScreen({Key? key}) : super(key: key);

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  Future<List<Supply>> getSupplies() async {
  Database database = await DB.openDB();
  final prefs = await SharedPreferences.getInstance();
  List<Map<String, Object?>> list = await database.query(
    'supplies',
    where: 'userId = ?',
    whereArgs: [prefs.getString("email")],
  );

  if (list.isEmpty) {
    // If the database is empty, fetch supplies from the API
    List<Supply> fetchSupplies = await API.getSupplies();
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
    list = await database.query(
      'supplies',
      where: 'userId = ?',
      whereArgs: [prefs.getString("email")],
    );
  }

  final supplies = List<Map<String, dynamic>>.from(list);

  return supplies.map((supply) => Supply.fromJson(supply)).toList();
}

  Future<void> _refresh() async {
    debugPrint('Haciendo refresh');
    
    setState(() {getSupplies();});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<Supply>>(
          future: getSupplies(),
          builder: (context, snapshot) {
            debugPrint("entrada en el build");
            if(snapshot.connectionState == ConnectionState.waiting){
              debugPrint("entrada en cargando");
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              debugPrint("entrada en error");
              return Container();
            }else {
              debugPrint("entrada en carga suministro");
              List<Supply>? suministros = snapshot.data;
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: suministros?.length,
                  itemBuilder: (context, index) {
                    final item = suministros![index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            leading:
                                const Icon(Icons.lightbulb, color: Colors.orange),
                            title: Text(
                              item.cups!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(AppLocalizations.of(context)!
                                .date_contract
                                .replaceAll("{date}", item.validDateFrom!)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
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
                                        builder: (context) =>
                                            ContractDetailScreen(
                                                cups: item.cups!,
                                                distributorCode:
                                                    item.distributorCode!)),
                                  );
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.view_contract),
                              ),
                              const Padding(padding: EdgeInsets.all(16.0)),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CalendarPage(supply: item)),
                                  );
                                },
                                child: Text(AppLocalizations.of(context)!
                                    .view_consumption),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      );
}