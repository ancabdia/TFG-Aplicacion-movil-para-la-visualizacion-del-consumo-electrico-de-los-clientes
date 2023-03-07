import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/model/User.dart';

class DB{
  static Future<Database> openDB() async{
    var database = await openDatabase(
        join(await getDatabasesPath(), 'TFG.bd'),
        onCreate: (db, version){
          db.execute(
              "CREATE TABLE IF NOT EXISTS users(email TEXT PRIMARY KEY, password TEXT, name TEXT, surname TEXT, nif TEXT, datadisPassword TEXT);"
          );
          db.execute(
              "CREATE TABLE IF NOT EXISTS consumptions(cups TEXT PRIMARY KEY, date TEXT, time TEXT, consumptionKWh REAL, obtainMethod TEXT);"
          );
        },
        version: 1
    );
    return database;
  }

  static insert(User user) async {
    Database db = await openDB();
    return db.insert("users", user.toMap());
  }
}