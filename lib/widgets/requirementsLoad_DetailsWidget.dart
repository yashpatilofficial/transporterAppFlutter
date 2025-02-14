import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/newRowTemplate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class RequirementsLoadDetails extends StatelessWidget {
  Map loadDetails;

  RequirementsLoadDetails({required this.loadDetails});

  @override
  Widget build(BuildContext context) {
    loadDetails['unitValue'] =
        loadDetails['unitValue'] == 'PER_TON' ? 'tonne' : 'truck';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'requirement'.tr,
          // AppLocalizations.of(context)!.requirement,
          style: TextStyle(fontWeight: mediumBoldWeight, fontSize: size_7),
        ),
        Container(
          padding: EdgeInsets.only(left: space_3, right: space_3, top: space_2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewRowTemplate(
                  label: 'truckType'.tr,
                  // AppLocalizations.of(context)!.truckType,
                  value: loadDetails['truckType']),
              NewRowTemplate(
                  label: 'tyre'.tr,
                  // AppLocalizations.of(context)!.tyre,
                  value: loadDetails["noOfTyres"] == null
                      ? "NA"
                      : loadDetails["noOfTyres"]),
              NewRowTemplate(
                  label: 'weight'.tr,
                  // AppLocalizations.of(context)!.weight,
                  value: "${loadDetails['weight']} tonnes"),
              NewRowTemplate(
                  label: 'productType'.tr,
                  // AppLocalizations.of(context)!.productType,
                  value: loadDetails['productType']),
              NewRowTemplate(
                  label: 'bidPrice'.tr,
                  // 'Bid Price',
                  value: "${loadDetails['rate']}/${loadDetails['unitValue']}"),
            ],
          ),
        ),
      ],
    );
  }
}
