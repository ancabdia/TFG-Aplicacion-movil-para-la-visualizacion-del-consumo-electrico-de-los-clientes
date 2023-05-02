import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/model/User.dart';

class DB {
  static Future<Database> openDB() async {
    var database = await openDatabase(
      join(await getDatabasesPath(), 'TFG.bd'),
      onCreate: (db, version) {
        db.execute("PRAGMA foreign_keys = ON");
        db.execute(
            "CREATE TABLE IF NOT EXISTS users(email TEXT PRIMARY KEY, password TEXT, name TEXT, surname TEXT, nif TEXT UNIQUE, datadisPassword TEXT);");
        db.execute(
            "CREATE TABLE IF NOT EXISTS supplies(cups TEXT PRIMARY KEY, address TEXT, postalCode TEXT, province TEXT, municipality TEXT, distributor TEXT ,validDateFrom TEXT, validDateTo TEXT, pointType INTEGER, distributorCode TEXT, userId TEXT, FOREIGN KEY(userId) REFERENCES users(email));");
        db.execute(
            "CREATE TABLE IF NOT EXISTS consumptions(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, time TEXT, consumptionKWh REAL, obtainMethod TEXT, supplyId TEXT, FOREIGN KEY(supplyId) REFERENCES supplies(cups));");
        db.execute(
            "CREATE TABLE IF NOT EXISTS contracts(cups TEXT PRIMARY KEY, distributor TEXT, marketer	TEXT, tension	TEXT, accessFare TEXT, province	TEXT, municipality TEXT, postalCode	TEXT, contractedPowerkWMin REAL, contractedPowerkWMax	REAL, timeDiscrimination TEXT, startDate TEXT);");
      },
      version: 1,
      onOpen: (db) {
        db.execute("PRAGMA foreign_keys = ON");
        db.execute(
            "CREATE TABLE IF NOT EXISTS users(email TEXT PRIMARY KEY, password TEXT, name TEXT, surname TEXT, nif TEXT UNIQUE, datadisPassword TEXT);");
        db.execute(
            "CREATE TABLE IF NOT EXISTS supplies(cups TEXT PRIMARY KEY, address TEXT, postalCode TEXT, province TEXT, municipality TEXT, distributor TEXT ,validDateFrom TEXT, validDateTo TEXT, pointType INTEGER, distributorCode TEXT, userId TEXT, FOREIGN KEY(userId) REFERENCES users(email));");
        db.execute(
            "CREATE TABLE IF NOT EXISTS consumptions(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, time TEXT, consumptionKWh REAL, obtainMethod TEXT, supplyId TEXT, FOREIGN KEY(supplyId) REFERENCES supplies(cups));");
        db.execute(
            "CREATE TABLE IF NOT EXISTS contracts(cups TEXT PRIMARY KEY, distributor TEXT, marketer	TEXT, tension	TEXT, accessFare TEXT, province	TEXT, municipality TEXT, postalCode	TEXT, contractedPowerkWMin REAL, contractedPowerkWMax	REAL, timeDiscrimination TEXT, startDate TEXT);");
      },
    );
    return database;
  }

  static Future<List<String>> getProvinces() async {
    Database database = await DB.openDB();
    var listProvinces =
        await database.rawQuery("SELECT DISTINCT province FROM contracts;");
    List<String> result =
        listProvinces.map((e) => e.entries.first.value.toString()).toList();
    return result;
  }

  static getMunicipalities(String province) async {
    Database database = await DB.openDB();
    var listProvinces = await database.rawQuery(
        "SELECT DISTINCT municipality FROM contracts WHERE province = '$province';");
    return listProvinces.map((e) => e.entries.first.value).toList();
  }

  static getSuppliesFilter(String province, String municipality, String date, String cups) async{
    Database database = await DB.openDB();
    var listProvinces;
    if(municipality == ''){
      listProvinces = await database.rawQuery(
        "SELECT consumptions.* FROM consumptions JOIN contracts ON consumptions.supplyId = contracts.cups WHERE province = '$province' AND date = '$date' AND supplyId IS NOT '$cups';");
    }else{
      listProvinces = await database.rawQuery(
        "SELECT consumptions.* FROM consumptions JOIN contracts ON consumptions.supplyId = contracts.cups WHERE province = '$province' AND municipality = '$municipality' AND date = '$date' AND supplyId IS NOT '$cups';");
    }
    
    return listProvinces.map((e) => e).toList();
  }
}
