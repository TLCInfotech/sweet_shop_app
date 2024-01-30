import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/log_out_dialog.dart';
import 'package:sweet_shop_app/presentation/menu/master/company_user/company_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/company_user/create_user.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee/franchisee.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee_purchase_rate/franchisee_purchase_rate.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee_sale_rate/franchisee_sale_rate.dart';
import 'package:sweet_shop_app/presentation/menu/master/item_category/Item_Category.dart';
import 'package:sweet_shop_app/presentation/menu/master/items/items.dart';
import 'package:sweet_shop_app/presentation/menu/master/unit/Units.dart';

class MenuActivity extends StatefulWidget {
  final MenuActivityInterface mListener;

  const MenuActivity({super.key, required this.mListener});

  @override
  State<MenuActivity> createState() => _MenuActivityState();
}

class _MenuActivityState extends State<MenuActivity>
    with LogOutDialogInterface {
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
    print("hkhjghjkgjgh  $openDropDown");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.white,
      child: Container(
        width: SizeConfig.screenWidth * .8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: SizeConfig.screenHeight * .05,
                ),
                getTopBar(SizeConfig.screenHeight, SizeConfig.screenWidth),
                getAddBottomBarLayout(
                    SizeConfig.screenHeight, SizeConfig.screenWidth),
              ],
            ),
            getAddAppVersionLayout(
                SizeConfig.screenHeight, SizeConfig.screenWidth),
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
        padding: EdgeInsets.only(right: parentWidth * .03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              onDoubleTap: () {},
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.clear,
                    size: parentHeight * .035,
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
  Widget getAddBottomBarLayout(double parentHeight, double parentWidth) {
    return Column(
      children: [
        getAddTransactionLayout(parentHeight, parentWidth),
        getAddReportLayout(parentHeight, parentWidth),
        openDropDown == false
            ? getAddMasterLayout(parentHeight, parentWidth)
            : getAddMasterSubLayout(parentHeight, parentWidth),
        getAddLogoutLayout(parentHeight, parentWidth),
      ],
    );
  }

  /* Widget for Logout Layout */
  Widget getAddLogoutLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return LogOutDialog(
                mListener: this,
              );
            });
      },
      onDoubleTap: () {},
      child: Container(
        alignment: Alignment.centerLeft,
        height: parentHeight * .06,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1, color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(left: parentWidth*.05,right: parentWidth*.05),
          child: const Text(
            StringEn.LOGOUT,
            style: page_heading_textStyle,
          ),
        ),
      ),
    );
  }

  bool openDropDown = false;

  /* Widget for Master Layout */
  Widget getAddMasterLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          openDropDown = true;
        });
      },
      onDoubleTap: () {},
      child: Container(
        alignment: Alignment.centerLeft,
        height: parentHeight * .06,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1, color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(left: parentWidth*.05,right: parentWidth*.03),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringEn.MASTER,
                style:page_heading_textStyle,
              ),
              Icon(
                Icons.arrow_drop_down_sharp,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Widget for Master Layout */
  Widget getAddMasterSubLayout(double parentHeight, double parentWidth) {
    return Container(
      alignment: Alignment.centerLeft,
      height: parentHeight * .53,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1, color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
        ),
      ),
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.05,right: parentWidth*.03,top: parentHeight*.01),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  openDropDown = false;
                });
              },
              onDoubleTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringEn.MASTER,
                    style: page_heading_textStyle,
                  ),
                  Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                ],
              ),
            ),
            getFranchiseeSaleRateLayout(parentHeight,parentWidth),
            getFranchiseePurchaseRateLayout(parentHeight,parentWidth),
            getUserLayout(parentHeight,parentWidth),
            getFranchiseeLayout(parentHeight,parentWidth),
            getItemLayout(parentHeight,parentWidth),
            getCategoryLayout(parentHeight,parentWidth),
            getMeasuringUnitLayout(parentHeight,parentWidth),
            getExpenseLayout(parentHeight,parentWidth),
            getExpensceGroupLayout(parentHeight,parentWidth),
            getCompanyInfoLayout(parentHeight,parentWidth),

          ],
        ),
      ),
    );
  }



  Widget getFranchiseeSaleRateLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseeSaleRate()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.FRANCHISE_SALE_RATE,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  Widget getFranchiseePurchaseRateLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseePurchaseRate()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.FRANCHISE_PURCHASE_RATE,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  Widget getFranchiseeLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.pop(context);
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context){
              return AddFranchiseeActivity(mListener: this,);
            }
        );
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.FRANCHISE,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  Widget getUserLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserCreate()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.USER,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  Widget getMeasuringUnitLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UnitsActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.MEASURING_UNIT,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  Widget getExpenseLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UnitsActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.EXPENSE,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }
  Widget getExpensceGroupLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UnitsActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.EXPENSE_GROUP,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }
  Widget getCompanyInfoLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyCreate()));
        },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.COMPANY_INFO,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemCategoryActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.CATEGORY,
              style:  page_heading_textStyle,
              textAlign: TextAlign.center,

            ),
          ],
        ),
      ),
    );
  }
  Widget getItemLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              StringEn.ITEM,
              style: page_heading_textStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }




  /* Widget for report Layout */
  Widget getAddReportLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {

      },
      onDoubleTap: () {},
      child: Container(
        alignment: Alignment.centerLeft,
        height: parentHeight * .06,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1, color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(left: parentWidth*.05,right: parentWidth*.05),
          child: const Text(
            StringEn.REPORT,
            style: page_heading_textStyle
          ),
        ),
      ),
    );
  }

  /* Widget for transaction Layout */
  Widget getAddTransactionLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {},
      onDoubleTap: () {},
      child: Container(
        alignment: Alignment.centerLeft,
        height: parentHeight * .06,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1, color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(left: parentWidth*.05,right: parentWidth*.05),
          child: const Text(
            StringEn.TRANSACTION,
            style: page_heading_textStyle
          ),
        ),
      ),
    );
  }



  /* Widget for AppVersion Layout */
  Widget getAddAppVersionLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: parentHeight * .02),
      child: Container(
        alignment: Alignment.center,
        height: parentHeight * .06,
        child: Text(
          "App Version $appVersion",
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal * 3.5,
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

abstract class MenuActivityInterface {
  addHomePage(String screenName);
}

