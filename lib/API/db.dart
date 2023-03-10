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
              "CREATE TABLE IF NOT EXISTS users(email TEXT PRIMARY KEY, password TEXT, name TEXT, surname TEXT, nif TEXT UNIQUE, datadisPassword TEXT);"
          );
          db.execute(
              "CREATE TABLE IF NOT EXISTS supplies(cups TEXT PRIMARY KEY, address TEXT, postalCode TEXT, province TEXT, municipality TEXT, distributor TEXT ,validDateFrom TEXT, validDateTo TEXT, pointType INTEGER, distributorCode TEXT, userId TEXT, FOREIGN KEY(userId) REFERENCES users(email));"
          );
          db.execute(
              "CREATE TABLE IF NOT EXISTS consumptions(cups TEXT PRIMARY KEY, date TEXT, time TEXT, consumptionKWh REAL, obtainMethod TEXT, supplyId TEXT, FOREIGN KEY(supplyId) REFERENCES supplies(cups));"
          );
        },
        version: 1
    );
    return database;
  }
}