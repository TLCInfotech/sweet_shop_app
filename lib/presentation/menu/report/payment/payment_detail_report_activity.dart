import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
import 'dart:io';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';import 'package:sweet_shop_app/presentation/menu/transaction/debit_Note/craete_debit_note_activity.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/payment/create_payment_activity.dart';
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


class PaymentDetailReportActivity extends StatefulWidget {
  final apiurl;
  final venderId;
  final venderName;
  final ledgerId;
  final ledgerName;
  final fromDate;
  final toDate;
  final come;
  final String logoImage;
  const PaymentDetailReportActivity({super.key, this.apiurl, this.venderId, this.venderName, this.ledgerId, this.ledgerName, this.fromDate, this.toDate, this.come, required this.logoImage});

  @override
  State<PaymentDetailReportActivity> createState() => _PaymentDetailReportActivityState();
}

class _PaymentDetailReportActivityState extends State<PaymentDetailReportActivity> with CreatePaymentInterface{
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

      if(widget.come=="ledgerName"){
        franchiseeName.text=widget.ledgerName.toString();
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
                              child:widget.come=="ledgerName"? Text("Payment ${ApplicationLocalizations.of(context)!
                                  .translate("bank_cash_ledger")!}",
                                style: appbar_text_style,
                              ): Text("Payment ${ApplicationLocalizations.of(context)!
                                  .translate("ledger")!}",
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
                    height: SizeConfig.safeUsedHeight * .10,
                    child: getSaveAndFinishButtonLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth)):Container(),
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
      title:widget.come=="ledgerName"? ApplicationLocalizations.of(context)!.translate("bank_cash_ledger")!:
      ApplicationLocalizations.of(context)!.translate("ledger")!,
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
                        var singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == "AT001");


                        await   Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            CreatePayment(
                              dateNew: DateTime.parse(reportDetailList[index]['Date']),
                              voucherNo: reportDetailList[index]['Voucher_No'],//DateFormat('dd-MM-yyyy').format(newDate),
                              mListener:this,   logoImage: widget.logoImage,
                              readOnly:singleRecord['Update_Right'] ,
                              // editedItem:reportDetailList[index],
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
                                      Expanded(
                                        child: Padding(
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
                                                  Text("Voucher : "+
                                                      reportDetailList[index]['Voucher_No'].toString(),
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
                                                Text("  ${CommonWidget.getCurrencyFormat((reportDetailList[index]['Amount']*-1))}",overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color:Colors.red,
                                                      fontFamily: "Inter_Medium_Font"
                                                  ),)
                                                    :
                                                reportDetailList[index]['Amount']!=null?
                                                Text(" "+
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

  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
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
  String TotalAmount="0.00";


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
          apiUrl= "${baseurl}${widget.apiurl}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Vouchar_Type=Payment&Party_ID=${widget.venderId}";
        }else
        if(widget.come=="ledgerName"){
          apiUrl= "${baseurl}${widget.apiurl}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Vouchar_Type=Payment&Bank_ID=${widget.ledgerId}";
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
                  TotalAmount = data['TotalAmount'].toString();
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



  pdfDownloadCall(String urlType) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          //  isLoaderShow=true;
        });


        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl ="";
        if (widget.come=="ledgerName") {
          apiUrl =baseurl + ApiConstants().getAcctVoucherBankwise+"/Download?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Vouchar_Type=Payment&Bank_ID=${widget.ledgerId}&Type=$urlType";
        } else if (widget.come=="partyName") {
          apiUrl =baseurl + ApiConstants().getAcctVoucherPartywise+"/Download?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(applicablefrom)}&To_Date=${DateFormat("yyyy-MM-dd").format(applicableTwofrom)}&Vouchar_Type=Payment&Party_ID=${widget.venderId}&Type=$urlType";
        }

        print(apiUrl);
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data)async{

              setState(() {
                isLoaderShow=false;
                print("  dataaaaaaaa  ${data['data']} ");
                downloadFile(data['data'],data['fileName']);
              });
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            },
            onException: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
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
