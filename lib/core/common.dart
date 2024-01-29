


import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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

 static pickDocumentFromfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );

    if (result != null) {
      print(result.files.first.name);
      PlatformFile file = result.files.first;
      Uint8List? fileBytes = result.files.first.bytes;

      final bytes = fileBytes?.length;
      print(" BYTES : $bytes");

      final kb = bytes! / 1024;

      final mb = kb! / 1024;

      if(mb<= 10){

        String fileName = result.files.first.name;

        print("FILENAE: $fileName");

        String bs4str = base64.encode(fileBytes!);

        File _file = File((result.files.single.path)as String);

        return _file;
      }
      else
      {
        // Fluttertoast.showToast(msg: "File Should be of size <= 10MB",toastLength: Toast.LENGTH_SHORT);
        return null;
      }
    }
  }

}