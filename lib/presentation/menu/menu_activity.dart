import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/internet_check.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/api/request_helper.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/main.dart';
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
import 'package:sweet_shop_app/presentation/menu/master/sale_invoice_addiction/sale_invoice_adiction_list_activity.dart';
import 'package:sweet_shop_app/presentation/menu/master/unit/Units.dart';
import 'package:sweet_shop_app/presentation/menu/report/Purchase/purchase_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/Sale/sale_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/credi_note/credit_note_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/debit_note/debit_note_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/expense/expense_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/report/ledger/ledger_vouchers_report.dart';
import 'package:sweet_shop_app/presentation/menu/setting/language_select_screen.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/constant_sale_order_activity.dart';
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
import 'master/user_rights/user_list_for_rights.dart';
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
    setDataComm();
  }
  String logoImage="";
  String companyName="";
  setDataComm()async{
    logoImage=await AppPreferences.getCompanyUrl();
    companyName=await AppPreferences.getCompanyName();
    setState(() {
    });
  }

  List MasterMenu=[];
  List TransactionMenu=[];


String companyId="";
var dataArr;
var dataArrM;
  int workingDay=0;
  DateTime viewWorkDDate=DateTime.now();
  final DateTime today = DateTime.now();
  getLocal()async{
    int workingDays = await AppPreferences.getWorkingDays();
    print("workingDayyyyyy  $workingDays");
    if(workingDays>-1) {
      workingDay=workingDays+1;
      print("NewworkingDayyyyyy  $workingDay");
      viewWorkDDate = today.subtract(Duration(days: workingDay));
      print("jgbjvbgvv   ${viewWorkDDate}");
    }else{
      viewWorkDDate = today.subtract(Duration(days: 50000));
      print("kjgkjgkjgjkgj  $viewWorkDDate");
    }
    companyId=await AppPreferences.getCompanyId();
    setState(() {
    });
    var menu =await (AppPreferences.getMasterMenuList());
    var tr =await (AppPreferences.getTransactionMenuList());
    dataArr=tr;
    dataArrM=menu;
    var re =await (AppPreferences.getReportMenuList());

    setState(() {
      MasterMenu=  (jsonDecode(menu)).map((i) => i['Form_ID']).toList();
      TransactionMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    //  print("jhhjgfgjjgd   $tr  \n  onnnnn $TransactionMenu");
      // MasterMenu=  (jsonDecode(menu)).map((i) => i['Form_ID']).toList();
      List<dynamic> jsonArray = jsonDecode(tr);

      // Get single record where Form_ID is "AT003"
      var singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == 'AT003');

      print("singleRecorddddd   $singleRecord");
    });

    print(MasterMenu.contains("AM001"));
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:        Row(
                  children: [
                    logoImage!=""? Container(
                      height:SizeConfig.screenHeight*.05,
                      width:SizeConfig.screenHeight*.05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          image: DecorationImage(
                            image: FileImage(File(logoImage)),
                            fit: BoxFit.cover,
                          )
                      ),
                    ):Container(),
                    const SizedBox(width: 10.0),
                    Container(
                      width:SizeConfig.screenWidth*.4,
                      child:    Text(
                          companyName,
                          style: appbar_text_style
                      ),
                    )

                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if(mounted){
                  print("HERE BACK");
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                }
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
      children:
      [
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
            ApplicationLocalizations.of(context).translate("log_out"),
            style: page_heading_textStyle,
          ),
        ),
      ),
    );
  }


  /* Widget for Logout Layout */
  Widget getLanguageLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () {

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => LanguageSelectionPage(logoImage: logoImage),
        //   ),
        // ).then((value) async {
        //   if (value == true) {
        //     // Refresh the UI or do something to apply the language change
        //     String lang = await AppPreferences.getLang();
        //     setState(() {
        //       // Update state if necessary
        //
        //       print("godddddd   $_locale");
        //     });
        //   }
        // });

         Navigator.push(context, MaterialPageRoute(builder: (context) =>LanguageSelectionPage(
    logoImage: logoImage,
        )));
        // Navigator.pop(context);
      },
      onDoubleTap: () {},
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
              ApplicationLocalizations.of(context).translate("language"),

              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
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
                ApplicationLocalizations.of(context).translate("master"),
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
                    ApplicationLocalizations.of(context).translate("master"),
                    style: page_heading_textStyle,
                  ),
                    const Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                ],
              ),
            ),
            (MasterMenu.contains("RM005"))?getOpeningBalanceLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("RM006"))?getFranchiseeSaleRateLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("RM007"))?getFranchiseePurchaseRateLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("RM008"))?getFranchiseeLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("LM001"))?getUserLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("AM006"))?  getUserRightsLayout(parentHeight,parentWidth):Container(),//
            (MasterMenu.contains("RM001"))?getItemLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("RM002"))?getCategoryLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("RM004"))?getMeasuringUnitLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("AM001"))? getExpenseLayout(parentHeight,parentWidth) :Container(),
            (MasterMenu.contains("AM002"))?getExpensceGroupLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("AM005"))?getLeaderOpeningLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("RM003"))?getOpeningBalanceForCompanyLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("AM007"))?  getCompanyInfoLayout(parentHeight,parentWidth):Container(),
            (MasterMenu.contains("RM009"))?  getInvoiceAddition(parentHeight,parentWidth):Container()
          ],
        ),
      ),
    );
  }


  /* Widget for franchisee sale rate Layout */
  Widget getFranchiseeSaleRateLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) =>    FranchiseeSaleRate(
          compId: companyId,
            formId: "RM006",
            viewWorkDDate:viewWorkDDate,
            logoImage:logoImage,
            arrData: dataArrM
        )));
      /*  if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/

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
              ApplicationLocalizations.of(context).translate("franchisee_sale_rate"),
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
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) =>    FranchiseePurchaseRate(
          compId: companyId,
            viewWorkDDate:viewWorkDDate,
            logoImage:logoImage,
            formId: "RM007",
            arrData: dataArrM
        )));
     /*   if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/

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
              ApplicationLocalizations.of(context).translate("franchisee_purchase_rate"),
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
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddFranchiseeActivity(mListener: this,
            formId: "RM008",
            logoImage: logoImage,
            arrData: dataArrM)));
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
              ApplicationLocalizations.of(context).translate("franchisee"),
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
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) => UsersList(
          formId:"LM001" ,
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
          arrData: dataArrM,
        )));
    /*    if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
*/
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
              ApplicationLocalizations.of(context).translate("user"),
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for user Layout */
  Widget getUserRightsLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) => UserRightListActivity(
          arrData: dataArrM,
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
          formId: "AM006",
        )));

        if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
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
              ApplicationLocalizations.of(context).translate("user_right"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => UnitsActivity(
          formId:"RM004" ,
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
          arrData: dataArrM,
        )));
   /*     if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
*/
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
              ApplicationLocalizations.of(context).translate("measuring_unit"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ExpenseListingActivity(
          formId:"AM001" , logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
          arrData: dataArrM,
        )));
    /*    if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/
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
              ApplicationLocalizations.of(context).translate("ledger"),
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
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) =>    ExpenseGroup(
          formId:"AM002" , logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
          arrData: dataArrM,
        )));
    /*    if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/
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
              ApplicationLocalizations.of(context).translate("ledger_group"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CompanyCreate(
          companyId: companyId,
          viewWorkDDate:viewWorkDDate,
          arrData: dataArrM, logoImage:logoImage,
          formId: "AM007",
        )));
      /*  if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/
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
              ApplicationLocalizations.of(context).translate("company_info"),
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for company info Layout */
  Widget getInvoiceAddition(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) =>  SaleInvoiceAdditionListActivity(
          arrData: dataArrM, logoImage:logoImage,
          formId: "RM009", mListener: this,
        )));
      /*  if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/
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
                   "Sale Invoice Addition",
            //  ApplicationLocalizations.of(context).translate("company_info"),
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
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) =>CreateItemOpeningBalForCompany(
            dateNew: DateTime.now().toString(),
          viewWorkDDate:viewWorkDDate,
        formId:"RM003" , logoImage:logoImage,
        arrData: dataArrM,
        )));
   /*     if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/

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
                ApplicationLocalizations.of(context).translate("company_item_opening"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ItemOpeningBal(
          newDate: null, logoImage:logoImage,
            formId: "RM005",
            menuuu: "menu",
            come: "Opening",
            viewWorkDDate:viewWorkDDate,
            titleKey: ApplicationLocalizations.of(context).translate("item_opening_balance"),
            arrData: dataArrM
        )));
   /*     if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
*/
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
                ApplicationLocalizations.of(context).translate("item_opening_balance"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerOpeningBal(
          formId:"AM005" , logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
          arrData: dataArrM,
        )));
       /* if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/

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
              ApplicationLocalizations.of(context).translate("ledger_opening_balance"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ItemCategoryActivity(
          formId:"RM002" , logoImage:logoImage,
          arrData: dataArrM,
          viewWorkDDate:viewWorkDDate,
        )));
       /* if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/

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
              ApplicationLocalizations.of(context).translate("item_category"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) =>    ItemsActivity(
          formId:"RM001" , logoImage:logoImage,
          arrData: dataArrM,
          viewWorkDDate:viewWorkDDate,
        )));
     /*   if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/

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
              ApplicationLocalizations.of(context).translate("item"),
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
                ApplicationLocalizations.of(context).translate("report"),
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
      margin: const EdgeInsets.only(bottom: 5),
     // height: parentHeight * .4,
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
                    ApplicationLocalizations.of(context).translate("report"),
                    style: page_heading_textStyle,
                  ),
                  const Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                ],
              ),
            ),
            getMISReportLayout(parentHeight, parentWidth),
            getLedgerVouchersReportLayout(parentHeight,parentWidth),
            getSellReportLayout(parentHeight,parentWidth),
            getPurchaseReportLayout(parentHeight,parentWidth),
            getExpenseReportLayout(parentHeight,parentWidth),
            getPaymentReportLayout(parentHeight,parentWidth),
            getReciptReportLayout(parentHeight,parentWidth),
            getCreditNoteReportLayout(parentHeight,parentWidth),
            getDebitNoteReportLayout(parentHeight,parentWidth),
          ],
        ),
      ),
    );
  }

  /* Widget for sell report Layout */
  Widget getLedgerVouchersReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    LedgerVouchersReport(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("ledger_voucher"),
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for sell report Layout */
  Widget getSellReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    SaleReportActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("sale_report"),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    PurchaseReportActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("purchase_report"),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    ExpenseReportActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("expense_report"),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    PaymentReportActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("payment_report"),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    RecieptReportActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("receipt_report"),
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }

  /* Widget for mis report Layout */
  Widget getCreditNoteReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    CreditReportActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("credit_note_voucher"),
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }


  /* Widget for mis report Layout */
  Widget getDebitNoteReportLayout(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    DebitReportActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
        )));
      },
      onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.04,right: parentWidth*.04,top: parentHeight*.01,bottom: parentHeight*.01),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child:  Text('●'),
            ),
            Text(
              ApplicationLocalizations.of(context).translate("debit_note_voucher"),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) =>MisReportActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("mis_report"),
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
                ApplicationLocalizations.of(context).translate("transaction"),
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
        child:
        // ListView.builder(itemBuilder: (context,index){
        //   return Text(MenuList[index]['Form_ID']);
        // }
        // )
        Column(
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
                    ApplicationLocalizations.of(context).translate("transaction"),
                    style: page_heading_textStyle,
                  ),
                  const Icon(
                    Icons.arrow_drop_up,
                    size: 30,
                  ),
                ],
              ),
            ),
            (TransactionMenu.contains("ST001"))? getOrderInvoice(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("ST002"))?getConstantOrderInvoice(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("ST003"))?getSellLayout(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("PT005"))?getPuerchaseLayout(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("AT009"))?getExpensseLayout(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("AT001"))?getPaymentLayout(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("AT002"))?getReceptLayout(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("AT003"))?getContraLayout(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("AT004"))?getJournalLayout(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("AT005"))?getDebitLayout(parentHeight,parentWidth):Container(),
            (TransactionMenu.contains("AT006"))? getCreditLayout(parentHeight,parentWidth):Container(),
          ],
        ),
      ),
    );
  }



/* Widget for constat order transaction Layout */
  Widget getConstantOrderInvoice(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ConstantOrderActivity(
          mListener: this,
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
          formId: "ST002",
          arrData: dataArr,
        )));
      /*  if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/
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
              ApplicationLocalizations.of(context).translate("constant_order_invoice"),
              style: page_heading_textStyle,
              textAlign: TextAlign.start,

            ),
          ],
        ),
      ),
    );
  }



/* Widget for order transaction Layout */
  Widget getOrderInvoice(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: ()async{

        await Navigator.push(context, MaterialPageRoute(builder: (context) => OrderInvoiceActivity(
          mListener: this,
          formId: "ST001",
          arrData: dataArr,
          viewWorkDDate:viewWorkDDate,
          logoImage:logoImage
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
              ApplicationLocalizations.of(context).translate("order_invoice"),
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
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) => SellActivity(
          mListener: this, logoImage:logoImage,
          formId: "ST003",
          viewWorkDDate:viewWorkDDate,
          arrData: dataArr,
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
              ApplicationLocalizations.of(context).translate("sale_invoice"),
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
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseActivity(mListener: this,
          formId: "PT005", logoImage:logoImage,
          arrData: dataArr,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("purchase_invoice"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) =>
            PaymentActivity(mListener: this,
              viewWorkDDate:viewWorkDDate,
              formId: "AT001", logoImage:logoImage,
              arrData: dataArr,)));

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
              ApplicationLocalizations.of(context).translate("payment_invoice"),
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
      onTap: ()async{
        await  Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ReceiptActivity(mListener: this, logoImage:logoImage,
              formId: "AT002",
              viewWorkDDate:viewWorkDDate,
              arrData: dataArr,)));

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
              ApplicationLocalizations.of(context).translate("receipt_detail"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => DebitNoteActivity(mListener: this,
            formId: "AT005", logoImage:logoImage,
            viewWorkDDate:viewWorkDDate,
            arrData: dataArr)));

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
              ApplicationLocalizations.of(context).translate("debit_note_voucher"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => CreditNoteActivity(mListener: this,
            formId: "AT006", logoImage:logoImage,
            viewWorkDDate:viewWorkDDate,
            arrData: dataArr)));

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
              ApplicationLocalizations.of(context).translate("credit_note_voucher"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => JournalVoucherActivity(mListener: this,
            formId: "AT004", logoImage:logoImage,
            viewWorkDDate:viewWorkDDate,
            arrData: dataArr)));

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
              ApplicationLocalizations.of(context).translate("journal"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ContraActivity(mListener: this,
            formId: "AT003", logoImage:logoImage,
            viewWorkDDate:viewWorkDDate,
            arrData: dataArr)));

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
              ApplicationLocalizations.of(context).translate("contra"),
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
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(mListener: this,
          formId: "AT009", logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
          arrData: dataArr,
        )));
       /* if(mounted){
          print("HERE BACK");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }*/
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
              ApplicationLocalizations.of(context).translate("expense_invoice"),
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
                ApplicationLocalizations.of(context).translate("setting"),
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
      height: parentHeight*.2,
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
                    ApplicationLocalizations.of(context).translate("setting"),
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
           getLanguageLayout(parentHeight, parentWidth),
          ],
        ),
      ),
    );
  }

/* Widget for change password Layout */
  Widget getChangePassword(double parentHeight, double parentWidth){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>    ChangePasswordActivity(
          logoImage:logoImage,
          viewWorkDDate:viewWorkDDate,
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
              ApplicationLocalizations.of(context).translate("change_password"),
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
              ApplicationLocalizations.of(context).translate("domain_link"),
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
bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  getAllForms() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().formList}?Company_ID=$companyId&${StringEn.lang}=$lang";
       print("nfnfnfnfvfv   $baseurl");
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              print(data);
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  print("################# ${data.length}");
                  setState(() {
                    // Item_list=_arrList;
                    // Inserted_list=_arrList;
                  });

                }

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  userLisstttttttt  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());

              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
            }, onException: (e) {

              print("Here2=> $e");

              setState(() {
                isLoaderShow=false;
              });
              var val= CommonWidget.errorDialog(context, e);

              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    }
    else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  @override
  isShowLoader(bool isShowLoader) {
    // TODO: implement isShowLoader
  }
}

abstract class MenuActivityInterface {
  addHomePage(String screenName);
}

