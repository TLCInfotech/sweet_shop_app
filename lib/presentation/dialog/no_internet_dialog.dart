import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';

import '../../core/colors.dart';
import '../../core/internet_check.dart';
import '../../core/size_config.dart';



class NoInternetConformationDialog extends StatefulWidget {
  final InternetCheckInterface? mListener;
  final String? isFor;

  const NoInternetConformationDialog({super.key,  this.mListener,  this.isFor});

  @override
  _NoInternetConformationDialogState createState() => _NoInternetConformationDialogState();
}

class _NoInternetConformationDialogState extends State<NoInternetConformationDialog> {
 late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    startTimer();
  }

  Future startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer =
        Timer.periodic(oneSec, (Timer timer) => checkInterNet());
  }

  checkInterNet() async {
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      _timer?.cancel();
      Navigator.pop(context);
    }

  }
 late double pageTextSize;
 late double problemTextSize;
 late double returnTextSize;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: CommonColor.MAIN_BG,
      child: Container(
          height: SizeConfig.screenHeight,
          color: Colors.transparent,
          child: getLogoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)),
    );

  }

  /*get Reloading Page Layout*/
  Widget getAddOtpSubTextLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
          left: parentWidth * .12,
          right: parentWidth * .12,
          top: parentHeight * .02),
      child: Column(
        children: [
          Text(
            ApplicationLocalizations.of(context).translate("wifi"),
            style: TextStyle(
              color: CommonColor.OTP_SUB_TEXT_COLOR,
              fontSize: SizeConfig.blockSizeHorizontal * 3.8,
              fontFamily: 'Inter_Medium_Font',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            ApplicationLocalizations.of(context).translate("on_try_again"),
            style: TextStyle(
              color: CommonColor.OTP_SUB_TEXT_COLOR,
              fontSize: SizeConfig.blockSizeHorizontal * 3.8,
              fontFamily: 'Inter_Medium_Font',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  /* get add Dr. Pradnya Logo Layout*/
  Widget getLogoLayout(double parentHeight, double parentWidth){
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(top: parentHeight*.25),
          child: Container(
            color: Colors.transparent,
            child: Image(
              image: AssetImage("assets/images/no_internet.png"),
              height: parentHeight* .2,
              width: parentHeight* .2,
            ),
          ),
        ),
        getProblemTextLayout( parentHeight,  parentWidth),
        getAddOtpSubTextLayout( parentHeight,  parentWidth),
        getAddReloadButtonLayout( parentHeight,  parentWidth)
      ],
    );
  }
  /* get Problem Text Layout*/
  Widget getProblemTextLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left:parentWidth* .0, right:parentWidth* .0,top:parentHeight* .07),
      child: Text(
        ApplicationLocalizations.of(context).translate("no_internet"),
        style: TextStyle(
          color: CommonColor.COMMENTS_COUNTS,
          fontSize: SizeConfig.blockSizeHorizontal* 4.7,
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat_Bold',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /*get New Container Layout*/
  Widget getAddReloadButtonLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: (){
        Navigator.pop(context,true);
      },
      onDoubleTap: (){},
      child: Padding(
        padding: EdgeInsets.only(top:parentHeight*.04,),
        child: Container(
          height: parentHeight*.05,
          width: parentWidth*.36,
          decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Center(
            child: Text(
              ApplicationLocalizations.of(context).translate("try_again"),
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockSizeHorizontal* 3.9,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(_timer!=null){
      _timer?.cancel();
    }
    else{}


    super.dispose();
  }

}

abstract class InternetCheckInterface {
  void netConformation(String isFor);
}


