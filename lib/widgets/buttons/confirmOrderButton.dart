import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/bidApiCalls.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/alertDialog/bookLoadAlertDialogBox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: must_be_immutable
class ConfirmOrderButton extends StatefulWidget {
  BiddingModel biddingModel;
  final String? postLoadId;
  bool? shipperApproval;
  bool? transporterApproval;

  ConfirmOrderButton({
    this.transporterApproval,
    this.shipperApproval,
    required this.biddingModel,
    required this.postLoadId,
  });

  @override
  _ConfirmOrderButtonState createState() => _ConfirmOrderButtonState();
}

class _ConfirmOrderButtonState extends State<ConfirmOrderButton> {
  List<TruckModel> truckDetailsList = [];

  List<DriverModel> driverDetailsList = [];

  TruckApiCalls truckApiCalls = TruckApiCalls();
  DriverApiCalls driverApiCalls = DriverApiCalls();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    truckDetailsList = await truckApiCalls.getTruckData();
    driverDetailsList = await driverApiCalls.getDriversByTransporterId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: space_3),
      height: 31,
      child: TextButton(
        child: Text(
          AppLocalizations.of(context)!.confirm,
          style: TextStyle(
              letterSpacing: 1,
              fontSize: size_6 + 1,
              color: white,
              fontWeight: mediumBoldWeight),
        ),
        onPressed:
        (widget.shipperApproval == false && widget.transporterApproval == true)
        ? null
        :
            () async {
          if(widget.shipperApproval == true && widget.transporterApproval == false){
            // putBidForAccept(bidId);
          }
           showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return BookLoadAlertDialogBox(
                  truckModelList: truckDetailsList,
                  driverModelList: driverDetailsList,
                  postLoadId: widget.postLoadId,
                  biddingModel: widget.biddingModel,
                  directBooking: false);
            }
          );
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius_6),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(
              (widget.shipperApproval == false && widget.transporterApproval == true)
              ? unselectedGrey
              :
              liveasyGreen
          ),
        ),
      ),
    );
  }
}
