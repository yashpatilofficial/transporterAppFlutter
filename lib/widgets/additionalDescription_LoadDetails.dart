import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class AdditionalDescriptionLoadDetails extends StatelessWidget {
  String? comment;

  AdditionalDescriptionLoadDetails(this.comment);

  @override
  Widget build(BuildContext context) {
    String message = comment.toString();
    if (message.length == 0 || message.isEmpty || message.contains("null"))
      message = "No Comments";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'additionalDescription'.tr,
          // AppLocalizations.of(context)!.additionalDescription,
          style: TextStyle(fontWeight: mediumBoldWeight, fontSize: size_7),
        ),
        SizedBox(
          height: space_2,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(space_1, space_1, space_2, space_2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(space_1 + 3),
              border: Border.all(color: lightGrayishBlue)),
          child: Text(
            message,
            style: TextStyle(fontWeight: normalWeight, fontSize: size_6),
          ),
        ),
      ],
    );
  }
}
