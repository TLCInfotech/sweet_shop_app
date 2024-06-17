import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/common_style.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../common_widget/singleLine_TextformField_without_double.dart';


class DetailReportActivity extends StatefulWidget {
  final apiurl;
  final fromDate;
  final toDate;
  final  party;
  final  partId;

  const DetailReportActivity(
      {super.key, this.apiurl, this.fromDate, this.toDate, this.party, this.partId,});

  @override
  State<DetailReportActivity> createState() => _DetailReportActivityState();
}

class _DetailReportActivityState extends State<DetailReportActivity> {
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

  setVal()async{
    setState(() {
      franchiseeName.text=widget.party.toString();
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
                          Expanded(
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!
                                    .translate("franchisee")!,
                                style: appbar_text_style,
                              ),
                            ),
                          ),
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
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
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
                Visibility(
                    visible:
                        reportDetailList.isEmpty && isApiCall ? true : false,
                    child: CommonWidget.getNoData(
                        SizeConfig.screenHeight, SizeConfig.screenWidth)),
              ],
            )),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
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
        // itemCount: reportDetailList.length,
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
                  onTap: () async {},
                  child: Card(
                    child: Container(
                      color: index %2==0? Colors.orange.withOpacity(0.1): Colors.green.withOpacity(0.1),
                      // color: index %2==0? (Color(0xFFFFC300)).withOpacity(0.3): Colors.orange.withOpacity(0.3),

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
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.calendar,
                                        color: Colors.black87,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        CommonWidget.getDateLayout(DateTime.parse(reportDetailList[index]['Date'])),
                                        style: item_heading_textStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //  FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),

                                      Expanded(child: Text("Online Amount: "+CommonWidget.getCurrencyFormat(reportDetailList[index]['Bank_Receipt_Amount']),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //  FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                      Expanded(child: Text("Share: "+CommonWidget.getCurrencyFormat(reportDetailList[index]['Profit_Share']),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: SizeConfig.halfscreenWidth-20,
                                        child:
                                        Text(CommonWidget.getCurrencyFormat(reportDetailList[index]['Profit']),
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
                                    await   callDeleteSaleInvoice(saleInvoice_list[index]['Invoice_No'].toString(),saleInvoice_list[index]['Seq_No'].toString(),index);
                                  }
                                },
                              )*/
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
        getFranchiseeNameLayout(
            SizeConfig.screenHeight, SizeConfig.screenWidth),
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
        String apiUrl = "${baseurl}${ApiConstants().getMISFranchiseeProfitDatewise}?Company_ID=$companyId&Party_ID=3113&From_Date=${DateFormat("yyyy-MM-dd").format(DateTime.parse(applicablefrom.toString()))}&To_Date=${DateFormat("yyyy-MM-dd").format(DateTime.parse(applicableTwofrom.toString()))}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;
                  if (_arrList.length < 10) {
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
}
