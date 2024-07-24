import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/presentation/menu/report/common_screens/detail_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/expense/ledger_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/purchase/create_purchase_activity.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/downloadservice.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
import '../../../common_widget/get_date_layout.dart';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';



class ReportTypeList extends StatefulWidget {
  final  reportName;
  final  reportId;
  final  party;
  final  partId;
  final  venderId;
  final  expenseName;
  final  expenseId;
  final  applicablefrom;
  final  applicableTwofrom;
  final  url;
  final comeFrom;
  final String logoImage;
  const ReportTypeList({super.key, required mListener,this.reportName, this.party, this.partId, this.applicablefrom, this.applicableTwofrom, this.reportId, this.url,this.comeFrom, this.venderId, this.expenseId, this.expenseName, required this.logoImage});

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

  String TotalAmount="0.00";
  String totalProfit="0.00";
  String totalProfitShare="0.00";
  String bankRAmount="0.00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ommmmmm${widget.reportId}");
    _scrollController.addListener(_scrollListener);
    if(widget.comeFrom=="MIS"){
      selectedFranchiseeName=widget.party;
      selectedFranchiseeId=widget.partId;
    }else{
      selectedFranchiseeName=widget.party;
      selectedFranchiseeId=widget.venderId;
      selectedLedgerName=widget.expenseName;
      selectedLedgerId=widget.expenseId;
    }


    applicablefrom=widget.applicablefrom;
    applicableTwofrom=widget.applicableTwofrom;
    getReportList(page);
    getLocal();
  }
  List MasterMenu=[];
  List TransactionMenu=[];
  var dataArr;
  getLocal()async{
    var tr =await (AppPreferences.getTransactionMenuList());
    dataArr=tr;
    setState(() {
    TransactionMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });
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
                        widget.logoImage!=""? Container(
                          height:SizeConfig.screenHeight*.05,
                          width:SizeConfig.screenHeight*.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              image: DecorationImage(
                                image: FileImage(File(widget.logoImage)),
                                fit: BoxFit.cover,
                              )
                          ),
                        ):Container(),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.reportName,
                              style: appbar_text_style,),
                          ),
                        ),
                        PopupMenuButton(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: Colors.transparent,
                              child: const FaIcon(Icons.download_sharp),
                            ),
                          ),
                          onSelected: (value) {
                            if(value == "PDF"){
                              // add desired output
                              pdfDownloadCall("PDF");
                            }else if(value == "XLS"){
                              // add desired output
                              pdfDownloadCall("XLS");
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            const PopupMenuItem(
                              value: "PDF",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.picture_as_pdf, color: Colors.red),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: "XLS",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage('assets/images/xls.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
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
          body: Column(
            // alignment: Alignment.center,
            children: [
              Expanded(
                child: Stack(
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
                          widget.reportId=="PTSM"||widget.reportId=="PROFIT"?getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth):Container(),
                          widget.reportId=="EXSM"?getExpenseNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth):Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          get_purchase_list_layout()
                        ],
                      ),
                                   ),
                    Visibility(
                        visible: array_list.isEmpty && isApiCall  ? true : false,
                        child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

                  ],
                ),
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
                  height: SizeConfig.safeUsedHeight * .12,
                  child: getSaveAndFinishButtonLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth)),
            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }
  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return widget.comeFrom=="MIS"? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.only(top:0,bottom:0,left: 10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${array_list.length} Items",style: item_regular_textStyle,),
              totalProfit=="0.00"?Container():Text("Total Profit: ${CommonWidget.getCurrencyFormat(double.parse(totalProfit))}",style: item_heading_textStyle,),
              totalProfitShare=="0.00"?Container():  Text("Profit Share: ${CommonWidget.getCurrencyFormat(double.parse(totalProfitShare))}",style: item_heading_textStyle,),
              bankRAmount=="0.00"?Container():  Text("Bank Receipt Amount: ${CommonWidget.getCurrencyFormat(double.parse(bankRAmount))}",style: item_heading_textStyle,),
            ],
          ),
        )
      ],
    ): Row(
mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TotalAmount!="0.00"? Container(
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.only(top:0,bottom:0,left: 10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${array_list.length} Items",style: item_regular_textStyle,),
              Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,),
            ],
          ),
        ):Container(),
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
    return   SearchableLedgerDropdown(
      apiUrl: "${ApiConstants().franchisee}?",
      titleIndicator: false,
      ledgerName: selectedFranchiseeName,
      franchiseeName:widget.party,
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
                    child: Column(
                      children: [
                        widget.comeFrom=="EXPENSE"?
                        getUIForExpenseReportPartyWise(context,index)
                            :getUIForMISReport(context, index)                      ],
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


 Widget getUIForMISReport(BuildContext context, int index) {
   return GestureDetector(
                    onTap: ()async{
                      await  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          DetailReportActivity(
                              logoImage: widget.logoImage,
                            apiurl: ApiConstants().getMISFranchiseeProfitDatewise,
                            partId: array_list[index]['Party_ID'],
                            party:array_list[index]['Party_Name'],
                            fromDate: applicablefrom,
                            toDate: applicableTwofrom,
                            come:"partyName"
                          )));
                      array_list=[];
                      await  getReportList(1);
                    },
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: SizeConfig.screenWidth*.1,
                              height:SizeConfig.screenHeight*.05,
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              alignment: Alignment.center,
                              child: Text("${index+1}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontSize: 14),)
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  array_list[index]['Party_Name']==null?Container():  Text(array_list[index]['Party_Name'],style: item_heading_textStyle,),
                                  SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                    //  FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                      Expanded(child: Text("Online Amount: ${CommonWidget.getCurrencyFormat(array_list[index]['Bank_Receipt_Amount'])}",overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color:array_list[index]['Bank_Receipt_Amount']<0? Colors.red:Colors.green,
                                          fontFamily: "Inter_Light_Font"
                                      ),)),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    //  FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                      Expanded(child:
                                      array_list[index]['Profit_Share']<0?
                                      Text("Share: ${CommonWidget.getCurrencyFormat((array_list[index]['Profit_Share']*-1))}",overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.red,
                                              fontFamily: "Inter_Light_Font"
                                          ))
                                          :
                                      Text("Share: ${CommonWidget.getCurrencyFormat(array_list[index]['Profit_Share'])}",overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color:Colors.green,
                                              fontFamily: "Inter_Light_Font"
                                          ))

                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: SizeConfig.halfscreenWidth-20,
                                        child:array_list[index]['Profit']<0?
                                        Text(" "+CommonWidget.getCurrencyFormat(array_list[index]['Profit']*-1),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.red,
                                              fontFamily: "Inter_Medium_Font"
                                          ),):
                                        Text(" "+CommonWidget.getCurrencyFormat(array_list[index]['Profit']),
                                          overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color:Colors.green,
                                                fontFamily: "Inter_Medium_Font"
                                            ),),
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
                  );
 }

  String selectedLedgerName="";
  String selectedLedgerId="";
  /* Widget for expense text from field layout */
  Widget getExpenseNameLayout(double parentHeight, double parentWidth) {
    return  SearchableLedgerDropdown(
      apiUrl: "${ApiConstants().ledger_list}?",
      titleIndicator: false,
      ledgerName:widget.expenseName,
      franchisee: "edit",
      franchiseeName: widget.expenseName,
      readOnly:true,
      title: ApplicationLocalizations.of(context)!.translate("expense")!,
      callback: (name,id){
        setState(() {
          selectedLedgerName = name!;
          selectedLedgerId = id.toString()!;
        });
        array_list=[];
        getReportList(1);
      },
    );
  }



  Widget getUIForExpenseReportPartyWise(BuildContext context, int index) {
    return GestureDetector(
      onTap: ()async{
        if(widget.reportId=="PTSM"){
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DetailReportActivity(
                apiurl: ApiConstants().getExpensePartywise,
                venderId: array_list[index]['Vendor_ID'],
                venderName: array_list[index]['Vendor_Name'],
                fromDate: applicablefrom,
                come:"vendorName",
                logoImage: widget.logoImage,
                toDate: applicableTwofrom,
              )));
        }else if(widget.reportId=="EXSM"){
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DetailReportActivity(
                apiurl: ApiConstants().getExpenseExpensewise,
                expense: array_list[index]['Expense_ID'],
                expenseName: array_list[index]['Expense_Name'],
                fromDate: applicablefrom,
                logoImage: widget.logoImage,
                come:"expanseName",
                toDate: applicableTwofrom,
              )));
        }else {
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>
              LedgerActivity(
               mListener: this,
                dateNew:DateTime.parse(array_list[index]['Date']),
                formId: "AT009",
                logoImage: widget.logoImage,
                arrData: dataArr,
              )));
        }
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: SizeConfig.screenWidth*.1,
                        height:SizeConfig.screenHeight*.05,
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        alignment: Alignment.center,
                        child: Text("${index+1}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontSize: 14),)
                    ),
                    array_list[index]['Date']!=null?
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5),
                        child: Text(
                          CommonWidget.getDateLayout(DateTime.parse(array_list[index]['Date'])),
                          style: item_heading_textStyle,
                        ),
                      ),
                    ):Container(),

                    array_list[index]['Expense_Name']==null?Container():

                    Expanded(child:
                    Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5),
                        child: Text(array_list[index]['Expense_Name'],style: item_heading_textStyle,))),
                    SizedBox(height: 5,),

                    array_list[index]['Vendor_Name']==null?Container():
                     Expanded(child: Padding(
                         padding: const EdgeInsets.only(left: 5.0,right: 5),
                         child: Text(array_list[index]['Vendor_Name'],style: item_heading_textStyle,))),
                    SizedBox(height: 5,),

                    
                    Container(
                      alignment: Alignment.centerLeft,
                      child: array_list[index]['Amount']!=null && array_list[index]['Amount']<0?
                      Text(" "+CommonWidget.getCurrencyFormat(array_list[index]['Amount']*-1),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontFamily: "Inter_Medium_Font"
                        ),):
                      array_list[index]['Amount']!=null && array_list[index]['Amount']>0?Text(" "+CommonWidget.getCurrencyFormat(array_list[index]['Amount']),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.0,
                            color:Colors.green,
                            fontFamily: "Inter_Medium_Font"
                        ),):Container(),
                      //   Expanded(child: Text(CommonWidget.getCurrencyFormat("Share: ${400096543}"),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
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
        String apiUrl="" ;
        if(widget.comeFrom=="MIS"){
        if(selectedFranchiseeId!=""){
          apiUrl= "${baseurl}${ApiConstants().reports}?Company_ID=$companyId&Form_Name=MIS&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&ID=$selectedFranchiseeId";
        }else{
          apiUrl= "${baseurl}${ApiConstants().reports}?Company_ID=$companyId&Form_Name=MIS&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}";
        }}else{
          if(selectedFranchiseeId!=""){
            apiUrl= "${baseurl}${ApiConstants().reports}?Company_ID=$companyId&Form_Name=Expense&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&ID=$selectedFranchiseeId";
          }else
          if(selectedLedgerId!=""){
            apiUrl= "${baseurl}${ApiConstants().reports}?Company_ID=$companyId&Form_Name=Expense&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&ID=$selectedLedgerId";
          }else{
            apiUrl= "${baseurl}${ApiConstants().reports}?Company_ID=$companyId&Form_Name=Expense&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}";
          }
        }
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;

                if(data!=null){
                  List<dynamic> _arrList = [];
                  if(widget.comeFrom=="MIS"){
                    array_list = data['Details'];
                    totalProfit = data['TotalProfit'].toString();
                    totalProfitShare = data['TotalProfitShare'].toString();
                    bankRAmount = data['TotalBankReceiptAmount'].toString();
                  }
                  else {
                    array_list = data['Details'];
                    TotalAmount = data['TotalAmount'].toString();
                  }
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


  pdfDownloadCall(String urlType) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId)async {
        setState(() {
          isLoaderShow=false;
        });
        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );


        String apiUrl="" ;
        if(widget.comeFrom=="MIS"){
            apiUrl =baseurl + ApiConstants().MISReports+"/Download?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&ID=$selectedFranchiseeId&Type=$urlType";
        }else{
          if(selectedFranchiseeId!=""){
            apiUrl= "${baseurl}${ApiConstants().getExpenseReports}/Download?Company_ID=$companyId&Form_Name=Expense&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&ID=$selectedFranchiseeId&Type=$urlType";
          }else {
            apiUrl= "${baseurl}${ApiConstants().getExpenseReports}/Download?Company_ID=$companyId&Form_Name=Expense&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&ID=$selectedLedgerId&Type=$urlType";
          }
        }
        String type="pdf";
        if(urlType=="XLS")
          type="xlsx";

        DownloadService downloadService = MobileDownloadService(apiUrl.toString(),type,context);
        await downloadService.download(url: apiUrl);

        setState(() {
          isLoaderShow=false ;
        });
      }); }
    else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  Future<void> downloadFile( String url, String fileName) async {
    // Check for storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Get the application directory
      var dir = await getExternalStorageDirectory();
      if (dir != null) {
        // String url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
        //  String fileName = "example.pdf";
        String savePath = "${dir.path}/$fileName";

        try {
          var response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
            File file = File(savePath);
            await file.writeAsBytes(response.bodyBytes);
            print("File is saved to download folder: $savePath");

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Downloaded: $fileName"),
              ),
            );
            // Show a notification
            NotificationService.showNotification(
                'Download Complete',
                'The file has been downloaded successfully.',
                savePath
            );
            // Open the downloaded file
            OpenFile.open(savePath);
          } else {
            print("Error: ${response.statusCode}");
          }
        } catch (e) {
          print("Error: $e");
        }
      }
    } else {
      print("Permission Denied");
    }
  }
}
