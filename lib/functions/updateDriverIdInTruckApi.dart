import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

updateDriverIdInTruckApi(selectedTruckId, selectedDriverId) async {
  final String truckApiUrl = FlutterConfig.get("truckApiUrl").toString();
  Map data = {"driverId": selectedDriverId};
  String body = json.encode(data);
  final response = await http.put(Uri.parse("$truckApiUrl/$selectedTruckId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  print(response.body);
}
