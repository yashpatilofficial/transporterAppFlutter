import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/functions/truckApis/getTruckDataWithPageNo.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/mapAllTrucks.dart';
import 'package:liveasy/screens/myTrucksSearchResultsScreen.dart';
import 'package:liveasy/screens/nearbyTrucksScreen.dart';
import 'package:liveasy/widgets/buttons/addTruckButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingWidgets.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/truckScreenBarButton.dart';
import 'package:provider/provider.dart';

class MyTrucks extends StatefulWidget {
  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {
  //TransporterId controller
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  TruckApiCalls truckApiCalls = TruckApiCalls();

  // Truck Model List used to  create cards
  // var truckDataList = [];
  var devicelist = [];
  var trucklist = [];
  // var truckAddressList = [];
  var status = [];
  var gpsDataList = [];
  var gpsStoppageHistory = [];
  MapUtil mapUtil = MapUtil();
  late List<Placemark> placemarks;
  late String date;
  var runningdevicelist = [];
  var stoppeddevicelist = [];
  var gpsData;
  bool loading = false;
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  var runningList = [];
  var runningStatus = [];
  var runningGpsData = [];
  int i = 0;
  var StoppedList = [];
  var StoppedStatus = [];
  var StoppedGpsData = [];
  var truckDataListForPage = [];

  var gpsList = [];
  var stat = [];
  var running = [];
  var runningStat = [];
  var runningGps = [];
  var Stopped = [];
  var StoppedStat = [];
  var StoppedGps = [];

  var items = [];

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    // FutureGroup futureGroup = FutureGroup();
    super.initState();
    setState(() {
      loading = true;
    });
    getMyTruckPosition();
    // var f2 = getMyDevices(i);

    /* scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getMyDevices(i);
      }
    });*/
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ProviderData providerData = Provider.of<ProviderData>(context);
    // providerData.resetTruckFilters();
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
        PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
          child: Container(
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
                    HeadingTextWidget('my_truck'.tr
                        // AppLocalizations.of(context)!.my_truck
                        ),
                    // HelpButtonWidget(),
                  ],
                ),
                HelpButtonWidget(),
                // Container(
                //   height: 15,
                //   child: FloatingActionButton(
                //     heroTag: "btn3",
                //     backgroundColor: Colors.white,
                //     foregroundColor: Colors.black,
                //     child: const Icon(Icons.my_location,
                //         size: 22, color: Color(0xFF152968)),
                //     onPressed: () {
                //       //mapAllTrucksNearUser(20);
                //       setState(() {
                //         //trucksNearUserController.updateDistanceRadiusData(16000);
                //         //trucksNearUserController.updateNearStatusData(false);
                //         Get.to(() => NearbyTrucksResult(
                //             gpsDataList: gpsDataList, deviceList: devicelist));

                //         // showDialog(
                //         //         context: context,
                //         //         builder: (context) => UserNearLocationSelection())
                //         //     .then((value) {
                //         //   if (value) {
                //         //     setState(() {});
                //         //   }
                //         // });
                //         //print(" kkkkkk ");
                //         //print(trucksNearUserController.nearStatus.value);
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: space_3),
              child: Container(
                height: space_8,
                decoration: BoxDecoration(
                  color: widgetBackGroundColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 0.8,
                    // color: borderBlueColor,
                  ),
                ),
                child: TextField(
                  onTap: () {
                    Get.to(() => MyTrucksResult(
                          gpsDataList: gpsDataList,
                          deviceList: devicelist,
                          //truckAddressList: truckAddressList,
                          status: status,
                          items: items,
                        ));
                    print("Enterrr");
                    print("THE ITEMS $items");
                  },
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'search'.tr,
                    icon: Padding(
                      padding: EdgeInsets.only(left: space_2),
                      child: Icon(
                        Icons.search,
                        color: grey,
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontSize: size_8,
                      color: grey,
                    ),
                  ),
                ),
              ),
            ),

            //LIST OF TRUCK CARDS---------------------------------------------
            Container(
              //    height: 26,
              //    width: 200,
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),

              //    margin: EdgeInsets.symmetric(horizontal: space_2),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEFEFEF),
                    blurRadius: 9,
                    offset: Offset(0, 2),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TruckScreenBarButton(
                      text: 'all'.tr,
                      // 'All',
                      value: 0,
                      pageController: pageController),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 1,
                    height: 15,
                    color: const Color(0xFFC2C2C2),
                  ),
                  TruckScreenBarButton(
                      text: 'running'.tr,
                      // 'Running'
                      value: 1,
                      pageController: pageController),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 1,
                    height: 15,
                    color: const Color(0xFFC2C2C2),
                  ),
                  TruckScreenBarButton(
                      text: 'stopped'.tr,
                      // 'Stopped',
                      value: 2,
                      pageController: pageController),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: () {
                Get.to(MapAllTrucks(
                  gpsDataList: gpsDataList,
                  deviceList: trucklist,
                  runningDataList: runningList,
                  runningGpsDataList: runningGpsData,
                  stoppedList: StoppedList,
                  stoppedGpsList: StoppedGpsData,
                ));
              },
              child: Container(

                  //     margin: EdgeInsets.fromLTRB(space_2, 0, space_2, 0),
                  padding:
                      EdgeInsets.fromLTRB(space_5, space_2, space_2, space_2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEFEFEF),
                        blurRadius: 9,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/Vector (1).png',
                        width: 17,
                        height: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Text(
                        'seeAllTruckMap'.tr,
                        // 'See All Trucks on Map',
                        style: TextStyle(fontSize: 15),
                      ),
                      Spacer(),
                      Image.asset(
                        'assets/icons/Vector (2).png',
                        width: 7,
                        height: 15,
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Stack(children: [
                Container(
                  //    margin: EdgeInsets.fromLTRB(space_2, 0, space_2, 0),
                  height: MediaQuery.of(context).size.height -
                      kBottomNavigationBarHeight -
                      230 -
                      space_4,
                  child: PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          providerData.updateUpperNavigatorIndex(value);
                        });
                      },
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            loading
                                ? TruckLoadingWidgets()
                                : trucklist.isEmpty
                                    ? Container(
                                        // height: MediaQuery.of(context).size.height * 0.27,
                                        margin: EdgeInsets.only(top: 153),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/TruckListEmptyImage.png'),
                                              height: 127,
                                              width: 127,
                                            ),
                                            Text(
                                              'notruckadded'.tr,
                                              // 'Looks like you have not added any Trucks!',
                                              style: TextStyle(
                                                  fontSize: size_8,
                                                  color: grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: lightNavyBlue,
                                        onRefresh: () {
                                          setState(() {
                                            runningList.clear();
                                            runningGpsData.clear();
                                            runningStatus.clear();
                                            gpsDataList.clear();
                                            status.clear();
                                            StoppedStatus.clear();
                                            StoppedGpsData.clear();
                                            StoppedList.clear();
                                            runningdevicelist.clear();
                                            stoppeddevicelist.clear();

                                            loading = true;
                                          });
                                          return refreshData(i);
                                        },
                                        child: ListView.builder(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            controller: scrollController,
                                            scrollDirection: Axis.vertical,
                                            padding: EdgeInsets.only(
                                                bottom: space_15),
                                            itemCount: trucklist.length,
                                            itemBuilder: (context, index) =>
                                                index == trucklist.length
                                                    ? bottomProgressBarIndicatorWidget()
                                                    : MyTruckCard(
                                                        truckno:
                                                            trucklist[index],
                                                        status: status[index],
                                                        gpsData:
                                                            gpsDataList[index],
                                                        device:
                                                            devicelist[index],
                                                        // truckId: .truckId,
                                                        // truckApproved:
                                                        //     truckDataList[index].truckApproved,
                                                        // truckNo: truckDataList[index].truckNo,
                                                        // truckType: truckDataList[index].truckType,
                                                        // tyres: truckDataList[index].tyresString,
                                                        // driverName: truckDataList[index].driverName,
                                                        // phoneNum: truckDataList[index].driverNum,
                                                        /*  imei:
                                                            truckDataList[index]
                                                                .imei,*/
                                                      )),
                                      ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            loading
                                ? TruckLoadingWidgets()
                                : runningList.isEmpty
                                    ? Container(
                                        // height: MediaQuery.of(context).size.height * 0.27,
                                        margin: EdgeInsets.only(top: 153),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/TruckListEmptyImage.png'),
                                              height: 127,
                                              width: 127,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'notruckrunnning'.tr,
                                              // 'Looks like none of your trucks are running!',
                                              style: TextStyle(
                                                  fontSize: size_8,
                                                  color: grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: lightNavyBlue,
                                        onRefresh: () {
                                          setState(() {
                                            runningList.clear();
                                            runningGpsData.clear();
                                            runningStatus.clear();
                                            gpsDataList.clear();
                                            status.clear();
                                            StoppedStatus.clear();
                                            StoppedGpsData.clear();
                                            StoppedList.clear();
                                            runningdevicelist.clear();
                                            stoppeddevicelist.clear();
                                            loading = true;
                                          });
                                          return refreshData(i);
                                        },
                                        child: ListView.builder(
                                          padding:
                                              EdgeInsets.only(bottom: space_15),
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemCount: runningList.length,
                                          itemBuilder: (context, index) => index ==
                                                  runningList.length
                                              ? bottomProgressBarIndicatorWidget()
                                              : MyTruckCard(
                                                  truckno: runningList[index],
                                                  status: runningStatus[index],
                                                  gpsData:
                                                      runningGpsData[index],
                                                  device:
                                                      runningdevicelist[index],
                                                  // truckId: .truckId,
                                                  // truckApproved:
                                                  //     truckDataList[index].truckApproved,
                                                  // truckNo: truckDataList[index].truckNo,
                                                  // truckType: truckDataList[index].truckType,
                                                  // tyres: truckDataList[index].tyresString,
                                                  // driverName: truckDataList[index].driverName,
                                                  // phoneNum: truckDataList[index].driverNum,
                                                  /*   imei:
                                                      truckDataList[index].imei,*/
                                                ),
                                        ),
                                      ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            loading
                                ? TruckLoadingWidgets()
                                : StoppedList.isEmpty
                                    ? Container(
                                        // height: MediaQuery.of(context).size.height * 0.27,
                                        margin: EdgeInsets.only(top: 153),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/TruckListEmptyImage.png'),
                                              height: 127,
                                              width: 127,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'notruckstopped'.tr,
                                              // 'Looks like none of your trucks are stopped!',
                                              style: TextStyle(
                                                  fontSize: size_8,
                                                  color: grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: lightNavyBlue,
                                        onRefresh: () {
                                          setState(() {
                                            runningList.clear();
                                            runningGpsData.clear();
                                            runningStatus.clear();
                                            gpsDataList.clear();
                                            status.clear();
                                            StoppedStatus.clear();
                                            StoppedGpsData.clear();
                                            StoppedList.clear();
                                            runningdevicelist.clear();
                                            stoppeddevicelist.clear();
                                            loading = true;
                                          });
                                          return refreshData(i);
                                        },
                                        child: ListView.builder(
                                          padding:
                                              EdgeInsets.only(bottom: space_15),
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemCount: StoppedList.length,
                                          itemBuilder: (context, index) => index ==
                                                  StoppedList.length
                                              ? bottomProgressBarIndicatorWidget()
                                              : MyTruckCard(
                                                  truckno: StoppedList[index],
                                                  status: StoppedStatus[index],
                                                  gpsData:
                                                      StoppedGpsData[index],
                                                  device:
                                                      stoppeddevicelist[index],
                                                  // truckId: .truckId,
                                                  // truckApproved:
                                                  //     truckDataList[index].truckApproved,
                                                  // truckNo: truckDataList[index].truckNo,
                                                  // truckType: truckDataList[index].truckType,
                                                  // tyres: truckDataList[index].tyresString,
                                                  // driverName: truckDataList[index].driverName,
                                                  // phoneNum: truckDataList[index].driverNum,
                                                  /*     imei:
                                                      truckDataList[index].imei,*/
                                                ),
                                        ),
                                      ),
                          ],
                        ),
                      ]),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height -
                      kBottomNavigationBarHeight -
                      230 -
                      2 * space_6 -
                      30,
                  left: (MediaQuery.of(context).size.width - 2 * space_6) / 2 -
                      60,
                  child: Container(
                      //     margin: EdgeInsets.only(bottom: space_2),
                      child: AddTruckButton()),
                ),
              ]),
            ),
          ],
        ),
      )),
    );
  } //build

  /* getMyDevices(int i) async {
    var devices = await mapUtil.getDevices();
    trucklist.clear();
    devicelist.clear();
    for (var device in devices) {
      setState(() {
        trucklist.add(device.truckno);
        devicelist.add(device);
      });
    }
  }
*/
  getMyTruckPosition() async {
    //   FutureGroup futureGroup = FutureGroup();

    var a = mapUtil.getDevices();
    var b = mapUtil.getTraccarPositionforAll();
    var devices = await a;
    var gpsDataAll = await b;
    trucklist.clear();
    devicelist.clear();
    for (var device in devices) {
      setState(() {
        trucklist.add(device.truckno);
        devicelist.add(device);
      });
    }
    print("total devices for me are ${devices.length}");

    setState(() {
      items = devices;
    });

    //FIX LENGTH OF ALL LIST----------------------
    gpsList = List.filled(devices.length, null, growable: true);
    stat = List.filled(devices.length, "", growable: true);
    running = List.filled(devices.length, null, growable: true);
    runningStat = List.filled(devices.length, "", growable: true);
    runningGps = List.filled(devices.length, null, growable: true);
    Stopped = List.filled(devices.length, null, growable: true);
    StoppedStat = List.filled(devices.length, "", growable: true);
    StoppedGps = List.filled(devices.length, null, growable: true);
    runningdevicelist = List.filled(devices.length, null, growable: true);
    stoppeddevicelist = List.filled(devices.length, null, growable: true);
    //------------------------------------------------

    //START ADDING DATA-------------------------------
    /*for (int i = 0; i < devices.length; i++) {
      print(
          "DeviceId is ${devices[i].deviceId} for ${devices[i].truckno}");

      
        var future = getGPSData(devices[i], i);
        futureGroup.add(future);
      
    }
    futureGroup.close();
    await futureGroup.future; */ //Fire all APIs at once (not one after the other)

    for (int i = 0; i < gpsDataAll.length; i++) {
      print("DeviceId is ${devices[i].deviceId} for ${devices[i].truckno}");

      getGPSData(gpsDataAll[i], i, devices[i].truckno, devices[i]);
    }

    setState(() {
      gpsDataList = gpsList;
      status = stat;

      runningList = running;
      runningGpsData = runningGps;
      runningStatus = runningStat;

      StoppedList = Stopped;
      StoppedGpsData = StoppedGps;
      StoppedStatus = StoppedStat;
    });

    //NOW REMOVE EXTRA ELEMENTS FROM RUNNING AND STOPPED LISTS-------

    runningList.removeWhere((item) => item == null);
    runningGpsData.removeWhere((item) => item == null);
    runningStatus.removeWhere((item) => item == "");
    runningdevicelist.removeWhere((item) => item == null);
    stoppeddevicelist.removeWhere((item) => item == null);
    StoppedList.removeWhere((item) => item == null);
    StoppedGpsData.removeWhere((item) => item == null);
    StoppedStatus.removeWhere((item) => item == "");

    print("ALL $status");
    print("ALL $gpsDataList");
    print("ALL RUNNING $runningList");
    print("ALL STOPPED $StoppedList");
    print("ALL STOPPED $StoppedGpsData ");
    print("ALL STOPPED $StoppedStatus");
    print("--TRUCK SCREEN DONE--");
    setState(() {
      loading = false;
    });
  }

  getGPSData(var gpsData, int i, var truckno, var device) async {
    getStoppedSince(gpsData, i, device);
    print('get stopped done');
    if (gpsData.speed >= 2) //For RUNNING Section
    {
      running.removeAt(i);
      runningGps.removeAt(i);
      runningdevicelist.removeAt(i);
      running.insert(i, truckno);
      runningdevicelist.insert(i, device);
      runningGps.insert(i, gpsData);
    } else if (gpsData.speed < 2) {
      //For STOPPED section

      Stopped.removeAt(i);
      StoppedGps.removeAt(i);
      stoppeddevicelist.removeAt(i);
      stoppeddevicelist.insert(i, device);
      Stopped.insert(i, truckno);
      StoppedGps.insert(i, gpsData);
    }
    gpsList.removeAt(i);

    gpsList.insert(i, gpsData);
    print("DONE ONE PART");
  }

  refreshData(int i) async {
    FutureGroup futureGroup = FutureGroup();
    print("device list $devicelist");
    //FIX LENGTH OF ALL LIST----------------------
    gpsList = List.filled(devicelist.length, null, growable: true);
    stat = List.filled(devicelist.length, "", growable: true);
    running = List.filled(devicelist.length, null, growable: true);
    runningStat = List.filled(devicelist.length, "", growable: true);
    runningGps = List.filled(devicelist.length, null, growable: true);
    Stopped = List.filled(devicelist.length, null, growable: true);
    StoppedStat = List.filled(devicelist.length, "", growable: true);
    StoppedGps = List.filled(devicelist.length, null, growable: true);
    runningdevicelist = List.filled(devicelist.length, null, growable: true);
    stoppeddevicelist = List.filled(devicelist.length, null, growable: true);
    //------------------------------------------------
    //Fire all APIs at once (not one after the other)
    var gpsDataAll = await mapUtil.getTraccarPositionforAll();
    for (int i = 0; i < gpsDataAll.length; i++) {
      print(
          "DeviceId is ${devicelist[i].deviceId} for ${devicelist[i].truckno}");

      getGPSData(gpsDataAll[i], i, devicelist[i].truckno, devicelist[i]);
    }
    setState(() {
      gpsDataList = gpsList;
      status = stat;

      runningList = running;
      runningGpsData = runningGps;
      runningStatus = runningStat;

      StoppedList = Stopped;
      StoppedGpsData = StoppedGps;
      StoppedStatus = StoppedStat;
    });

    //NOW REMOVE EXTRA ELEMENTS FROM RUNNING AND STOPPED LISTS-------

    runningList.removeWhere((item) => item == null);
    runningGpsData.removeWhere((item) => item == null);
    runningStatus.removeWhere((item) => item == "");
    runningdevicelist.removeWhere((item) => item == null);
    stoppeddevicelist.removeWhere((item) => item == null);
    StoppedList.removeWhere((item) => item == null);
    StoppedGpsData.removeWhere((item) => item == null);
    StoppedStatus.removeWhere((item) => item == "");

    print("ALL $status");
    print("ALL $gpsDataList");
    print("--TRUCK SCREEN DONE--");
    setState(() {
      loading = false;
    });
  }

  getStoppedSince(var gpsData, int i, var device) async {
    if (device.status == 'online') {
      StoppedStat.removeAt(i);
      StoppedStat.insert(i, "Online");

      runningStat.removeAt(i);
      runningStat.insert(i, "Online");

      stat.removeAt(i);
      stat.insert(i, "Online");
    } else {
      StoppedStat.removeAt(i);
      StoppedStat.insert(i, "Offline");

      runningStat.removeAt(i);
      runningStat.insert(i, "Offline");

      stat.removeAt(i);
      stat.insert(i, "Offline");
    }
    /*   if (gpsData.motion == false) {
      StoppedStat.removeAt(i);
      StoppedStat.insert(i, "Stopped");

      stat.removeAt(i);
      stat.insert(i, "Stopped");
    } else {
      runningStat.removeAt(i);
      runningStat.insert(i, "Running");

      stat.removeAt(i);
      stat.insert(i, "Running");
    }*/
  }
}

//class
