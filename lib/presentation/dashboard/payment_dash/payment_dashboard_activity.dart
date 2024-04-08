import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/app_preferance.dart';
import '../../../core/common.dart';
import '../../../core/common_style.dart';
import '../../../core/internet_check.dart';
import '../../../core/localss/application_localizations.dart';
import '../../../core/size_config.dart';
import '../../../data/api/constant.dart';
import '../../../data/api/request_helper.dart';
import '../../../data/domain/commonRequest/get_toakn_request.dart';
import '../home/home_fragment.dart';

class PaymentDashActivity extends StatefulWidget {
  const PaymentDashActivity({Key? key}) : super(key: key);

  @override
  State<PaymentDashActivity> createState() => _PaymentDashActivityState();
}

class _PaymentDashActivityState extends State<PaymentDashActivity> {
  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isApiCall=false;

  List<SalesData> _saleData = [];

  var statistics=[];

  var saleAmt=0;
  var expenseAmt=0;
  var returnAmt=0;
  var receiptAmt=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDashboardExpense();
  }
  bool isShowSkeleton = true;
  getDashboardExpense() async {
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
        String apiUrl = "${baseurl}${ApiConstants().getDashboardExpense}?Company_ID=$companyId&Date=02-04-2024";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){

              setState(() {
                isLoaderShow=false;
                isShowSkeleton=false;
                if(data!=null){
                  if (mounted) {
                    for (var item in data['DashboardSaleDateWise']) {
                      _saleData.add(SalesData(DateFormat("dd/MM/yyy").format(DateTime.parse(item['Date'])), item['Amount']));
                    }
                  }
                  _saleData=_saleData;
                  saleAmt=data['DashboardMainData'][0]['Sale_Amount'];
                  expenseAmt=data['DashboardMainData'][0]['Expense_Amount'];
                  returnAmt=data['DashboardMainData'][0]['Return_Amount'];
                  receiptAmt=data['DashboardMainData'][0]['Receipt_Amount'];

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
                    ApplicationLocalizations.of(context)!.translate("payment")!,
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
      body: SingleChildScrollView(
        child:   Column(
          children: [
            getPurchaseDateLayout(),
            weeklySalegraph(),
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
          getDashboardExpense();
        },
        applicablefrom: saleDate
    );
  }

  Container weeklySalegraph() {
    return  Container(
      height: 400,
      width: SizeConfig.screenWidth,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Weekly Sales analysis',alignment: ChartAlignment.near),
        // Enable legend
        // legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis( labelIntersectAction: AxisLabelIntersectAction.rotate90,labelPlacement: LabelPlacement.betweenTicks),
        primaryYAxis: NumericAxis(
            title: AxisTitle(text: "Party ",textStyle: item_regular_textStyle, )
        ),
        series: <ChartSeries>[
          ColumnSeries<SalesData, String>(
            dataSource: _saleData,
            xValueMapper: (SalesData sales, _) => sales.Date,
            yValueMapper: (SalesData sales, _) => sales.Amount,
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
