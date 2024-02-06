import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/constant.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/home/home_fragment.dart';
import 'package:sweet_shop_app/presentation/menu/master/user/user_fragment.dart';
import 'package:sweet_shop_app/presentation/menu/menu_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/purchase/purchase_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/sell/sell_activity.dart';

import '../menu/transaction/expense/ledger_activity.dart';
import '../menu/transaction/payment/payment_activity.dart';

class DashboardActivity extends StatefulWidget {

  @override
  State<DashboardActivity> createState() => _DashboardActivityState();
}

class _DashboardActivityState extends State<DashboardActivity>with HomeFragmentInterface,UserFragmentInterface,
    MenuActivityInterface{
  bool isLoader = false;


  double doubleValueLat = 0.0;
  double doubleValueLong = 0.0;

  String  companyLatitude = "";
  String  companyLongitude = "";
  double distanceInMeters = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addNewScreen(
        HomeFragment(
          mListener: this,
        ),
        Constant.HOME_FRAGMENT);

  }


  late Widget widParentScreen;
  late String currentScreen;

  /*Function for change Screen*/
  addNewScreen(Widget newScreen, String tag) {
    currentScreen = tag;
    if (mounted) {
      setState(() {
        switch (currentScreen) {
          case Constant.DASHBOARD:
            break;
        }
      });
    }
    if (mounted) {
      setState(() {
        widParentScreen = newScreen;
      });
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      //onWillPop: () async => false,
      child: Scaffold(

        backgroundColor: CommonColor.MAIN_BG,
        resizeToAvoidBottomInset: false,
        // drawerEnableOpenDragGesture: false,
        key: _scaffoldKey,
        drawer: MenuActivity(
          mListener: this,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: SizeConfig.screenHeight*.90,
                  child: widParentScreen,
                ),
                Container(
                  height: SizeConfig.screenHeight*.10,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight:Radius.circular(15.6),
                        topLeft: Radius.circular(15.6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CommonColor.DASHBOARD_SHADOW,
                          blurRadius: 3.0,
                        ),]
                  ),
                  child: getBottomBar(SizeConfig.screenHeight,SizeConfig.screenWidth),
                ),
              ],
            ),
            Positioned.fill(child: CommonWidget.isLoader(isLoader)),
          ],
        ),
      ),
    );
  }




  /*widget for bottom bar layout*/
  Widget getBottomBar(double parentHeight,double parentWidth){
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            addNewScreen(
                HomeFragment(
                  mListener: this,
                ),
                Constant.HOME_FRAGMENT);

          },
          onDoubleTap: (){},
          child: Container(
            height: parentHeight*.10,
            width: parentWidth*.2,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/home.png"),
                  height: parentHeight * .035,
                  width:parentHeight * .035,
                  color:currentScreen == Constant.HOME_FRAGMENT ? CommonColor.THEME_COLOR:Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight*.005),
                  child: Text(
                    StringEn.HOME,
                    style: TextStyle(
                        color: currentScreen == Constant.HOME_FRAGMENT ? CommonColor.THEME_COLOR:Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal* 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            addNewScreen(
                SellActivity(
                  mListener: this,
                ),
                Constant.SELL);

          },
          onDoubleTap: (){},
          child: Container(
            height: parentHeight*.10,
            width: parentWidth*.2,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/hand.png"),
                  height: parentHeight * .035,
                  width:parentHeight * .035,
                  color:currentScreen == Constant.SELL ? CommonColor.THEME_COLOR:Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight*.005),
                  child: Text(
                    StringEn.SELL,
                    style: TextStyle(
                        color: currentScreen == Constant.SELL ? CommonColor.THEME_COLOR:Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal* 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            addNewScreen(
                PurchaseActivity(
                  mListener: this,
                ),
                Constant.PURCHASE);

          },
          onDoubleTap: (){},
          child: Container(
            height: parentHeight*.10,
            width: parentWidth*.2,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/payment-method.png"),
                  height: parentHeight * .035,
                  width:parentHeight * .035,
                  color:currentScreen == Constant.PURCHASE ? CommonColor.THEME_COLOR:Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight*.005),
                  child: Text(
                    StringEn.PURCHASE,
                    style: TextStyle(
                        color: currentScreen == Constant.PURCHASE ? CommonColor.THEME_COLOR:Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal* 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            addNewScreen(
                LedgerActivity(
                  mListener: this,
                ),
                Constant.EXPENSE);

          },
          onDoubleTap: (){},
          child: Container(
            height: parentHeight*.10,
            width: parentWidth*.2,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/expense.png"),
                  height: parentHeight * .035,
                  width:parentHeight * .035,
                  color:currentScreen == Constant.EXPENSE ? CommonColor.THEME_COLOR:Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight*.005),
                  child: Text(
                    StringEn.EXPENSE,
                    style: TextStyle(
                        color: currentScreen == Constant.EXPENSE ? CommonColor.THEME_COLOR:Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal* 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            addNewScreen(
                PaymentActivity(
                  mListener: this,
                ),
                Constant.PAYMENT);

          },
          onDoubleTap: (){},
          child: Container(
            height: parentHeight*.10,
            width: parentWidth*.2,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/cashless-payment.png"),
                  height: parentHeight * .035,
                  width:parentHeight * .035,
                  color:currentScreen == Constant.PAYMENT ? CommonColor.THEME_COLOR:Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight*.005),
                  child: Text(
                    StringEn.PAYMENT,
                    style: TextStyle(
                        color: currentScreen == Constant.PAYMENT ? CommonColor.THEME_COLOR:Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal* 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Future<bool> _onBackPressed() {
    return CommonWidget.showExitDialog(context, "", "1");
  }



  @override
  addHomePage(String screenName) {
    // TODO: implement addHomePage
    throw UnimplementedError();
  }


}

