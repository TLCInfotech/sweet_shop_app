import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dialog/exit_app_dialog.dart';
import 'package:sweet_shop_app/presentation/login/Login.dart';

import '../presentation/dialog/Delete_Dialog.dart';
import '../presentation/dialog/ErrorOccuredDialog.dart';
import '../presentation/dialog/ShowInformationDialog.dart';
import '../presentation/dialog/no_internet_dialog.dart';
import 'app_preferance.dart';
import 'common_style.dart';
class CommonWidget {
  static getCurrencyFormat(var amount) {
    return NumberFormat.currency(locale: 'en_IN', symbol: '₹', name: "", decimalDigits: 2,).format(amount);
  }

  static getCommonPadding(double padding, Color colors) {
    return Container(
      height: padding,
      color: colors,
    );
  }

  static getScreenBackgroundGradient() {
    return const RadialGradient(center: Alignment.center, radius: 0.7, stops: [
      .001,
      1.999
    ], colors: <Color>[
      CommonColor.WHITE_COLOR,
      CommonColor.WHITE_COLOR,
    ]);
  }

  static Future<DateTime?> startDatee(BuildContext context, DateTime date, int days) async {
    final DateTime today = DateTime.now();
    final DateTime firstSelectableDate = today.subtract(Duration(days: days));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: firstSelectableDate,
      lastDate: today,
      selectableDayPredicate: (DateTime day) {
        return day.isAfter(firstSelectableDate.subtract(Duration(days: 1))) && day.isBefore(today.add(Duration(days: 1)));
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CommonColor.THEME_COLOR, // <-- SEE HERE
              onPrimary: CommonColor.WHITE_COLOR, // <-- SEE HERE
              onSurface: CommonColor.BLACK_COLOR, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: CommonColor.BLACK_COLOR, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      print(formattedDate);
      return picked;
    } else {
      return null;
    }
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
    AppPreferences.clearAppPreference();
     Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginActivity()),
          (Route<dynamic> route) => false,
    );
  }





  static String errorDialog(BuildContext context, String message) {
    if (context != null) {
      showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
            // return Transform(
            //   transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: ErrorOccuredDialog(
                  message:message,
                  onCallBack:(value){
                    print("INSIDE");
                      return "yes";
                  }
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation2, animation1) {
            return Container();
          });
    }
    return "null";
  }


  static noInternetDialog(BuildContext context, String? message) {
    if (message != "No internet") {
      if (context != null) {
        showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              final curvedValue =
                  Curves.easeInOutBack.transform(a1.value) - 1.0;
              // return Transform(
              //   transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              return Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: ShowInformationDialog(
                    message: message!,
                  ),
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation2, animation1) {
              return Container();
            });
      }
    } else {
    }
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
/*    showCupertinoDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ExitAppDialog(
          isDialogType: isDialogType, // Or whatever type you need
        );
      },
    );*/
    if (context != null) {
      showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
            // return Transform(
            //   transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: ExitAppDialog(
                  isDialogType: isDialogType,
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation2, animation1) {
            return Container();
          });
    }
     // Navigator.push(context, MaterialPageRoute(builder: (context) => ExitAppDialog(
     //   isDialogType: isDialogType, // Or whatever type you need
     // )));
  /*  showCupertinoDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ExitAppDialog(
              isDialogType: isDialogType, // Or whatever type you need
            );
          },
        );
      },
    );*/
    }
    static convertBytesToFile(data) async{
      List<int> img=[];
      img=(data).whereType<int>().toList();
      Uint8List imageInUnit8List= Uint8List.fromList(img);
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(imageInUnit8List);
      return file;
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



  static startDate(BuildContext context,date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date as DateTime,
      firstDate: DateTime(2020, 12, 31),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CommonColor.THEME_COLOR, // <-- SEE HERE
              onPrimary: CommonColor.WHITE_COLOR, // <-- SEE HERE
              onSurface: CommonColor.BLACK_COLOR, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: CommonColor.BLACK_COLOR, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      print(formattedDate);
      return picked;
    }
    else{
    return null;
    }
  }

  static previousDate(BuildContext context,date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date as DateTime,
      firstDate: DateTime(1970),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CommonColor.THEME_COLOR, // <-- SEE HERE
              onPrimary: CommonColor.WHITE_COLOR, // <-- SEE HERE
              onSurface: CommonColor.BLACK_COLOR, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: CommonColor.BLACK_COLOR, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      print(formattedDate);
      return picked;
    }
    else{
      return null;
    }
  }

  static getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }
  static getDateLayout(DateTime dateNew) {
    return DateFormat('dd-MM-yyyy').format(dateNew);
  }

  static noInternetDialogNew(BuildContext context) {
    /*if (context != null) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            NoInternetConformationDialog(isFor: "",),
      ),
      );
    }*/
    if (context != null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              NoInternetConformationDialog());
    }

  }

  static getNoData(double parentHeight,double parentWidth,String title){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal * 4.2,
            fontFamily: 'Inter_Medium_Font',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static getPlayerId()   async {
    await OneSignal.shared.setAppId("8915610b-2521-4686-8069-0f5eea3c87b8");
    /// Get the Onesignal userId and update that into the firebase.
    /// So, that it can be used to send Notifications to users later.̥
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status!.userId;
    print("osUserIDsss   $osUserID");
    // We will update this once he logged in and goes to dashboard.
    ////updateUserProfile(osUserID);
    // Preferences.setOnesignalUserId(osUserID);

    if (osUserID != null) AppPreferences.setPushKey(osUserID);
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: false,
    );
  }
}