import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';

class ExitScreenDialog extends StatefulWidget {
  final String isDialogType;

  const ExitScreenDialog({super.key, required this.isDialogType});


  @override
  State<ExitScreenDialog> createState() => _ExitScreenDialogState();
}

class _ExitScreenDialogState extends State<ExitScreenDialog> {


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
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Container(
                      height: SizeConfig.screenHeight * .2,
                      width: SizeConfig.screenWidth * .8,
                      decoration: const BoxDecoration(
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
              ApplicationLocalizations.of(context)!.translate("exit_screen")!,
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
             Navigator.pop(context);
             Navigator.pop(context);
            } else{}
          },
          onDoubleTap: () {},
          child: Container(
            height:parentHeight*.05,
            width: parentWidth*.4,
            // width: SizeConfig.blockSizeVertical * 20.0,
            decoration: const BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("yes")!,
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
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("no")!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeVertical * 2.1,
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
