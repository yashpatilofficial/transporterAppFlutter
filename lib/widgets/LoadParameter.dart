import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';

// ignore: must_be_immutable
class LoadParameter extends StatelessWidget {
  String para;
  LoadParameter({Key? key, required this.para}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      para,
      style: TextStyle(
          fontWeight: regularWeight,
          fontSize: 11,
          color: liveasyBlackColor,
          fontFamily: "Montserrat"),
    );
  }
}
