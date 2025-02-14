import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:ui' as ui;
import 'mapUtils/getLoactionUsingImei.dart';

MapUtil mapUtil = MapUtil();
var startTimeParam;
var endTimeParam;
DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
List<LatLng> polylineCoordinates = [];
List<LatLng> polylineCoordinates2 = [];

//Date format functions---------------------------

getFormattedDateForDisplay2(String date){
  var timestamp = date
      .replaceAll(" ", "")
      .replaceAll("-", "")
      .replaceAll(":", "");
  var year = timestamp.substring(2, 4);
  var month = int.parse(timestamp.substring(4, 6));
  var day = timestamp.substring(6, 8);
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var monthname = DateFormat('MMM').format(DateTime(0, month));
  var ampm = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
  var truckDate = "$day $monthname $year, $ampm";
  return truckDate;
}

getISOtoIST(String date){
  var istDate =  new DateFormat("yyyy-MM-ddThh:mm:ss").parse(date).add(Duration(hours: 5, minutes: 30));
  var timestamp = istDate.toString()
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll(" ", "")
      .replaceAll(".", "");
      var year = timestamp.substring(0, 4);
      var month = int.parse(timestamp.substring(4, 6));
      var day = timestamp.substring(6, 8);
      var hour = int.parse(timestamp.substring(8, 10));
      var minute = int.parse(timestamp.substring(10, 12));
      var monthname  = DateFormat('MMM').format(DateTime(0, month));
      var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
      var truckDate = "$day $monthname $year, $ampm";
      print("ISO $truckDate");
      return truckDate;

}

getStopDuration(String from, String to){
  print("from : $from and to : $to");
  DateTime start=
  new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(from);
  DateTime end =
  new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(to);
  print("from : $start and to : $end");

  var diff = end.difference(start).toString();
  print("diff is $diff");
  DateTime dur =
  new DateFormat("HH:mm:ss").parse(diff);
  var timestamp = dur.toString()
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll(" ", "")
      .replaceAll(".", "");
  print("timestamp $timestamp");
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var second = int.parse(timestamp.substring(12, 14));
  var duration;
  if(hour==0 && second ==0)
    duration = "$minute min";
  else if(minute==0)
    duration = "$second sec";
  else if(second==0)
    duration = "$hour hr $minute min";
  else if(hour==0)
    duration = "$minute min $second sec";
  else
    duration = "$hour hr $minute min $second sec";
  print("Stop DUR is $duration");

  return duration;

}

//get GPS Data Model functions -------------------
getRouteStatusList(int? deviceId, String from, String to) async{
  var gpsRoute = await mapUtil.getTraccarTrips(
    deviceId: deviceId,
    from: from,
    to: to,
  );
  return gpsRoute;
}

getDataHistory(int? deviceId, String from, String to) async{
  // getFormattedDate(start, end);
  var gpsDataHistory =
  await mapUtil.getTraccarHistory(
      deviceId: deviceId,
      from: from,
      to: to,
      );
  return gpsDataHistory;

}

getStoppageHistory(int? deviceId, String from, String to) async{
  // getFormattedDate(start, end);
  var gpsStoppageHistory =
  await mapUtil.getTraccarStoppages(
    deviceId: deviceId,
    from: from,
    to: to
  );
  return gpsStoppageHistory;
}

//Return list of polyline coordinates

getPoylineCoordinates(var gpsDataHistory){
  var logger = Logger();
  logger.i("in polyline after function");
  polylineCoordinates.clear();
  int a=0;
  int b=a+3;
  int c=0;
  print("length ${gpsDataHistory.length}");
  print("End lat ${gpsDataHistory[gpsDataHistory.length-1].latitude}");
  for(int i=0; i<gpsDataHistory.length; i++) {
    c=b+3;
    PointLatLng point1 =  PointLatLng(gpsDataHistory[a].latitude,  gpsDataHistory[a].longitude);
    PointLatLng point2 =  PointLatLng(gpsDataHistory[b].latitude,  gpsDataHistory[b].longitude);
    polylineCoordinates.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates.add(LatLng(point2.latitude, point2.longitude));
    a=b;
    b=c;
    if(b>=gpsDataHistory.length){
      break;
    }
  } // get polyline between every two lat long obtained from response body

  if(gpsDataHistory.length%2==0){
    print("In even ");
    PointLatLng point1 =  PointLatLng(gpsDataHistory[gpsDataHistory.length-2].latitude,  gpsDataHistory[gpsDataHistory.length-2].longitude);
    PointLatLng point2 =  PointLatLng(gpsDataHistory[gpsDataHistory.length-1].latitude,  gpsDataHistory[gpsDataHistory.length-1].longitude);
    polylineCoordinates.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates.add(LatLng(point2.latitude, point2.longitude));
  }
  print("POLY $polylineCoordinates");
  return polylineCoordinates;
}

getPoylineCoordinates2(var gpsDataHistory2){
  var logger = Logger();
  logger.i("in polyline 2 function");
  polylineCoordinates2.clear();
  int a=0;
  int b=a+1;
  int c=0;
  print("length ${gpsDataHistory2.length}");
  print("End lat ${gpsDataHistory2[gpsDataHistory2.length-1].latitude}");
  for(int i=0; i<gpsDataHistory2.length; i++) {
    c=b+1;
    PointLatLng point1 =  PointLatLng(gpsDataHistory2[a].latitude,  gpsDataHistory2[a].longitude);
    PointLatLng point2 =  PointLatLng(gpsDataHistory2[b].latitude,  gpsDataHistory2[b].longitude);
    polylineCoordinates2.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates2.add(LatLng(point2.latitude, point2.longitude));
    a=b;
    b=c;
    if(b>=gpsDataHistory2.length){
      break;
    }
  } // get polyline between every two lat long obtained from response body

  if(gpsDataHistory2.length%2==0){
    print("In even ");
    PointLatLng point1 =  PointLatLng(gpsDataHistory2[gpsDataHistory2.length-2].latitude,  gpsDataHistory2[gpsDataHistory2.length-2].longitude);
    PointLatLng point2 =  PointLatLng(gpsDataHistory2[gpsDataHistory2.length-1].latitude,  gpsDataHistory2[gpsDataHistory2.length-1].longitude);
    polylineCoordinates2.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates2.add(LatLng(point2.latitude, point2.longitude));
  }
  return polylineCoordinates2;
}


//STOPPAGE FUNCTIONS----------------------

getStoppageTime(var gpsStoppageHistory) {
  String truckStart ;
  String truckEnd ;
  var stoppageTime;

  // for(int i=0; i<gpsStoppageHistory.length; i++) {
 //   print("start time is  ${gpsStoppageHistory[i].startTime}");
    // final dateTime = DateTime.parse('2021-08-11T11:38:09.000Z');
    // print(convertDateTimeToString(dateTime));
 //   var istDate =  new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(gpsStoppageHistory[i].startTime);
//    print("here $istDate");
 //   istDate = istDate.add(Duration(hours: 5, minutes: 30));
  //  print("hh $istDate");
  //  print("isDate $istDate");
    var istDate =  new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(gpsStoppageHistory.startTime).add(Duration(hours: 5, minutes: 30));
  //  print("IST $istDate");
    var timestamp = istDate.toString()
        .replaceAll("-", "")
        .replaceAll(":", "")
        .replaceAll(" ", "")
        .replaceAll(".", "");
  //  print("timestamp is $timestamp");
    var month = int.parse(timestamp.substring(4, 6));
    var day = timestamp.substring(6, 8);
    var hour = int.parse(timestamp.substring(8, 10));
    var minute = int.parse(timestamp.substring(10, 12));
    var monthname  = DateFormat('MMM').format(DateTime(0, month));
    var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
    truckStart = "$day $monthname,$ampm";
    print("ISO $truckStart");

    var istDate2 =  new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(gpsStoppageHistory.endTime).add(Duration(hours: 5, minutes: 30));
    print("IST $istDate2");
    var timestamp2 = istDate2.toString()
        .replaceAll("-", "")
        .replaceAll(":", "")
        .replaceAll(" ", "")
        .replaceAll(".", "");
    print("timestamp is $timestamp2");
    var month2 = int.parse(timestamp2.substring(4, 6));
    var day2 = timestamp2.substring(6, 8);
    var hour2 = int.parse(timestamp2.substring(8, 10));
    var minute2 = int.parse(timestamp2.substring(10, 12));
    var monthname2  = DateFormat('MMM').format(DateTime(0, month2));
    var ampm2  = DateFormat.jm().format(DateTime(0, 0, 0, hour2, minute2));
    if("$day2 $monthname2,$ampm2" == "$day $monthname,$ampm")
      truckEnd = "Present";
    else
      truckEnd = "$day2 $monthname2,$ampm2";

    stoppageTime="$truckStart - $truckEnd";
  // }
  print("Stop time $stoppageTime");
  return stoppageTime;
}

getStoppageDuration(var gpsStoppageHistory){
  var duration;
  // for(int i=0; i<gpsStoppageHistory.length; i++) {
    if(gpsStoppageHistory.duration==0)
      duration="Ongoing";
    else {
      var time = new Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: gpsStoppageHistory.duration).toString();
      var time2 =  new DateFormat("hh:mm:ss").parse(time).toString();
      var dur = time2.substring(0, time2.indexOf('.'));

      var timestamp = dur.toString()
          .replaceAll("-", "")
          .replaceAll(":", "")
          .replaceAll(" ", "");
      var hour = int.parse(timestamp.substring(8, 10));
      var minute = int.parse(timestamp.substring(10, 12));
      var second = int.parse(timestamp.substring(12, 14));
      if(hour==0 && second ==0)
        duration="$minute min";
      else if(minute==0)
        duration="$second sec";
      else if(second==0)
        duration="$hour hr $minute min";
      else if(hour==0)
        duration="$minute min $second sec";
      else
        duration="$hour hrs $minute min $second sec";
    // }
  }
  return duration;
  }

getStoppageAddress(var gpsStoppageHistory) async{
  var stopAddress;
  // for(int i=0; i<gpsStoppageHistory.length; i++) {
    List<Placemark> placemarks = await placemarkFromCoordinates(gpsStoppageHistory.latitude, gpsStoppageHistory.longitude);
    var first = placemarks.first;
    print("${first.subLocality},${first.locality},${first.administrativeArea}\n${first.postalCode},${first.country}");

    if(first.subLocality=="")
      stopAddress="${first.street}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
    else
      stopAddress="${first.street}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";

  // }
  return stopAddress;
}

getStopList(var newGPSRoute){
  int i=0;
  var start;
  var end;
  var duration;
  bool last = false;
  var lastStop = newGPSRoute[newGPSRoute.length -1].endTime;
  DateTime now = DateTime.now().subtract(Duration(days: 0, hours: 5, minutes: 30));

  DateTime nowDateFormat=
  new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(now.toIso8601String());
  DateTime lastStopDateFormat =
  new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(newGPSRoute[newGPSRoute.length -1].endTime);
  if(lastStopDateFormat.compareTo(nowDateFormat) <=0)    //Check if end time of last trip is less than current time, if yes, then add stop at end
  {
    last = true;
  }

  int length = newGPSRoute.length;
  print("GpsRoute Length ${length}");
  while(i<newGPSRoute.length){
    print("i $i");
    if(i==0) {
      DateTime yesterday = DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
      start = getISOtoIST(yesterday.toIso8601String());
      end = getISOtoIST(newGPSRoute[i].startTime);
      
      duration = getStopDuration(yesterday.toIso8601String(), newGPSRoute[i].startTime);
      newGPSRoute.insert(i, ["stopped", start, end, duration,newGPSRoute[i].latitude,newGPSRoute[i].longitude]);
    } else {
      start = getISOtoIST(newGPSRoute[i - 1].endTime);
      end = getISOtoIST(newGPSRoute[i].startTime);
      duration = getStopDuration(newGPSRoute[i - 1].endTime, newGPSRoute[i].startTime);
      newGPSRoute.insert(i, ["stopped", start, end, duration,newGPSRoute[i].latitude,newGPSRoute[i].longitude]);
    }
    i = i+2;
  }

  if(last)         //to add stop at end
  {
    start = getISOtoIST(lastStop);
    end = getISOtoIST(now.toIso8601String());
    duration = getStopDuration(lastStop, now.toIso8601String());
    newGPSRoute.add(["stopped", start, end, duration, newGPSRoute.last.endLat, newGPSRoute.last.endLon]);
  }
  print("With Stops $newGPSRoute");
  return newGPSRoute;
}

//STOP MARKER -------------
Future<Uint8List> getBytesFromCanvas(int customNum, int width, int height) async  {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.red;
  final Radius radius = Radius.circular(width/2);
  // canvas.drawRect(Offset(0, -100) & const Size(500, 500), paint);
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(),  height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint);

  TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
  painter.text = TextSpan(
    text: customNum.toString(), // your custom number here
    style: TextStyle(fontSize: 50.0, color: Colors.white),
  );

  painter.layout();
  painter.paint(
      canvas,
      Offset((width * 0.5) - painter.width * 0.5,
          (height * .5) - painter.height * 0.5));
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}//Info Window for mapscreen
Future<Uint8List> getBytesFromCanvas3(String truckNo, int width, int height) async{
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.black.withAlpha(100);
  final Radius radius = Radius.circular(10);
  canvas.drawRect(Offset(100, -100) & const Size(500, 250), paint);

  TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
  
  TextPainter painter2 = TextPainter(textDirection: ui.TextDirection.ltr);
  painter2.text = TextSpan(
    text: truckNo, // your custom number here
    style: TextStyle(fontSize: 34.0, color: Colors.white),
  );
  painter2.layout();
  painter2.paint(
      canvas,
      Offset(190,
          65));
  final img = await pictureRecorder.endRecording().toImage(500, 250);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

//INFO WINDOW FOR PLAY ROUTE HISTORY ---------------------------
Future<Uint8List> getBytesFromCanvas2(String time, String speed, int width, int height) async{
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.black.withAlpha(100);
  final Radius radius = Radius.circular(10);
  canvas.drawRect(Offset(100, -100) & const Size(500, 250), paint);

  TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
  painter.text = TextSpan(
    text: time, // your custom number here
    style: TextStyle(fontSize: 34.0, color: Colors.white),
  );
  painter.layout();
  painter.paint(
      canvas,
      Offset(190,
          30));
  TextPainter painter2 = TextPainter(textDirection: ui.TextDirection.ltr);
  painter2.text = TextSpan(
    text: speed, // your custom number here
    style: TextStyle(fontSize: 34.0, color: Colors.white),
  );
  painter2.layout();
  painter2.paint(
      canvas,
      Offset(190,
          65));
  final img = await pictureRecorder.endRecording().toImage(500, 250);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

//Display data on TRACK SCREEN -----------
getTotalRunningTime(var routeHistory){
  var totalRunning;
  var duration = 0;
  print("route history length ${routeHistory.length}");
  for(var instance in routeHistory) {
    print("Duration : ${instance.duration}");
    duration += (instance.duration) as int;
  }
  totalRunning = convertMillisecondsToDuration(duration);
  print("Total running $totalRunning");
  return totalRunning;
}

getTotalStoppageTime(var routeHistory){
  var totalStopped;
  var duration = 0;
  print("stop history length ${routeHistory.length}");
  for(var instance in routeHistory) {
    duration += (instance.duration) as int;
  }
  print("total $duration");
  totalStopped = convertMillisecondsToDuration(duration);
  print("Total stopped $totalStopped");
  return totalStopped;
}

getTotalDistance(var tripHistory){
  var total = 0.0;
  var totalDist = 0.0;
  for(var instance in tripHistory){
    total += (instance.distance) as double;
  }
  totalDist = total/1000;
  print("Total distance $totalDist");
  return (totalDist.toStringAsFixed(2));
}

getStatus(var gpsData, var gpsStoppageHistory){
  String status;
  if(gpsData.last.motion == false)
  {
    var timestamp1 =  gpsStoppageHistory.last.startTime.toString();

    DateTime truckTime = new DateFormat("yyyy-MM-ddTHH:mm:ss")
        .parse(timestamp1).add(Duration(hours: 5, minutes: 30));

    var now = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now());
    DateTime nowTime = DateTime.parse(now);
    Duration constraint = Duration(hours: 0, minutes: 0, seconds: 15);

    print("One is $truckTime");
    print("two is $now");

    var diff = nowTime.difference(truckTime).toString();
    var diff2 = nowTime.difference(truckTime);
    print("diff is $diff");
    double speed = gpsData.last.speed;
    var v = diff.toString().split(":");
    if (speed <= 2 && diff2.compareTo(constraint) > 0) {
      if (v[0] == "0")
        status = "Stopped since ${v[1]} min ";
      else if((v[1] == "00") && (v[0] == "0"))
        status = "Stopped since ${(double.parse(v[2])).toStringAsFixed(1)} sec";
      else
        status = "Stopped since ${v[0]} hrs : ${v[1]} min";
    } else {
      print("Running : ${(gpsData.last.speed).toStringAsFixed(2)} km/h");
      status = "Running : ${(gpsData.last.speed).toStringAsFixed(2)} km/h";
    }
  }
  else
    status = "Running : ${(gpsData.last.speed).toStringAsFixed(2)} km/h";
  print("STATUS : $status");
  return status;
}

//MILLISECONDS TO HRS MIN SEC---------------
convertMillisecondsToDuration(int time){
  var formatted;
  var time2 = new Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: time).toString();
  var time3 =  new DateFormat("HH:mm:ss").parse(time2).toString();
  var dur = time3.substring(0, time3.indexOf('.'));
  var timestamp = dur.toString()
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll(" ", "");
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var second = int.parse(timestamp.substring(12, 14));
  if(hour==0 && second ==0)
    formatted = "$minute min";
  else if(minute==0)
    formatted = "$second sec";
  else if(second==0)
    formatted = "$hour hr $minute min";
  else if(hour==0)
    formatted = "$minute min $second sec";
  else
    formatted = "$hour hrs $minute min $second sec";
  print("Formatted $formatted");
  return formatted;
}


