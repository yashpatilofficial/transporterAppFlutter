import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/SelectedDriverController.dart';
import 'package:liveasy/functions/loadApis/runSuggestedLoadApiWithPageNo.dart';
import 'package:liveasy/models/WidgetLoadDetailsScreenModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/additionalDescription_LoadDetails.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/buttons/bookNowButton.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/loadPosterDetails.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/loadDetailsLoadingWidget.dart';
import 'package:liveasy/widgets/locationDetails_LoadDetails.dart';
import 'package:liveasy/widgets/requirementsLoad_DetailsWidget.dart';
import 'package:liveasy/widgets/buttons/shareButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable

class LoadDetailsScreen extends StatefulWidget {
  final LoadDetailsScreenModel loadDetailsScreenModel;

  LoadDetailsScreen({required this.loadDetailsScreenModel});

  @override
  _LoadDetailsScreenState createState() => _LoadDetailsScreenState();
}

class _LoadDetailsScreenState extends State<LoadDetailsScreen> {
  late WidgetLoadDetailsScreenModel widgetLoadDetailsScreenModel;
  bool loading = false;
  SelectedDriverController selectedDriverController =
      Get.put(SelectedDriverController());
  runGetDetailsByPostLoadID() async {
    widgetLoadDetailsScreenModel = await getLoadDetailsByPostLoadID(
        loadPosterId: widget.loadDetailsScreenModel.postLoadId.toString());
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    runGetDetailsByPostLoadID();
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedDriverController.updateFromBook(false);
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: loading == true
              ? LoadDetailsLoadingWidget()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(horizontal: space_2),
                  child: Column(
                    children: [
                      SizedBox(
                        height: space_4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButtonWidget(),
                          SizedBox(
                            width: space_3,
                          ),
                          HeadingTextWidget(
                            'loadDetails'.tr
                              // AppLocalizations.of(context)!.loadDetails
                          ),
                          // HelpButtonWidget(),
                        ],
                      ),
                      SizedBox(
                        height: space_3,
                      ),
                      Stack(
                        children: [
                          LoadPosterDetails(
                            loadPosterLocation:
                                widgetLoadDetailsScreenModel.loadPosterLocation,
                            loadPosterName:
                                widgetLoadDetailsScreenModel.loadPosterName,
                            loadPosterCompanyName: widgetLoadDetailsScreenModel
                                .loadPosterCompanyName,
                            loadPosterCompanyApproved:
                                widgetLoadDetailsScreenModel
                                    .loadPosterCompanyApproved,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: space_8,
                                top: MediaQuery.of(context).size.height * 0.192,
                                right: space_8),
                            child: Container(
                              height: space_10,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(radius_2 - 2)),
                              child: Card(
                                color: white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BidButton(
                                        loadDetails:
                                            widget.loadDetailsScreenModel),
                                    CallButton(
                                      directCall: true,
                                      phoneNum:
                                          widgetLoadDetailsScreenModel.phoneNo,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              space_2, space_3, space_2, space_3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: space_3),
                                child: LocationDetailsLoadDetails(
                                  loadDetails: {
                                    "loadDate":
                                        widget.loadDetailsScreenModel.loadDate,
                                    "loadingPoint": widget
                                        .loadDetailsScreenModel.loadingPoint,
                                    "loadingPointCity": widget
                                        .loadDetailsScreenModel
                                        .loadingPointCity,
                                    "loadingPointState": widget
                                        .loadDetailsScreenModel
                                        .loadingPointState,
                                    "unloadingPoint": widget
                                        .loadDetailsScreenModel.unloadingPoint,
                                    "unloadingPointCity": widget
                                        .loadDetailsScreenModel
                                        .unloadingPointCity,
                                    "unloadingPointState": widget
                                        .loadDetailsScreenModel
                                        .unloadingPointState,
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: space_2),
                                child: Divider(
                                  thickness: 1,
                                  color: borderLightColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: space_3),
                                child: RequirementsLoadDetails(
                                  loadDetails: {
                                    "truckType":
                                        widget.loadDetailsScreenModel.truckType,
                                    "noOfTyres":
                                        widget.loadDetailsScreenModel.noOfTyres,
                                    "weight":
                                        widget.loadDetailsScreenModel.weight,
                                    "productType": widget
                                        .loadDetailsScreenModel.productType,
                                    "rate": widget.loadDetailsScreenModel.rate,
                                    "unitValue":
                                        widget.loadDetailsScreenModel.unitValue,
                                  },
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: space_4),
                                  child: AdditionalDescriptionLoadDetails(
                                      widget.loadDetailsScreenModel.comment)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BookNowButton(
                                    loadDetailsScreenModel:
                                        widget.loadDetailsScreenModel,
                                  ),
                                  ShareButton(
                                    loadDetails: widget.loadDetailsScreenModel,
                                    widgetLoadDetailsScreenModel:
                                        widgetLoadDetailsScreenModel,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
