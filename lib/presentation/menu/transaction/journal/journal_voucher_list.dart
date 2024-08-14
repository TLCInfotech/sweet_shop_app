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
import 'package:sweet_shop_app/presentation/menu/transaction/journal/create_journal_voucher.dart';
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
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';


class JournalVoucherActivity extends StatefulWidget {
  final String? comeFor;
  final  formId;
  final  arrData;
  final String logoImage;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  const JournalVoucherActivity({super.key, required mListener, this.comeFor, this.formId, this.arrData, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});
  @override
  State<JournalVoucherActivity> createState() => _PaymentActivityState();
}

class _PaymentActivityState extends State<JournalVoucherActivity>with CreateJournalInterface {

  DateTime newDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  bool viewWorkDVisible=true;
  bool isLoaderShow=false;
  bool isApiCall=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> payment_list=[];
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
    getJournals(page);
    setData();
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
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

  String companyId='';
  setData()async{
    companyId=await AppPreferences.getCompanyId();
    setState(() {

    });
  }
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getJournals(page);
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
    await getJournals(page);
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
                                    ApplicationLocalizations.of(context)!.translate("journal_voucher")!,
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
                        payment_list.isNotEmpty?getTotalCountAndAmount():Container(),
                        const SizedBox(
                          height: .5,
                        ),
                        get_payment_list_layout()
                      ],
                    ),
                  ),
                  Visibility(
                      visible: payment_list.isEmpty && isApiCall  ? true : false,
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
                backgroundColor: const Color(0xFFFBE404),
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black87,
                ),
                onPressed: ()async {
                  await  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateJournals(
                    mListener: this,
                    dateNew:newDate,   viewWorkDDate: widget.viewWorkDDate,
                    viewWorkDVisible: viewWorkDVisible,// CommonWidget.getDateLayout(newDate),
                    voucherNo: null,   logoImage: widget.logoImage,
                    companyId: companyId,//DateFormat('dd-MM-yyyy').format(newDate),
                  )));
                  selectedFranchiseeId="";
                  partyBlank=false;
                  payment_list=[];
                  await  getJournals(1);
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
            payment_list=[];
          });
          getJournals(1);
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
      apiUrl: ApiConstants().getLedgerWithoutBankCash+"?",
      titleIndicator: false,
      ledgerName: selectedFranchiseeName,
      readOnly: singleRecord['Update_Right']||singleRecord['Insert_Right'],
      title: ApplicationLocalizations.of(context)!.translate("ledger_without_bank_cash")!,
      callback: (name,id){
        setState(() {
          selectedFranchiseeName = name!;
          selectedFranchiseeId = id.toString()!;
          payment_list=[];
          getJournals(1);
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
              Text("${payment_list.length} ${ApplicationLocalizations.of(context)!.translate("journal")!}", style: subHeading_withBold,),
              // Text(CommonWidget.getCurrencyFormat(200000), style: subHeading_withBold,),
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
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: payment_list.length,
            itemBuilder: (BuildContext context, int index) {
              return  AnimationConfiguration.staggeredList(
                position: index,
                duration:
                const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    delay: const Duration(microseconds: 1500),
                    child: GestureDetector(
                      onTap: ()async{

                      await  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateJournals(
                          mListener: this,   logoImage: widget.logoImage,
                          dateNew: newDate,  //CommonWidget.getDateLayout(newDate),
                          voucherNo: payment_list[index]['Voucher_No'],
                          debitNote:payment_list[index] ,
                          companyId: companyId, viewWorkDDate: widget.viewWorkDDate,
                        viewWorkDVisible: viewWorkDVisible,
                          readOnly: singleRecord['Update_Right'],
                          come: "edit",//DateFormat('dd-MM-yyyy').format(newDate),
                        )));
                        selectedFranchiseeId="";
                        partyBlank=false;
                        payment_list=[];
                        await  getJournals(1);
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
                                                Text("${payment_list[index]['Ledger_Name']}",style: item_heading_textStyle,),
                                                const SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                                    const SizedBox(width: 10,),
                                                    Expanded(child: Text("Voucher No: - ${payment_list[index]['Voucher_No']}",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                                    const SizedBox(width: 10,),
                                                    Expanded(child: Text("${CommonWidget.getCurrencyFormat(payment_list[index]['Amount'])}",overflow: TextOverflow.clip,style: item_heading_textStyle,)),
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
                                    pdfDownloadCall(payment_list[index]['Voucher_No'].toString(),"PDF");
                                  }else if(value == "XLS"){
                                    // add desired output
                                    pdfDownloadCall(payment_list[index]['Voucher_No'].toString(),"XLS");
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
                       child:   singleRecord['Delete_Right']==true?      DeleteDialogLayout(
                            callback: (response ) async{
                              if(response=="yes"){
                                print("##############$response");
                                await   callDeleteExpense(payment_list[index]['Voucher_No'].toString(),payment_list[index]['Seq_No'].toString(),index);
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
              return const SizedBox(
                height: 5,
              );
            },
          ),
        ));
  }


  getJournals(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().getPaymentVouvher}?Company_ID=$companyId&Ledger_ID=$selectedFranchiseeId&Date=${DateFormat("yyyy-MM-dd").format(newDate)}&Voucher_Name=Journal&PageNumber=$page&${StringEn.pageSize}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                partyBlank=true;
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;
                  setState(() {
                    payment_list=_arrList;
                  });
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

  callDeleteExpense(String removeId,String seqNo,int index) async {
    String uid = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        var model= {
          "Voucher_No": removeId,
          "Voucher_Name": "Journal",
          "Seq_No":seqNo,
          "Modifier": uid,
          "Modifier_Machine": deviceId,
          "Date":DateFormat("yyyy-MM-dd").format(newDate)
        };
        String apiUrl = baseurl + ApiConstants().getPaymentVouvher+"?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(newDate)}";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model, "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                payment_list.removeAt(index);

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
  backToList(DateTime date) {
    // TODO: implement backToList
    setState(() {
      payment_list=[];
      newDate=date;
    });
    getJournals(1);
    Navigator.pop(context);
  }

  pdfDownloadCall(String orderNo,String urlType) async {
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
        String apiUrl =baseurl + ApiConstants().getJournalVouchers+"/Download?Company_ID=$companyId&Voucher_Name=Journal&Voucher_No=$orderNo&Type=$urlType";

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
