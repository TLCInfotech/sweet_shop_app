import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/localss/application_localizations.dart';
import '../../core/size_config.dart';

class BackPageDialog extends StatefulWidget {
  final message;
  final  Function(dynamic value) onCallBack;
  const BackPageDialog({super.key,  this.message, required this.onCallBack , });

  @override
  State<BackPageDialog> createState() => _ErrorOccuredDialogState();
}

class _ErrorOccuredDialogState extends State<BackPageDialog> {

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
              ApplicationLocalizations.of(context).translate("save_changes"),
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
          onTap: () async{
            await widget.onCallBack("yes");
            Navigator.pop(context);

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
          onTap: ()async {
             await widget.onCallBack("no");
            Navigator.pop(context);
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
