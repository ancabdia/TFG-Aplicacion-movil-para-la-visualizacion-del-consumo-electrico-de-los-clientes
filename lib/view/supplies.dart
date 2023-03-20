import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../API/API.dart';
import '../model/Supply.dart';

class SuppliesScreen extends StatefulWidget {
  const SuppliesScreen({Key? key}) : super(key: key);

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

Future<List<Supply>> getSupplies() async {
  return await API.getSupplies();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  @override
  Widget build(BuildContext context) => 
    Scaffold(body: FutureBuilder<List<Supply>>(
        future: getSupplies(),
        builder: (context, snapshot) {
          print(snapshot);
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



class SupplyList extends StatelessWidget {
  const SupplyList({super.key, required this.supplies});

  final List<Supply> supplies;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: supplies.length,
        itemBuilder: (context, index) {
          final item = supplies[index];
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
                  subtitle: Text("Fecha del contrato ${item.validDateFrom}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      'Suministro con direccion: ${item.address} ${item.municipality} ${item.province}'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton(
                    onPressed: () async {
                      debugPrint("Consultar contrato con cups ${item.cups}");
                      //ContractDetail contractDetail = await getContractDetail(item.cups, item.distributorCode!);
                      // ignore: use_build_context_synchronously
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ContractDetailScreen(cups: item.cups, distributorCode: item.distributorCode!)
                      //   ),
                      // );
                    },
                    child: const Text('Consultar contrato'),
                  ),
                  const Padding(padding: EdgeInsets.all(16.0)),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint("Consultar consumos con cups ${item.cups}");
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ComsupmtionScreen(cups: item.cups, distributorCode: item.distributorCode!)
                      //   ),
                      // );
                    },
                    child: const Text('Consultar consumos'),
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
  }
}