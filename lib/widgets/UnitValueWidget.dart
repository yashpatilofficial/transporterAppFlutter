import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnitValueWidget extends StatelessWidget {
  const UnitValueWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Padding(
      padding: EdgeInsets.only(left: space_4),
      child: Row(
        children: [
          Container(
              child: OutlinedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(2),
                    backgroundColor: providerData.perTruck
                        ? MaterialStateProperty.all(darkBlueColor)
                        : MaterialStateProperty.all(whiteBackgroundColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ))),
                onPressed: () {
                  if (!providerData.perTruck) {

                    providerData.PerTruckTrue(true, false);
                    providerData.updateResetActive(true);
                    if (providerData.price == 0) {
                        providerData.updateHintText("enter price");
                        providerData.updateBorderColor(red);
                    }
                  }
                  else
                  {
                    providerData.updateResetActive(false);
                    providerData.PerTruckTrue(false, false);
                    providerData.updateBorderColor(darkBlueColor);
                  }
                },
                child: Text('perTruck'.tr,
                  // AppLocalizations.of(context)!.perTruck,
                  style: TextStyle(
                    fontSize: size_7,
                      fontWeight: regularWeight,
                      color: providerData.perTruck? white : black),
                ),
              )
            ),
          SizedBox(width: space_8),
         Container(
                child: OutlinedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(2),
                      backgroundColor: providerData.perTon
                          ? MaterialStateProperty.all(darkBlueColor)
                          : MaterialStateProperty.all(whiteBackgroundColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ))),
                  onPressed: () {
                    if (!providerData.perTon) {

                      providerData.PerTonTrue(true, false);
                      providerData.updateResetActive(true);
                      if (providerData.price == 0) {
                          providerData.updateHintText("enter price");
                          providerData.updateBorderColor(red);
                      }
                    }
                    else
                      {
                        providerData.updateResetActive(false);
                        providerData.PerTonTrue(false, false);
                        providerData.updateBorderColor(darkBlueColor);
                      }
                  },
                  child: Text('perTon'.tr,
                    // AppLocalizations.of(context)!.perTon,
                    style: TextStyle(
                        fontSize: size_7,
                        fontWeight: regularWeight,
                        color: providerData.perTon? white : black),
                  ),
                )
            ),
        ],
      ),
    );
  }
}
