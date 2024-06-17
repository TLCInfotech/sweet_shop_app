import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/presentation/menu/report/common_screens/detail_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/purchase/create_purchase_activity.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';



class ReportTypeList extends StatefulWidget {
  final  reportName;
  final  party;
  final  partId;
  final  applicablefrom;
  final  applicableTwofrom;

  const ReportTypeList({super.key, required mListener,this.reportName, this.party, this.partId, this.applicablefrom, this.applicableTwofrom});

  @override
  State<ReportTypeList> createState() => _ReportTypeListState();
}

class _ReportTypeListState extends State<ReportTypeList>with CreatePurchaseInvoiceInterface {

  DateTime applicablefrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTwofrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isLoaderShow=false;
  bool partyBlank=false;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  List<dynamic> array_list=[];
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  bool isApiCall=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    selectedFranchiseeName=widget.party;
    selectedFranchiseeId=widget.partId;
    applicablefrom=widget.applicablefrom;
    applicableTwofrom=widget.applicableTwofrom;
    getReportList(page);

  }
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getReportList(page);
      }
    }
  }
  setDataToList(List<dynamic> _list) {
    if (array_list.isNotEmpty) array_list.clear();
    if (mounted) {
      setState(() {
        array_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        array_list.addAll(_list);
      });
    }
  }
  //FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await getReportList(page);
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
                         GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: FaIcon(Icons.arrow_back),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.reportName,
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
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width:(SizeConfig.halfscreenWidth),
                            child: getDateONELayout(SizeConfig.screenHeight,SizeConfig.screenWidth)),
                        Container(

                            width:(SizeConfig.halfscreenWidth),
                            child: getDateTwoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                    const SizedBox(
                      height: 10,
                    ),
                    get_purchase_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: array_list.isEmpty && isApiCall  ? true : false,
                  child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }
  /*widget for no data d*/
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

  /* Widget for date one layout */
  Widget getDateONELayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title:ApplicationLocalizations.of(context)!.translate("from_date")!,
        callback: (date){
          setState(() {
            applicablefrom=date!;
          });
          getReportList(page);
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
            applicableTwofrom=date!;
          });
          getReportList(page);
        },
        applicablefrom: applicableTwofrom
    );
  }


  String selectedFranchiseeName="";
  String selectedFranchiseeId="";
  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return partyBlank==false?Container():  SearchableLedgerDropdown(
      apiUrl: "${ApiConstants().franchisee}?",
      titleIndicator: false,
      ledgerName: selectedFranchiseeName,
      franchiseeName: selectedFranchiseeName,
      franchisee: "edit",
      readOnly:true,
      title: ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
      callback: (name,id){
        setState(() {
          selectedFranchiseeName = name!;
          selectedFranchiseeId = id.toString()!;
          array_list=[];
          getReportList(1);
        });
        print("############3");
        print(selectedFranchiseeId+"\n"+selectedFranchiseeName);
      },
    );
  }

 Expanded get_purchase_list_layout() {
    return Expanded(
        child: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount:array_list.length,
            itemBuilder: (BuildContext context, int index) {
              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: Duration(microseconds: 1500),
                    child: GestureDetector(
                      onTap: ()async{
                        await  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            DetailReportActivity(
                              franchisee: selectedFranchiseeName,
                            )));
                        selectedFranchiseeId="";
                        partyBlank=false;
                        array_list=[];
                        await  getReportList(1);
                      },
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  //  Text(array_list[index]['Party_Name'],style: item_heading_textStyle,),
                                    SizedBox(height: 5,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                      //  FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                        Expanded(child: Text("Online Amount: ${CommonWidget.getCurrencyFormat(array_list[index]['Bank_Receipt_Amount'])}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      //  FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                        Expanded(child: Text("Share:+${CommonWidget.getCurrencyFormat(array_list[index]['Profit_Share'])}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: SizeConfig.halfscreenWidth-20,
                                          child:
                                          Text(CommonWidget.getCurrencyFormat(array_list[index]['Profit']),
                                            overflow: TextOverflow.ellipsis,
                                            style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                        //   Expanded(child: Text(CommonWidget.getCurrencyFormat("Share: ${400096543}"),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                        )],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                         /*     DeleteDialogLayout(
                              callback: (response ) async{
                                if(response=="yes"){
                                  print("##############$response");
                                  await   callDeleteSaleInvoice(array_list[index]['Invoice_No'].toString(),array_list[index]['Seq_No'].toString(),index);
                                }
                              },
                            )*/
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 5,
              );
            },
          ),
        ));
  }


  getReportList(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().misprofit}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Party_ID=$selectedFranchiseeId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;

                if(data!=null){
                  List<dynamic> _arrList = [];
                  array_list=data;
                  partyBlank=true;
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
  backToList(DateTime updateDate) {
    // TODO: implement backToList
    setState(() {
      array_list=[];
    });
    getReportList(1);
    Navigator.pop(context);
  }
}
