import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/playRouteHistoryScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/screens/truckHistoryScreen.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/MapScreenBarButton.dart';
import 'package:liveasy/widgets/OrderScreenNavigationBarButton.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/allMapWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/widgets/trackScreenDetailsWidget.dart';
import 'package:liveasy/widgets/truckScreenBarButton.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';
class MapAllTrucks extends StatefulWidget {
  List gpsDataList;
  List truckDataList;
  List runningDataList;
  List runningGpsDataList;
  List stoppedList;
  List stoppedGpsList;
   MapAllTrucks({
    required this.gpsDataList,
    required this.truckDataList, 
    required this.runningDataList,
    required this.runningGpsDataList,
    required this.stoppedGpsList,
    required this.stoppedList,
   });

  @override
  _MapAllTrucksState createState() => _MapAllTrucksState();
}

class _MapAllTrucksState extends State<MapAllTrucks> with WidgetsBindingObserver{
  late GoogleMapController _googleMapController;
  late LatLng lastlatLngMarker = LatLng(28.5673, 77.3211);
  late List<Placemark> placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIconTruck;
  late CameraPosition camPosition =  CameraPosition(
      target: lastlatLngMarker,
      zoom: 4);
  var logger = Logger();
  late Marker markernew;
  List<Marker> customMarkers = [];
  late Timer timer;
  Completer<GoogleMapController> _controller = Completer();
  late List newGPSData;
  late List reversedList;
  late List oldGPSData;
  MapUtil mapUtil = MapUtil();
  List<LatLng> latlng = [];
  String googleAPiKey = FlutterConfig.get("mapKey");
  bool popUp=false;
  late Uint8List markerIcon;
  var markerslist;
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  bool isAnimation = false;
  double mapHeight=600;
  var direction;
  var maptype = MapType.normal;
  double zoom = 8;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    
  }
 
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle("[]");
    
    _controller.complete(controller);
    
    _customInfoWindowController.googleMapController = controller;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
    final GoogleMapController controller = await _controller.future;
    onMapCreated(controller);
    print('appLifeCycleState resumed');
    break;
    case AppLifecycleState.paused:
    print('appLifeCycleState paused');
    break;
    case AppLifecycleState.detached:
    print('appLifeCycleState detached');
    break;
  }
  }
  

  //function called every one minute
/*  void onActivityExecuted() {
    logger.i("It is in Activity Executed function");
    
    iconthenmarker();
  }
    void iconthenmarker() {
    logger.i("in Icon maker function");
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/truckPin.png')
        .then((value) => {
      setState(() {
        pinLocationIconTruck = value;
      }),
      for(int i =0;i<widget.gpsDataList.length;i++)
    {
      createmarker(widget.gpsDataList[i],widget.truckDataList[i]),
    }
      
    });
  }
  void createmarker(List gpsData,TruckModel truckData) async {
    try {
      final GoogleMapController controller = await _controller.future;
      LatLng latLngMarker =
      LatLng(gpsData.last.lat, gpsData.last.lng);
      print("Live location is ${gpsData.last.lat}");
      String? title = truckData.truckNo;
      setState(() {
        direction = 180 + double.parse(gpsData.last.direction);
        lastlatLngMarker = LatLng(gpsData.last.lat, gpsData.last.lng);
        latlng.add(lastlatLngMarker);
        customMarkers.add(Marker(
            markerId: MarkerId(gpsData.last.id.toString()),
            position: latLngMarker,
            infoWindow: InfoWindow(title: title),
            icon: pinLocationIconTruck,
        rotation: direction));
        
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: lastlatLngMarker,
          zoom: zoom,
        ),
      ));
    } catch (e) {
      print("Exceptionis $e");
    }
  }

  @override
  void dispose() {
    logger.i("Activity is disposed");
    timer.cancel();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double threshold = 100;
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
        PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
           width: MediaQuery.of(context).size.width,
          child: Column(
            children:[
              Row(
                children:[
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(space_4,space_10,0,space_4),
                      child: Image.asset('assets/icons/navigationIcons/goBack.png',
                      width: 11,
                      height: 21,),
                    ),
                  ),
                   Container(
                      margin: EdgeInsets.fromLTRB(space_4,space_10,space_4,space_4),
                      width: MediaQuery.of(context).size.width -85,
                      child: SearchLoadWidget(
                        hintText: 'Search',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => NextUpdateAlertDialog());
                        },
                      )),
                ]
              ),
                
              Container(
                //    height: 26,
                //    width: 200,
                  //  padding: EdgeInsets.fromLTRB(5,5,5,5),
                     padding: EdgeInsets.all(0),
                        margin: EdgeInsets.fromLTRB(space_6,0,space_6,space_4),
                        decoration: BoxDecoration(
                          
                          boxShadow: [
                            BoxShadow(color: const Color(0xFFEFEFEF),
                            blurRadius: 9,
                            offset: Offset(0, 2),),
                          ],
                          color: const Color(0xFFF7F8FA),
                  ),
                  
                    child: Row(
                      
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                     
                        MapScreenBarButton(
                          text: 'All', value: 0, pageController: pageController),
                        Container(
                          padding: EdgeInsets.all(0),
                          width: 1,
                          height: 15,
                          color: const Color(0xFFC2C2C2),
                        ),
                        MapScreenBarButton(
                          text: 'Running', value: 1, pageController: pageController),
                        Container(
                          padding: EdgeInsets.all(0),
                          width: 1,
                          height: 15,
                          color: const Color(0xFFC2C2C2),
                        ),
                        MapScreenBarButton(
                          text: 'Stopped', value: 2, pageController: pageController),
                      ],
                    ),
          
                  ),
                  Container(
                  height: MediaQuery.of(context).size.height -125,
                  child: PageView(
                    controller: pageController,
                            onPageChanged: (value) {
                              setState(() {
                                providerData.updateUpperNavigatorIndex(value);
                              });
                            },
                            children:[
                              AllMapWidget(gpsDataList: widget.gpsDataList, truckDataList: widget.truckDataList),
                              AllMapWidget(gpsDataList: widget.runningGpsDataList, truckDataList: widget.runningDataList),
                              AllMapWidget(gpsDataList: widget.stoppedGpsList, truckDataList: widget.stoppedList),
                            ]
                  )
                  ),
                  
            
            ]
               ),
               
         
         ),
      ),
    );
  }

}