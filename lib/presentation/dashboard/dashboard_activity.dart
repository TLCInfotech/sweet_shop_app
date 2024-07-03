import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/constant.dart';
import 'package:sweet_shop_app/core/internet_check.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/api/request_helper.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/presentation/dashboard/ledger_dash/ledger_dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/dashboard/payment_dash/payment_dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/dashboard/purchase_dash/purchase_dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/dashboard/sale_dash/sale_dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/menu/menu_activity.dart';
import '../../core/app_preferance.dart';
import 'home/home_fragment.dart';

class DashboardActivity extends StatefulWidget {

  @override
  State<DashboardActivity> createState() => _DashboardActivityState();
}

class _DashboardActivityState extends State<DashboardActivity>with HomeFragmentInterface,
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
    getUserPermissions();
    getLocal();
  }
  List MasterMenu=[];
  List TransactionMenu=[];
  String companyId="";
  var dataArr;
  var dataArrM;
  getLocal()async{
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
  });
  }

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  getUserPermissions() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String date=await AppPreferences.getDateLayout();
    String uid=await AppPreferences.getUId();
    //DateTime newDate=DateFormat("yyyy-MM-dd").format(DateTime.parse(date));

    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().getUserPermission}?UID=$uid&Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){

              setState(() {
                if(data!=null){
                  if (mounted) {
                    AppPreferences.setMasterMenuList(jsonEncode(data['MasterSub_ModuleList']));
                    AppPreferences.setTransactionMenuList(jsonEncode(data['TransactionSub_ModuleList']));
                    // AppPreferences.setReportMenuList(jsonEncode(apiResponse.reportMenu));
                  }

                }else{
                }
              });
            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              var val= CommonWidget.errorDialog(context, e);
              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }
    else{
      CommonWidget.noInternetDialogNew(context);
    }
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

  Widget getBottomBar(double parentHeight, double parentWidth) {
    List<Widget> bottomBarItems = [];
    // Home button
    bottomBarItems.add(
      GestureDetector(
        onTap: () {
          setState(() {
            getUserPermissions();
            getLocal();
         bottomBarItems = [];
       });
          Navigator.of(context).pushReplacementNamed('/dashboard');
       /*  addNewScreen(
              HomeFragment(
                mListener: this,
              ),
              Constant.HOME_FRAGMENT);*/
        },
        onDoubleTap: () {},
        child: Container(
          height: parentHeight * .10,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage("assets/images/home.png"),
                height: parentHeight * .035,
                width: parentHeight * .035,
                color: currentScreen == Constant.HOME_FRAGMENT
                    ? CommonColor.THEME_COLOR
                    : Colors.black,
              ),
              Padding(
                padding: EdgeInsets.only(top: parentHeight * .005),
                child: Text(
                  StringEn.HOME,
                  style: TextStyle(
                      color: currentScreen == Constant.HOME_FRAGMENT
                          ? CommonColor.THEME_COLOR
                          : Colors.black,
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter_SemiBold_Font'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Sale button
    if (TransactionMenu.contains("ST003")) {
      bottomBarItems.add(
        GestureDetector(
          onTap: () {
            addNewScreen(
                SaleDashboardActivity(),
                Constant.SELL);
            getUserPermissions();
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .10,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/hand.png"),
                  height: parentHeight * .035,
                  width: parentHeight * .035,
                  color: currentScreen == Constant.SELL
                      ? CommonColor.THEME_COLOR
                      : Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight * .005),
                  child: Text(
                    ApplicationLocalizations.of(context)!.translate("sale")!,
                    style: TextStyle(
                        color: currentScreen == Constant.SELL
                            ? CommonColor.THEME_COLOR
                            : Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Expense button
    if (TransactionMenu.contains("AT009")) {
      bottomBarItems.add(
        GestureDetector(
          onTap: () {
            addNewScreen(
                LedgerDashActivity(),
                Constant.EXPENSE);
            getUserPermissions();
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .10,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/expense.png"),
                  height: parentHeight * .035,
                  width: parentHeight * .035,
                  color: currentScreen == Constant.EXPENSE
                      ? CommonColor.THEME_COLOR
                      : Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight * .005),
                  child: Text(
                    ApplicationLocalizations.of(context)!.translate("expense")!,
                    style: TextStyle(
                        color: currentScreen == Constant.EXPENSE
                            ? CommonColor.THEME_COLOR
                            : Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Return button
    if (TransactionMenu.contains("AT006")) {
      bottomBarItems.add(
        GestureDetector(
          onTap: () {
            addNewScreen(
                PurchaseDashActivity(),
                Constant.RETURN);
            getUserPermissions();
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .10,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/payment-method.png"),
                  height: parentHeight * .035,
                  width: parentHeight * .035,
                  color: currentScreen == Constant.RETURN
                      ? CommonColor.THEME_COLOR
                      : Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight * .005),
                  child: Text(
                    ApplicationLocalizations.of(context)!.translate("return")!,
                    style: TextStyle(
                        color: currentScreen == Constant.RETURN
                            ? CommonColor.THEME_COLOR
                            : Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Receipt button
    if (TransactionMenu.contains("AT002")) {
      bottomBarItems.add(
        GestureDetector(
          onTap: () {
            addNewScreen(
                PaymentDashActivity(),
                Constant.RECEIPT);
            getUserPermissions();
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .10,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/cashless-payment.png"),
                  height: parentHeight * .035,
                  width: parentHeight * .035,
                  color: currentScreen == Constant.RECEIPT
                      ? CommonColor.THEME_COLOR
                      : Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: parentHeight * .005),
                  child: Text(
                    ApplicationLocalizations.of(context)!.translate("receipt")!,
                    style: TextStyle(
                        color: currentScreen == Constant.RECEIPT
                            ? CommonColor.THEME_COLOR
                            : Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter_SemiBold_Font'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bottomBarItems,
    );
  }



  /*widget for bottom bar layout*/
/*  Widget getBottomBar(double parentHeight,double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
           // width: parentWidth*.2,
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
        Visibility(
          visible: TransactionMenu.contains("ST003"),
          child: GestureDetector(
            onTap: (){
              addNewScreen(
                  SaleDashboardActivity(
                  ),
                  Constant.SELL);
              },
            onDoubleTap: (){},
            child: Container(
              height: parentHeight*.10,
              //width: parentWidth*.2,
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
                      ApplicationLocalizations.of(context)!.translate("sale")!,
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
        ),
        Visibility(
          visible: TransactionMenu.contains("AT009"),
          child: GestureDetector(
            onTap: (){
              addNewScreen(
                  LedgerDashActivity(
                  ),
                  Constant.EXPENSE);
              },
            onDoubleTap: (){},
            child: Container(
              height: parentHeight*.10,
            //  width: parentWidth*.2,
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
                      ApplicationLocalizations.of(context)!.translate("expense")!,
                      //StringEn.EXPENSE,
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
        ),
         Visibility(
          visible: TransactionMenu.contains("AT006"),
          child: GestureDetector(
            onTap: (){
              addNewScreen(
                  PurchaseDashActivity(
                  ),
                  Constant.RETURN);

            },
            onDoubleTap: (){},
            child: Container(
              height: parentHeight*.10,
             // width: parentWidth*.2,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage("assets/images/payment-method.png"),
                    height: parentHeight * .035,
                    width:parentHeight * .035,
                    color:currentScreen == Constant.RETURN ? CommonColor.THEME_COLOR:Colors.black,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: parentHeight*.005),
                    child: Text(
                      ApplicationLocalizations.of(context)!.translate("return")!,
                      style: TextStyle(
                          color: currentScreen == Constant.RETURN ? CommonColor.THEME_COLOR:Colors.black,
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
        ),
        Visibility(
          visible: TransactionMenu.contains("AT002"),
          child: GestureDetector(
            onTap: (){
              addNewScreen(
                  PaymentDashActivity(
                  ),
                  Constant.RECEIPT);
              },
            onDoubleTap: (){},
            child: Container(
              height: parentHeight*.10,
              //width: parentWidth*.2,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage("assets/images/cashless-payment.png"),
                    height: parentHeight * .035,
                    width:parentHeight * .035,
                    color:currentScreen == Constant.RECEIPT ? CommonColor.THEME_COLOR:Colors.black,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: parentHeight*.005),
                    child: Text(
                      ApplicationLocalizations.of(context)!.translate("receipt")!,
                    //  StringEn.PAYMENT,
                      style: TextStyle(
                          color: currentScreen == Constant.RECEIPT ? CommonColor.THEME_COLOR:Colors.black,
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
        ),
      ],
    );
  }*/


  Future<bool> _onBackPressed() {
    return CommonWidget.showExitDialog(context, "", "1");
  }



  @override
  addHomePage(String screenName) {
    // TODO: implement addHomePage

  }

  @override
  getAddLeder(String comeScreen) {
    // TODO: implement getAddLeder
    if(comeScreen=="Expense"){
      addNewScreen(
          LedgerDashActivity(
          ),
          Constant.EXPENSE);
    } else if(comeScreen=="Sale"){
      addNewScreen(
          SaleDashboardActivity(
          ),
          Constant.SELL);

    }else  if(comeScreen=="Return"){
      addNewScreen(
          PurchaseDashActivity(
          ),
          Constant.RETURN);
    } else if(comeScreen=="Receipt"){
      addNewScreen(
          PaymentDashActivity(
          ),
          Constant.RECEIPT);
    }else{
      addNewScreen(
          HomeFragment(
            mListener: this,
          ),
          Constant.HOME_FRAGMENT);
    }

  }

}

