import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/deliveredCardModel.dart';
import 'package:liveasy/widgets/buttons/trackButton.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/loadPosterDetails.dart';
import 'package:liveasy/widgets/newRowTemplate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveredLoadDetails extends StatelessWidget {
  final DeliveredCardModel loadALlDataModel;
  bool? trackIndicator = false;

  DeliveredLoadDetails({required this.loadALlDataModel, this.trackIndicator});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        margin: EdgeInsets.all(space_4),
        child: Column(
          children: [
            Header(
                reset: false,
                text: AppLocalizations.of(context)!.orderDetails,
                backButton: true),
            Container(
              margin: EdgeInsets.only(top: space_4),
              child: Stack(
                children: [
                  LoadPosterDetails(
                    loadPosterLocation: loadALlDataModel.transporterLocation,
                    loadPosterName: loadALlDataModel.transporterName,
                    loadPosterCompanyName: loadALlDataModel.companyName,
                    loadPosterCompanyApproved:
                        loadALlDataModel.transporterApproved,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_8,
                        top: MediaQuery.of(context).size.height * 0.192,
                        right: space_8),
                    child: Container(
                      height: space_10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius_2 - 2)),
                      child: Card(
                        color: white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TrackButton(
                              truckApproved: trackIndicator!,
                            ),
                            CallButton(
                              directCall: false,
                              driverPhoneNum: loadALlDataModel.driverPhoneNum,
                              driverName: loadALlDataModel.driverName,
                              transporterPhoneNum:
                                  loadALlDataModel.transporterPhoneNum,
                              transporterName: loadALlDataModel.transporterName,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Card(
              elevation: 5,
              child: Container(
                margin: EdgeInsets.all(space_3),
                child: Column(
                  children: [
                    NewRowTemplate(
                        label: AppLocalizations.of(context)!.location,
                        value:
                            '${loadALlDataModel.loadingPointCity} - ${loadALlDataModel.unloadingPointCity}'),
                    NewRowTemplate(
                        label: AppLocalizations.of(context)!.truckNumber,
                        value: loadALlDataModel.truckNo),
                    NewRowTemplate(
                        label: AppLocalizations.of(context)!.truckType,
                        value: loadALlDataModel.truckType),
                    NewRowTemplate(
                        label: AppLocalizations.of(context)!.numberOfTrucks,
                        value: loadALlDataModel.noOfTrucks),
                    NewRowTemplate(
                        label: AppLocalizations.of(context)!.productType,
                        value: loadALlDataModel.productType),
                    NewRowTemplate(
                        label: AppLocalizations.of(context)!.price,
                        value:
                            '${loadALlDataModel.rate}/${loadALlDataModel.unitValue}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
