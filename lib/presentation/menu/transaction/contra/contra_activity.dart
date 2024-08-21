import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
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
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';
import 'create_contra_activity.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';


class ContraActivity extends StatefulWidget {
  final String? comeFor;
  final  formId;
  final  arrData;
  final String logoImage;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  const ContraActivity({super.key, required mListener, this.comeFor, this.formId, this.arrData, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});
  @override
  State<ContraActivity> createState() => _ContraActivityState();
}

class _ContraActivityState extends State<ContraActivity>with CreateContraInterface {

  DateTime newDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  bool viewWorkDVisible=true;
  bool isLoaderShow=false;
  bool isApiCall=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> contraList=[];
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.viewWorkDVisible!=null){
      viewWorkDVisible=widget.viewWorkDVisible;
    }
    _scrollController.addListener(_scrollListener);
    getContra(page);
    setData();
    setVal();
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
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getContra(page);
      }
    }
  }
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await getContra(page);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
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
                                    ApplicationLocalizations.of(context)!.translate("contra")!,
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
                        getPurchaseDateLayout(),
                        const SizedBox(
                          height: 2,
                        ),
                        getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                        const SizedBox(
                          height: 10,
                        ),
                      contraList.isNotEmpty?getTotalCountAndAmount():
                        Container(),
                        const SizedBox(
                          height: .5,
                        ),
                        get_payment_list_layout()
                      ],
                    ),
                  ),
                  Visibility(
                      visible: contraList.isEmpty && isApiCall  ? true : false,
                      child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),],
              ),
            ),
            Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
          ],
        ),
        viewWorkDVisible==false?Container():
        singleRecord['Insert_Right']==true?Positioned(
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
                backgroundColor: const Color(0xFFFBE404),
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black87,
                ),
                onPressed: () async{
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateContra(
                    mListener: this,
                    newDate: newDate,   logoImage: widget.logoImage,
                    readOnly: true,
                    viewWorkDDate: widget.viewWorkDDate,
                    viewWorkDVisible: viewWorkDVisible,
                    voucherNo: null,
                    dateNew:newDate,
                    companyId: companyId,//DateFormat('dd-MM-yyyy').format(newDate),
                  )));
                  selectedFranchiseeId="";
                  partyBlank=false;
                  contraList=[];
                  await  getContra(1);
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

  /* Widget to get add purchase date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            if (date!.isAfter(widget.viewWorkDDate)) {
              viewWorkDVisible=true;
              print("previousDateTitle  ");
            } else {
              viewWorkDVisible=false;
              print("previousDateTitle   ");
            }
            newDate=date!;
            contraList=[];
          });
          getContra(1);
        },
        applicablefrom: newDate
    );
  }
  String selectedFranchiseeName="";
  String selectedFranchiseeId="";
  bool partyBlank=true;
  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return partyBlank==false?Container():SearchableLedgerDropdown(
      apiUrl: ApiConstants().getBankCashLedger+"?",
      titleIndicator: false,
      ledgerName: selectedFranchiseeName,
      readOnly: singleRecord['Update_Right']||singleRecord['Insert_Right'],
      title: ApplicationLocalizations.of(context)!.translate("bank_cash_ledger")!,
      callback: (name,id){
        setState(() {
          selectedFranchiseeName = name!;
          selectedFranchiseeId = id.toString()!;
          contraList=[];
          getContra(1);
        });

        print("############3");
        print(selectedFranchiseeId+"\n"+selectedFranchiseeName);
      },

    );

  }
  /* Widget to get total count and amount Layout */
  Widget getTotalCountAndAmount() {
    return Container(
      margin: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
      child: Container(
          height: 40,
          width: SizeConfig.screenWidth*0.9,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              // border: Border.all(color: Colors.grey.withOpacity(0.5))
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
               Text("${contraList.length} ${ApplicationLocalizations.of(context)!.translate("invoices")!}", style: subHeading_withBold,),
              Text(CommonWidget.getCurrencyFormat(double.parse(TotalAmount)), style: subHeading_withBold,),
            ],
          )
      ),
    );
  }


  /* widget for title layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 5, bottom: 5,),
      child: Text(
        title,
        style: page_heading_textStyle,
      ),
    );
  }

  /* Widget to get add payment list Layout */
  Expanded get_payment_list_layout() {
    return Expanded(
        child:  RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            itemCount: contraList.length,
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: const Duration(microseconds: 1500),
                    child:GestureDetector(
                      onTap: ()async{
                       await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateContra(
                          mListener: this,
                          newDate: newDate,   logoImage: widget.logoImage,
                          voucherNo: contraList[index]["Voucher_No"],
                          dateNew:newDate,
                          companyId: companyId,
                         viewWorkDDate: widget.viewWorkDDate,
                         viewWorkDVisible: viewWorkDVisible,
                          come: "edit",
                          readOnly: singleRecord['Update_Right'],
                          debitNote:contraList[index] ,// DateFormat('dd-MM-yyyy').format(newDate),
                        )));
                        selectedFranchiseeId="";
                        partyBlank=false;
                        contraList=[];
                        await  getContra(1);
                      },
                      child: Stack(
                        children: [
                          Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: (index)%2==0?Colors.green:Colors.blueAccent,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child:  const FaIcon(
                                        FontAwesomeIcons.moneyCheck,
                                        color: Colors.white,
                                      )
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
                                                 Text(contraList[index]["Ledger_Name"],style: item_heading_textStyle,),
                                                const SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                                    const SizedBox(width: 10,),
                                                     Expanded(child: Text("Voucher No: - ${contraList[index]["Voucher_No"]}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                                    const SizedBox(width: 10,),
                                                    Expanded(child: Text("${CommonWidget.getCurrencyFormat(contraList[index]["Amount"])}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
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
                                ),
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
                                    pdfDownloadCall(contraList[index]['Voucher_No'].toString(),"PDF");
                                  }else if(value == "XLS"){
                                    // add desired output
                                    pdfDownloadCall(contraList[index]['Voucher_No'].toString(),"XLS");
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
                          viewWorkDVisible==false?Container(): Positioned(
                  bottom: 5,
                  right: 5,
                   child: singleRecord['Delete_Right']==true?
                    DeleteDialogLayout(
                      callback: (response ) async{
                        if(response=="yes"){
                          print("##############$response");
                          await   callDeleteContra(contraList[index]['Voucher_No'].toString(),index);
                        }
                      },
                    )
                        :Container()
                )
                        ],
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


  String TotalAmount="0.00";
  calculateTotalAmt()async{
    var total=0.00;
    for(var item  in contraList ){
      total=total+item['Amount'];
      print(item['Amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }

  getContra(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String lang = await AppPreferences.getLang();
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
        String apiUrl = "${baseurl}${ApiConstants().getPaymentVouvher}?Company_ID=$companyId&${StringEn.lang}=$lang&Ledger_ID=$selectedFranchiseeId&Date=${DateFormat("yyyy-MM-dd").format(newDate)}&Voucher_Name=Contra&PageNumber=$page&${StringEn.pageSize}";
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
                }else{
                  isApiCall=true;
                }
                calculateTotalAmt();
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

  setDataToList(List<dynamic> _list) {
    if (contraList.isNotEmpty) contraList.clear();
    if (mounted) {
      setState(() {
        contraList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        contraList.addAll(_list);
      });
    }
  }

  callDeleteContra(String removeId,int index) async {
    String uid = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String lang = await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        var model= {
          "Voucher_No": removeId,
          "Voucher_Name": "Contra",
          "Modifier": uid,
          "Modifier_Machine": deviceId,
          "Date":DateFormat("yyyy-MM-dd").format(newDate)
        };
        String apiUrl = baseurl + ApiConstants().getPaymentVouvher+"?Company_ID=$companyId&${StringEn.lang}=$lang&Date=${DateFormat("yyyy-MM-dd").format(newDate)}";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model, "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                contraList.removeAt(index);
                calculateTotalAmt();
              });
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
      contraList=[];
      newDate=updateDate;
    });
    getContra(1);
    Navigator.pop(context);
  }

  pdfDownloadCall(String orderNo,String urlType) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId)async {
        setState(() {
          isLoaderShow=false;
        });

        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl =baseurl + ApiConstants().getPaymentVoucherDetail+"/Download?Company_ID=$companyId&${StringEn.lang}=$lang&Voucher_Name=Contra&Voucher_No=$orderNo&Type=$urlType";

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
