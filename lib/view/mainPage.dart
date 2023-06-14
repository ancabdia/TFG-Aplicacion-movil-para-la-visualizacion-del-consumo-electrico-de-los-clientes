
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    //if (widget.supply == null) {
    return Scaffold(
      appBar: AppBars(),
      body: IndexedStack(       //Sirve para no perder la referencia del tree y manter las paginas activas: https://youtu.be/xoKqQjSDZ60?t=532
        index: _selectedIndex,
        children: screens,
      )
      ,
      bottomNavigationBar: BottomNavigationBar(
       type: BottomNavigationBarType.shifting,
      fixedColor: Colors.blue,
      unselectedItemColor: Colors.blue,
      showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.home,
            activeIcon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder_copy_outlined),
            label: AppLocalizations.of(context)!.supplies,
            activeIcon: const Icon(Icons.folder),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_box_outlined),
            label: AppLocalizations.of(context)!.profile,
            activeIcon: const Icon(Icons.account_box)
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}




