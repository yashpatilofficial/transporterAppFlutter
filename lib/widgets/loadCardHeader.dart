import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'LoadEndPointTemplate.dart';
import 'priceContainer.dart';

// ignore: must_be_immutable
class LoadCardHeader extends StatelessWidget {
  LoadDetailsScreenModel loadDetails;

  LoadCardHeader({
    required this.loadDetails,
  });

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  @override
  Widget build(BuildContext context) {
    if (truckFilterVariables.truckTypeValueList
        .contains(loadDetails.truckType)) {
      loadDetails.truckType = truckFilterVariables.truckTypeTextList[
          truckFilterVariables.truckTypeValueList
              .indexOf(loadDetails.truckType)];
    }

    return Container(
      padding: EdgeInsets.fromLTRB(space_3, space_3, space_3, space_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Posted Date : ${loadDetails.loadDate}',
                style: TextStyle(fontSize: size_6, color: veryDarkGrey),
              ),
              Icon(Icons.arrow_forward_ios_sharp)
            ],
          ),
          SizedBox(
            height: space_1,
          ),
          LoadEndPointTemplate(
              text: loadDetails.loadingPointCity.toString(),
              endPointType: 'loading'),
          Container(
            height: space_3 + 1,
            padding: EdgeInsets.only(left: space_1 - 3),
            child: CustomPaint(
              foregroundPainter: LinePainter(height: space_3 + 1, width: 1),
            ),
          ),
          LoadEndPointTemplate(
              text: loadDetails.unloadingPointCity.toString(),
              endPointType: 'unloading'),
          SizedBox(
            height: space_1,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Image(
                  image: AssetImage('assets/images/TruckListEmptyImage.png'),
                  height: 24,
                  width: 24,
                ),
              ),
              Text(
                '${loadDetails.truckType} | ${loadDetails.noOfTyres} tyres',
                style:
                    TextStyle(fontSize: size_6, fontWeight: mediumBoldWeight),
              ),
            ],
          ),
          SizedBox(
            height: space_1,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Image(
                  image: AssetImage('assets/images/EmptyLoad.png'),
                  height: 24,
                  width: 24,
                ),
              ),
              Text(
                '${loadDetails.productType} | ${loadDetails.weight} tons',
                style:
                    TextStyle(fontSize: size_6, fontWeight: mediumBoldWeight),
              ),
            ],
          ),
          SizedBox(
            height: space_2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loadDetails.rate != 'NA'
                  ? PriceContainer(
                      rate: loadDetails.rate.toString(),
                      unitValue: loadDetails.unitValue,
                    )
                  : SizedBox(),
              BidButton(
                loadDetails: loadDetails,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
