import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/internet_check.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:sweet_shop_app/presentation/dashboard/home/franchisee_outstanding_activity.dart';
import 'package:sweet_shop_app/presentation/dashboard/home/profit_loss_details_activity.dart';
import 'package:sweet_shop_app/presentation/dashboard/notification/notification_listing.dart';
import 'package:sweet_shop_app/presentation/menu/master/item_opening_balance/item_opening_bal_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/credit_note/credit_note_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/expense/ledger_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/receipt/receipt_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/sell/sell_activity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:countup/countup.dart';
import '../../../data/api/request_helper.dart';
import '../../../data/domain/commonRequest/get_toakn_request.dart';
import 'home_skeleton.dart';
import 'package:skeleton_text/skeleton_text.dart';


class HomeFragment extends StatefulWidget {
  final HomeFragmentInterface mListener;
  const HomeFragment({Key? key, required this.mListener}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isApiCall=false;
  List<SalesData> _saleData = [];

  var statistics=[];

  List<ProfitPartyWiseData> _profitPartywise = [];

  double profit=0.0;
  var saleCompanyAmt=0.0;
  var expenseAmt=0.0;
  var returnAmt=0.0;
  var receiptAmt=0.0;
  var FranchiseeOutstanding=0.0;
  var franchiseesaleAmt=0.0;
  var itemOpening=0.0;
  var itemClosing=0.0;

  var profitLossShare=0.0;

  var additionalProfitLoss=0.0;
  var additionalProfitLossShare=0.0;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPermissions();
    getLocal();
    addDate();
    callGetFranchiseeNot(0);
    getDashboardData();
    print("hfshjffhfbh  $dateString");
     // AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(saleDate));
 }
  List MasterMenu=[];
  List TransactionMenu=[];

  var dataArr;
  var dataArrM;
  getLocal()async{
    setState(() {
    });
    var menu =await (AppPreferences.getMasterMenuList());
    var tr =await (AppPreferences.getTransactionMenuList());
    var re =await (AppPreferences.getReportMenuList());
    dataArr=tr;
    dataArrM=menu;
    setState(() {
      MasterMenu=  (jsonDecode(menu)).map((i) => i['Form_ID']).toList();
      TransactionMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });

    print("bnbedbdbnebnedbneebn    $menu");
  }

  late DateTime dateTime;
  String dateString="";



  callGetFranchiseeNot(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
            token: sessionToken,
        );
        String apiUrl = "${baseurl}${ApiConstants().sendFranchiseeNotification}?Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){
              setState(() {

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  franchisee   $data ");
            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
            }, onException: (e) {

              print("Here2=> $e");
              var val= CommonWidget.errorDialog(context, e);

              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    }
    else{
      CommonWidget.noInternetDialogNew(context);
    }
  }

  getUserPermissions() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String date=await AppPreferences.getDateLayout();
    String uid=await AppPreferences.getUId();
    //DateTime newDate=DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    print("objectgggg   $date  ");
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().getUserPermission}?UID=$uid&Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){

              setState(() {

                isLoaderShow=false;
                if(data!=null){
                  if (mounted) {
                    AppPreferences.setMasterMenuList(jsonEncode(data['MasterSub_ModuleList']));
                    AppPreferences.setTransactionMenuList(jsonEncode(data['TransactionSub_ModuleList']));
                    // AppPreferences.setReportMenuList(jsonEncode(apiResponse.reportMenu));
                  }

                }else{
                  isApiCall=true;
                }
              });
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
              });
              var val= CommonWidget.errorDialog(context, e);
              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
              });
              CommonWidget.gotoLoginScreen(context);
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

  addDate() async {

    String  dateString = await AppPreferences.getDateLayout(); // Example string date
     dateTime = DateTime.parse(dateString);
    if(dateString==""){
      DateTime saleDate =  DateTime.now().subtract(Duration(days:1,minutes: 30 - DateTime.now().minute % 30));
      AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(saleDate));
      print("jdjfjfbf  $saleDate");
    }else{

    }
    print(dateTime);
    print("jdhbdcbhb  $dateTime  $dateString");
    setState(() {

    });
  }
  bool isShowSkeleton = true;


  getDashboardData() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String date=await AppPreferences.getDateLayout();
    //DateTime newDate=DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    print("objectgggg   $date  ");
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().getDashboardData}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(dateTime)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){

              setState(() {
                _saleData=[];
                _profitPartywise=[];
                profit=0.0;
                FranchiseeOutstanding=0.0;
                isLoaderShow=false;
                isShowSkeleton=false;
                if(data!=null){
                    if (mounted) {
                      for (var item in data['DashboardSaleDateWise']) {
                        _saleData.add(SalesData(DateFormat("dd/MM").format(DateTime.parse(item['Date'])), (item['Amount'])));
                      }
                      for (var item in data['DashboardProfitPartywise']) {
                        _profitPartywise.add(ProfitPartyWiseData(DateFormat("dd/MM/yyy").format(DateTime.parse(item['Date'])), double.parse(item['Profit'].toString()),item['Vendor_Name']));
                      }
                    }
                    // _saleData=_saleData;
                    // print("nessssss  $_saleData");

                   setState(() {
                     profit=double.parse(data['DashboardMainData'][0]['Profit'].toString());
                     _profitPartywise=_profitPartywise;
                     franchiseesaleAmt=double.parse(data['DashboardMainData'][0]['Franchisee_Sale_Amount'].toString());
                     expenseAmt=double.parse(data['DashboardMainData'][0]['Expense_Amount'].toString());
                     returnAmt=double.parse(data['DashboardMainData'][0]['Return_Amount'].toString());
                     receiptAmt=double.parse(data['DashboardMainData'][0]['Receipt_Amount'].toString());
                     saleCompanyAmt=double.parse(data['DashboardMainData'][0]['Company_Sale_Amount'].toString());

                     itemOpening=double.parse(data['DashboardMainData'][0]['Item_Opening_Amount'].toString());

                     itemClosing=double.parse(data['DashboardMainData'][0]['Item_Closing_Amount'].toString());
                     FranchiseeOutstanding=double.parse(data['DashboardMainData'][0]['Franchisee_Outstanding'].toString());

                     profitLossShare=data['DashboardMainData'][0]['Profit_Share']==null?0.0:double.parse(data['DashboardMainData'][0]['Profit_Share'].toString());
                     additionalProfitLoss=data['DashboardMainData'][0]['Additional_Profit']!=null?double.parse(data['DashboardMainData'][0]['Additional_Profit'].toString()):0.0;
                     additionalProfitLossShare=data['DashboardMainData'][0]['Additional_Profit_Share']==null?0.0:double.parse(data['DashboardMainData'][0]['Additional_Profit_Share'].toString());
                   });

                }else{
                  isApiCall=true;
                }
              });
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
              });
              var val= CommonWidget.errorDialog(context, e);
              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
              });
              CommonWidget.gotoLoginScreen(context);
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

  Future<void> refreshList() async {
      await Future.delayed(Duration(seconds: 2));
    await callGetFranchiseeNot(0);
   await  getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return isShowSkeleton? SkeletonAnimation(
        curve: Curves.easeIn,
        child: Container(
            color: CommonColor.MAIN_BG,
            child: const HomeSkeleton())):Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              // color: Colors.red,
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
             child: AppBar(
                  leadingWidth: 30,
                  automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                leading: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                title: Image(
                  width: SizeConfig.screenHeight * .1,
                  image: const AssetImage('assets/images/Shop_Logo.png'),
                  // fit: BoxFit.contain,
                ),
               actions: [
                 IconButton(
                     onPressed: ()async{
                       await Navigator.push(context,MaterialPageRoute(builder: (context)=>NotificationListing()));
                     },
                     icon: FaIcon(FontAwesomeIcons.bell,))
               ],
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFfffff5),
        body: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () => refreshList(),
          child: ListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // getFieldTitleLayout("Statistics Of : "),
                    getPurchaseDateLayout(),
                    // const SizedBox(height: 10,),
                    //
                    // const SizedBox(height: 5,),
                    // getProfitLayout(),
                    // sale_purchase_expense_container(),
                    // const SizedBox(height: 10,),
                    // getFranchiseeLayout(),
                    const SizedBox(height: 10,),
                    (MasterMenu.contains("RM005"))?  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [  GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>   ItemOpeningBal(
                                newDate: dateTime,
                                formId: "RM005",
                                arrData: dataArrM,
                              )));
                            },
                            child: getThreeLayout("Opening Bal.","${CommonWidget.getCurrencyFormat(itemOpening)}",Color(0xFF6495ED))),
                        GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>    ItemOpeningBal(
                                newDate: dateTime.add(Duration(days: 1)),
                                formId: "RM005",
                                arrData: dataArrM,
                              )));
                            }, child: getThreeLayout("Closing Bal.","${CommonWidget.getCurrencyFormat(itemClosing)}",Color(0xFF6082B6))),
                      ],
                    ):Container(),
                    const SizedBox(height: 10,),
                    (TransactionMenu.contains("ST003"))?   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (TransactionMenu.contains("ST003"))? GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SellActivity(mListener: this,dateNew: dateTime,
                                formId: "ST003",
                                arrData: dataArr,
                              )));
                            },
                            child: getThreeLayout("Company Sale","${CommonWidget.getCurrencyFormat(saleCompanyAmt)}",Color(0xFF4CBB17)))
                        :Container(),
                        (TransactionMenu.contains("AT006"))? GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreditNoteActivity(mListener: this,
                                dateNew: dateTime,
                                formId: "AT006",
                                arrData: dataArr,
                              )));
                            },child: getThreeLayout( "Return", "${CommonWidget.getCurrencyFormat((returnAmt))}",Color(0xFFef1246)))
                        :Container(),
                      ],
                    )
                    :Container(),
                    (TransactionMenu.contains("ST003"))?Container():
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (TransactionMenu.contains("AT006"))? GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreditNoteActivity(mListener: this,
                                dateNew: dateTime,
                                formId: "AT006",
                                arrData: dataArr,
                              )));
                            },child: getThreeLayout( "Return", "${CommonWidget.getCurrencyFormat((returnAmt))}",Color(0xFFef1246)))
                        :Container(),
                        (TransactionMenu.contains("AT009"))? GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(mListener: this,dateNew: dateTime,
                                formId: "AT009",
                                arrData: dataArr,
                              )));
                            },child: getThreeLayout( "Expense", "${CommonWidget.getCurrencyFormat((expenseAmt))}",Colors.orange))
                            :Container(),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    (TransactionMenu.contains("ST003"))?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (TransactionMenu.contains("ST003"))&& (TransactionMenu.contains("AT006"))?   GestureDetector(
                            onTap: (){
                            },child: getThreeLayout("Franchisee Sale","${CommonWidget.getCurrencyFormat(franchiseesaleAmt)}",Color(0xFF00A36C)))
                        :Container(),
                        (TransactionMenu.contains("AT009"))? GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(mListener: this,dateNew: dateTime,
                                formId: "AT009",
                                arrData: dataArr,
                              )));
                            },child: getThreeLayout( "Expense", "${CommonWidget.getCurrencyFormat((expenseAmt))}",Colors.orange))
                        :Container(),
                      ],
                    ):Container(),
                    const SizedBox(height: 10,),
                    (TransactionMenu.contains("AT002"))?  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getThreeLayout( "Payment", "${CommonWidget.getCurrencyFormat((receiptAmt))}",Colors.deepPurple,),
                        getThreeLayout("Outstanding", "${CommonWidget.getCurrencyFormat((FranchiseeOutstanding))}", Colors.deepOrange),
                      ],
                    ):Container(),

                    const SizedBox(height: 10,),
                    // getAdditonalProfitLayout(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          GestureDetector(
                            onTap: (){
                            },child: getThreeLayout(additionalProfitLoss>=0?"Additional Profit ":"Additional Loss","${CommonWidget.getCurrencyFormat(additionalProfitLoss)}",additionalProfitLoss<0?Colors.red:Colors.green)),

                      GestureDetector(
                            onTap: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(mListener: this,dateNew: dateTime,
                              //   formId: "AT009",
                              //   arrData: dataArr,
                              // )));
                            },child: getThreeLayout(additionalProfitLossShare>=0? "Additional Profit Share":"Additional Loss Share", "${CommonWidget.getCurrencyFormat((additionalProfitLossShare))}",additionalProfitLossShare<0?Colors.red:Colors.green))
                      ],
                    ),
                     SizedBox(height: 10,),
                    // getFieldTitleLayout("Profit/Loss "),
                    // const SizedBox(height: 5,),
                    // getFieldTitleLayout("Payment-Outanding "),
                    // const SizedBox(height: 5,),
                    (MasterMenu.contains("RM005"))&&(TransactionMenu.contains("ST003"))&&
                        (TransactionMenu.contains("AT006"))&&(TransactionMenu.contains("AT009"))?
                    getProfitLayout():Container(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }



  Widget getThreeLayout(title,amount,boxcolor){
    return Container(
      height: 100,
      width: (SizeConfig.screenWidth * 0.89) / 2,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: (Colors.orange).withOpacity(0.3),
          border: Border.all(color: boxcolor),
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: 40,
            width: (SizeConfig.screenWidth * 0.89) / 2,
            // margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: (Colors.orange), borderRadius: BorderRadius.circular(5)
            ),
            alignment: Alignment.center,
            child: Text(
              "$amount",
              style: subHeading_withBold.copyWith(fontSize:19,color: Colors.black87 ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          Expanded(
            child: Container(
              width: (SizeConfig.screenWidth * 0.89) / 2,
              alignment: Alignment.center,
              color: boxcolor,
              padding: EdgeInsets.all(5),
              child: Text(
                "$title",
                style: item_heading_textStyle.copyWith(
                    color: (Colors.white),
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget getAdditonalProfitLayout(){
    return GestureDetector(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitLossDetailActivity(mListener: this,
        //   comeFor: profit>=0?"Profit ":"Loss" ,
        //   profit:profit ,
        //   date:dateTime,
        // )));
      },
      onDoubleTap: (){},
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10),
        margin: const EdgeInsets.only(bottom: 10),
        width: (SizeConfig.screenWidth),
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: additionalProfitLoss<0?Colors.red:Colors.green,
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  padding:  EdgeInsets.only(left: 10),
                  child:  Text(
                    additionalProfitLoss>=0?"Additional Profit ":" Additional Loss",
                    style: item_heading_textStyle.copyWith(
                        color:Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold

                    ),
                  ),
                ),
                Padding(
                    padding:  EdgeInsets.only(left: 10,right: 10),
                    child: Text("${NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(10000000)}", style: big_title_style.copyWith(fontSize: 26,color: Colors.white))
                )
              ],
            ),
            Divider(height: 1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  padding:  EdgeInsets.only(left: 10),
                  child: Text(
                    additionalProfitLossShare>=0?"Add. Profit Share":"Add. Loss Share",
                    style: item_heading_textStyle.copyWith(
                        color:Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold

                    ),
                  ),
                ),
                Padding(
                    padding:  EdgeInsets.only(left: 10,right: 10),
                    child: Text("${NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(1000000000)}", style: big_title_style.copyWith(fontSize: 26,color: Colors.white))
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getProfitLayout(){
    return
    //   Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     GestureDetector(
    //         onTap: (){
    //           Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitLossDetailActivity(mListener: this,
    //             comeFor: profit>=0?"Profit ":"Loss" ,
    //             profit:profit ,
    //             date:dateTime,
    //           )));
    //         },child: getThreeLayout(profit>=0?"Profit ":"Loss","${CommonWidget.getCurrencyFormat(profit)}",profit<0?Colors.red:Colors.green)),
    //
    //     GestureDetector(
    //         onTap: (){
    //           // Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(mListener: this,dateNew: dateTime,
    //           //   formId: "AT009",
    //           //   arrData: dataArr,
    //           // )));
    //         },child: getThreeLayout(profitLossShare>=0?"Profit Share":"Loss Share","${CommonWidget.getCurrencyFormat(profitLossShare)}",profitLossShare<0?Colors.red:Colors.green))
    //   ],
    // );

    GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitLossDetailActivity(mListener: this,
        comeFor: profit>=0?"Profit ":"Loss" ,
          date:dateTime,
        )));
      },
      onDoubleTap: (){},
      child: Container(
        height:80 ,
        margin: const EdgeInsets.only(bottom: 10),
        width: (SizeConfig.screenWidth),
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: profit<0?Colors.red:Colors.green,
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profit>=0?"Profit ":"Loss",
                        style: item_heading_textStyle.copyWith(
                            color:Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold

                        ),
                      ),

                    ],
                  ),
                ),
                getAnimatedFunction(),
              ],
            ),
            Divider(height: 1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profitLossShare>=0?"Profit Share":"Loss Share",
                        style: item_heading_textStyle.copyWith(
                            color:Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold

                        ),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10),
                  child: Text("${NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(profitLossShare)}", style: big_title_style.copyWith(fontSize: 26,color: Colors.white))
                )
                  ],
            )
          ],
        ),
      ),
    );
  }


  Widget getFranchiseeLayout(){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseeOutstandingDetailActivity(mListener: this,
          comeFor: "Franchisee Outstanding",
          profit:FranchiseeOutstanding ,
          date:dateTime,
        )));
      },
      child: Container(
        height:70 ,
        margin: const EdgeInsets.only(bottom: 10),
        width: (SizeConfig.screenWidth),
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Franchisee \nOutstanding",
                    style: item_heading_textStyle.copyWith(
                        color:Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold

                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const FaIcon(
                      FontAwesomeIcons.solidArrowAltCircleRight,
                      color:Colors.white,
                    ),
                  )
                ],
              ),
            ),
            getFranAnimatedFunction(),
          ],
        ),
      ),
    );
  }

   getAnimatedFunction(){
   return  Padding(
     padding:  EdgeInsets.only(left: 10,right: 10),
     child: Text("${NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(profit)}", style: big_title_style.copyWith(fontSize: 26,color: Colors.white))
     // Countup(
     //   locale: Locale('HI', 'IN'),
     //   precision: 2,
     //   begin: 0,
     //     // NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(amount);
     //   end: double.parse((profit).toString()),
     //   duration: const Duration(seconds: 2),
     //   separator: ',',
     //
     //     style: big_title_style.copyWith(fontSize: 26,color: Colors.white)
     //
     // ),
   );
  }

  getFranAnimatedFunction(){
    return  Padding(
      padding:  EdgeInsets.only(left: 20),
      child: Countup(
          precision: 2,
          begin: 0,
          end:double.parse((FranchiseeOutstanding).toString()) ,
          duration: const Duration(seconds: 2),
          separator: ',',
          style: big_title_style.copyWith(fontSize: 26,color: Colors.white)
      ),
    );
  }


  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            dateTime=date!;
            AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(dateTime));
          });
          getDashboardData();
        },
        applicablefrom: dateTime
    );
  }

  // Container yearly_report_graph() {
  //   return   Container(
  //     height: 400,
  //     width: 400,
  //     child: SfCircularChart(
  //       title: ChartTitle(text: 'Expense analysis',alignment: ChartAlignment.near),
  //       series: <CircularSeries>[
  //         PieSeries<ExpenseData, String>(
  //           dataSource: [
  //             ExpenseData('Food', 300),
  //             ExpenseData('Rent', 600),
  //             ExpenseData('Transport', 200),
  //             ExpenseData('Utilities', 150),
  //           ],
  //           xValueMapper: (ExpenseData data, _) => data.category,
  //           yValueMapper: (ExpenseData data, _) => data.amount,
  //           dataLabelSettings: const DataLabelSettings(
  //             isVisible: true,
  //             connectorLineSettings: ConnectorLineSettings(
  //               color: Colors.blue,
  //               length: '8%',
  //               type: ConnectorType.line,
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // sale_purchase_expense_container() {
  //   return Column(
  //     children: [
  //       Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     getSellPurchaseExpenseLayout(Colors.green, "${CommonWidget.getCurrencyFormat(saleAmt)}", "Sale"),
  //                     getSellPurchaseExpenseLayout(Colors.orange, "${CommonWidget.getCurrencyFormat((expenseAmt))}", "Expense"),
  //                   ],
  //                 ),
  //       const SizedBox(height: 10,),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           getSellPurchaseExpenseLayout(Colors.blue, "${CommonWidget.getCurrencyFormat((returnAmt))}", "Return"),
  //           getSellPurchaseExpenseLayout(Colors.deepPurple, "${CommonWidget.getCurrencyFormat((receiptAmt))}", "Receipt"),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Container weeklySalegraph() {
  //   return  Container(
  //     height: 400,
  //     width: SizeConfig.screenWidth,
  //     child: SfCartesianChart(
  //       title: ChartTitle(text: 'Weekly Sale',alignment: ChartAlignment.near),
  //       // Enable legend
  //       // legend: Legend(isVisible: true),
  //       primaryXAxis: CategoryAxis(labelRotation: 270, labelIntersectAction: AxisLabelIntersectAction.rotate90,labelPlacement: LabelPlacement.betweenTicks),
  //       primaryYAxis: NumericAxis(
  //           // numberFormat: NumberFormat('#,##0'),
  //           // numberFormat: NumberFormat.compact(),
  //         numberFormat:  NumberFormat.currency(locale: "HI", name: "", decimalDigits: 0,),
  //           title: AxisTitle(text: "Amount ",textStyle: item_regular_textStyle, )
  //       ),
  //       series: <ChartSeries>[
  //         ColumnSeries<SalesData, String>(
  //           dataSource: _saleData,
  //           xValueMapper: (SalesData sales, _) => sales.Date,
  //           yValueMapper: (SalesData sales, _) => sales.Amount,
  //           dataLabelSettings: DataLabelSettings(
  //             alignment: ChartAlignment.far,
  //               angle: 270,
  //               isVisible: true,
  //               labelAlignment: ChartDataLabelAlignment.outer,
  //               textStyle: item_heading_textStyle.copyWith(fontSize:9 )
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }


  Widget partywisegraph() {
    return  _profitPartywise.length!=0? Container(
      height: _profitPartywise.length*120>SizeConfig.screenHeight?SizeConfig.screenHeight:_profitPartywise.length*120,
      margin: const EdgeInsets.symmetric(vertical:5),
      width: SizeConfig.screenWidth,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Profit Analysis',
            textStyle: item_heading_textStyle.copyWith(fontSize: 16),
            alignment: ChartAlignment.near),
        primaryXAxis: CategoryAxis(
            maximumLabelWidth: 50,
            labelIntersectAction: AxisLabelIntersectAction.rotate90,
            labelPlacement: LabelPlacement.betweenTicks),
        primaryYAxis: NumericAxis(
            numberFormat:  NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,),
            title: AxisTitle(text: "Profit ",textStyle: item_regular_textStyle, )
        ),
        series: <ChartSeries>[
          BarSeries<ProfitPartyWiseData, String>(
            width: 0.2,
            dataSource: _profitPartywise,
            xValueMapper: (ProfitPartyWiseData sales, _) => sales.Vendor_Name,
            yValueMapper: (ProfitPartyWiseData sales, _) => sales.Profit,
            pointColorMapper: (ProfitPartyWiseData sales, _) => sales.Profit >= 0 ? Colors.green : Colors.red,// Conditional color
            dataLabelSettings: DataLabelSettings(
                alignment: ChartAlignment.far,
                angle: 360,
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.outer,
                textStyle: item_heading_textStyle.copyWith(fontSize:9 )
            ),
          )
        ],
      ),
    ):Container();
  }



  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 0, bottom: 0,),
      child: Text(
        "$title",
        style: item_heading_textStyle.copyWith(fontSize: 22),
      ),
    );
  }

  Widget getSellPurchaseExpenseLayout( MaterialColor boxcolor, String amount, String title) {
    return   GestureDetector(
      onTap: (){
        if(title=="Outstanding"){
          Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseeOutstandingDetailActivity(mListener: this,
            comeFor: "Franchisee Outstanding",
            profit:FranchiseeOutstanding ,
            date:dateTime,
          )));
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptActivity(mListener: this,
            dateNew: dateTime,
            formId: "AT002",
            arrData: dataArr,
          )));
       //   widget.mListener.getAddLeder(title);
        }
      },
      child: Container(
        height: 120,
        width: (SizeConfig.screenWidth * 0.89) / 2,
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: boxcolor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: 60,
              width: (SizeConfig.screenWidth * 0.89) / 2,
              // margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: boxcolor, borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.center,
              child: Text(
                amount,
                style: subHeading_withBold.copyWith(fontSize:18 ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$title",
                  style: item_heading_textStyle.copyWith(
                    color: boxcolor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}

abstract class HomeFragmentInterface {
getAddLeder(String comeScreen);
}

class SalesData {
  final String Date;
  final int Amount;

  SalesData(this.Date, this.Amount);
}

class ExpenseData {
  final String category;
  final int amount;

  ExpenseData(this.category, this.amount);
}

class ProfitPartyWiseData {
  final String Date;
  final String Vendor_Name;
  final double Profit;

  ProfitPartyWiseData(this.Date, this.Profit, this.Vendor_Name);
}