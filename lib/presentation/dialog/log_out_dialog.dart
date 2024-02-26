import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';

class LogOutDialog extends StatefulWidget {
  final LogOutDialogInterface mListener;

  const LogOutDialog({super.key, required this.mListener});

  @override
  State<LogOutDialog> createState() => _LogOutDialogState();
}



class _LogOutDialogState extends State<LogOutDialog> {


  bool isLoaderShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * .15,
                  right: SizeConfig.screenWidth * .15),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:   Container(
                  // height: SizeConfig.screenHeight * .29,
                  // ignore: unnecessary_new
                  decoration:   const BoxDecoration(
                    borderRadius:   BorderRadius.all(Radius.circular(8.0)),
                    //color: CommonColor.RED_COLOR,
                  ),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getAddLogOutDialogLayout(
                          SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getAddLogOutDialogTextLayout(
                          SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getAddMainMessageLayout(
                          SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getAddCancelButtonLayout(
                          SizeConfig.screenHeight, SizeConfig.screenWidth),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(child: CommonWidget.isLoader(isLoaderShow))
        ],
      ),
    );
  }

  /* Main Delete Message Layout */
  Widget getAddLogOutDialogLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .019),
      child: Text(
        ApplicationLocalizations.of(context)!.translate("log_out")!,
        style: TextStyle(
          color: CommonColor.BLACK_COLOR,
          fontSize: SizeConfig.blockSizeHorizontal * 5,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto_Bold',
        ),
      ),
    );
  }

  /* Get Add Delete Game Text Layout */
  Widget getAddLogOutDialogTextLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
          top: parentHeight * .015,
          left: parentWidth * .03,
          right: parentWidth * .03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              ApplicationLocalizations.of(context)!.translate("log_out_sub_text")!,
              style: TextStyle(
                color: CommonColor.BLACK_COLOR,
                fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto_Regular',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /* Get Add Main Message Layout */
  Widget getAddMainMessageLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .027),
      child: GestureDetector(
        onTap: ()  {
          setState(() {
            AppPreferences.clearAppPreference();
            CommonWidget.gotoLoginScreen(context);
          });

        },
        onDoubleTap: () {},
        child: Container(
          height: parentHeight * .06,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              top: BorderSide(width: 1, color: CommonColor.HINT_TEXT),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ApplicationLocalizations.of(context)!.translate("log_out_caps")!,
                style: TextStyle(
                  color: CommonColor.RED_COLOR,
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto_Medium',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Get Add Cancel Button Layout */
  Widget getAddCancelButtonLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      onDoubleTap: () {},
      child: Padding(
        padding: EdgeInsets.only(top: parentHeight * .0),
        child: Container(
          height: parentHeight * .07,
          decoration:   const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1, color: CommonColor.HINT_TEXT),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              ApplicationLocalizations.of(context)!.translate("cancel")!,
                style: TextStyle(
                  color: CommonColor.BLACK_COLOR,
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto_Medium',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }





}



abstract class LogOutDialogInterface {
  isShowLoader(bool isShowLoader);
}
