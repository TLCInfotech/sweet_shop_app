import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/ledger_opening_bal/item_opening_bal_request_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';
import 'add_or_edit_ledger_opening_bal.dart';
import 'create_ledger_opening_bal_activity.dart';

class LedgerOpeningBal extends StatefulWidget {
  final  formId;
  final  arrData;
  const LedgerOpeningBal({super.key, this.formId, this.arrData});

  @override
  State<LedgerOpeningBal> createState() => _ItemOpeningBalState();
}

class _ItemOpeningBalState extends State<LedgerOpeningBal> with AddOrEditItemOpeningBalInterface, CreateItemOpeningBalInterface{
  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isApiCall = false;
  bool isLoaderShow = false;
  var editedItem=null;

  int page = 1;
  bool isPagination = true;
  ScrollController _scrollController = new ScrollController();
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetLedgerOB(page);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    callGetLedgerOB(page);
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
    setState(() {

    });
  }
  List<dynamic> ledgerList = [];
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await callGetLedgerOB(page);
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
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
               child: AppBar(
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),
                  backgroundColor: Colors.white,
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
                             ApplicationLocalizations.of(context)!.translate("ledger_opening_balance")!,
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
          floatingActionButton: singleRecord['Insert_Right']==true ?FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                goToAddOrEditItem(null,"",companyId,true);
             /*   Navigator.push(context, MaterialPageRoute(builder: (context) => CreateLedgerOpeningBal(
                  dateNew: CommonWidget.getDateLayout(invoiceDate),
                  //DateFormat('dd-MM-yyyy').format(invoiceDate),
                  mListener: this,
                )));*/
              }):Container(),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getPurchaseDateLayout(),
                    const SizedBox(
                      height: 5,
                    ),
                    ledgerList.isNotEmpty?getTotalCountAndAmount():Container(),
                    const SizedBox(
                      height: .5,
                    ),
                    get_purchase_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: ledgerList.isEmpty && isApiCall  ? true : false,
                  child: CommonWidget.getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  removeData(){
    setState(() {
      Updated_list=[];
      Inserted_list=[];
      Deleted_list=[];
      ledgerList=[];
    });
  }

  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            invoiceDate=date!;
          });
          removeData();
          callGetLedgerOB(1);
        },
        applicablefrom: invoiceDate
    );

  }

  Widget getTotalCountAndAmount() {
    return Container(
      margin: const EdgeInsets.only(top: 8,left: 8,right: 8,bottom: 8),
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
               Text("${ledgerList.length} ${ApplicationLocalizations.of(context)!.translate("ledgers")!}", style: subHeading_withBold,),
              Row(
                children: [
                  Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: subHeading_withBold,),
                  Text(TotalCr>TotalDr?" Cr":" Dr",style: subHeading_withBold,)
                ],
              )
            ],
          )
      ),
    );
  }

  /* widget for button layout */
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

  Expanded get_purchase_list_layout() {
    return Expanded(
        child: RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            itemCount: ledgerList.length,
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
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
                      onTap: (){

                        goToAddOrEditItem(ledgerList[index],"edit",companyId,singleRecord['Update_Right']);
                      },
                      child: Card(
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
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10,left: 10,right: 40,bottom: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Text(ledgerList[index]["Ledger_Name"],style: item_heading_textStyle,),
                                          const SizedBox(height: 5,),
                                       /*   Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                              const SizedBox(width: 10,),
                                              const Expanded(child: Text("Bal. Sheet No. - 1234",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),*/
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                              const SizedBox(width: 10,),
                                              Expanded(child: Text("${(ledgerList[index]['Amount']).toStringAsFixed(2)} ${ledgerList[index]['Amount_Type']} ",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                              //Expanded(child: Text(CommonWidget.getCurrencyFormat(1000),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    singleRecord['Delete_Right']==true?    Positioned(
                                        top: 0,
                                        right: 0,
                                        child:DeleteDialogLayout(
                                          callback: (response ) async{
                                            if(response=="yes"){
                                              print("##############$response");
                                              var deletedItem=   {
                                                "Ledger_ID": ledgerList[index]['Ledger_ID'],
                                              };
                                              Deleted_list.add(deletedItem);
                                              setState(() {
                                                Deleted_list=Deleted_list;
                                              });
                                              await  callLedgerOpeningBal(Deleted_list,index);
                                            }
                                          },
                                        )):Container()
                                  ],
                                )

                            )
                          ],
                        ),
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

  Future<Object?> goToAddOrEditItem(product,status,compId,update) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -
              1.0;
          return Transform(
            transform:
            Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AddOrEditLedgerOpeningBal(
                mListener: this,
                editproduct:product,
                readOnly: update,
                dateNew:CommonWidget.getDateLayout(invoiceDate) ,
                dateApi:DateFormat('yyyy-MM-dd').format(invoiceDate) ,
                come: status,
                list:ledgerList,
                companyId: compId,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation2, animation1) {
          throw Exception('No widget to return in pageBuilder');
        });
  }

  double TotalCr=0.00;
  String TotalAmount="0.00";
  double TotalDr=0.00;
  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    var totalcr=0.00;
    var totaldr=0.00;
    for(var item  in ledgerList ){
      total=total+item['Amount'];
      if(item['Amount_Type']=="CR"){
        totalcr=totalcr+item['Amount'];
      }
      else  if(item['Amount_Type']=="DR"){
        totaldr=totaldr+item['Amount'];
      }
    }
    if(totalcr>totaldr){
      var total=totalcr-totaldr;
      setState(() {
        TotalAmount=total.isNegative?(-1*total).toStringAsFixed(2):total.toStringAsFixed(2) ;
        TotalCr=totalcr;
        TotalDr=totaldr;
      });

    }
    if(totalcr<=totaldr){
      var total=totalcr-totaldr;
      setState(() {
        TotalAmount=total.isNegative?(-1*total).toStringAsFixed(2):total.toStringAsFixed(2) ;
        TotalCr=totalcr;
        TotalDr=totaldr;
      });

    }

  }

  callGetLedgerOB(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
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
        String apiUrl = "$baseurl${ApiConstants().ledger_opening_bal}?Company_ID=$companyId&Date=${DateFormat('yyyy-MM-dd').format(invoiceDate)}&PageNumber=$page&PageSize=10";
          print("newwww  $apiUrl   $baseurl ");
        //  "?pageNumber=$page&PageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;

                  print("ledger opening data....  $data");
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

  setDataToList(List<dynamic> _list) {
    if (ledgerList.isNotEmpty) ledgerList.clear();
    if (mounted) {
      setState(() {
        ledgerList.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        ledgerList.addAll(_list);
      });
    }
  }

  @override
  AddOrEditItemOpeningBalDetail(item) {
    // TODO: implement AddOrEditItemOpeningBalDetail

    setState(() {
      ledgerList.clear();
    });
    callGetLedgerOB(1);
  }
  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];
  callLedgerOpeningBal(itemDelete,index) async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostILedgerOpeningRequestModel model = PostILedgerOpeningRequestModel(
          companyID: companyId,
          date:DateFormat('yyyy-MM-dd').format(invoiceDate),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Inserted_list.toList(),
          uPDATE: Updated_list.toList(),
          dELETE: Deleted_list.toList()
      );
      print("PostILedgerOpeningRequestModel    ${model.toJson()}");
      String apiUrl = ApiConstants().baseUrl + ApiConstants().ledger_opening_bal;
      print("urlll  $apiUrl");
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=false;
              ledgerList.removeAt(index);
            });
            callGetLedgerOB(1);
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

    });
  }
}
