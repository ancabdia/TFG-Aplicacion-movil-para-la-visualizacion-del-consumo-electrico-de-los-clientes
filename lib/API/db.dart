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

        //INSERT RAW DATA INTO DB    
        db.execute(
          "INSERT INTO users('email', 'password', 'name', 'surname', 'nif', 'datadisPassword') VALUES ('test@gmail.com', '5wh1rOhM+UFhUfNt1Y4kGA==', 'Test', 'Surname Test', '12345678Y', '5wh1rOhM+UFhUfNt1Y4kGA==');");
        db.execute(
          "INSERT INTO supplies('cups', 'address', 'postalCode', 'province', 'municipality', 'distributor', 'validDateFrom', 'validDateTo', 'pointType', 'distributorCode', 'userId') VALUES ('ES0000000000000000QX0W', 'SIN NOMBRE', '35011', 'Las Palmas', 'PALMAS DE GRAN CANARIA, LAS', 'EDISTRIBUCIÓN', '2021/07/22', '', '5', '2', 'test@gmail.com');");
        db.execute(
          "INSERT INTO contracts('cups', 'distributor', 'marketer', 'tension', 'accessFare', 'province', 'municipality', 'postalCode', 'contractedPowerkWMin', 'contractedPowerkWMax', 'timeDiscrimination', 'startDate') VALUES ('ES0000000000000000QX0W', 'EDISTRIBUCIÓN', 'ENDESA ENERGÍA S.A.U.', 'Baja tensión', 'BAJA TENSION y POTENCIA <= 15 kW', 'Las Palmas', 'PALMAS DE GRAN CANARIA, LAS', '35011', '3.3', '3.4', 'TARIFA DE EJEMPLO', '2023/06/13');");
        db.execute(
          "INSERT INTO consumptions ('date', 'time', 'consumptionKWh', 'obtainMethod', 'supplyId') VALUES ('2023/03/31', '01:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '02:00', '0.3', 'Real', 'ES0000000000000000QX0W'), ('2023/03/31', '03:00', '0.3', 'Real', 'ES0000000000000000QX0W'), ('2023/03/31', '04:00', '0.3', 'Real', 'ES0000000000000000QX0W'), ('2023/03/31', '05:00', '0.3', 'Real', 'ES0000000000000000QX0W'), ('2023/03/31', '06:00', '0.3', 'Real', 'ES0000000000000000QX0W'), ('2023/03/31', '07:00', '0.3', 'Real', 'ES0000000000000000QX0W'), ('2023/03/31', '08:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '09:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '10:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '11:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '12:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '13:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '14:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '15:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '16:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '17:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '18:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '19:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '20:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '21:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '22:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '23:00', '0.3', 'Real', 'ES0000000000000000QX0W'),('2023/03/31', '24:00', '0.3', 'Real', 'ES0000000000000000QX0W');"
        );
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
