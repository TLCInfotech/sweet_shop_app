


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dialog/exit_app_dialog.dart';
import 'package:sweet_shop_app/presentation/login/Login.dart';

class CommonWidget {

  static getCommonPadding(double padding, Color colors) {
    return Container(
      height: padding,
      color: colors,
    );
  }
  static getScreenBackgroundGradient() {
    return RadialGradient(center: Alignment.center, radius: 0.7, stops: [
      .001,
      1.999
    ], colors: <Color>[

      CommonColor.WHITE_COLOR,
      CommonColor.WHITE_COLOR,
    ]);
  }

  static Widget getShowError(var topMargin,var rightMargin,var fontSize,bool isVis,String errorMsg){
    return Positioned(
      right: rightMargin,
      top: topMargin,
      child: isVis
          ? Container(
        alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2),width:1),
            borderRadius: BorderRadius.circular(8)
          ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                errorMsg,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir_Heavy',
                  fontSize: fontSize,
                ),
                textScaleFactor: 1.02,
              ),
            ),
          )
          : Container(),
    );
  }

  /*Function for clear local data and goto loginPage*/
  static gotoLoginScreen(BuildContext context) {
     Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginActivity()),
          (Route<dynamic> route) => false,
    );
  }

  static isLoader(bool isLoaderShows)  {
    return Visibility(
      visible: isLoaderShows,
      child:  Container(
        height: SizeConfig.safeUsedHeight,
        width: SizeConfig.screenWidth,
        color: Colors.transparent,
        child:const Padding(
          padding: EdgeInsets.all(160.0),
          child: Image(
            image: AssetImage("assets/images/rounded_blocks.gif"),
            // color: CommonColor.THEME_COLOR,
          ),
        ),
      ),
    );
  }


  static showExitDialog(BuildContext context, String message, isDialogType) {
    if (context != null) {
      showCupertinoDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: true,
        builder: (context) {
          return ExitAppDialog(
            // message: message,
            isDialogType: isDialogType,
          );
        },
      );
    }
  }

}