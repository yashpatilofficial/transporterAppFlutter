import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/loadApis/runSuggestedLoadApiWithPageNo.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/filterButton.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import 'package:liveasy/widgets/suggestedLoadsCard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SuggestedLoadScreen extends StatefulWidget {
  @override
  _SuggestedLoadScreenState createState() => _SuggestedLoadScreenState();
}

class _SuggestedLoadScreenState extends State<SuggestedLoadScreen> {
  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  //for pageNo
  int i = 0;

  List data = [];

  bool loading = false;

  //API CALL--------------------------------------------------------------------
  runSuggestedLoadApi(int i) async {
    var suggestedLoadDataList = await runSuggestedLoadApiWithPageNo(i);
    for (var suggestedLoadData in suggestedLoadDataList){
      setState(() {
        data.add(suggestedLoadData);
      });
    }
    setState(() {
      loading = false;
    });
  }
  //API CALL--------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    runSuggestedLoadApi(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        runSuggestedLoadApi(i);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(space_3, space_4, space_3, 0),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(bottom: space_4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Header(
                        reset: false,
                        text: 'suggestedLoad'.tr,
                        // AppLocalizations.of(context)!.suggestedLoad,
                        backButton: true),
                    FilterButtonWidget()
                  ],
                ),
              ),
              Container(
                // height: (MediaQuery.of(context).size.height),
                height: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight -
                    space_6,
                color: backgroundColor,
                child: loading == true
                    ? OnGoingLoadingWidgets()
                    : RefreshIndicator(
                  color: lightNavyBlue,
                  onRefresh: () {
                    setState(() {
                      data.clear();
                      loading = true;
                    });
                    return runSuggestedLoadApi(0);
                  },
                      child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          itemCount: data.length+1,
                          itemBuilder: (BuildContext context, index) => index == data.length
                              ? Container(child: bottomProgressBarIndicatorWidget(),
                                    margin: EdgeInsets.only(bottom: space_2),)
                              : SuggestedLoadsCard(loadDetailsScreenModel: data[index],
                          ),
                        ),
                    ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
