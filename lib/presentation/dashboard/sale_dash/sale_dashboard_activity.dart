import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/presentation/dashboard/home/home_fragment.dart';
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

  var statistics=[];

  var saleAmt=0;
  var expenseAmt=0;
  var returnAmt=0;
  var receiptAmt=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDashboardSale();
  }
  bool isShowSkeleton = true;
  getDashboardSale() async {
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
        String apiUrl = "${baseurl}${ApiConstants().getDashboardSalePartywise}?Company_ID=$companyId&Date=${DateFormat("dd-MM-yyyy").format(saleDate)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){

              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
                if(data!=null){
                  if (mounted) {
                    for (var item in data['DashboardSalePartywise']) {
                      _saleData.add(SalesDataDash(DateFormat("dd/MM/yyy").format(DateTime.parse(item['Date'])), item['Amount'],item['Vendor_Name']));
                    }
                  }
                  _saleData=_saleData;

                  print(statistics);

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              leading: Container(),
              title:  Container(
                width: SizeConfig.screenWidth,
                child: Center(
                  child: Text(
                    ApplicationLocalizations.of(context)!.translate("sale")!,
                    style: appbar_text_style,),
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            getPurchaseDateLayout(),
            weeklySalegraph()
          ],
        ),
      ),
    );
  }
  DateTime saleDate =  DateTime.now().subtract(Duration(days:1,minutes: 30 - DateTime.now().minute % 30));


  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            saleDate=date!;
          });
          getDashboardSale();
        },
        applicablefrom: saleDate
    );
  }

  Container weeklySalegraph() {
    return  Container(
     // height: 400,
      margin: const EdgeInsets.symmetric(vertical:5),
      width: SizeConfig.screenWidth,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Sales analysis',alignment: ChartAlignment.near),
        primaryXAxis: CategoryAxis( labelIntersectAction: AxisLabelIntersectAction.rotate90,labelPlacement: LabelPlacement.betweenTicks),
        primaryYAxis: NumericAxis(
            title: AxisTitle(text: "Party ",textStyle: item_regular_textStyle, )
        ),
        series: <ChartSeries>[
          BarSeries<SalesDataDash, String>(
            width: 0.2,
            dataSource: _saleData,
            xValueMapper: (SalesDataDash sales, _) => sales.Vendor_Name,
            yValueMapper: (SalesDataDash sales, _) => sales.Amount,
            dataLabelSettings: DataLabelSettings(
                alignment: ChartAlignment.far,
                angle: 270,
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.outer,
                textStyle: item_heading_textStyle.copyWith(fontSize:9 )
            ),
          )
        ],
      ),
    );
  }
}
class SalesDataDash {
  final String Date;
  final String Vendor_Name;
  final int Amount;

  SalesDataDash(this.Date, this.Amount, this.Vendor_Name);
}