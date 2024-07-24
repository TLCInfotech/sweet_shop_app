import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/presentation/dashboard/home/profit_loss_dashboard.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/common_style.dart';
import '../../../../core/downloadservice.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../common_widget/singleLine_TextformField_without_double.dart';
import '../../transaction/expense/create_ledger_activity.dart';
import '../../transaction/expense/ledger_activity.dart';


class DetailReportActivity extends StatefulWidget {
  final apiurl;
  final fromDate;
  final toDate;
  final  party;
  final  partId;
  final  expenseName;
  final  expense;
  final  venderId;
  final  venderName;
  final  come;
  final String logoImage;
  const DetailReportActivity(
      {super.key, this.apiurl, this.fromDate, this.toDate, this.party, this.partId, this.expenseName, this.expense, this.venderId, this.venderName, this.come, required this.logoImage,});

  @override
  State<DetailReportActivity> createState() => _DetailReportActivityState();
}

class _DetailReportActivityState extends State<DetailReportActivity> with ProfitLossDashInterface{
  bool isLoaderShow = false;
  bool isApiCall = false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  int page = 1;
  bool isPagination = true;

  TextEditingController franchiseeName = TextEditingController();
  DateTime applicablefrom =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTwofrom =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  List<dynamic> reportDetailList = [];
  ScrollController _scrollController = new ScrollController();

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callDetailReportList(page);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);

    setVal();

  }
  List MasterMenu=[];
  List TransactionMenu=[];
  var dataArr;

  String TotalAmount="0.00";
  String totalProfit="0.00";
  String totalProfitShare="0.00";
  String bankRAmount="0.00";

  setVal()async{
    var tr =await (AppPreferences.getTransactionMenuList());
    dataArr=tr;
    setState(() {
      TransactionMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });
    setState(() {
      print("hbjfbhfbbf ${widget.come} ${widget.venderId}");

      if(widget.come=="expanseName"){
        franchiseeName.text=widget.expenseName.toString();
      }else if(widget.come=="vendorName"){
        franchiseeName.text=widget.venderName.toString();
      }else{
        franchiseeName.text=widget.party.toString();
      }
      applicablefrom=widget.fromDate;
      applicableTwofrom=widget.toDate;
    });
    await callDetailReportList(page);
  }

  Future<void> refreshList() async {
    print("Here");
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page = 1;
    });
    isPagination = true;
    await callDetailReportList(page);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
            backgroundColor: Color(0xFFfffff5),
            appBar: PreferredSize(
              preferredSize: AppBar().preferredSize,
              child: SafeArea(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.transparent,
                  // color: Colors.red,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: AppBar(
                    leadingWidth: 0,
                    automaticallyImplyLeading: false,
                    title: Container(
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
                              child: widget.come!="expanseName"?Text(
    widget.come=="partyName"?ApplicationLocalizations.of(context)!
                                    .translate("franchisee")!+" Profit": ApplicationLocalizations.of(context)!
        .translate("franchisee")!):Text(
                                  ApplicationLocalizations.of(context)!
        .translate("expense")!,
                                style: appbar_text_style,
                              ),
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
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            body: Column(
              // alignment: Alignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTopLayout(
                            SizeConfig.screenHeight, SizeConfig.halfscreenWidth),
                        const SizedBox(
                          height: 10,
                        ),
                        get_detail_report_list_layout()
                      ],
                    ),
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
                        SizeConfig.screenHeight, SizeConfig.screenWidth))
              ],
            )),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  Widget getTotalCountAndAmount() {
    return Container(
      margin: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
      child: Container(
          height: 40,
          width: SizeConfig.screenWidth*0.9,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),]

          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${reportDetailList.length} ${ApplicationLocalizations.of(context)!.translate("invoices")!}", style: subHeading_withBold,),
              Text(CommonWidget.getCurrencyFormat(double.parse(TotalAmount)), style: subHeading_withBold,),
            ],
          )
      ),
    );
  }
  /* widget for Franchisee name layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      readOnly: false,
      title:
          ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
      callbackOnchage: (value) {},
      textInput: TextInputType.text,
      maxlines: 1,
      format:
          FilteringTextInputFormatter.allow(RegExp(r'^[A-zÀ\s*&^%0-9,.-:)(]+')),
      validation: ((value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      }),
      controller: franchiseeName, 
      focuscontroller: null,
      focusnext: null,

    );
  }

  Expanded get_detail_report_list_layout() {
    return Expanded(
        child: RefreshIndicator(
      color: CommonColor.THEME_COLOR,
      onRefresh: () => refreshList(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportDetailList.length,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: -44.0,
              child: FadeInAnimation(
                delay: Duration(microseconds: 1500),
                child: GestureDetector(
                  onTap: () async {
                    if(widget.come=="vendorName" || widget.come=="expanseName") {
                      // await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      //     LedgerActivity(
                      //       mListener: this,
                      //       dateNew:DateTime.parse(reportDetailList[index]['Date']),
                      //       formId: "AT009",
                      //       arrData: dataArr,
                      //     )));
                      List<dynamic> jsonArray = jsonDecode(dataArr);
                      var singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == "AT009");
                      print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");

                      await  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateLedger(
                        mListener: this,   logoImage: widget.logoImage,
                        voucherNo: reportDetailList[index]["Voucher_No"].toString(),
                        dateNew: DateTime.parse(reportDetailList[index]['Date']),
                        readOnly:singleRecord['Update_Right'],
                        editedItem:reportDetailList[index],
                        come:"edit",
                        // DateFormat('dd-MM-yyyy').format(newDate),
                      )));
                    }
                    else{
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              ProfitLossDash(mListener: this,
                                fid: widget.partId,
                                vName: widget.party,
                                logoImage: widget.logoImage,
                                date: reportDetailList[index]['Date'],
                                come: "report",
                              )));
                    }
                  },
                  child: Card(
                    child: Container(
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                              child: Row(
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          reportDetailList[index]['Date']!=null?Text(
                                            CommonWidget.getDateLayout(DateTime.parse(reportDetailList[index]['Date'])),
                                            style: item_heading_textStyle,
                                          ):Container(),
                                          SizedBox(height: 5,),
                                          reportDetailList[index]['Bank_Receipt_Amount']!=null?  Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              //  FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                    
                                              Expanded(child: Text("Online Amount: "+CommonWidget.getCurrencyFormat(reportDetailList[index]['Bank_Receipt_Amount']),overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color:reportDetailList[index]['Bank_Receipt_Amount']<0? Colors.red:Colors.green,
                                                      fontFamily: "Inter_Light_Font"
                                                  ))),
                                            ],
                                          ):Container(),
                                          SizedBox(height: 5,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //  FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                              reportDetailList[index]['Profit_Share']!=null?Expanded(child:
                                              reportDetailList[index]['Profit_Share']<0?
                                              Text("Share: ${CommonWidget.getCurrencyFormat((reportDetailList[index]['Profit_Share']*-1))}",overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.red,
                                                      fontFamily: "Inter_Light_Font"
                                                  ))
                                                  :
                                              Text("Share: ${CommonWidget.getCurrencyFormat(reportDetailList[index]['Profit_Share'])}",overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color:Colors.green,
                                                      fontFamily: "Inter_Light_Font"
                                                  ))
                                    
                                              ):Container(),
                                              reportDetailList[index]['Profit']!=null? Container(
                                                alignment: Alignment.centerRight,
                                                width: SizeConfig.halfscreenWidth-20,
                                                child:reportDetailList[index]['Profit']<0?
                                                Text(" "+CommonWidget.getCurrencyFormat(reportDetailList[index]['Profit']*-1),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.red,
                                                      fontFamily: "Inter_Medium_Font"
                                                  ),):
                                                Text(" "+CommonWidget.getCurrencyFormat(reportDetailList[index]['Profit']),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color:Colors.green,
                                                      fontFamily: "Inter_Medium_Font"
                                                  ),),
                                                //   Expanded(child: Text(CommonWidget.getCurrencyFormat("Share: ${400096543}"),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                              ):Container()],
                                          ),
                                    
                                     
                                    
                                        ],
                                      ),
                                    ),
                                  ),
                                  reportDetailList[index]['Amount']!=null&& reportDetailList[index]['Amount']<0?
                                  Text(" ${CommonWidget.getCurrencyFormat((reportDetailList[index]['Amount']*-1))}",overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color:Colors.green,
                                          fontFamily: "Inter_Medium_Font"
                                      ))
                                      :
                                  reportDetailList[index]['Amount']!=null?Text(" ${CommonWidget.getCurrencyFormat(reportDetailList[index]['Amount'])}",overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color:Colors.green,
                                          fontFamily: "Inter_Medium_Font"
                                      )):Container()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Card(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         margin: const EdgeInsets.only(
                  //             top: 10, left: 10, right: 10, bottom: 10),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 FaIcon(
                  //                   FontAwesomeIcons.calendar,
                  //                   color: Colors.black87,
                  //                   size: 20,
                  //                 ),
                  //                 SizedBox(
                  //                   width: 10,
                  //                 ),
                  //                 Text(
                  //                   CommonWidget.getDateLayout(DateTime.now()),
                  //                   style: item_heading_textStyle,
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 5,
                  //             ),
                  //             Text(
                  //               "Online : " +
                  //                   CommonWidget.getCurrencyFormat(
                  //                           double.parse("1000000000"))
                  //                       .toString(),
                  //               overflow: TextOverflow.clip,
                  //               style: item_regular_textStyle,
                  //             ),
                  //             Text("Share : " + CommonWidget.getCurrencyFormat(double.parse("1000000000")).toString(),
                  //               overflow: TextOverflow.clip,
                  //               style: item_regular_textStyle,
                  //             ),
                  //             Container(
                  //               width: SizeConfig.screenWidth * 0.83,
                  //               alignment: Alignment.centerRight,
                  //               child: Text(
                  //                 CommonWidget.getCurrencyFormat(
                  //                         double.parse("1000000000"))
                  //                     .toString(),
                  //                 // "${(Item_list[index]['Net_Rate']).toStringAsFixed(2)}/kg ",
                  //                 overflow: TextOverflow.ellipsis,
                  //                 textAlign: TextAlign.end,
                  //                 style: item_heading_textStyle.copyWith(
                  //                     color: Colors.blue),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       // Expanded(child:
                  //       // Text(
                  //       //   CommonWidget.getCurrencyFormat(double.parse("1000000000")).toString() ,
                  //       //   // "${(Item_list[index]['Net_Rate']).toStringAsFixed(2)}/kg ",
                  //       //   overflow:
                  //       //   TextOverflow.ellipsis,
                  //       //   style: item_heading_textStyle
                  //       //       .copyWith(
                  //       //       color: Colors.blue),
                  //       // ),)
                  //     ],
                  //   ),
                  // ),
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

  getTopLayout(double parentHeight, double parentWidth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: (SizeConfig.halfscreenWidth),
                child: getDateONELayout(parentHeight, parentWidth)),
            Container(
                width: (SizeConfig.halfscreenWidth),
                child: getDateTwoLayout(parentHeight, parentWidth)),
          ],
        ),
        getFranchiseeNameLayout(
            SizeConfig.screenHeight, SizeConfig.screenWidth),

      ],
    );
  }

  /* Widget for date one layout */
  Widget getDateONELayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title: ApplicationLocalizations.of(context)!.translate("from_date")!,
        callback: (date) async{
          setState(() {
            applicablefrom = date!;
          });
          await callDetailReportList(0);
        },
        applicablefrom: applicablefrom);
  }

  /* Widget for date two layout */
  Widget getDateTwoLayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title: ApplicationLocalizations.of(context)!.translate("to_date")!,
        callback: (date) async{
          setState(() {
            applicableTwofrom = date!;
          });
          await callDetailReportList(0);

        },
        applicablefrom: applicableTwofrom);
  }

  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    print("fhfbhbfvfv  ${widget.come}");
    return widget.come=="partyName"? Row(
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
              Text("${reportDetailList.length} Items",style: item_regular_textStyle,),
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
              Text("${reportDetailList.length} Items",style: item_regular_textStyle,),
              Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,),
            ],
          ),
        ):Container(),
      ],
    );
  }


  callDetailReportList(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: page.toString()
        );
        String apiUrl="";
        if(widget.come=="vendorName"){
          apiUrl= "${baseurl}${widget.apiurl}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Franchisee_ID=${widget.venderId}";
        }else
        if(widget.come=="expanseName"){
          apiUrl= "${baseurl}${widget.apiurl}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Expense_ID=${widget.expense}";
        }else{
          apiUrl= "${baseurl}${widget.apiurl}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Party_ID=${widget.partId}";
        }
     apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];

                  if(widget.come=="partyName"){
                    reportDetailList = data['Details'];
                    totalProfit = data['TotalProfit'].toString();
                    totalProfitShare = data['TotalProfitShare'].toString();
                    bankRAmount = data['TotalBankReceiptAmount'].toString();
                  }
                  else {
                    reportDetailList = data['Details'];
                    TotalAmount = data['TotalAmount'].toString();
                  }
                }else{
                  isApiCall=true;
                }
              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  franchisee   $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());

              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
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
              // widget.mListener.loaderShow(false);
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
  setDataToList(List<dynamic> _list) {
    if (reportDetailList.isNotEmpty) reportDetailList.clear();
    if (mounted) {
      setState(() {
        reportDetailList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        reportDetailList.addAll(_list);
      });
    }
  }
  pdfDownloadCall(String urlType) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) async{
        setState(() {
          isLoaderShow=false;
        });


        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl;

        if(widget.come=="vendorName"){
          apiUrl =baseurl + ApiConstants().getExpensePartywise+"/Download?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Franchisee_ID=${widget.venderId}&Type=$urlType";
        }else
        if(widget.come=="expanseName"){
          apiUrl =baseurl + ApiConstants().getExpenseExpensewise+"/Download?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Expense_ID=${widget.expense}&Type=$urlType";
        }else{
          apiUrl =baseurl + ApiConstants().getMISFranchiseeProfitDatewise+"/Download?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Party_ID=${widget.partId }&Type=$urlType";
        }
     print(apiUrl);
        // apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
        //     onSuccess:(data)async{
        //       setState(() {
        //         isLoaderShow=false;
        //         print("  dataaaaaaaa  ${data['data']} ");
        //         downloadFile(data['data'],data['fileName']);
        //       });
        //     }, onFailure: (error) {
        //       setState(() {
        //         isLoaderShow=false;
        //       });
        //       CommonWidget.errorDialog(context, error.toString());
        //     },
        //     onException: (e) {
        //       setState(() {
        //         isLoaderShow=false;
        //       });
        //       CommonWidget.errorDialog(context, e.toString());
        //
        //     },sessionExpire: (e) {
        //       setState(() {
        //         isLoaderShow=false;
        //       });
        //       CommonWidget.gotoLoginScreen(context);
        //       // widget.mListener.loaderShow(false);
        //     });

        String type="pdf";
        if(urlType=="XLS")
          type="xlsx";

        DownloadService downloadService = MobileDownloadService(apiUrl.toString(),type,context);
        await downloadService.download(url: apiUrl);

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
