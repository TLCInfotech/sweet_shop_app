import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/menu/report/debit_note/debit_note_detail_report_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/debit_Note/debit_note_activity.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/common_style.dart';
import '../../../../core/downloadservice.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
class DebitNoteReportTypeList extends StatefulWidget {
  final mListener;
  final String logoImage;
  final reportName;
  final reportId;
  final vendorName;
  final vandorId;
  final itemName;
  final itemId;
  final applicablefrom;
  final applicableTwofrom;
  final url;
  final  viewWorkDDate;
  final  viewWorkDVisible;

  const DebitNoteReportTypeList(
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
      this.mListener, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});

  @override
  State<DebitNoteReportTypeList> createState() => _DebitNoteReportTypeListState();
}

class _DebitNoteReportTypeListState extends State<DebitNoteReportTypeList> {
  DateTime applicablefrom =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTwofrom =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  bool viewWorkDVisible=true;
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
                              "Debit Note ${widget.reportName}",
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
            children: [
              Expanded(
                child: Stack(
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
                        visible: array_list.isEmpty && isApiCall  ? true : false,
                        child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

                  ],
                ),
              ),
              TotalAmount!="0.00"?Container(
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
                      SizeConfig.screenHeight, SizeConfig.screenWidth)):Container(),
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
                                      DebitNoteDetailReportActivity(
                                        apiurl: ApiConstants().voucherPartywise,
                                        venderId: array_list[index]
                                            ['Vendor_ID'],
                                        logoImage: widget.logoImage, viewWorkDDate: widget.viewWorkDDate,
                                        viewWorkDVisible: viewWorkDVisible,
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
                                      DebitNoteDetailReportActivity(
                                        apiurl: ApiConstants().voucherItemwise,
                                        itemId: array_list[index]['Item_ID'],
                                        itemName: array_list[index]
                                            ['Item_Name'],
                                        logoImage: widget.logoImage,
                                        viewWorkDDate: widget.viewWorkDDate,
                                        viewWorkDVisible: viewWorkDVisible,
                                        fromDate: applicablefrom,
                                        come: "itemName",
                                        toDate: applicableTwofrom,
                                      )));
                        } else {
                          setState(() {
                            if (DateTime.parse(array_list[index]['Date']).isAfter(widget.viewWorkDDate)) {
                              viewWorkDVisible=true;
                            } else {
                              viewWorkDVisible=false;
                            }
                          });
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DebitNoteActivity(
                                        mListener: this,
                                    viewWorkDDate: widget.viewWorkDDate,
                                    viewWorkDVisible: viewWorkDVisible,
                                        dateNew: DateTime.parse(
                                            array_list[index]['Date']),
                                        formId: "AT005",
                                        come: "report",
                                    logoImage: widget.logoImage,
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
                                              " " +
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
                                              " "
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
           ApplicationLocalizations.of(context).translate("no_data"),
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

  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
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
  String TotalAmount="0.00";

  getReportList(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    String lang = await AppPreferences.getLang();
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
              "${baseurl}${ApiConstants().reports}?Company_ID=$companyId&${StringEn.lang}=$lang&Form_Name=Debit Note&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&ID=$selectedFranchiseeId";
        } else if (selectedItemId != "") {
          apiUrl =
              "${baseurl}${ApiConstants().reports}?Company_ID=$companyId&${StringEn.lang}=$lang&Form_Name=Debit Note&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&ID=$selectedItemId";
        } else {
          apiUrl =
              "${baseurl}${ApiConstants().reports}?Company_ID=$companyId&${StringEn.lang}=$lang&Form_Name=Debit Note&Report_ID=${widget.reportId}&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}";
        }
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess: (data) {
          setState(() {
            isLoaderShow = false;

            if (data != null) {
              List<dynamic> _arrList = [];
              array_list = data['Details'];
              TotalAmount = data['TotalAmount'].toString();
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


  pdfDownloadCall(String urlType) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId)async {
        setState(() {
          //  isLoaderShow=true;
        });


        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl="";
        if (selectedFranchiseeId != "") {
          apiUrl =baseurl + ApiConstants().getVoucherReports+"/Download?Company_ID=$companyId&${StringEn.lang}=$lang&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Report_ID=${widget.reportId}&Form_Name=Debit Note&ID=$selectedItemId&ID=$selectedFranchiseeId&Type=$urlType";
        } else if (selectedItemId != "") {
          apiUrl =baseurl + ApiConstants().getVoucherReports+"/Download?Company_ID=$companyId&${StringEn.lang}=$lang&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Report_ID=${widget.reportId}&Form_Name=Debit Note&ID=$selectedItemId&Type=$urlType";
        } else {
          apiUrl =baseurl + ApiConstants().getVoucherReports+"/Download?Company_ID=$companyId&${StringEn.lang}=$lang&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Report_ID=${widget.reportId}&Form_Name=Debit Note&Type=$urlType";
        }
        print(apiUrl);
        // apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
        //     onSuccess:(data)async{
        //
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
