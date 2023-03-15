import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tfgproyecto/model/ContractDetail.dart';

import '../model/Consumption.dart';
import '../model/Power.dart';
import '../model/Prices.dart';
import '../model/Supply.dart';

class API {
  static Future<List<Price>> fetchPrices() async {
    final response = await http
        .get(Uri.parse('https://api.preciodelaluz.org/v1/prices/all?zone=PCB'));

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      List<Price> prices = [];
      jsonMap.forEach((key, value) {
        prices.add(Price(
            hour: value['hour'],
            cheap: value['is-cheap'],
            price: value['price']/1000));
      });
      return prices;
    } else {
      throw Exception('Failed to fetch prices');
    }
  }

  static Future<Price> fetchPrice(String type) async {
    final response = await http
        .get(Uri.parse('https://api.preciodelaluz.org/v1/prices/$type?zone=PCB'));

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);  
        Price p = Price(hour: jsonMap['hour'], cheap: jsonMap['is-cheap'], price: jsonMap['price']/1000);
        return p;
    } else {
      throw Exception('Failed to fetch $type price');
    }
  }

  static String apiBase = "https://datadis.es";
  static String apiBasePrivate = "https://datadis.es/api-private";

  /// Obtiene el token de autenticación para el área privada.
  /// @param username: NIF del usuario dado de alta en Datadis
  /// @param password: Contraseña de acceso a Datadis del usuario
  /// @return token de autentificación
  Future<String> postLogin(String username, String password) async {
    final uri = Uri.parse('https://datadis.es/nikola-auth/tokens/login');
    final queryParams = {'username': username, 'password': password};
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(uri.replace(queryParameters: queryParams),
        headers: headers);

    return response.statusCode == 200
        ? jsonDecode(response.body)['token'] as String
        : throw Exception('Failed to log in');
  }

  ///Buscar todos los suministros
  Future<List<Supply>> getSupplies(String bearerToken) async {
    final url = Uri.parse('https://datadis.es/api-private/api/get-supplies');
    final headers = {'Authorization': 'Bearer $bearerToken'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final supplies =
          List<Map<String, dynamic>>.from(jsonResponse['supplies']);
      return supplies.map((json) => Supply.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load supplies');
    }
  }

  ///Obtener detalles de un suministro
  Future<ContractDetail> getContractDetail(
      String bearerToken, String cups, int distributorCode) async {
    final uri =
        Uri.parse('https://datadis.es/api-private/api/get-contract-detail');
    final headers = {'Authorization': 'Bearer $bearerToken'};
    final queryParams = {'cups': cups, 'distributorCode': distributorCode};

    final response = await http.get(uri.replace(queryParameters: queryParams),
        headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      ContractDetail contractDetail = ContractDetail.fromJson(jsonResponse);
      return contractDetail;
    } else {
      throw Exception('Failed to load Contract Detail');
    }
  }

  ///Obtener consumos de un suministro
  Future<List<Consumption>> getConsumptionData(
      String bearerToken,
      String cups,
      String distributorCode,
      String startDate,
      String endDate,
      String pointType) async {
    final uri =
        Uri.parse('https://datadis.es/api-private/api/get-consumption-data');
    final headers = {'Authorization': 'Bearer $bearerToken'};
    final queryParams = {
      'cups': cups,
      'distributorCode': distributorCode,
      'startDate': startDate,
      'endDate': endDate,
      'measurementType': "0",
      'pointType': pointType
    };

    final response = await http.get(uri.replace(queryParameters: queryParams),
        headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final consumptions =
          List<Map<String, dynamic>>.from(jsonResponse['consumptions']);
      return consumptions.map((json) => Consumption.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load consumptions');
    }
  }

  ///Obtener potencias de un suministro
  Future<List<Power>> getMaxPower(String bearerToken, String cups,
      String distributorCode, String startDate, String endDate) async {
    final uri =
        Uri.parse('https://datadis.es/api-private/api/get-consumption-data');
    final headers = {'Authorization': 'Bearer $bearerToken'};
    final queryParams = {
      'cups': cups,
      'distributorCode': distributorCode,
      'startDate': startDate,
      'endDate': endDate
    };

    final response = await http.get(uri.replace(queryParameters: queryParams),
        headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final powers = List<Map<String, dynamic>>.from(jsonResponse['powers']);
      return powers.map((json) => Power.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load consumptions');
    }
  }
}