import 'dart:convert';

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
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../common_widget/singleLine_TextformField_without_double.dart';
import '../../transaction/sell/create_sell_activity.dart';
import '../../transaction/sell/sell_activity.dart';
class SaleDetailReportActivity extends StatefulWidget {

  final apiurl;
  final venderId;
  final venderName;
  final itemId;
  final itemName;
  final fromDate;
  final toDate;
  final come;
  const SaleDetailReportActivity({super.key, this.apiurl, this.venderId, this.venderName, this.itemId, this.itemName, this.fromDate, this.toDate, this.come});

  @override
  State<SaleDetailReportActivity> createState() => _SaleDetailReportActivityState();
}

class _SaleDetailReportActivityState extends State<SaleDetailReportActivity> with CreateSellInvoiceInterface{
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

  setVal()async{
    var tr =await (AppPreferences.getTransactionMenuList());
    dataArr=tr;
    setState(() {
      TransactionMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });
    setState(() {
      print("hbjfbhfbbf ${widget.come} ${widget.venderId}");

      if(widget.come=="itemName"){
        franchiseeName.text=widget.itemName.toString();
      }else if(widget.come=="partyName"){
        franchiseeName.text=widget.venderName.toString();
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
                          Expanded(
                            child: Center(
                              child: widget.come=="itemName"? Text(
                                ApplicationLocalizations.of(context)!
                                    .translate("item")!,
                                style: appbar_text_style,
                              ): Text(
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
      title:widget.come=="itemName"? ApplicationLocalizations.of(context)!.translate("item")!:
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
                        // await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        //     SellActivity(
                        //       mListener: this,
                        //       dateNew:DateTime.parse(reportDetailList[index]['Date']),
                        //       formId: "ST003",
                        //       arrData: dataArr,
                        //     )));
                        List<dynamic> jsonArray = jsonDecode(dataArr);
                        var singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == "ST003");
                        print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");

                        await   Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            CreateSellInvoice(
                              dateNew: DateTime.parse(reportDetailList[index]['Date']),
                              Invoice_No: reportDetailList[index]['Invoice_No'],//DateFormat('dd-MM-yyyy').format(newDate),
                              mListener:this,
                              readOnly:singleRecord['Update_Right'] ,
                              editedItem:reportDetailList[index],
                              come:"edit",
                            )));

                      },
                      child: Card(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                               Expanded(
                                 child: Container(
                                  margin:  EdgeInsets.only(top: 10,left: 5,right: 0 ,bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: SizeConfig.screenWidth*.1,
                                          height:SizeConfig.screenHeight*.05,
                                          margin: EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.purple.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                          alignment: Alignment.center,
                                          child: Text("${index+1}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontSize: 14),)
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.all(8.0),
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                 Text(
                                                  CommonWidget.getDateLayout(DateTime.parse(reportDetailList[index]['Date'])),
                                                  style: item_heading_textStyle,
                                                ),
                                                Text("Invoice : "+
                                                    reportDetailList[index]['Invoice_No'].toString(),
                                                  style: item_regular_textStyle,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              
                                              alignment: Alignment.centerRight,
                                              child: reportDetailList[index]['Amount']!=null&& reportDetailList[index]['Amount']<0?
                                              Text("INR  ${CommonWidget.getCurrencyFormat((reportDetailList[index]['Amount']*-1))}",overflow: TextOverflow.clip,
                                               textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color:Colors.red,
                                                    fontFamily: "Inter_Medium_Font"
                                                ),)
                                                  :
                                              reportDetailList[index]['Amount']!=null?
                                              Text("INR "+
                                                  "${CommonWidget.getCurrencyFormat(reportDetailList[index]['Amount'])}",
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color:Colors.green,
                                                    fontFamily: "Inter_Medium_Font"
                                                ),):Container(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                                               ),
                               ),
                            ],
                          ),
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
        getFranchiseeNameLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),

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
        String apiUrl="";
        if(widget.come=="partyName"){
          apiUrl= "${baseurl}${widget.apiurl}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Franchisee_ID=${widget.venderId}";
        }else
        if(widget.come=="itemName"){
          apiUrl= "${baseurl}${widget.apiurl}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Item_ID=${widget.itemId}";
        }
        // else{
        //   apiUrl= "${baseurl}${widget.apiurl}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Party_ID=${widget.partId}";
        // }
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  reportDetailList=data['Details'];
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

  @override
  backToList(DateTime updateDate) {
    // TODO: implement backToList
    setState(() {
      reportDetailList.clear();

    });
    callDetailReportList(1);
    Navigator.pop(context);
  }
}
