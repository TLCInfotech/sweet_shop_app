import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';
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
import 'package:sweet_shop_app/presentation/menu/master/item_opening_balance_for_company/item_opening_bal_for_company.dart';
import 'package:sweet_shop_app/presentation/menu/master/items/items.dart';
import 'package:sweet_shop_app/presentation/menu/master/ledger_group/expense_group.dart';
import 'package:sweet_shop_app/presentation/menu/master/ledger/expense_listing_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/ledger_opening_balance/ledger_opening_bal_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/unit/Units.dart';
import 'package:sweet_shop_app/presentation/menu/report/Purchase/purchase_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/Sale/sale_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/expense/expense_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/contra/contra_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/credit_note/credit_note_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/debit_Note/debit_note_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/journal/journal_voucher_list.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/order/order_invoice_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/payment/payment_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/purchase/purchase_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/receipt/receipt_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/sell/sell_activity.dart';
import '../../core/localss/application_localizations.dart';
import 'report/MIS/mis_report_activity.dart';
import 'report/payment/payment_report_activity.dart';
import 'report/recipt/recipt_report_layout.dart';
import 'setting/change_password_activity.dart';
import 'setting/domain_link_activity.dart';
import 'transaction/expense/ledger_activity.dart';

class MenuActivity extends StatefulWidget {
  final MenuActivityInterface mListener;

  const  MenuActivity({super.key, required this.mListener});

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
    getLocal();
  }
String companyId="";
  getLocal()async{
    companyId=await AppPreferences.getCompanyId();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)
          ),
        ),
        child: Container(
          width: SizeConfig.screenWidth * .8,

          child: Column(
            children: [
              // Container(
              //   height: SizeConfig.screenHeight * .05,
              // ),
              getTopBar(SizeConfig.screenHeight, SizeConfig.screenWidth),
              Container(
                height: SizeConfig.screenHeight * .85,
                child: getAllFieldLayout(
                    SizeConfig.screenHeight, SizeConfig.screenWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Widget for Top Bar Layout */
  Widget getTopBar(double parentHeight, double parentWidth) {
    return Container(
      height: SizeConfig.screenHeight * .08,
      decoration: BoxDecoration(
        color: CommonColor.THEME_COLOR,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            // bottomLeft: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            offset:   const Offset(0, 5),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(right: parentWidth * .03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                width: SizeConfig.screenHeight * .15,
                image: const AssetImage('assets/images/Shop_Logo.png'),
                // fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              onDoubleTap: () {},
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding:   const EdgeInsets.all(4.0),
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
      physics:   const AlwaysScrollableScrollPhysics(),
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
          child:  Text(
            ApplicationLocalizations.of(context)!.translate("log_out")!,
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
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ApplicationLocalizations.of(context)!.translate("master")!,
                style:page_heading_textStyle,
              ),
                const Icon(
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
      //height: parentHeight * .68,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1, color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
        ),
      ),
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.05,right: parentWidth*.03,top: parentHeight*.01,bottom: parentHeight*.015),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  openMasterDropDown = false;
                });
              },
              onDoubleTap: () {},
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ApplicationLocalizations.of(context)!.translate("master")!,
                    style: page_heading_textStyle,
                  ),
                    const Icon(
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
            getOpeningBalanceForCompanyLayout(parentHeight,parentWidth),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    FranchiseeSaleRate(
          compId: companyId,
        )));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("franchisee_sale_rate")!,
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

        Navigator.push(context, MaterialPageRoute(builder: (context) =>    FranchiseePurchaseRate(
          compId: companyId,
        )));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("franchisee_purchase_rate")!,
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
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("franchisee")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const UsersList()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("user")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const UnitsActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("measuring_unit")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const ExpenseListingActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("ledger")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const ExpenseGroup()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("ledger_group")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  CompanyCreate(
          companyId: companyId,
        )));
        },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("company_info")!,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for item opening balance Layout */
  Widget getOpeningBalanceForCompanyLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    CreateItemOpeningBalForCompany(dateNew: DateTime.now().toString())));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Expanded(
              child: Text(
                ApplicationLocalizations.of(context)!.translate("company_item_opening")!,
                style: page_heading_textStyle,
                textAlign: TextAlign.start,
              ),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const ItemOpeningBal()));
        },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Expanded(
              child: Text(
                ApplicationLocalizations.of(context)!.translate("item_opening_balance")!,
                style: page_heading_textStyle,
                textAlign: TextAlign.start,
              
              ),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const LedgerOpeningBal()));
        },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("ledger_opening_balance")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const ItemCategoryActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("item_category")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const ItemsActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("item")!,
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
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ApplicationLocalizations.of(context)!.translate("report")!,
                style:page_heading_textStyle,
              ),
              const Icon(
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
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ApplicationLocalizations.of(context)!.translate("report")!,
                    style: page_heading_textStyle,
                  ),
                  const Icon(
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const SaleReportActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("sale_report")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const PurchaseReportActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("purchase_report")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const ExpenseReportActivity(
        )));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("expense_report")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const PaymentReportActivity(
        )));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("payment_report")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const RecieptReportActivity(
        )));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("receipt_report")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const MisReportActivity(
        )));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("mis_report")!,
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
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ApplicationLocalizations.of(context)!.translate("transaction")!,
                style:page_heading_textStyle,
              ),
              const Icon(
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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1, color: CommonColor.BLACK_COLOR.withOpacity(0.2)),
        ),
      ),
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.05,right: parentWidth*.03,top: parentHeight*.01,bottom: parentHeight*.01),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  openTransactionDropDown = false;
                });
              },
              onDoubleTap: () {},
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ApplicationLocalizations.of(context)!.translate("transaction")!,
                    style: page_heading_textStyle,
                  ),
                  const Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                ],
              ),
            ),
            getOrderInvoice(parentHeight,parentWidth),
            getSellLayout(parentHeight,parentWidth),
            getPuerchaseLayout(parentHeight,parentWidth),
            getExpensseLayout(parentHeight,parentWidth),
            getPaymentLayout(parentHeight,parentWidth),
            getReceptLayout(parentHeight,parentWidth),
            getContraLayout(parentHeight,parentWidth),
            getJournalLayout(parentHeight,parentWidth),
            getDebitLayout(parentHeight,parentWidth),
            getCreditLayout(parentHeight,parentWidth),
          ],
        ),
      ),
    );
  }



/* Widget for sell transaction Layout */
  Widget getOrderInvoice(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderInvoiceActivity(
          mListener: this,
        )));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("order_invoice")!,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
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
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("sale_invoice")!,
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
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("purchase_invoice")!,
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
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("payment_invoice")!,
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
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("receipt_detail")!,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for journal transaction Layout */
  Widget getDebitLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DebitNoteActivity(mListener: this)));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("debit_note_voucher")!,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }
  /* Widget for credit transaction Layout */
  Widget getCreditLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreditNoteActivity(mListener: this)));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("credit_note_voucher")!,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for journal transaction Layout */
  Widget getJournalLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => JournalVoucherActivity(mListener: this)));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("journal")!,
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for contra transaction Layout */
  Widget getContraLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ContraActivity(mListener: this)));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("contra")!,
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
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("expense_invoice")!,
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
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ApplicationLocalizations.of(context)!.translate("setting")!,
                style:page_heading_textStyle,
              ),
                const Icon(
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
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ApplicationLocalizations.of(context)!.translate("setting")!,
                    style: page_heading_textStyle,
                  ),
                  const Icon(
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const ChangePasswordActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("change_password")!,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>   const DomainLinkActivity()));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context)!.translate("domain_link")!,
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

