import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/unverifiedWidget.dart';
import 'package:liveasy/widgets/verifiedWidget.dart';

// ignore: must_be_immutable
class LoadPosterDetails extends StatelessWidget {
  String? loadPosterLocation;
  String? loadPosterName;
  String? loadPosterCompanyName;
  bool? loadPosterCompanyApproved;

  LoadPosterDetails({
    required this.loadPosterLocation,
    required this.loadPosterName,
    required this.loadPosterCompanyName,
    this.loadPosterCompanyApproved,
  });

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Container(
      height: MediaQuery.of(context).size.height * 0.225,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius_2-2),
        color: darkBlueColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: space_2, right: space_3),
            child: CircleAvatar(
              radius: radius_11,
              backgroundColor: white,
              child: Container(
                height: space_11,
                width: space_11,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/defaultDriverImage.png"),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  "$loadPosterName",
                  style: TextStyle(
                      fontWeight: mediumBoldWeight,
                      color: white,
                      fontSize: size_9),
                ),
              ),
              SizedBox(
                height: space_1,
              ),
              Row(
                children: [
                  Image(
                    image: AssetImage("assets/icons/buildingIcon.png"),
                    height: space_3 + 1,
                    width: space_3,
                  ),
                  SizedBox(
                    width: space_1 - 2,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      "$loadPosterCompanyName",
                      style: TextStyle(
                          fontWeight: normalWeight,
                          color: white,
                          fontSize: size_6),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: space_1,
              ),
              Row(
                children: [
                  Container(
                    height: space_3,
                    width: space_3 - 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/icons/locationIcon.png",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: space_1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      "$loadPosterLocation",
                      style: TextStyle(
                          fontWeight: normalWeight,
                          color: white,
                          fontSize: size_6),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: space_1 + 1,
              ),
              loadPosterCompanyApproved!
                  ? VerifiedWidget()
                  : UnverifiedWidget()
            ],
          ),
        ],
      ),
    );
  }
}
