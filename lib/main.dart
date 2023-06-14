import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/API/encrypter.dart';
import 'package:tfgproyecto/model/Language.dart';
import 'package:tfgproyecto/provider/locale_provider.dart';
import 'package:tfgproyecto/view/login.dart';
import 'package:tfgproyecto/view/mainPage.dart';
import 'API/db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  Intl.systemLocale = await findSystemLocale();
  WidgetsFlutterBinding.ensureInitialized();
  Database db = await DB.openDB();
  encryptInit();
  log(db.path);
  final prefs = await SharedPreferences.getInstance();
  String? logged = prefs.getString('email');
  print(logged);
  final MyApp myApp = MyApp(
    initialRoute: logged == null ? '/' : '/home',
    initLanguage: prefs.getString("language"),
  );
  // initializeDateFormatting().then((_) => runApp(const MyApp()));
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  final String? initLanguage;
  const MyApp({super.key, this.initialRoute, this.initLanguage});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("initLanguage: $initLanguage");
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        if(initLanguage == null) provider.locale; else provider.setLocale(Locale(initLanguage!));
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // Colores
          // primaryColor: Colors.blueGrey,
          // Tipografía
          fontFamily: 'Roboto',
          // Efectos de sombra
          shadowColor: Colors.grey[500],
          cardTheme: CardTheme(
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
    
          // Barra de navegación
          appBarTheme: const AppBarTheme(
            elevation: 0.0,
            // color: Colors.blueGrey,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          // Botones
          buttonTheme: ButtonThemeData(
            // buttonColor: Colors.blueGrey,
            textTheme: ButtonTextTheme.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
        initialRoute: initialRoute,
        routes: {
          '/': (context) => LoginScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => const MainPage(),
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('en', 'US'),
          Locale('de', 'DE'),
        ],
        locale: provider.locale,
      );
      },
    );
  }
}
