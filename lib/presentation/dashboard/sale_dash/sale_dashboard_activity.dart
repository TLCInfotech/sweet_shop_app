import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/sell/sell_activity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/app_preferance.dart';
import '../../../core/common.dart';
import '../../../core/common_style.dart';
import '../../../core/internet_check.dart';
import '../../../core/localss/application_localizations.dart';
import '../../../core/size_config.dart';
import '../../../data/api/constant.dart';
import '../../../data/api/request_helper.dart';
import '../../common_widget/get_date_layout.dart';

class SaleDashboardActivity extends StatefulWidget {
  const SaleDashboardActivity({Key? key}) : super(key: key);

  @override
  State<SaleDashboardActivity> createState() => _SaleDashboardState();
}

class _SaleDashboardState extends State<SaleDashboardActivity> {

  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isApiCall=false;

  List<SalesDataDash> _saleData = [];

  List<SalesItemWise> _saleItem = [];

  DateTime dateTime= DateTime.now().subtract(Duration(days:1,minutes: 30 - DateTime.now().minute % 30));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addDate();
    getSalePartyWise();
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
   DateTime saleDate= DateTime.now().subtract(Duration(days:1,minutes: 30 - DateTime.now().minute % 30));
  addDate() async {
    String dateString = await AppPreferences.getDateLayout(); // Example string date
    saleDate = DateTime.parse(dateString);
    print(saleDate);
    setState(() {

    });
  }
  bool isShowSkeleton = true;
  getSalePartyWise() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().getDashboardSalePartywise}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(saleDate)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){

              setState(() {
                _saleData=[];
                isLoaderShow=false;
                isShowSkeleton=false;
                print("jejejnj   ${data['DashboardSalePartywise']}");
                if(data['DashboardSalePartywise']!=[]){
                  if (mounted) {
                    for (var item in data['DashboardSalePartywise']) {
                      _saleData.add(SalesDataDash(DateFormat("dd/MM/yyy").format(DateTime.parse(item['Date'])), item['Amount'],item['Vendor_Name']));
                    }
                  }
                  _saleData=_saleData;



                }else{
                  isApiCall=true;
                }
              });
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
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

  getSaleItemWise() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().getDashboardSaleItemwise}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(saleDate)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){

              setState(() {
                _saleItem=[];
                isLoaderShow=false;
                isShowSkeleton=false;
                if(data!=null){
                  if (mounted) {
                    for (var item in data['DashboardSaleItemwise']) {
                      _saleItem.add(SalesItemWise(DateFormat("dd/MM/yyy").format(DateTime.parse(item['Date'])), item['Amount'],item['Item_Name']));
                    }
                  }
                  _saleItem=_saleItem;

                }else{
                  isApiCall=true;
                }
              });
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
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
  final ScrollController _scrollController =  ScrollController();
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    await  getSalePartyWise();
  }
  Future<void> refreshListItem() async {
    await Future.delayed(Duration(seconds: 2));
   await    getSaleItemWise();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
              title:Row(
                children: [
                  logoImage!=""? Container(
                    height:SizeConfig.screenHeight*.05,
                    width:SizeConfig.screenHeight*.08,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        image: DecorationImage(
                          image: FileImage(File(logoImage)),
                          fit: BoxFit.cover,
                        )
                    ),
                  ):Container(),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Text(
                        companyName,
                        style: appbar_text_style
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFfffff5),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child:Column(
          // shrinkWrap: true,
          // physics: AlwaysScrollableScrollPhysics(),
          children: [
            getPurchaseDateLayout(),
            goToTransactionPage(),
            toggleLayout(),

            isPartyWise?partywisegraph():itemwisegraph()
          ],
        ),
      ),
    );
  }
  goToTransactionPage(){
    return GestureDetector(
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => SellActivity(mListener: this,dateNew: saleDate,
          formId: "ST003",
          arrData: dataArr,
        )));
      },
      child: Container(
        height: 40,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.black87),
          color: Colors.green,
          // border: Border.all(color: isPartyWise?Colors.transparent: Colors.black87),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        // padding: EdgeInsets.all(5),
        child: Padding(
          padding:  EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Go To Sale Invoice",style: subHeading_withBold.copyWith(color: Colors.white,fontSize: 18),),
              // IconButton(onPressed: (){}, icon: Icon(Icons.double_arrow_outlined,color: Colors.white,))
              Icon(Icons.double_arrow_outlined,color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }

  /*widget for no data*/
  Widget getNoData(double parentHeight,double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "No data available.",
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

  var isPartyWise=true;
  toggleLayout(){
    return Padding(
      padding:  EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: ()async{
              setState(() {
                isPartyWise=true;
              });
              await getSalePartyWise();
            },
            child: Container(
              height: 45,
              width: SizeConfig.halfscreenWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.black87),
                color: isPartyWise?CommonColor.THEME_COLOR:Colors.white,
                // border: Border.all(color: isPartyWise?Colors.transparent: Colors.black87),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Text(ApplicationLocalizations.of(context)!.translate("party_wise")!,style: subHeading_withBold.copyWith(color: Colors.black87,fontSize: 18),),
            ),
          ),
          GestureDetector(
            onTap: ()async{
              setState(() {
                isPartyWise=false;
              });
              await getSaleItemWise();
            },
            child: Container(
              height: 45,
              width: SizeConfig.halfscreenWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isPartyWise==false?CommonColor.THEME_COLOR:Colors.white,
                // border: Border.all(color: isPartyWise?Colors.transparent: Colors.black87),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Text(ApplicationLocalizations.of(context)!.translate("item_wise")!,style: subHeading_withBold.copyWith(color: Colors.black87,fontSize: 18),),
            ),
          ),
        ],
      ),
    );
  }

 // DateTime saleDate =  DateTime.now().subtract(Duration(days:1,minutes: 30 - DateTime.now().minute % 30));


  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            saleDate=date!;
            AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(date));
          });
          if(isPartyWise){
            getSalePartyWise();
          }
          else{
            getSaleItemWise();
          }
        },
        applicablefrom: saleDate
    );
  }

  Widget partywisegraph() {
    print("ghhgrghr  ${_saleData.length}");
    return  Expanded(
      child: RefreshIndicator(
        color: CommonColor.THEME_COLOR,
        onRefresh: () => refreshList(),
        child: ListView(
          shrinkWrap: true,
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            _saleData.length!=0? Container(
              height: _saleData.length*120>SizeConfig.screenHeight?SizeConfig.screenHeight:_saleData.length*120,
              margin: const EdgeInsets.symmetric(vertical:5),
              width: SizeConfig.screenWidth,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Sales analysis',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: .1
                    ),
                    alignment: ChartAlignment.near),
                primaryXAxis: CategoryAxis(
                    maximumLabelWidth: 50,
                    labelIntersectAction: AxisLabelIntersectAction.rotate90,
                    labelPlacement: LabelPlacement.betweenTicks),
                primaryYAxis: NumericAxis(

                    numberFormat:  NumberFormat.currency(locale: "HI", name: "", decimalDigits: 0,),
                    title: AxisTitle(text: "Amount ",textStyle: item_regular_textStyle, )
                ),
                series: <ChartSeries>[
                  BarSeries<SalesDataDash, String>(
                    width: 0.2,
                    dataSource: _saleData,
                    xValueMapper: (SalesDataDash sales, _) => sales.Vendor_Name,
                    yValueMapper: (SalesDataDash sales, _) => sales.Amount,
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
            ):Container(
                height:SizeConfig.screenHeight*.60,
                alignment: Alignment.center,
                child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
          ],
        ),
      ),
    );
  }

  Widget itemwisegraph() {
    return  Expanded(
      child:RefreshIndicator(
        color: CommonColor.THEME_COLOR,
        onRefresh: () => refreshListItem(),
        child: ListView(
          shrinkWrap: true,
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            _saleItem.length!=0? Container(
              //height: _saleItem.length>6?SizeConfig.screenHeight:SizeConfig.screenHeight*.5,
              height: _saleItem.length*120>SizeConfig.screenHeight?SizeConfig.screenHeight:_saleItem.length*120,
              margin: const EdgeInsets.symmetric(vertical:0),
              width: SizeConfig.screenWidth,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Sales analysis',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: .1
                    ),
                    alignment: ChartAlignment.near),
                primaryXAxis: CategoryAxis(
                    maximumLabelWidth: 50,
                    labelIntersectAction: AxisLabelIntersectAction.rotate90,
                    labelPlacement: LabelPlacement.betweenTicks),
                primaryYAxis: NumericAxis(
                    numberFormat:  NumberFormat.currency(locale: "HI", name: "", decimalDigits: 0,),
                    title: AxisTitle(text: "Amount ",textStyle: item_regular_textStyle, )
                ),
                series: <ChartSeries>[
                  BarSeries<SalesItemWise, String>(
                    width: 0.2,
                    dataSource: _saleItem,
                    xValueMapper: (SalesItemWise sales, _) => sales.Item_Name,
                    yValueMapper: (SalesItemWise sales, _) => sales.Amount,
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
            ):
            Container(
                height:SizeConfig.screenHeight*.60,
                alignment: Alignment.center,
                child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
          ],
        ),
      ),
    );
  }

}
class SalesDataDash {
  final String Date;
  final String Vendor_Name;
   var Amount;

  SalesDataDash(this.Date, this.Amount, this.Vendor_Name);
}

class SalesItemWise {
  final String Date;
  final String Item_Name;
  var Amount;

  SalesItemWise(this.Date, this.Amount, this.Item_Name);
}