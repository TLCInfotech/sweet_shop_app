import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/log_out_dialog.dart';
import 'package:sweet_shop_app/presentation/item_category/Item_Category.dart';
import 'package:sweet_shop_app/presentation/item_category/item_create_activity.dart';
import 'package:sweet_shop_app/presentation/master/master_list_activity.dart';
import 'package:sweet_shop_app/presentation/unit/Units.dart';


class MenuActivity extends StatefulWidget {
  final MenuActivityInterface mListener;


  const MenuActivity({super.key, required this.mListener});

  @override
  State<MenuActivity> createState() => _MenuActivityState();
}

class _MenuActivityState extends State<MenuActivity>with LogOutDialogInterface{

  String firstName = "";
  String lastName = "";
  String email = "";
  String profilePic = "";
  File imageFile = File('');
  String serverUrl = '';
  String appVersion = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.white,
      child: Container(
        width: SizeConfig.screenWidth*.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: SizeConfig.screenHeight * .05,
                ),
                getTopBar(SizeConfig.screenHeight, SizeConfig.screenWidth),
                getAddBottomBarLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
              ],
            ),
            getAddAppVersionLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          ],
        ),
      ),
    );
  }

  /* Widget for Top Bar Layout */
  Widget getTopBar(double parentHeight, double parentWidth) {
    return Container(
      height: SizeConfig.screenHeight * .06,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Padding(
        padding:  EdgeInsets.only(right: parentWidth*.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              onDoubleTap: (){},
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.clear,
                    size: parentHeight*.035,
                    color: CommonColor.BLACK_COLOR,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /* Widget for Bottom Bar Layout */
  Widget getAddBottomBarLayout(double parentHeight, double parentWidth){
    return Column(
      children: [
        getAddMasterLayout(parentHeight,parentWidth),
        getAddReportLayout(parentHeight,parentWidth),
        getAddTransactionLayout(parentHeight,parentWidth),
        getAddLogoutLayout(parentHeight,parentWidth),
      ],
    );
  }


  /* Widget for Logout Layout */
  Widget getAddLogoutLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: (){
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context){
              return LogOutDialog(mListener: this,);
            }
        );
      },
      onDoubleTap: (){},
      child: Container(
        alignment: Alignment.center,
        height: parentHeight*.06,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1,color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
          ),
        ),
        child: Text(
          StringEn.LOGOUT,
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal* 4.2,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter_SemiBold_Font",
          ),
        ),
      ),
    );
  }
  
  /* Widget for Master Layout */
  Widget getAddMasterLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MasterActivity()));

      },
      onDoubleTap: (){},
      child: Container(
        alignment: Alignment.center,
        height: parentHeight*.06,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1,color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
          ),
        ),
        child: Text(
          StringEn.MASTER,
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal* 4.2,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter_SemiBold_Font",
          ),
        ),
      ),
    );
  }
  /* Widget for report Layout */
  Widget getAddReportLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItem()));

      },
      onDoubleTap: (){},
      child: Container(
        alignment: Alignment.center,
        height: parentHeight*.06,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1,color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
          ),
        ),
        child: Text(
          StringEn.REPORT,
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal* 4.2,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter_SemiBold_Font",
          ),
        ),
      ),
    );
  }

  /* Widget for transaction Layout */
  Widget getAddTransactionLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: (){

      },
      onDoubleTap: (){},
      child: Container(
        alignment: Alignment.center,
        height: parentHeight*.06,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1,color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
          ),
        ),
        child: Text(
          StringEn.TRANSACTION,
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal* 4.2,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter_SemiBold_Font",
          ),
        ),
      ),
    );
  }

  /* Widget for AppVersion Layout */
  Widget getAddAppVersionLayout(double parentHeight, double parentWidth){
    return  Padding(
      padding: EdgeInsets.only(bottom: parentHeight*.02),
      child: Container(
        alignment: Alignment.center,
        height: parentHeight*.06,
        child: Text(
          "App Version $appVersion",
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal* 3.5,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter_SemiBold_Font",
          ),
        ),
      ),
    );
  }

  @override
  isShowLoader(bool isShowLoader) {
    // TODO: implement isShowLoader
  }



}
abstract class MenuActivityInterface{
  addHomePage(String screenName);
}