import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/view/login.dart';
import 'package:tfgproyecto/view/mainPage.dart';

import 'API/db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database db = await DB.openDB();
  log(db.path);
  print(db.path);
  final prefs = await SharedPreferences.getInstance();
  String? logged = prefs.getString('datadisToken');
  final MyApp myApp = MyApp(
    initialRoute: logged == null ? '/' : '/home',
  );
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  const MyApp({super.key, this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      // Colores
      // primaryColor: Colors.blueGrey,

      // Tipografía
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
        bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
      ),

      // Efectos de sombra
      shadowColor: Colors.grey[500],
      cardTheme: CardTheme(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),

      // Barra de navegación
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        // color: Colors.blueGrey,
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),

      // Botones
      buttonTheme: ButtonThemeData(
        // buttonColor: Colors.blueGrey,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    ),
    initialRoute: initialRoute,
      routes: {
        '/':(context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/home' : (context) => const MainPage(),
      },
    );
  }
}
