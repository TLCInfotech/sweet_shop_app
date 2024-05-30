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
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
import 'package:sweet_shop_app/presentation/common_widget/deleteDialog.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import 'create_item_opening_bal_activity.dart';

class ItemOpeningBal extends StatefulWidget {
  final newDate;
  final  formId;
  final  arrData;
  const ItemOpeningBal({super.key, this.newDate, this.formId, this.arrData});

  @override
  State<ItemOpeningBal> createState() => _ItemOpeningBalState();
}

class _ItemOpeningBalState extends State<ItemOpeningBal> with CreateItemOpeningBalInterface{



  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> Franchisee_list=[];
  bool isApiCall=false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetFranchiseeItemOpeningList(1);
    if(widget.newDate!=null){
      invoiceDate=widget.newDate;
    }
    getLocal();
    setVal();
  }
  var  singleRecord;
  setVal()async{
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
  }
  String companyId="";
  getLocal()async{
    companyId=await AppPreferences.getCompanyId();
    setState(() {

    });
  }
//FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    await   callGetFranchiseeItemOpeningList(1);
  }
  final ScrollController _scrollController =  ScrollController();

  String selectedFranchiseeName="";
  String selectedFranchiseeId="";
/* Widget to get sale ledger Name Layout */
  Widget getFranchiseeSearchLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():
    SearchableLedgerDropdown(
        apiUrl: "${ApiConstants().getFetchFranchiseeName}?Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&",
        titleIndicator: false,
        title: ApplicationLocalizations.of(context)!.translate("franchisee")!,
        franchiseeName: selectedFranchiseeName!=""? selectedFranchiseeName:"",
        franchisee:selectedFranchiseeName,
        callback: (name,id)async{
          setState(() {
            selectedFranchiseeName = name!;
            selectedFranchiseeId = id!;
            // Item_list=[];
            // Updated_list=[];
            // Deleted_list=[];
            // Inserted_list=[];
          });
          print(selectedFranchiseeId);
          var item={
            "Name":name,
            "Franchisee_ID":id
          };
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateItemOpeningBal(
            dateNew:invoiceDate,
            editedItem:item,
            compId:companyId ,
            come:"edit",
            readOnly: singleRecord['Update_Right'],
            //DateFormat('dd-MM-yyyy').format(invoiceDate),
            mListener: this,
          )));

          await callGetFranchiseeItemOpeningList(1);

          // await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateExpenseActivity(
          //   mListener: this,
          //   ledgerList: item,
          //   readOnly:singleRecord['Update_Right'],
          // )));
          // await callGetLedger(0);
        },
        ledgerName: selectedFranchiseeName);
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
                // color: Colors.red,
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
                              ApplicationLocalizations.of(context)!.translate("item_opening_balance")!,
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
          floatingActionButton:singleRecord['Insert_Right']==true? FloatingActionButton(
              backgroundColor: const Color(0xFFFBE404),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () async{
                await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemOpeningBal(
                  dateNew:invoiceDate,
                  compId:companyId ,
                  //DateFormat('dd-MM-yyyy').format(invoiceDate),
                  mListener: this,
                )));
                setState(() {
                  Franchisee_list=[];
                });
                callGetFranchiseeItemOpeningList(1);
              }):Container(),
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
                      height: 1,
                    ),
                    Franchisee_list.length>0?getFranchiseeSearchLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth):Container(),

                    getTotalCountAndAmount(),
                  const SizedBox(
                      height: 10,
                    ),
                    get_purchase_list_layout()
                  ],
                ),
              ),
              Visibility(
                  visible: Franchisee_list.isEmpty && isApiCall  ? true : false,
                  child:CommonWidget.getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  Widget getTotalCountAndAmount() {
    return Franchisee_list.length>0?Container(
      margin: const EdgeInsets.only(top: 10),
      child: Container(
          height: 40,
          // width: SizeConfig.halfscreenWidth,
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
              Text("${Franchisee_list.length} ${ApplicationLocalizations.of(context)!.translate("items")!}  ", style: subHeading_withBold,),
              Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: subHeading_withBold,)
            ],
          )
      ),
    ):Container();
  }

  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout(){
    return GetDateLayout(
        titleIndicator: false,
        title:ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            invoiceDate=date!;
          });
          setState(() {
            Franchisee_list=[];
          });
          callGetFranchiseeItemOpeningList(0);
        },
        applicablefrom: invoiceDate
    );

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





  Expanded get_purchase_list_layout() {
    return Expanded(
        child:RefreshIndicator(
          color: CommonColor.THEME_COLOR,
          onRefresh: () {
            return refreshList();
          },
          child: ListView.separated(
            itemCount:Franchisee_list.length,
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
                    child: GestureDetector(
                      onTap: ()async{
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemOpeningBal(
                          dateNew:invoiceDate,
                          editedItem:Franchisee_list[index],
                          compId:companyId ,
                          come:"edit",
                          readOnly: singleRecord['Update_Right'],
                          //DateFormat('dd-MM-yyyy').format(invoiceDate),
                          mListener: this,
                        )));
                        callGetFranchiseeItemOpeningList(0);
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
                                // Text("A",style: kHeaderTextStyle.copyWith(color: Colors.white,fontSize: 16),),
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
                                          Text("${Franchisee_list[index]['Name']}",style: item_heading_textStyle,),
                                          //  SizedBox(height: 5,),
                                          // Row(
                                          //   crossAxisAlignment: CrossAxisAlignment.center,
                                          //   children: [
                                          //     FaIcon(FontAwesomeIcons.fileInvoice,size: 15,color: Colors.black.withOpacity(0.7),),
                                          //     const SizedBox(width: 10,),
                                          //      Expanded(child: Text("${Franchisee_list[index]['itemCount']} Items",overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                          //   ],
                                          // ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              FaIcon(FontAwesomeIcons.moneyBill1Wave,size: 15,color: Colors.black.withOpacity(0.7),),
                                              const SizedBox(width: 10,),
                                              Expanded(child: Text(CommonWidget.getCurrencyFormat(Franchisee_list[index]['Amount']),overflow: TextOverflow.clip,style: item_regular_textStyle,)),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    singleRecord['Delete_Right']==true?     Positioned(
                                        top: 0,
                                        right: 0,
                                        child: DeleteDialogLayout(
                                          callback: (response ) async{
                                            if(response=="yes"){
                                              print("##############$response");
                                              await   callDeleteContra(Franchisee_list[index]['Franchisee_ID'].toString(),index);
                                            }
                                          },
                                        ) ):Container()
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

  String TotalAmount="0.00";
  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    for(var item  in Franchisee_list ){
      if(item['Amount']!=null||item['Amount']!="") {
        total = total + double.parse(item['Amount'].toString());
        print(item['Amount']);
      }
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });
  }
  callGetFranchiseeNot(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl = "${baseurl}${ApiConstants().sendFranchiseeNotification}?Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){
              setState(() {

              });
              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  franchisee   $data ");
            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
            }, onException: (e) {

              print("Here2=> $e");
              var val= CommonWidget.errorDialog(context, e);

              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    }
    else{
      CommonWidget.noInternetDialogNew(context);
    }
  }
  callGetFranchiseeItemOpeningList(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().franchisee_item_opening_list}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;

                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;
                  callGetFranchiseeNot(0);
                  setState(() {

                    Franchisee_list=_arrList;
                  });
                }else{
                  isApiCall=true;
                }
                calculateTotalAmt();
              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
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
  @override
  backToList() {
    // TODO: implement backToList
    setState(() {
      callGetFranchiseeNot(0);
    });
    Navigator.pop(context);
  }
  callDeleteContra(String removeId,int index) async {
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
          "Franchisee_ID": removeId,
          "Modifier": uid,
          "Modifier_Machine": deviceId,
          "Date":DateFormat("yyyy-MM-dd").format(invoiceDate)
        };
        String apiUrl = baseurl + ApiConstants().franchisee_item_opening+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(apiUrl, model, "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                Franchisee_list.removeAt(index);
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



}
