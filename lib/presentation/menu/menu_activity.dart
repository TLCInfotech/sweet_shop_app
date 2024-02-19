import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/log_out_dialog.dart';
import 'package:sweet_shop_app/presentation/menu/master/company_user/company_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/company_user/users_list.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee/franchisee.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee_purchase_rate/franchisee_purchase_rate.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee_sale_rate/franchisee_sale_rate.dart';
import 'package:sweet_shop_app/presentation/menu/master/item_category/Item_Category.dart';
import 'package:sweet_shop_app/presentation/menu/master/item_opening_balance/item_opening_bal_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/items/items.dart';
import 'package:sweet_shop_app/presentation/menu/master/ledger/expense_group.dart';
import 'package:sweet_shop_app/presentation/menu/master/ledger/expense_listing_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/ledger_opening_balance/ledger_opening_bal_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/unit/Units.dart';
import 'package:sweet_shop_app/presentation/menu/report/Purchase/purchase_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/Sale/sale_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/expense/expense_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/payment/payment_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/purchase/purchase_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/receipt/receipt_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/sell/sell_activity.dart';
import 'report/MIS/mis_report_activity.dart';
import 'report/payment/payment_report_activity.dart';
import 'report/recipt/recipt_report_layout.dart';
import 'setting/change_password_activity.dart';
import 'setting/domain_link_activity.dart';
import 'transaction/expense/ledger_activity.dart';

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
  bool openMasterDropDown = false;
  bool openTransactionDropDown = false;
  bool openReportDropDown = false;
  bool openSettingDropDown = false;
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
        width: SizeConfig.screenWidth * .8,
        child: Column(
          children: [
            Container(
              height: SizeConfig.screenHeight * .05,
            ),
            getTopBar(SizeConfig.screenHeight, SizeConfig.screenWidth),
            Container(
              height: SizeConfig.screenHeight * .85,
              child: getAllFieldLayout(
                  SizeConfig.screenHeight, SizeConfig.screenWidth),
            ),
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

  /* Widget for all field Layout */
  Widget getAllFieldLayout(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        openTransactionDropDown==false?getAddTransactionLayout(parentHeight, parentWidth):
        getTransactionSubLayout(parentHeight, parentWidth),
        openReportDropDown==false?getAddReportLayout(parentHeight, parentWidth):
        getReportSubLayout(parentHeight, parentWidth),
        openMasterDropDown == false
            ? getAddMasterLayout(parentHeight, parentWidth)
            : getAddMasterSubLayout(parentHeight, parentWidth),
        openSettingDropDown == false
            ? getSettingLayout(parentHeight, parentWidth)
            : getSettingSubLayout(parentHeight, parentWidth),
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



  /* Widget for Master Layout */
  Widget getAddMasterLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          openMasterDropDown = true;
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

  /* Widget for Master sub field Layout */
  Widget getAddMasterSubLayout(double parentHeight, double parentWidth) {
    return Container(
      alignment: Alignment.centerLeft,
      height: parentHeight * .62,
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
                  openMasterDropDown = false;
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
            getOpeningBalanceLayout(parentHeight,parentWidth),
            getLeaderOpeningLayout(parentHeight,parentWidth),
          ],
        ),
      ),
    );
  }


  /* Widget for franchisee sale rate Layout */
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

  /* Widget for franchisee purchase rate sub field Layout */
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
  /* Widget for franchisee  Layout */
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

  /* Widget for user Layout */
  Widget getUserLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UsersList()));
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

  /* Widget for measuring unit Layout */
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

  /* Widget for expense Layout */
  Widget getExpenseLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseListingActivity()));
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

  /* Widget for expense group Layout */
  Widget getExpensceGroupLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseGroup()));
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

  /* Widget for company info Layout */
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

  /* Widget for item opening balance Layout */
  Widget getOpeningBalanceLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemOpeningBal()));
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
              StringEn.OPENING_BAL,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for ledger opening balance Layout */
  Widget getLeaderOpeningLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerOpeningBal()));
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
              StringEn.LEARDER_OPENING_BAL,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for category Layout */
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
              StringEn.ITEM_CATEGORY,
              style:  page_heading_textStyle,
              textAlign: TextAlign.center,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for item Layout */
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
    return  GestureDetector(
      onTap: () {
        setState(() {
          openReportDropDown = true;
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
                StringEn.REPORT,
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


  /* Widget for report sub field Layout */
  Widget getReportSubLayout(double parentHeight, double parentWidth) {
    return Container(
      alignment: Alignment.centerLeft,
      height: parentHeight * .35,
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
                  openReportDropDown = false;
                });
              },
              onDoubleTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringEn.REPORT,
                    style: page_heading_textStyle,
                  ),
                  Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                ],
              ),
            ),
            getSellReportLayout(parentHeight,parentWidth),
            getPurchaseReportLayout(parentHeight,parentWidth),
            getExpenseReportLayout(parentHeight,parentWidth),
            getPaymentReportLayout(parentHeight,parentWidth),
            getReciptReportLayout(parentHeight,parentWidth),
            getMISReportLayout(parentHeight, parentWidth)
          ],
        ),
      ),
    );
  }


  /* Widget for sell report Layout */
  Widget getSellReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SaleReportActivity()));
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
              StringEn.SALE_REPORT,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for purchase report Layout */
  Widget getPurchaseReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseReportActivity()));
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
              StringEn.PURCHASE_REPORT,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for expense report Layout */
  Widget getExpenseReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseReportActivity(
        )));
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
              StringEn.EXPENSE_REPORT,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for payment report Layout */
  Widget getPaymentReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentReportActivity(
        )));
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
              StringEn.PAYMENT_REPORT,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for receipt report Layout */
  Widget getReciptReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecieptReportActivity(
        )));
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
              StringEn.RECEIPT_REPORT,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for mis report Layout */
  Widget getMISReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MisReportActivity(
        )));
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
              StringEn.MIS_REPORT,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }


  /* Widget for transaction Layout */
  Widget getAddTransactionLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          openTransactionDropDown = true;
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
                StringEn.TRANSACTION,
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

  /* Widget for transaction sub field Layout */
  Widget getTransactionSubLayout(double parentHeight, double parentWidth) {
    return Container(
      alignment: Alignment.centerLeft,
      height: parentHeight * .3,
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
                  openTransactionDropDown = false;
                });
              },
              onDoubleTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringEn.TRANSACTION,
                    style: page_heading_textStyle,
                  ),
                  Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                ],
              ),
            ),
            getSellLayout(parentHeight,parentWidth),
            getPuerchaseLayout(parentHeight,parentWidth),
            getExpensseLayout(parentHeight,parentWidth),
            getPaymentLayout(parentHeight,parentWidth),
            getReceptLayout(parentHeight,parentWidth),
          ],
        ),
      ),
    );
  }



/* Widget for sell transaction Layout */
  Widget getSellLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SellActivity(
          mListener: this,
        )));
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
              StringEn.SELL,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for purchase transaction Layout */
  Widget getPuerchaseLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseActivity(mListener: this,)));
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
              StringEn.PURCHASE_INVOICE,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for payment transaction Layout */
  Widget getPaymentLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        
        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentActivity(mListener: this)));
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
              StringEn.PAYMENT_INVOICE,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for receipt transaction Layout */
  Widget getReceptLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptActivity(mListener: this)));
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
              StringEn.RECEIPT_INVOICE,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for expense transaction Layout */
  Widget getExpensseLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(mListener: this)));
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
              StringEn.EXPENSES_INVOICE,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for setting Layout */
  Widget getSettingLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          openSettingDropDown = true;
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
                StringEn.SETTING,
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

  /* Widget for Setting sub field Layout */
  Widget getSettingSubLayout(double parentHeight, double parentWidth) {
    return Container(
      alignment: Alignment.centerLeft,
      height: parentHeight * .15,
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
                  openSettingDropDown = false;
                });
              },
              onDoubleTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringEn.SETTING,
                    style: page_heading_textStyle,
                  ),
                  Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                ],
              ),
            ),
            getChangePassword(parentHeight,parentWidth),
            getDomainLink(parentHeight,parentWidth),
          ],
        ),
      ),
    );
  }

/* Widget for change password Layout */
  Widget getChangePassword(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordActivity()));
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
              StringEn.CHANGE_PASSWORD,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for domain link Layout */
  Widget getDomainLink(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DomainLinkActivity()));
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
              StringEn.DOMAIN_LINK,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
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

