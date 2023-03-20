
import 'package:flutter/material.dart';
import 'package:tfgproyecto/view/home_screen.dart';
import 'package:tfgproyecto/view/profile.dart';

import '../components/app_bar.dart';
import 'GraficoConsumo.dart';

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
    const GraficoConsumo(),
    // ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    //if (widget.supply == null) {
    return Scaffold(
      appBar: AppBars(title: const Text("App Consumos"), context: context,),
      body: IndexedStack(       //Sirve para no perder la referencia del tree y manter las paginas activas: https://youtu.be/xoKqQjSDZ60?t=532
        index: _selectedIndex,
        children: screens,
      )
      ,
      bottomNavigationBar: BottomNavigationBar(
//        type: BottomNavigationBarType.shifting,
        //  backgroundColor: Colors.amber,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates_sharp),
            label: 'Suministros',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Perfil',
            backgroundColor: Colors.orange,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}




