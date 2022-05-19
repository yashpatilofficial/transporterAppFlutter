import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DeviceModel {
  int? deviceId;
  String? truckno;
  String? imei;
  String? status;
  String? lastUpdate;
  //truck Details Below
  int? tyre;
  String? passingWeight;
  String? category;
  String? contact;
  String? phone;

  DeviceModel({
    this.deviceId,
    this.truckno,
    this.imei,
    this.status,
    this.lastUpdate,
    this.tyre,
    this.passingWeight,
    this.category,
    this.contact,
    this.phone,
  });
}
