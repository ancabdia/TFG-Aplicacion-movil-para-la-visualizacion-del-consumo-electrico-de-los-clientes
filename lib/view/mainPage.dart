
import 'package:flutter/material.dart';
import 'package:tfgproyecto/view/home_screen.dart';
import 'package:tfgproyecto/view/profile.dart';
import 'package:tfgproyecto/view/supplies.dart';

import '../components/app_bar.dart';
import 'GraficoConsumo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
//  final Supply? supply;

  const MainPage({
    Key? key,
//    this.supply
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final screens =[
    const HomeScreenOld(),
    const SuppliesScreen(),
    // ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    //if (widget.supply == null) {
    return Scaffold(
      appBar: AppBars(title: AppLocalizations.of(context)!.language),
      body: IndexedStack(       //Sirve para no perder la referencia del tree y manter las paginas activas: https://youtu.be/xoKqQjSDZ60?t=532
        index: _selectedIndex,
        children: screens,
      )
      ,
      bottomNavigationBar: BottomNavigationBar(
//        type: BottomNavigationBarType.shifting,
        //  backgroundColor: Colors.amber,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.tips_and_updates_sharp),
            label: AppLocalizations.of(context)!.supplies,
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.manage_accounts),
            label: AppLocalizations.of(context)!.profile,
            backgroundColor: Colors.orange,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}




