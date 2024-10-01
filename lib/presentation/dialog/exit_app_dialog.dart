import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/menu/setting/language_select_screen.dart';

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
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor:Colors.white.withOpacity(0.1),// Make background transparent
          body: Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  color: Colors.white.withOpacity(0.2), // Semi-transparent overlay
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10.0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Container(
                      height: SizeConfig.screenHeight * .2,
                      width: SizeConfig.screenWidth * .8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: SizeConfig.screenHeight * .15,
                            child: getMessageText(SizeConfig.screenHeight, SizeConfig.screenWidth),
                          ),
                          Container(
                            height: SizeConfig.screenHeight * .05,
                            child: getAddForButtonsLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Text field Widget */
  Widget getMessageText(double parentHeight, double parentWidth) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            ApplicationLocalizations.of(context)!.translate("exit_app_sub_text")!,
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.blockSizeVertical * 2.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /* Widget for Buttons Layout */
  Widget getAddForButtonsLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            if (widget.isDialogType == "1") {
              exit(0);
            } else {}
          },
          child: Container(
            height: parentHeight * .05,
            width: parentWidth * .4,
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
          child: Container(
            height: parentHeight * .05,
            width: parentWidth * .4,
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
