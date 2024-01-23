import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';

class ExitAppDialog extends StatefulWidget {
  final String isDialogType;

  const ExitAppDialog({super.key, required this.isDialogType});


  @override
  State<ExitAppDialog> createState() => _ExitAppDialogState();
}

class _ExitAppDialogState extends State<ExitAppDialog> {


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onDoubleTap: () {},
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10.0),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Container(
                      height: SizeConfig.screenHeight * .2,
                      width: SizeConfig.screenWidth * .8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: SizeConfig.screenHeight*.15,
                              child: getMessageText(SizeConfig.screenHeight,SizeConfig.screenWidth)),

                          Container(
                              height: SizeConfig.screenHeight*.05,
                              child: getAddForButtonsLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned.fill(child: CommonWidget.isLoaderShow(isLoaderShow))
          ],
        ),
      ),
    );
  }

  /*text filed Widget*/
  Widget getMessageText(double parentHeight,double parentWidth) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
              "Are you sure you want to exit from this app",
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.blockSizeVertical * 2.3,
                // fontFamily: Constant.AVENIR_HEAVY,
              ),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

  /* Widget for Buttons Layout0 */
  Widget getAddForButtonsLayout(double parentHeight,double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            if (widget.isDialogType == "1") {
              exit(0);
            } else{}
          },
          onDoubleTap: () {},
          child: Container(
            height:parentHeight*.05,
            width: parentWidth*.4,
            // width: SizeConfig.blockSizeVertical * 20.0,
            decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeVertical * 2.1,
                    // fontFamily: Constant.AVENIR_HEAVY
                  ),
                  textScaleFactor: 1.05,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth*.4,
            decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR.withOpacity(0.4),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 "No",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeVertical * 2.1,
                    // fontFamily: Constant.AVENIR_HEAVY
                  ),
                  textScaleFactor: 1.05,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
