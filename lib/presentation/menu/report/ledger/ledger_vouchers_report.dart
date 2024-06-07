import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';
import 'package:sweet_shop_app/core/internet_check.dart';
import 'package:sweet_shop_app/data/api/request_helper.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';

import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/common_style.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';

class LedgerVouchersReport extends StatefulWidget {
  const LedgerVouchersReport({super.key});

  @override
  State<LedgerVouchersReport> createState() => _LedgerVouchersReportState();
}

class _LedgerVouchersReportState extends State<LedgerVouchersReport> {
  String reportType = "";
  String reportId = "";
  bool isLoaderShow=false;
  bool partyBlank=true;
  bool isApiCall=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> expense_list=[];
  bool disableColor = false;

  DateTime applicablefrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTo =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  String selectedFranchiseeName="";

  final _expenseFocus = FocusNode();
  final expenseController = TextEditingController();
  String selectedLedgerName="";
  String selectedLedgerId="";


  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        // callGetLedger(page);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     getReportLedger(page);

  }

  var  singleRecord;
  List<dynamic> ledgerList = [];

  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    // await callGetLedger(page);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: CommonColor.BACKGROUND_COLOR,
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
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
                            ApplicationLocalizations.of(context)!.translate("ledger_voucher")!,
                            style: appbar_text_style,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  child: getAllTextFormFieldLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth)),
            ),
            Container(
                decoration: BoxDecoration(
                  color: CommonColor.WHITE_COLOR,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withOpacity(0.08),
                      width: 1.0,
                    ),
                  ),
                ),
                height: SizeConfig.safeUsedHeight * .1,
                child: getSaveAndFinishButtonLayout(
                    SizeConfig.screenHeight, SizeConfig.screenWidth)),
            CommonWidget.getCommonPadding(
                SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
          ],
        ),
      ),
    );
  }


  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return  Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width:(SizeConfig.halfscreenWidth),
                      child: getDateONELayout(parentHeight, parentWidth)),
                  Container(

                      width:(SizeConfig.halfscreenWidth),
                      child: getDateTwoLayout(parentHeight, parentWidth)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                ApplicationLocalizations.of(context)!.translate("ledger_voucher")!,
                style: item_heading_textStyle,),
              get_items_list_layout()
            ],
          ),
        ),
        Visibility(
            visible: expense_list.isEmpty && isApiCall  ? true : false,
            child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

      ],
    );

  }

  /* Widget to get sale ledger Name Layout */
  Widget getSaleLedgerLayout(double parentHeight, double parentWidth) {
    return SearchableLedgerDropdown(
        apiUrl: "${ApiConstants().ledgerWithoutImage}?",
        titleIndicator: true,
        title: ApplicationLocalizations.of(context)!.translate("ledger")!,
        franchiseeName: selectedLedgerName!=""? selectedLedgerName:"",
        franchisee:selectedLedgerName,
        callback: (name,id)async{
          setState(() {
            selectedLedgerName = name!;
            selectedLedgerId = id!;

          });
           await getReportLedger(page);
        },
        ledgerName: selectedLedgerName);
  }

  /* Widget for date one layout */
  Widget getDateONELayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title:ApplicationLocalizations.of(context)!.translate("from_date")!,
        callback: (date){
          setState(() {
            applicablefrom=date!;
          });
          getReportLedger(page);
        },
        applicablefrom: applicablefrom
    );

  }

  /* Widget for date two layout */
  Widget getDateTwoLayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title:ApplicationLocalizations.of(context)!.translate("to_date")!,
        callback: (date){
          setState(() {
            applicableTo=date!;
          });
          getReportLedger(page);
        },
        applicablefrom: applicableTo
    );
  }

  Expanded get_items_list_layout() {
    return Expanded(
        child: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: expense_list.length,
            controller: _scrollController,
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (BuildContext context, int index) {
              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: const Duration(microseconds: 1500),
                    child: GestureDetector(
                      onTap: ()async{
                      },
                      child: Card(
                        elevation: 0,
                        color:  expense_list[index]['Credit']!=null?Colors.deepOrange.withOpacity(0.2):Colors.green.withOpacity(0.2),
                        child: Row(
                          children: [
                           Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(expense_list[index]['Ledger_Name'],style: item_heading_textStyle,),

                                          Row(
                                            children: [
                                              FaIcon(FontAwesomeIcons.fileInvoice ,size: 15,),
                                              SizedBox(width: 10,),
                                              Text("${expense_list[index]['Voucher_Name']} Voucher No.:${expense_list[index]['Voucher_No']}", style: item_regular_textStyle,),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  FaIcon(FontAwesomeIcons.calendar,size: 15,),
                                                  SizedBox(width: 10,),
                                                  Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(expense_list[index]['Date'])), style: item_regular_textStyle,),
                                                ],
                                              ),
                                              Expanded(
                                                  child:Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      expense_list[index]['Credit']!=null?  Text(CommonWidget.getCurrencyFormat(expense_list[index]['Credit']),overflow: TextOverflow.clip,style: item_heading_textStyle,):
                                                      Text(CommonWidget.getCurrencyFormat(expense_list[index]['Debit']),overflow: TextOverflow.clip,style: item_heading_textStyle,),
                                                      SizedBox(width: 5,),
                                                      expense_list[index]['Credit']!=null? Text("CR",style: item_heading_textStyle,):Text("DR",style: item_heading_textStyle,)
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                )

                            )
                          ],
                        ),
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

  /* Widget for navigate to next screen button  */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        openingBal==null?Container():  Container(
          padding: EdgeInsets.only(top: 0,bottom:0,left: 10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text("Opening Bal. : ${CommonWidget.getCurrencyFormat(double.parse(openingBal).ceilToDouble().abs())}",style: item_heading_textStyle,),
              int.parse(closingBal)==0?Container():( int.parse(openingBal)<0?Text(" CR",style: item_heading_textStyle,):Text(" DR",style: item_heading_textStyle,)),
            ],
          ),
        ),
       closingBal==null?Container():
       Container(
          padding: EdgeInsets.only(top: 5,bottom:10,left: 10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child:  Row(
            children: [
              Text("Closing Bal: ${CommonWidget.getCurrencyFormat(double.parse(closingBal).ceilToDouble().abs())}",style: item_heading_textStyle,),
              int.parse(closingBal)==0?Container():(int.parse(closingBal)<0?Text(" CR",style: item_heading_textStyle,):Text(" DR",style: item_heading_textStyle,)),
            ],
          ),
        ),

      ],
    );
  }

  var openingBal=null;
  var closingBal=null;

  getReportLedger(int page) async {
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
        String apiUrl;
        apiUrl = "${baseurl}${ApiConstants().ledgerOpeningBalance}?Company_ID=$companyId&Ledger_ID=$selectedLedgerId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTo)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                partyBlank=true;
                isLoaderShow=false;
                print("jfhfhb  $data");
                if(data!=null){
                  // openingBal=data['Opening_Balance']<0?"${data['Opening_Balance']}":"${data['Opening_Balance']}DR";
                  // closingBal=data['Closing_Balance']<0?"${data['Closing_Balance']}CR":"${data['Closing_Balance']}DR";
                  openingBal= (data['Opening_Balance']).toString();
                  closingBal=data['Closing_Balance'].toString();
                  List<dynamic>  newList=(data['Ledger_vouchers']);
                  expense_list=newList;
           print("njdnj  $expense_list");
                }else{
                  isApiCall=true;
                }
              //  calculateTotalAmt();
              });

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
