import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/trucksNearUserController.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/nearbyTrucksCard.dart';

class NearbyTrucksResult extends StatefulWidget {
  List gpsDataList;
  List deviceList;
  //List status;
  //List items;

  NearbyTrucksResult({
    required this.gpsDataList,
    required this.deviceList,
    //required this.status,
    //required this.items
  });

  @override
  _NearbyTrucksResultState createState() => _NearbyTrucksResultState();
}

class _NearbyTrucksResultState extends State<NearbyTrucksResult> {
  ScrollController scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  var _currentPosition;
  var customGpsDataList = [];
  var customDeviceList = [];
  var customRunningDataList = [];
  var customRunningGpsDataList = [];
  var customStoppedList = [];
  var customStoppedGpsList = [];
  var rangeDistance;
  // var truckDataList = [];
  var deviceList = [];
  //var status = [];
  String dropdownValue = '50 Km';
  var distanceRequired = 4;
  List<String> _distance = [
    '50 Km',
    '100 Km',
    '200 Km',
    '300 Km',
    '400 Km',
  ];
  var truckDistance = [];

  TrucksNearUserController trucksNearUserController =
      Get.put(TrucksNearUserController());

  @override
  void initState() {
    customGpsDataList = widget.gpsDataList;
    customDeviceList = widget.deviceList;
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..maskColor = darkBlueColor
      ..userInteractions = false
      ..backgroundColor = darkBlueColor
      ..dismissOnTap = false;
    EasyLoading.show(
      status: "Loading...",
    );
    // customRunningDataList = widget.runningDataList;
    // customRunningGpsDataList = widget.runningGpsDataList;
    // customStoppedList = widget.stoppedList;
    // customStoppedGpsList = widget.stoppedGpsList;
    _getCurrentLocation();

    //status = widget.status;
    //deviceList = widget.deviceList;
    //print("CHECK Init${status}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            //color: darkBlueColor,
            padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
            height: MediaQuery.of(context).size.height -
                kBottomNavigationBarHeight -
                space_4,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /*  SizedBox(
                      width: space_3,
                    ),*/
                        HeadingTextWidget("Nearby  Trucks"
                            // AppLocalizations.of(context)!.my_truck
                            ),
                      ],
                    ),
                    HelpButtonWidget(),
                  ],
                ),
                Container(
                  //margin: EdgeInsets.symmetric(vertical: space_3),
                  //color: Colors.red,
                  child: Container(
                      //height: space_8,

                      child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        print(dropdownValue);
                        customSelection(dropdownValue);
                        mapAllTrucksNearUser();
                      });
                    },
                    items:
                        _distance.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
                ),
                Text(
                  "CURRENT DISTANCE: ${distanceRequired}",
                  style: TextStyle(fontSize: 20),
                ),
                //Text("${customGpsDataList[1].deviceId}")
                Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(bottom: space_15),
                      itemCount: customDeviceList.length,
                      itemBuilder: (context, index) =>
                          index == customDeviceList.length
                              ? bottomProgressBarIndicatorWidget()
                              :
                              //Text("data ${customDeviceList[index]}")
                              NearbyTruckCard(
                                  deviceList: customDeviceList[index],
                                  //status: status[index],
                                  gpsData: customGpsDataList[index],
                                  //device: items[index],
                                )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(
            "CURRENT LOCATION IS ${_currentPosition.latitude} AND ${_currentPosition.longitude}");
        //widget.gpsDataList[1].latitude
        print(
            "CURRENT LOCATION IS ${widget.gpsDataList[1].latitude} AND ${widget.gpsDataList[1].longitude}");
        mapAllTrucksNearUser();
      });
    }).catchError((e) {
      print(e);
    });
  }

  void mapAllTrucksNearUser() {
    // customGpsDataList = [];
    // customDeviceList = [];
    // customRunningDataList = [];
    // customRunningGpsDataList = [];
    // customStoppedList = [];
    // customStoppedGpsList = [];

    var customGpsDataListDummy = [];
    var customDeviceListDummy = [];
    // var customRunningDataListDummy = [];
    // var customRunningGpsDataListDummy = [];
    // var customStoppedListDummy = [];
    // var customStoppedGpsListDummy = [];

    print("INSIDE THE MAP_ALLFUNCTION");
    print(trucksNearUserController.distanceRadius.value);
    print(
        "THE CONTENT IS ${widget.gpsDataList[0]} and the lenght is ${widget.gpsDataList.length}");
    //var j = 0;
    for (var i = 0; i < widget.gpsDataList.length; i++) {
      print(widget.gpsDataList[i]);
      var distanceStore = Geolocator.distanceBetween(
              widget.gpsDataList[i].latitude,
              widget.gpsDataList[i].longitude,
              _currentPosition.latitude,
              _currentPosition.longitude) /
          1000;
      print(distanceStore);
      print("THE CODE VALUE ${trucksNearUserController.distanceRadius.value}");
      if (distanceStore <= distanceRequired) {
        print("TRYINGGGGGG distance $distanceRequired");
        customGpsDataListDummy.add(widget.gpsDataList[i]);
        customDeviceListDummy.add(widget.deviceList[i]);
      }
    }

    setState(() {
      customGpsDataList = [];
      customDeviceList = [];

      customGpsDataList.addAll(customGpsDataListDummy);
      customDeviceList.addAll(customDeviceListDummy);

      print("THE NEW LIST HAS ${customGpsDataList} and ${customDeviceList}");
      EasyLoading.dismiss();
      // AllMapWidget(
      //     gpsDataList: customGpsDataList, truckDataList: customGpsDataList);
    });
    //print("OUT OF FORRRR");
    return;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  customSelection(String? choice) {
    switch (choice) {
      case '50 Km':
        setState(() {
          distanceRequired = 1;
          print("set 50");
          //mapAllTrucksNearUser();
        });
        break;
      case '100 Km':
        setState(() {
          distanceRequired = 4;
          print("set 100");
          //mapAllTrucksNearUser();
        });
        break;
      case '200 Km':
        setState(() {
          distanceRequired = 10;
          print("set 200");
          //mapAllTrucksNearUser();
        });
        break;
      case '300 Km':
        setState(() {
          distanceRequired = 40;
          print("set 300");
          //mapAllTrucksNearUser();
        });
        break;
      case '400 Km':
        setState(() {
          distanceRequired = 400;
          print("set 400");
          //mapAllTrucksNearUser();
        });
        break;
      //default:
    }
  }

  // void filterSearchResults(String query) {
  //   print("LIST IS $deviceList");
  //   print("$query");

  //   if (query.isNotEmpty) {
  //     //print("DUMMYSEARCH${dummySearchList}");
  //     var dummyListData = [];
  //     var dummyGpsData = [];
  //     var dummyStatusData = [];
  //     for (var i = 0; i < dummySearchList.length; i++) {
  //       print("FOREACH ${dummySearchList[i].truckno}");
  //       if ((dummySearchList[i].truckno.replaceAll(' ', '')).contains(query) ||
  //           (dummySearchList[i].truckno).contains(query)) {
  //         print("INSIDE IF");
  //         print("THE SEARCHHH IS ${dummySearchList[i].truckno}");
  //         dummyListData.add(dummySearchList[i]);
  //         dummyGpsData.add(widget.gpsDataList[i]);
  //         dummyStatusData.add(widget.status[i]);
  //         //print("DATATYPE${dummyListData.runtimeType}");
  //       }
  //     }
  //     setState(() {
  //       items = [];
  //       gpsDataList = [];

  //       status = [];
  //       items.addAll(dummyListData);
  //       gpsDataList.addAll(dummyGpsData);
  //       status.addAll(dummyStatusData);
  //       //print("THE DUMY $dummyListData");
  //     });
  //     return;
  //   } else {
  //     print("QUERY EMPTY?");
  //     setState(() {
  //       items = [];
  //       gpsDataList = [];
  //       status = [];
  //       items.addAll(widget.deviceList);
  //       gpsDataList.addAll(widget.gpsDataList);
  //       status.addAll(widget.status);
  //       //print("THE ITEMSS ${items}");
  //     });
  //   }
  // }
}


// import 'dart:math';
// import 'package:flutter/material.dart';
// //import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:liveasy/controller/trucksNearUserController.dart';
// import 'package:liveasy/models/deviceModel.dart';
// import 'package:liveasy/models/gpsDataModel.dart';
// import 'package:liveasy/models/truckModel.dart';
// import 'package:liveasy/functions/trackScreenFunctions.dart';
// import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
// import 'package:liveasy/widgets/alertDialog/userNearLocationSelectionDialog.dart';
// import 'package:liveasy/widgets/truckInfoWindow.dart';
// import 'package:logger/logger.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:flutter_config/flutter_config.dart';
// import 'package:location/location.dart' as geo;

// class nearbyTrucksScreen extends StatefulWidget {
//   List gpsDataList;
//   List truckDataList;
//   nearbyTrucksScreen({
//     required this.gpsDataList,
//     required this.truckDataList,
//   });

//   @override
//   _nearbyTrucksScreenState createState() => _nearbyTrucksScreenState();
// }

// class _nearbyTrucksScreenState extends State<nearbyTrucksScreen>
//     with WidgetsBindingObserver {
//   late GoogleMapController _googleMapController;
//   late LatLng lastlatLngMarker = LatLng(28.5673, 77.3211);
//   late List<Placemark> placemarks;
//   Iterable markers = [];
//   ScreenshotController screenshotController = ScreenshotController();
//   late BitmapDescriptor pinLocationIcon;
//   late BitmapDescriptor pinLocationIconTruck;
//   late CameraPosition camPosition =
//       CameraPosition(target: lastlatLngMarker, zoom: 4.5);
//   var logger = Logger();
//   bool showdetails = false;
//   late Marker markernew;
//   List<Marker> customMarkers = [];
//   late Timer timer;
//   Completer<GoogleMapController> _controller = Completer();
//   late List newGPSData;
//   late List reversedList;
//   late List oldGPSData;
//   MapUtil mapUtil = MapUtil();
//   List<LatLng> latlng = [];
//   String googleAPiKey = FlutterConfig.get("mapKey");
//   bool popUp = false;
//   late Uint8List markerIcon;
//   var markerslist;

//   geo.Location locations = geo.Location();
//   late geo.LocationData _locationData;
//   //CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
//   CustomInfoWindowController _customDetailsInfoWindowController =
//       CustomInfoWindowController();
//   bool isAnimation = false;
//   double mapHeight = 600;
//   var direction;
//   var maptype = MapType.normal;
//   double zoom = 4.5;

//   var _currentPosition;
//   var customGpsDataList = [];
//   var customDeviceList = [];

//   TrucksNearUserController trucksNearUserController =
//       Get.put(TrucksNearUserController());

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     WidgetsBinding.instance!.addObserver(this);
//     iconthenmarker();
//     initfunction2();
//     try {
//       timer = Timer.periodic(
//           Duration(minutes: 1, seconds: 10), (Timer t) => onActivityExecuted());
//     } catch (e) {
//       logger.e("Error is $e");
//     }

//     print("THE GPS DATALIST IS ${widget.gpsDataList}");
//     //var _currentPosition;
//     customGpsDataList = widget.gpsDataList;
//     customDeviceList = widget.truckDataList;
//     // var customRunningDataList = widget.runningDataList;
//     // var customRunningGpsDataList = widget.runningGpsDataList;
//     // var customStoppedList = widget.stoppedList;
//     // var customStoppedGpsList = widget.stoppedGpsList;
//     // _getCurrentLocation();
//   }

//   Future<void> initfunction2() async {
//     final GoogleMapController controller = await _controller.future;
//     setState(() {
//       _googleMapController = controller;
//     });
//   }

//   void onMapCreated(GoogleMapController controller) {
//     controller.setMapStyle("[]");

//     _controller.complete(controller);

//     // _customInfoWindowController.googleMapController = controller;
//     _customDetailsInfoWindowController.googleMapController = controller;
//   }

//   @override
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     super.didChangeAppLifecycleState(state);
//     switch (state) {
//       case AppLifecycleState.inactive:
//         print('appLifeCycleState inactive');
//         break;
//       case AppLifecycleState.resumed:
//         final GoogleMapController controller = await _controller.future;
//         onMapCreated(controller);
//         print('appLifeCycleState resumed');
//         break;
//       case AppLifecycleState.paused:
//         print('appLifeCycleState paused');
//         break;
//       case AppLifecycleState.detached:
//         print('appLifeCycleState detached');
//         break;
//     }
//   }

//   //function called every one minute
//   void onActivityExecuted() {
//     logger.i("It is in Activity Executed function");

//     iconthenmarker();
//   }

//   void iconthenmarker() {
//     logger.i("in Icon maker function");
//     BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
//             'assets/icons/truckPin.png')
//         .then((value) => {
//               setState(() {
//                 pinLocationIconTruck = value;
//               }),
//               print("hello ${customGpsDataList.length}"),
//               for (int i = 0; i < customGpsDataList.length; i++)
//                 {
//                   if (customGpsDataList[i] != null)
//                     createmarker(customGpsDataList[i], customDeviceList[i]),
//                 }
//             });
//   }

//   void createmarker(GpsDataModel gpsData, var truck) async {
//     try {
//       final GoogleMapController controller = await _controller.future;

//       LatLng latLngMarker = LatLng(gpsData.latitude!, gpsData.longitude!);
//       print("Live location is  ${gpsData.latitude}");
//       print("hh");
//       print(gpsData.deviceId.toString());
//       String? title = truck;
//       var markerIcons = await getBytesFromCanvas3(truck!, 100, 100);
//       var address = await getAddress(gpsData);
//       var trucklatlong = latLngMarker;
//       setState(() {
//         direction = 180 + gpsData.course!;
//         lastlatLngMarker = LatLng(gpsData.latitude!, gpsData.longitude!);
//         latlng.add(lastlatLngMarker);
//         customMarkers.add(Marker(
//             markerId: MarkerId(gpsData.deviceId.toString()),
//             position: trucklatlong,
//             onTap: () {
//               _customDetailsInfoWindowController.addInfoWindow!(
//                 truckInfoWindow(truck, address),
//                 trucklatlong,
//               );
//             },
//             infoWindow: InfoWindow(
//                 //   title: title,
//                 onTap: () {}),
//             icon: pinLocationIconTruck,
//             rotation: direction));
//         print("here i am");
//         customMarkers.add(Marker(
//             markerId: MarkerId("Details of ${gpsData.deviceId.toString()}"),
//             position: latLngMarker,
//             icon: BitmapDescriptor.fromBytes(markerIcons),
//             rotation: 0.0));
//       });
//       print("done");
//       //   controller.showMarkerInfoWindow(MarkerId(gpsData.last.deviceId.toString()));
//       controller.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(
//           bearing: 0,
//           target: LatLng(28.5673, 77.3211),
//           zoom: zoom,
//         ),
//       ));
//     } catch (e) {
//       print("Exceptionis $e");
//     }
//   }

//   @override
//   void dispose() {
//     logger.i("Activity is disposed");
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double threshold = 100;

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child: Scaffold(
//         body: Stack(children: <Widget>[
//           GoogleMap(
//             onTap: (position) {
//               //   _customInfoWindowController.hideInfoWindow!();
//               _customDetailsInfoWindowController.hideInfoWindow!();
//             },
//             onCameraMove: (position) {
//               //   _customInfoWindowController.onCameraMove!();
//               _customDetailsInfoWindowController.onCameraMove!();
//             },
//             markers: customMarkers.toSet(),
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//             initialCameraPosition: camPosition,
//             compassEnabled: true,
//             mapType: maptype,
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//               //   _customInfoWindowController.googleMapController = controller;
//               _customDetailsInfoWindowController.googleMapController =
//                   controller;
//             },
//             gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
//               new Factory<OneSequenceGestureRecognizer>(
//                 () => new EagerGestureRecognizer(),
//               ),
//             ].toSet(),
//           ),
//           /*  CustomInfoWindow(
//                                 controller: _customInfoWindowController,
//                                 height: 110,
//                                 width: 275,
//                                 offset: 0,
//                               ),*/
//           CustomInfoWindow(
//             controller: _customDetailsInfoWindowController,
//             height: 140,
//             width: 300,
//             offset: 0,
//           ),
//           /*       Positioned(
//                                   left: 10,
//                                   top: 275,
//                                   child: SizedBox(
//                                     height: 40,
//                                     child: FloatingActionButton(
//                                       heroTag: "btn1",
//                                       backgroundColor: Colors.white,
//                                       foregroundColor: Colors.black,
//                                       child: const Icon(Icons.my_location, size: 22, color: Color(0xFF152968) ),
//                                       onPressed: () {
//                                         setState(() {
//                                           this.maptype=(this.maptype == MapType.normal) ? MapType.satellite : MapType.normal;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),*/
//           Positioned(
//             right: 10,
//             bottom: height / 3 + 140,
//             child: SizedBox(
//               height: 40,
//               child: FloatingActionButton(
//                 heroTag: "btn2",
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 child: const Icon(Icons.zoom_in,
//                     size: 22, color: Color(0xFF152968)),
//                 onPressed: () {
//                   setState(() {
//                     this.zoom = this.zoom + 0.5;
//                   });
//                   this
//                       ._googleMapController
//                       .animateCamera(CameraUpdate.newCameraPosition(
//                         CameraPosition(
//                           bearing: 0,
//                           target: lastlatLngMarker,
//                           zoom: this.zoom,
//                         ),
//                       ));
//                 },
//               ),
//             ),
//           ),
//           Positioned(
//             right: 10,
//             bottom: height / 3 + 90,
//             child: SizedBox(
//               height: 40,
//               child: FloatingActionButton(
//                 heroTag: "btn3",
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 child: const Icon(Icons.zoom_out,
//                     size: 22, color: Color(0xFF152968)),
//                 onPressed: () {
//                   setState(() {
//                     this.zoom = this.zoom - 0.5;
//                   });
//                   this
//                       ._googleMapController
//                       .animateCamera(CameraUpdate.newCameraPosition(
//                         CameraPosition(
//                           bearing: 0,
//                           target: lastlatLngMarker,
//                           zoom: this.zoom,
//                         ),
//                       ));
//                 },
//               ),
//             ),
//           ),
//           Positioned(
//             right: 10,
//             bottom: height / 3 + 40,
//             child: SizedBox(
//               height: 40,
//               child: FloatingActionButton(
//                 heroTag: "btn3",
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 child: const Icon(Icons.my_location,
//                     size: 22, color: Color(0xFF152968)),
//                 onPressed: () {
//                   //mapAllTrucksNearUser(20);
//                   setState(() {
//                     trucksNearUserController.updateDistanceRadiusData(100);
//                     trucksNearUserController.updateNearStatusData(false);
//                     mapAllTrucksNearUser();
//                     showDialog(
//                             context: context,
//                             builder: (context) => UserNearLocationSelection())
//                         .then((value) {
//                       if (value) {
//                         setState(() {});
//                       }
//                     });
//                     print(" kkkkkk ");
//                     print(trucksNearUserController.nearStatus.value);
//                   });
//                 },
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   getAddress(var gpsData) async {
//     var address =
//         await getStoppageAddressLatLong(gpsData.latitude, gpsData.longitude);

//     return address;
//   }

//   _getCurrentLocation() async {
//     print("INSIDE USER LOCATION");
//     // Geolocator.getCurrentPosition(
//     //         desiredAccuracy: LocationAccuracy.best,
//     //         forceAndroidLocationManager: true)
//     //     .then((Position position) {
//     //   print("ERROR THERE");
//     //   setState(() {
//     //     _currentPosition = position;
//     //     print(
//     //         "CURRENT LOCATION IS ${_currentPosition.latitude} AND ${widget.gpsDataList[1].latitude}");
//     //   });
//     // }).catchError((e) {
//     //   print(e);
//     //   print("ERROR THERE");
//     // });
//     _locationData = await locations.getLocation();
//     print("CURRENT LOCATION IS ${_locationData.latitude}");
//   }

//   void mapAllTrucksNearUser() {
//     for (var i = 0; i < widget.gpsDataList.length; i++) {
//       var distanceStore = calculateDistance(
//           widget.gpsDataList[i].latitude,
//           widget.gpsDataList[i].longitude,
//           _locationData.latitude,
//           _locationData.latitude);
//       if (distanceStore <= 2) {
//         print("TRYINGGGGGG");
//         customGpsDataList[i] = widget.gpsDataList[i];
//         customDeviceList[i] = widget.truckDataList[i];
//         // customRunningDataList[i] = widget.runningDataList[i];
//         // customRunningGpsDataList[i] = widget.runningGpsDataList[i];
//         // customStoppedList[i] = widget.stoppedList[i];
//         // customStoppedGpsList[i] = widget.stoppedGpsList[i];
//       } else {
//         customGpsDataList[i] = [];
//         customDeviceList[i] = [];
//         // customRunningDataList[i] = [];
//         // customRunningGpsDataList[i] = [];
//         // customStoppedList[i] = [];
//         // customStoppedGpsList[i] = [];
//       }
//     }
//   }
 
//   double calculateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }
// }
