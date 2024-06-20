import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/presentation/menu/report/Sale/sale_detail_report_screen.dart';

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
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../transaction/sell/sell_activity.dart';

class SaleReportTypeList extends StatefulWidget {
  final mListener;
  final reportName;
  final reportId;
  final vendorName;
  final vandorId;
  final itemName;
  final itemId;
  final applicablefrom;
  final applicableTwofrom;
  final url;

  const SaleReportTypeList(
      {super.key,
      this.reportName,
      this.reportId,
      this.vendorName,
      this.vandorId,
      this.itemName,
      this.itemId,
      this.applicablefrom,
      this.applicableTwofrom,
      this.url,
      this.mListener});

  @override
  State<SaleReportTypeList> createState() => _SaleReportTypeListState();
}

class _SaleReportTypeListState extends State<SaleReportTypeList> {
  DateTime applicablefrom =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTwofrom =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isLoaderShow = false;
  bool partyBlank = false;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  List<dynamic> array_list = [];
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController = ScrollController();
  bool isApiCall = false;

  String selectedFranchiseeName = "";
  String selectedFranchiseeId = "";

  String selectedItemName = "";
  String selectedItemId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ommmmmm${widget.reportId}");
    _scrollController.addListener(_scrollListener);

    selectedFranchiseeName = widget.vendorName;
    selectedFranchiseeId = widget.vandorId;
    selectedItemName = widget.itemName;
    selectedItemId = widget.itemId;

    applicablefrom = widget.applicablefrom;
    applicableTwofrom = widget.applicableTwofrom;
    getReportList(page);
    getLocal();
  }

  List MasterMenu = [];
  List TransactionMenu = [];
  var dataArr;

  getLocal() async {
    var tr = await (AppPreferences.getTransactionMenuList());
    dataArr = tr;
    setState(() {
      TransactionMenu = (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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
      page = 1;
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
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: Colors.transparent,
                // color: Colors.red,
                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                              widget.reportName,
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
                margin: const EdgeInsets.only(
                    top: 4, left: 15, right: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: (SizeConfig.halfscreenWidth),
                            child: getDateONELayout(SizeConfig.screenHeight,
                                SizeConfig.screenWidth)),
                        Container(
                            width: (SizeConfig.halfscreenWidth),
                            child: getDateTwoLayout(SizeConfig.screenHeight,
                                SizeConfig.screenWidth)),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    widget.reportId == "PTSM"
                        ? getFranchiseeNameLayout(
                            SizeConfig.screenHeight, SizeConfig.screenWidth)
                        : Container(),
                    widget.reportId == "ITSM"
                        ? getItemNameLayout(
                            SizeConfig.screenHeight, SizeConfig.screenWidth)
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    get_purchase_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: array_list.isEmpty && isApiCall ? true : false,
                  child: getNoData(
                      SizeConfig.screenHeight, SizeConfig.screenWidth)),
            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
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
        itemCount: array_list.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: -44.0,
              child: FadeInAnimation(
                delay: Duration(microseconds: 1500),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (widget.reportId == "PTSM") {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SaleDetailReportActivity(
                                        apiurl: ApiConstants().getSalePartywise,
                                        venderId: array_list[index]
                                            ['Vendor_ID'],
                                        venderName: array_list[index]
                                            ['Vendor_Name'],
                                        fromDate: applicablefrom,
                                        come: "partyName",
                                        toDate: applicableTwofrom,
                                      )));
                        } else if (widget.reportId == "ITSM") {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SaleDetailReportActivity(
                                        apiurl: ApiConstants().getSaleItemwise,
                                        itemId: array_list[index]['Item_ID'],
                                        itemName: array_list[index]
                                            ['Item_Name'],
                                        fromDate: applicablefrom,
                                        come: "itemName",
                                        toDate: applicableTwofrom,
                                      )));
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellActivity(
                                        mListener: this,
                                        dateNew: DateTime.parse(
                                            array_list[index]['Date']),
                                        formId: "ST003",
                                        arrData: dataArr,
                                      )));
                        }
                        array_list = [];
                        await getReportList(1);
                      },
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 10, left: 5, right: 10, bottom: 10),
                                padding: EdgeInsets.only(top: 10,right: 10,bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    array_list[index]['Date'] != null
                                        ? Expanded(
                                          child: Row(
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
                                                  CommonWidget.getDateLayout(
                                                      DateTime.parse(
                                                          array_list[index]
                                                              ['Date'])),
                                                  style: item_heading_textStyle,
                                                ),
                                              ],
                                            ),
                                        )
                                        : Container(),
                                    array_list[index]['Item_Name'] == null
                                        ? Container()
                                        : Expanded(
                                          child: Text(
                                              array_list[index]['Item_Name'],
                                          
                                              style: item_heading_textStyle,
                                            ),
                                        ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    array_list[index]['Vendor_Name'] == null
                                        ? Container()
                                        : Expanded(
                                          child: Text(
                                              array_list[index]['Vendor_Name'],
                                              style: item_heading_textStyle,
                                            ),
                                        ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(left: 5),
                                      child: array_list[index]['Amount'] < 0
                                          ? Text(
                                              "INR " +
                                                  CommonWidget
                                                      .getCurrencyFormat(
                                                          array_list[index]
                                                                  ['Amount'] *
                                                              -1),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.red,
                                                  fontFamily:
                                                      "Inter_Medium_Font"),
                                            )
                                          : Text(
                                              "INR "
                                                  +
                                                  CommonWidget
                                                      .getCurrencyFormat(
                                                          array_list[index]
                                                              ['Amount'])
                                        ,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.green,
                                                  fontFamily:
                                                      "Inter_Medium_Font"),
                                            ),
                                      //   Expanded(child: Text(CommonWidget.getCurrencyFormat("Share: ${400096543}"),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
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
                    )
                  ],
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

  /*widget for no data d*/
  Widget getNoData(double parentHeight, double parentWidth) {
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
        title: ApplicationLocalizations.of(context)!.translate("from_date")!,
        callback: (date) {
          setState(() {
            applicablefrom = date!;
          });
          getReportList(page);
        },
        applicablefrom: applicablefrom);
  }

  /* Widget for date two layout */
  Widget getDateTwoLayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title: ApplicationLocalizations.of(context)!.translate("to_date")!,
        callback: (date) {
          setState(() {
            applicableTwofrom = date!;
          });
          getReportList(page);
        },
        applicablefrom: applicableTwofrom);
  }

  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return SearchableLedgerDropdown(
      apiUrl: "${ApiConstants().franchisee}?",
      titleIndicator: false,
      ledgerName: selectedFranchiseeName,
      franchiseeName: widget.vendorName,
      franchisee: "edit",
      readOnly: true,
      title:
          ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
      callback: (name, id) {
        setState(() {
          selectedFranchiseeName = name!;
          selectedFranchiseeId = id.toString()!;
          array_list = [];
          getReportList(1);
        });
        print("############3");
        print(selectedFranchiseeId + "\n" + selectedFranchiseeName);
      },
    );
  }

  Widget getItemNameLayout(double parentHeight, double parentWidth) {
    return SearchableLedgerDropdown(
      apiUrl:
          "${ApiConstants().item_list}?Date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}&",
      titleIndicator: false,
      ledgerName: widget.itemName,
      franchisee: "edit",
      franchiseeName: widget.itemName,
      readOnly: true,
      title: ApplicationLocalizations.of(context)!.translate("item")!,
      callback: (name, id) {
        setState(() {
          selectedItemName = name!;
          selectedItemId = id.toString()!;
        });
        array_list = [];
        getReportList(1);
      },
    );
  }

  getReportList(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
            TokenRequestModel(token: sessionToken, page: page.toString());
        String apiUrl = "";

        if (selectedFranchiseeId != "") {
          apiUrl =
              "${baseurl}${widget.url}?Company_ID=$companyId&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Vendor_ID=$selectedFranchiseeId";
        } else if (selectedItemId != "") {
          apiUrl =
              "${baseurl}${widget.url}?Company_ID=$companyId&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Item_ID=$selectedItemId";
        } else {
          apiUrl =
              "${baseurl}${widget.url}?Company_ID=$companyId&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}";
        }
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess: (data) {
          setState(() {
            isLoaderShow = false;

            if (data != null) {
              List<dynamic> _arrList = [];
              array_list = data;
              partyBlank = true;
            } else {
              isApiCall = true;
            }
          });
          print("  LedgerLedger  $data ");
        }, onFailure: (error) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.errorDialog(context, error.toString());
        }, onException: (e) {
          print("Here2=> $e");
          setState(() {
            isLoaderShow = false;
          });
          var val = CommonWidget.errorDialog(context, e);
          print("YES");
          if (val == "yes") {
            print("Retry");
          }
        }, sessionExpire: (e) {
          setState(() {
            isLoaderShow = false;
          });
          CommonWidget.gotoLoginScreen(context);
        });
      });
    } else {
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
      array_list = [];
    });
    getReportList(1);
    Navigator.pop(context);
  }
}
