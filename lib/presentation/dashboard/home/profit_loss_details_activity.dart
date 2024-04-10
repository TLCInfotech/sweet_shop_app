import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/expense/create_ledger_activity.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';




class ProfitLossDetailActivity extends StatefulWidget {
  final String? comeFor;
  final date;
  const ProfitLossDetailActivity({super.key, required mListener, this.comeFor, this.date});

  @override
  State<ProfitLossDetailActivity> createState() => _ProfitLossDetailActivityState();
}

class _ProfitLossDetailActivityState extends State<ProfitLossDetailActivity> {

  DateTime newDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isLoaderShow=false;
  bool isApiCall=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 //   _scrollController.addListener(_scrollListener);
    newDate=widget.date;
    getExpense(page);
  }
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getExpense(page);
      }
    }
  }
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await getExpense(page);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFfffff5),
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
                        widget.comeFor=="dash"? Container(): GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: FaIcon(Icons.arrow_back),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                            widget.comeFor!,
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
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4,left: 15,right: 15,bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getPurchaseDateLayout(),
                    const SizedBox(
                      height: 10,
                    ),

                    get_ledger_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: _profitPartywise.isEmpty && isApiCall  ? true : false,
                  child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
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

  /* Widget to get add PURCHASE date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            newDate=date!;
            _profitPartywise=[];
          });
          getExpense(1);
        },
        applicablefrom: newDate
    );
  }



  /* widget for title layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 5, bottom: 5,),
      child: Text(
        title,
        style: page_heading_textStyle,
      ),
    );
  }

  /* widget for get ledger list layout */
  Expanded get_ledger_list_layout() {
    return Expanded(
        child:  RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            itemCount: _profitPartywise.length,
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              ProfitPartyWiseData model =_profitPartywise.elementAt(index);
              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: const Duration(microseconds: 1500),
                    child: Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: (index)%2==0?Colors.green:Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child:  const FaIcon(
                                  FontAwesomeIcons.moneyCheck,
                                  color: Colors.white,
                                )
                              // Text("A",style: kHeaderTextStyle.copyWith(color: Colors.white,fontSize: 16),),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(model.Vendor_Name,style: item_heading_textStyle,),
                                  const SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                      const SizedBox(width: 10,),
                                      Expanded(child: Text("Vendor ID:- ${model.Vendor_ID}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                      const SizedBox(width: 10,),
                                      Expanded(child: Text("Sale Amount:- ${CommonWidget.getCurrencyFormat(model.Sale_Amount)}",overflow: TextOverflow.clip,style: item_heading_textStyle,)),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                      const SizedBox(width: 10,),
                                      Expanded(child: Text("Expense Amount:- ${CommonWidget.getCurrencyFormat(model.Expense_Amount)}",overflow: TextOverflow.clip,style: item_heading_textStyle,)),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                      const SizedBox(width: 10,),
                                      Expanded(child: Text("Return Amount:- ${CommonWidget.getCurrencyFormat(model.Expense_Amount)}",overflow: TextOverflow.clip,style: item_heading_textStyle,)),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                      const SizedBox(width: 10,),
                                      Expanded(child: Text("Profit:- ${CommonWidget.getCurrencyFormat(model.Profit)}",overflow: TextOverflow.clip,style: item_heading_textStyle,)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
        ));
  }

  List<ProfitPartyWiseData> _profitPartywise = [];
  getExpense(int page) async {
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
            page: page.toString()
        );
        String apiUrl = "${baseurl}${ApiConstants().getDashboardProfitDetailpartywise}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(newDate)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  for (var item in data['DashboardProfitDetailPartywise']) {
                    _profitPartywise.add(ProfitPartyWiseData(DateFormat("dd/MM").format(DateTime.parse(item['Date'])), (item['Vendor_ID']),(item['Vendor_Name']),(item['Sale_Amount']),(item['Expense_Amount']),(item['Return_Amount']),(item['Profit'])));
                  }
                  print("getDashboardProfitDetailpartywise    $_profitPartywise");
            /*      if (_arrList.length < 10) {
                    if (mounted) {
                      setState(() {
                        isPagination = false;
                      });
                    }
                  }
                  if (page == 1) {
                    setDataToList(_arrList);
                  } else {
                    setMoreDataToList(_arrList);
                  }*/
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





}


class ProfitPartyWiseData {
  final String Date;
  final String Vendor_Name;
  final int Profit;
  final int Sale_Amount;
  final int Expense_Amount;
  final int Return_Amount;
  final int Vendor_ID;

  ProfitPartyWiseData(this.Date, this.Profit, this.Vendor_Name,this.Sale_Amount,this.Expense_Amount,this.Return_Amount,this.Vendor_ID);
}