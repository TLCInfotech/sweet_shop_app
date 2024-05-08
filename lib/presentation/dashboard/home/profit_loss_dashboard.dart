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
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:sweet_shop_app/presentation/dashboard/notification/notification_listing.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:countup/countup.dart';
import '../../../data/api/request_helper.dart';
import '../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../menu/master/item_opening_balance/create_item_opening_bal_activity.dart';
import '../../menu/transaction/credit_note/credit_note_activity.dart';
import '../../menu/transaction/expense/create_ledger_activity.dart';
import '../../menu/transaction/expense/ledger_activity.dart';
import '../../menu/transaction/sell/sell_activity.dart';
import 'home_skeleton.dart';
import 'package:skeleton_text/skeleton_text.dart';
class ProfitLossDash extends StatefulWidget {
  final ProfitLossDashInterface mListener;
  final fid;
  final vName;
  final date;
  const ProfitLossDash({Key? key, required this.mListener, this.fid, this.vName, this.date}) : super(key: key);

  @override
  State<ProfitLossDash> createState() => _ProfitLossDashState();
}

class _ProfitLossDashState extends State<ProfitLossDash> with CreateItemOpeningBalInterface{
  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isApiCall=false;

  List<SalesData> _saleData = [];

  var statistics=[];

  List<ProfitPartyWiseData> _profitPartywise = [];

  double profit=0.0;
  var purchaseAmt=0.0;
  var expenseAmt=0.0;
  var returnAmt=0.0;
  var receiptAmt=0.0;
  var FranchiseeOutstanding=0.0;
  var saleAmt=0.0;
  var itemOpening=0.0;
  var itemClosing=0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addDate();
    callGetFranchiseeNot(0);
    getDashboardData();
    print("hfshjffhfbh  $dateString");
    // AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(saleDate));
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
        String apiUrl = "${baseurl}${ApiConstants().sendFranchiseeNotification}?Company_ID=$companyId&${StringEn.frnachisee_id}=${widget.fid}";
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
        String apiUrl = "${baseurl}${ApiConstants().getDashboardData}?Company_ID=$companyId&${StringEn.frnachisee_id}=${widget.fid}&Date=${DateFormat("yyyy-MM-dd").format(dateTime)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){

              setState(() {
                _saleData=[];
                _profitPartywise=[];
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
                    purchaseAmt=double.parse(data['DashboardMainData'][0]['Purchase_Amount'].toString());
                    expenseAmt=double.parse(data['DashboardMainData'][0]['Expense_Amount'].toString());
                    returnAmt=double.parse(data['DashboardMainData'][0]['Return_Amount'].toString());
                    receiptAmt=double.parse(data['DashboardMainData'][0]['Payment_Amount'].toString());
                    saleAmt=double.parse(data['DashboardMainData'][0]['Sale_Amount'].toString());

                    itemOpening=double.parse(data['DashboardMainData'][0]['Item_Opening_Amount'].toString());

                    itemClosing=double.parse(data['DashboardMainData'][0]['Item_Closing_Amount'].toString());

                    FranchiseeOutstanding=double.parse(data['DashboardMainData'][0]['Franchisee_Outstanding'].toString());

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
    await getDashboardData();
  }
  final ScrollController _scrollController =  ScrollController();
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
            child:  Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),
              color: Colors.transparent,
              // color: Colors.red,
              margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
              child: AppBar(
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                title:  Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: FaIcon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.vName!,
                            style: appbar_text_style,),
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFfffff5),
        body: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
     children: [
       Padding(
         padding: const EdgeInsets.all(15.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // getFieldTitleLayout("Statistics Of : "),
             getPurchaseDateLayout(),
             const SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 GestureDetector(
                     onTap: ()async{
                       await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemOpeningBal(
                           dateNew: dateTime,
                           mListener: this,
                           come:"edit",
                           franchiseeDetails:[widget.vName!,widget.fid!]
                       )));
                       await callGetFranchiseeNot(0);
                       await getDashboardData();
                     },
                     child: getThreeLayout("Opening Bal.","${CommonWidget.getCurrencyFormat(itemOpening)}",Color(0xFF6495ED))),
                 GestureDetector(
                     onTap: ()async{
                       await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemOpeningBal(
                           dateNew: dateTime.add(Duration(days: 1)),
                           mListener: this,
                           come:"edit",
                           franchiseeDetails:[widget.vName!,widget.fid!]
                       )));
                       await callGetFranchiseeNot(0);
                       await getDashboardData();
                     },
                     child: getThreeLayout("Closing Bal.","${CommonWidget.getCurrencyFormat(itemClosing)}",Color(0xFF6082B6))),
  ],
             ),
             const SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [

                 GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => SellActivity(
                           dateNew: dateTime,
                           mListener: this,
                           franhiseeID:widget.fid!
                       )));
                     },
                     child: getThreeLayout("Company Sale","${CommonWidget.getCurrencyFormat(purchaseAmt)}",Color(0xFF4CBB17))),

                 GestureDetector(
                     onTap: ()async{
                       Navigator.push(context, MaterialPageRoute(builder: (context) => CreditNoteActivity(
                           dateNew: dateTime,
                           mListener: this,
                           franhiseeID:widget.fid!
                       )));
                     },
                     child: getThreeLayout( "Return", "${CommonWidget.getCurrencyFormat((returnAmt))}",Color(0xFFef1246))),
               ],
             ),
             const SizedBox(height: 10,),

             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 getThreeLayout("Sale","${CommonWidget.getCurrencyFormat(saleAmt)}",Color(0xFF00A36C)),
                 GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerActivity(
                           dateNew: dateTime,
                           mListener: this,
                           franhiseeID:widget.fid!
                       )));
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateLedger(
                       //   mListener: this,
                       //   voucherNo: null,
                       //   dateNew: dateTime.add(Duration(days: 1)),
                       //   franchiseeDetails:[widget.vName!,widget.fid!],
                       //   come:"edit",
                       //   // DateFormat('dd-MM-yyyy').format(newDate),
                       // )));
                     },
                     child: getThreeLayout( "Expense", "${CommonWidget.getCurrencyFormat((expenseAmt))}",Colors.orange)),
               ],
             ),
             const SizedBox(height: 10,),
             getProfitLayout(),


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


  Widget getProfitLayout(){
    return GestureDetector(
      onTap: (){
        /*   Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitLossDetailActivity(mListener: this,
        comeFor: profit>=0?"Profit ":"Loss" ,
          profit:profit ,
          date:dateTime,
        )));*/
      },
      onDoubleTap: (){},
      child: Container(
        height:70 ,
        margin: const EdgeInsets.only(bottom: 10),
        width: (SizeConfig.screenWidth),
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: profit<0?Colors.red:Colors.green,
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 40),
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
      ),
    );
  }


  Widget getFranchiseeLayout(){
    return GestureDetector(
      onTap: (){
        /*    Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseeOutstandingDetailActivity(mListener: this,
          comeFor: "Franchisee Outstanding",
          profit:FranchiseeOutstanding ,
          date:dateTime,
        )));*/
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
      padding:  EdgeInsets.only(left: 50),
      child:Text("${NumberFormat.currency(locale: "HI", name: "", decimalDigits: 2,).format(profit)}", style: big_title_style.copyWith(fontSize: 26,color: Colors.white))
      // Countup(
      //     precision: 2,
      //     begin: 0,
      //     end: double.parse((profit).toString()),
      //     duration: const Duration(seconds: 2),
      //     separator: ',',
      //     style: big_title_style.copyWith(fontSize: 26,color: Colors.white)
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
        callback: (date)async{
          setState(() {
            dateTime=date!;
            AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(dateTime));
            profit=0.0;
            purchaseAmt=0.0;
            expenseAmt=0.0;
            returnAmt=0.0;
            receiptAmt=0.0;
            FranchiseeOutstanding=0.0;
          });
          await callGetFranchiseeNot(0);
          await getDashboardData();
        },
        applicablefrom: dateTime
    );
  }






  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 0, bottom: 0,),
      child: Text(
        "$title",
        style: item_heading_textStyle.copyWith(fontSize: 20),
      ),
    );
  }

  @override
  backToList() {
    // TODO: implement backToList
  }

}

abstract class ProfitLossDashInterface {

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