import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/downloadservice.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';
import 'craete_credit_note_activity.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';


class CreditNoteActivity extends StatefulWidget {
  final String? comeFor;
  final dateNew;
  final franhiseeID;
  final  formId;
  final  arrData;
  final franchiseeName;
  final String logoImage;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  const CreditNoteActivity({super.key, required mListener,  this.comeFor, this.dateNew,  this.franhiseeID, this.formId, this.arrData, this.franchiseeName, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});

  @override
  State<CreditNoteActivity> createState() => _CreditNoteState();
}

class _CreditNoteState extends State<CreditNoteActivity>with CreateCreditNoteInterface {
  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  bool viewWorkDVisible=true;
  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> debitNote_list=[];
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  bool isApiCall=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.viewWorkDVisible!=null){
      viewWorkDVisible=widget.viewWorkDVisible;
    }
    _scrollController.addListener(_scrollListener);
    if(widget.dateNew!=null){
      setState(() {
        invoiceDate=widget.dateNew!;
      });
    }
    if(widget.franhiseeID!=null){
      setState(() {
        selectedFranchiseeId=widget.franhiseeID.toString();
        selectedFranchiseeName=widget.franchiseeName;
      });
    }
    getCreditNote(page);
    setData();
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
  }
  String companyId='';
  setData()async{
    companyId=await AppPreferences.getCompanyId();
  }

  double minX = 30;
  double minY = 30;
  double maxX = SizeConfig.screenWidth*0.78;
  double maxY = SizeConfig.screenHeight*0.9;

  Offset position = Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);

  void _updateOffset(Offset newOffset) {
    setState(() {
      // Clamp the Offset values to stay within the defined constraints
      double clampedX = newOffset.dx.clamp(minX, maxX);
      double clampedY = newOffset.dy.clamp(minY, maxY);
      position = Offset(clampedX, clampedY);
    });
  }

  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getCreditNote(page);
      }
    }
  }
  setDataToList(List<dynamic> _list) {
    if (debitNote_list.isNotEmpty) debitNote_list.clear();
    if (mounted) {
      setState(() {
        debitNote_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        debitNote_list.addAll(_list);
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
    await getCreditNote(page);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              backgroundColor: Color(0xFFfffff5),
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
                    margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                    child: AppBar(
                      leadingWidth: 0,
                      automaticallyImplyLeading: false,
                      leading: Container(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      ),
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
                                  ApplicationLocalizations.of(context)!.translate("credit_note_voucher")!,
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
                          height: 2,
                        ),
                        getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                        const SizedBox(
                          height: 10,
                        ),
                        debitNote_list.isNotEmpty? getTotalCountAndAmount():
                        Container(),
                        const SizedBox(
                          height: .5,
                        ),
                        get_purchase_list_layout()
                      ],
                    ),
                  ),
                  Visibility(
                      visible: debitNote_list.isEmpty && isApiCall  ? true : false,
                      child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
                ],
              ),
            ),
            Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
          ],
        ),
        viewWorkDVisible==false?Container():
        singleRecord['Insert_Right']==true? Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              // setState(() {
              //   position = Offset(position.dx + details.delta.dx, position.dy + details.delta.dy);
              // });
              _updateOffset(position + details.delta);

            },
            child: FloatingActionButton(
                backgroundColor: Color(0xFFFBE404),
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black87,
                ),
                onPressed: () async{
                  await  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      CreateCreditNote(
                        dateNew:   invoiceDate,
                        Invoice_No: null,   logoImage: widget.logoImage,
                        companyId:companyId,//DateFormat('dd-MM-yyyy').format(newDate),
                        mListener:this, viewWorkDDate: widget.viewWorkDDate,
                        viewWorkDVisible: viewWorkDVisible,
                      )));
                  selectedFranchiseeId="";
                  partyBlank=false;
                  debitNote_list=[];
                  await  getCreditNote(1);
                }),
          ),
        ):Container(),
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

  Widget getTotalCountAndAmount() {
    return Container(
      margin: EdgeInsets.only(left: 8,right: 8,bottom: 8),
      child: Container(
          height: 40,
          // width: SizeConfig.halfscreenWidth,
          width: SizeConfig.screenWidth*0.9,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              // border: Border.all(color: Colors.grey.withOpacity(0.5))
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),]

          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${debitNote_list.length} ${ApplicationLocalizations.of(context)!.translate("invoices")!} ", style: subHeading_withBold,),
              Text(CommonWidget.getCurrencyFormat(double.parse(TotalAmount)), style: subHeading_withBold,),
            ],
          )
      ),
    );
  }
  String TotalAmount="0.00";
  calculateTotalAmt()async{
    var total=0.00;
    for(var item  in debitNote_list ){
      total=total+item['Total_Amount'];
      print(item['Total_Amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 5, bottom: 5,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }


  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            debitNote_list.clear();
            if (date!.isAfter(widget.viewWorkDDate)) {
              viewWorkDVisible=true;
              print("previousDateTitle  ");
            } else {
              viewWorkDVisible=false;
              print("previousDateTitle   ");
            }
          });
          setState(() {
            invoiceDate=date!;
          });
          getCreditNote(1);
        },
        applicablefrom: invoiceDate
    );
  }

  String selectedFranchiseeName="";
  String selectedFranchiseeId="";
  bool partyBlank=true;
  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return partyBlank==false?Container():SearchableLedgerDropdown(
      apiUrl: ApiConstants().ledgerWithoutImage+"?",
      titleIndicator: false,
      ledgerName: selectedFranchiseeName,
      franchisee: "edit",
      franchiseeName: selectedFranchiseeName,
      readOnly: singleRecord['Update_Right']||singleRecord['Insert_Right'],
      title: ApplicationLocalizations.of(context)!.translate("party")!,
      callback: (name,id){
        setState(() {
          selectedFranchiseeName = name!;
          selectedFranchiseeId = id.toString()!;
          debitNote_list=[];
          getCreditNote(1);
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
            itemCount: debitNote_list.length,
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
                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            CreateCreditNote(
                              dateNew: invoiceDate,
                              Invoice_No: debitNote_list[index]['Invoice_No'],
                                debitNote:debitNote_list[index],//DateFormat('dd-MM-yyyy').format(newDate),
                              mListener:this,   logoImage: widget.logoImage,
                                companyId:companyId, viewWorkDDate: widget.viewWorkDDate,
                                viewWorkDVisible: viewWorkDVisible,
                              readOnly:  singleRecord['Update_Right'],
                              come:"edit"
                            )));
                        selectedFranchiseeId="";
                        partyBlank=false;
                        debitNote_list=[];
                        await  getCreditNote(1);
                      },
                      child: Stack(
                        children: [
                          Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      padding: EdgeInsets.all(10),
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${debitNote_list[index]['Vendor_Name']}",style: item_heading_textStyle,),
                                                SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                                    SizedBox(width: 10,),
                                                    Expanded(child: Text("Invoice No:- ${debitNote_list[index]['Fin_Invoice_No']}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                                  ],
                                                ), SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                                    SizedBox(width: 10,),
                                                    Expanded(child: Text(CommonWidget.getCurrencyFormat(debitNote_list[index]['Total_Amount']),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 10,
                                          color: Colors.transparent,
                                        ),
                                     ],
                                    )

                                )
                              ],
                            ),
                          ),
                          Positioned(
                              top: 10,
                              right: 20,
                              child:    PopupMenuButton(
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
                                    pdfDownloadCall(debitNote_list[index]['Invoice_No'].toString(),"PDF");
                                  }else if(value == "XLS"){
                                    // add desired output
                                    pdfDownloadCall(debitNote_list[index]['Invoice_No'].toString(),"XLS");
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
                          ),
                          viewWorkDVisible==false?Container():
                Positioned(
                  bottom: 5,
                  right: 5,
                child:      singleRecord['Delete_Right']==true?  DeleteDialogLayout(
                  callback: (response ) async{
                    if(response=="yes"){
                      print("##############$response");
                      await   deleteCreditNote(debitNote_list[index]['Invoice_No'].toString(),debitNote_list[index]['Seq_No'].toString(),index);
                    }
                  },
                ):Container()

                )
                        ],
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


  getCreditNote(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
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

          apiUrl = "${baseurl}${ApiConstants().voucherCreditNoteHeader}?Company_ID=$companyId&${StringEn.lang}=$lang&Franchisee_ID=$selectedFranchiseeId&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&PageNumber=$page&${StringEn.pageSize}";

        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){

              setState(() {
                partyBlank=true;
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList.clear();
                  _arrList=data;
                  if (_arrList.length < 50) {
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

                  calculateTotalAmt();
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

  deleteCreditNote(String removeId,String seqNo,int index) async {
    String uid = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        var model= {
          "Invoice_No": removeId,
          "Modifier": uid,
          "Modifier_Machine": deviceId
        };
        String apiUrl = baseurl + ApiConstants().getVoucherNote+"?Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model, "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                debitNote_list.removeAt(index);
              });
              if(debitNote_list.length==0){
                setState(() {
                  TotalAmount="0.00";
                });
              }
              calculateTotalAmt();
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
            }, onException: (e) {
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
      });
    }else{
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
      debitNote_list.clear();
      invoiceDate=updateDate;
    });
    getCreditNote(1);
    Navigator.pop(context);
  }

  pdfDownloadCall(String orderNo,String urlType) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) async{
        setState(() {
          isLoaderShow=false;
        });

    TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl =baseurl + ApiConstants().getVoucherNoteHeaderDetails+"/Download?Company_ID=$companyId&${StringEn.lang}=$lang&Invoice_No=$orderNo&Type=$urlType";

        print(apiUrl);
        // apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
        //     onSuccess:(data)async{
        //
        //       setState(() {
        //         isLoaderShow=false;
        //         print("  dataaaaaaaa  ${data['data']} ");
        //          downloadFile(data['data'],data['fileName']);
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
