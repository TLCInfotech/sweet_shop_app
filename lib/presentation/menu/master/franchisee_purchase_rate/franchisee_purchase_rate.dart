import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:sweet_shop_app/presentation/common_widget/get_category_layout.dart';
import 'package:sweet_shop_app/presentation/dialog/Delete_Dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/back_page_dialog.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee_purchase_rate/add_new_purchase_rate_product.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/serchable_branch_sale_and_purchase.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/franchiseeSaleRate/franchisee_sale_rate_request_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../dialog/exit_screen_dialog.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';

class FranchiseePurchaseRate extends StatefulWidget {
  final String compId;
  final  formId;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  final  arrData;final String logoImage;
  const FranchiseePurchaseRate({super.key, required this.compId, this.formId, this.arrData, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});

  @override
  State<FranchiseePurchaseRate> createState() => _FranchiseePurchaseRateState();
}

class _FranchiseePurchaseRateState extends State<FranchiseePurchaseRate> with AddProductPurchaseRateInterface {
  final _formkey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  String selectedProductCategory="";
  var selectedCategoryID=null;

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));


  List<dynamic> Item_list=[];

  String selectedFranchiseeName="";
  var selectedFranchiseeID=null;

  bool displayLayout=true;
  bool viewWorkDVisible=true;
  String TotalAmount="0.00";

  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  bool isLoaderShow=false;

  var editedItemIndex=null;
  var  singleRecord;

  List<dynamic> CopyItem_list = [];
  String selectedCopyFranchiseeName = "";
  String selectedCopyFranchiseeId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _scrollController.addListener(_scrollListener);
    if(widget.viewWorkDVisible!=null){
      viewWorkDVisible=widget.viewWorkDVisible;
    }
    setVal();
  }
  setVal()async{
    print(widget.arrData);
    List<dynamic> jsonArray = jsonDecode(widget.arrData);
    singleRecord = jsonArray.firstWhere((record) => record['Form_ID'] == widget.formId);
    print("singleRecorddddd11111   $singleRecord   ${singleRecord['Update_Right']}");
  }
  int page = 1;
  bool isPagination = true;
  bool isApiCall = false;
  bool showButton = false;

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetFranchiseeItemOpeningList(page);
      }
    }
  }

  getPurchaseList(){
    setState(() {
      Item_list=[];
      Updated_list=[];
      Deleted_list=[];
      Inserted_list=[];
    });
    if(selectedFranchiseeID!=null){
      callGetFranchiseeItemOpeningList(1);
    }
  }

  callGetFranchiseeItemOpeningList(int page) async {
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
        // &Category_ID=$selectedCategoryID
        String apiUrl = "${baseurl}${ApiConstants().franchisee_item_rate_list}?Franchisee_ID=$selectedFranchiseeID&${StringEn.lang}=$lang&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&Company_ID=$companyId&Txn_Type=P";
        // &PageNumber=$page&${StringEn.pageSize}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
               setState(() {
                 isLoaderShow=false;
                disableColor = false;
                 displayLayout=true;
                if(data!=null){
                  List<dynamic> _arrList = [];
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
                  if(Item_list.length>0){
                    position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.7);
                  }
                }else{
                  isApiCall=false;
                }
              /*    setState(() {
                    Item_list=_arrList;
                  });
                  calculateTotalAmt();
                }*/

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

  callGetCopyFrenchisee(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String lang = await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
        TokenRequestModel(token: sessionToken, page: "");
        String apiUrl =
            "$baseurl${ApiConstants().franchisee_item_rate_list}?Franchisee_ID=$selectedCopyFranchiseeId&${StringEn.lang}=$lang&Date=${DateFormat('yyyy-MM-dd').format(invoiceDate)}&Company_ID=$companyId&Txn_Type=P";
        // &PageNumber=$page&${StringEn.pageSize}";
        print("newwww  $apiUrl   $baseurl ");
        //  "?pageNumber=$page&PageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess: (data) {
              setState(() {
                isLoaderShow = false;
                disableColor = false;
                if (data != null) {
                  // Item_list=data;
                  print("ledger opening data....  $data");

                  List<dynamic> _arrList = [];
                  //  _arrList.clear();
                  _arrList = data;
                  setState(() {
                    CopyItem_list=_arrList;
                  });

                  var  itemlist= (Item_list).map((i) => i['Item_ID']).toList();
                  print("################## $itemlist");
                  for (var i in _arrList){
                    print(i['Item_ID']);
                    var contain=itemlist.contains(i['Item_ID']);
                    print(contain);
                    if(contain==false){
                      Item_list.add(i);
                      Inserted_list.add(i);
                    }
                  }

                } else {
                  isApiCall = true;
                }
                if(CopyItem_list.isEmpty){
                position=  Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);
                }else{

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

  setDataToList(List<dynamic> _list) {
    if (Item_list.isNotEmpty) Item_list.clear();
    if (mounted) {
      setState(() {
        Item_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        Item_list.addAll(_list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(showButton==true){
          print("jfjhjbvh  11111");
         await showCustomDialog(context,callPostIFranchiseetemOpeningBal);
          return false;
        }else{
          return true;
        }

      },
      child: Stack(
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
                      borderRadius: BorderRadius.circular(25)
                  ),
                  color: Colors.transparent,
                  // color: Colors.red,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                 child: AppBar(
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                    title:  Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if(showButton==true){
                                await showCustomDialog(context,callPostIFranchiseetemOpeningBal);
                              }else{
                                Navigator.pop(context);
                              }},
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
                                ApplicationLocalizations.of(context)!.translate("franchisee_purchase_rate")!,
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
            body:  Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        // color: CommonColor.DASHBOARD_BACKGROUND,
                          child: getAllFields(SizeConfig.screenHeight, SizeConfig.screenWidth)),
                    ),
                    Item_list.isEmpty && showButton==false?Container(): Container(
                        decoration: BoxDecoration(
                          color: CommonColor.WHITE_COLOR,
                          border: Border(
                            top: BorderSide(
                              color: Colors.black.withOpacity(0.08),
                              width: 1.0,
                            ),
                          ),
                        ),
                        height: SizeConfig.safeUsedHeight * .08,
                        child: getSaveAndFinishButtonLayout(
                            SizeConfig.screenHeight, SizeConfig.screenWidth)),
                    CommonWidget.getCommonPadding(
                        SizeConfig.screenBottom, CommonColor.WHITE_COLOR),

                  ],
                ),
                Visibility(
                    visible: CopyItem_list.isEmpty && isApiCall==true  ? true : false,
                    child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),

              ],
            ),
          ),
          viewWorkDVisible==false?Container():
          singleRecord['Insert_Right']==true||singleRecord['Update_Right']==true? Positioned(
            left: position.dx,
            top: position.dy,
            child:
            GestureDetector(
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
                    setState(() {
                      editedItemIndex=null;
                    });
                    if(selectedFranchiseeID!=null){
                      editedItemIndex=null;
                      goToAddOrEditProduct(null,true);
                    }else{
                      CommonWidget.errorDialog(context, "Select franchisee first.");
                    }
                    FocusScope.of(context).requestFocus(FocusNode());

                  }),
            ),
          ):Container(),

          Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
        ],
      ),
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


  Future<void> showCustomDialog(BuildContext context, Function onYesCallback) async {
    await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: BackPageDialog(
              onCallBack: (value) async {
                if(value=="yes"){
                  if(selectedFranchiseeID==null){
                    var snackBar=SnackBar(content: Text("Select Franchisee Id !"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else if(selectedFranchiseeID!=null) {
                    if (mounted) {
                      setState(() {
                        showButton=false;
                      });
                    }
                    await onYesCallback();
                  }
                }
              },
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation2, animation1) {
        return Container();
      },
    );
  }




  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return  Padding(
      padding:  EdgeInsets.only(left:15,right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      Item_list.length==0?Container():Container(
            width: SizeConfig.halfscreenWidth,
            padding: EdgeInsets.only(top: 0,bottom:0),
            decoration: BoxDecoration(
              // color:  CommonColor.DARK_BLUE,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${Item_list.length} ${ApplicationLocalizations.of(context)!.translate("items")!}",style: item_regular_textStyle.copyWith(color: Colors.grey),),
                viewWorkDVisible==false?Container(): GestureDetector(
                  onTap: () async {
                    await showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue =
                              Curves.easeInOutBack.transform(a1.value) - 1.0;
                          // return Transform(
                          //   transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                          return Transform.scale(
                            scale: a1.value,
                            child: Opacity(
                              opacity: a1.value,
                              child: DeleteDialog(onCallBack: (value) async {
                                print("nfnnvbvb  $value");
                                if (value == "yes") {

                                  List<Map<String, dynamic>> idAndItemIdList = Item_list.map((item) {
                                    return {
                                      'ID': item['ID'],
                                      'Item_ID': item['Item_ID']
                                    };
                                  }).toList();
                                  // Deleted_list.add(idAndItemIdList);
                                  setState(() {
                                    Item_list = [];
                                    Deleted_list = idAndItemIdList;
                                    print("objecttttttt   $idAndItemIdList");
                                    print("godddddd  $Deleted_list");
                                  });
                                  await callPostIFranchiseetemOpeningBal();
                                }
                              }),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation2, animation1) {
                          return Container();
                        });
                  },
                  onDoubleTap: () {},
                  child: Container(
                    width: SizeConfig.halfscreenWidth,
                    height: 30,
                    decoration: BoxDecoration(
                      color: disableColor == true
                          ? Colors.redAccent.withOpacity(.5)
                          : Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: parentWidth * .005),
                          child: Text(
                            "Delete All",
                            style: page_heading_textStyle.copyWith(
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                  ],
            ),
          ),
          viewWorkDVisible==false?Container():
          singleRecord['Insert_Right']==false || singleRecord['Update_Right']==false||showButton==false  || Item_list.length==0?  Container():
          GestureDetector(
            onTap: () {
              // if(widget.comeFrom=="clientInfoList"){
              //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ClientInformationListingPage(
              //   )));
              // }if(widget.comeFrom=="Projects"){
              //   Navigator.pop(context,false);
              // }
              // else if(widget.comeFrom=="edit"){
              //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ClientInformationDetails(
              //   )));
              // }
              if(selectedFranchiseeID==null){
                var snackBar=SnackBar(content: Text("Select Franchisee Id !"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else if(selectedFranchiseeID!=null) {
                if (mounted) {
                  setState(() {
                    selectedCopyFranchiseeName="";
                    selectedCopyFranchiseeId="";
                    showButton=false;
                    displayLayout = false;
                  });
                }
                callPostIFranchiseetemOpeningBal();
              }

            },
            onDoubleTap: () {},
            child: Container(
              width: SizeConfig.halfscreenWidth,
              height: 40,
              decoration: BoxDecoration(
                color: disableColor == true
                    ? CommonColor.THEME_COLOR.withOpacity(.5)
                    : CommonColor.THEME_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: parentWidth * .005),
                    child:  Text(
                      ApplicationLocalizations.of(context)!.translate("save")!,
                      style: page_heading_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget getAllFields(double parentHeight, double parentWidth) {
    return  ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01,left: parentWidth*.03,right: parentWidth*.03),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [

                  //  getFieldTitleLayout("Invoice Detail"),
                  InvoiceInfo(),
                  Container(
                    padding: EdgeInsets.only(left:8,right: 8),
                    width: SizeConfig.screenWidth,
                    child: getProductCategoryLayout(),
                  ),
                  SizedBox(height: 10,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //
                  //     singleRecord['Insert_Right']==true||singleRecord['Update_Right']==true?       GestureDetector(
                  //         onTap: (){
                  //           setState(() {
                  //             editedItemIndex=null;
                  //           });
                  //           if(selectedFranchiseeID!=null){
                  //             editedItemIndex=null;
                  //             goToAddOrEditProduct(null,true);
                  //           }else{
                  //             CommonWidget.errorDialog(context, "Select franchisee first.");
                  //           }
                  //           FocusScope.of(context).requestFocus(FocusNode());
                  //
                  //         },
                  //         child: Container(
                  //             width: 140,
                  //             padding: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                  //             margin: EdgeInsets.only(bottom: 10),
                  //             decoration: BoxDecoration(
                  //                 color: CommonColor.THEME_COLOR,
                  //                 border: Border.all(color: Colors.grey.withOpacity(0.5))
                  //             ),
                  //             child:  Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text(    ApplicationLocalizations.of(context)!.translate("add_item")!,
                  //                   style: item_heading_textStyle,),
                  //                 FaIcon(FontAwesomeIcons.plusCircle,
                  //                   color: Colors.black87, size: 20,)
                  //               ],
                  //             )
                  //
                  //         )
                  //     ):Container()
                  //   ],
                  // ),
                  Item_list.isNotEmpty? get_purchase_list_layout(parentHeight,parentWidth):Container(),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }

  Widget get_purchase_list_layout(double parentHeight, double parentWidth) {
    return   ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Item_list.length,
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
                onTap: (){
                  if(viewWorkDVisible==false){
                    goToAddOrEditProduct(
                        Item_list[index], false);
                  }else{
        if(singleRecord['Update_Right']==true) {
          setState(() {
            editedItemIndex = index;
          });
          FocusScope.of(context).requestFocus(FocusNode());
          if (context != null) {
            goToAddOrEditProduct(
                Item_list[index], singleRecord['Update_Right']);
          }
        }}
                },
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10,left: 10,right: 10 ,bottom: 10),
                            child:Row(
                              children: [
                                Container(
                                    width: parentWidth*.1,
                                    height:parentWidth*.1,
                                    decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("${index+1}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontSize: 14),)
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: parentWidth*.70,
                                    //  height: parentHeight*.1,
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${Item_list[index]['Name']}",style: item_heading_textStyle,),

                                        SizedBox(height: 5,),

                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: SizeConfig.screenWidth,
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              Text(
                                                CommonWidget.getCurrencyFormat(
                                                    double.parse(Item_list[index]
                                                    ['Rate'].toString()))
                                                    .toString() + "${Item_list[index]['Unit']}"
                                                // "${(Item_list[index]['Rate']).toStringAsFixed(2)}/kg "
                                                ,overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),),
                                              //Text("${(Item_list[index]['gst']).toStringAsFixed(2)}% ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                              Container(

                                                alignment: Alignment.centerRight,
                                                width: SizeConfig.halfscreenWidth-50,
                                                child: Text(
                                                  CommonWidget.getCurrencyFormat(
                                                      double.parse(Item_list[index]
                                                      ['Net_Rate'].toString()))
                                                      .toString() + "${Item_list[index]['Unit']}",
                                                  // "${(Item_list[index]['Net_Rate']).toStringAsFixed(2)}/kg ",
                                                  overflow: TextOverflow.ellipsis,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                              ),
                                              // Text("${(Item_list[index]['Rate']).toStringAsFixed(2)}/${Item_list[index]['Unit']} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),),
                                              // //Text("${(Item_list[index]['gst']).toStringAsFixed(2)}% ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                              // Text("${(Item_list[index]['Net_Rate']).toStringAsFixed(2)}/${Item_list[index]['Unit']} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),

                                            ],
                                          ),

                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                                viewWorkDVisible==false?Container():
                                singleRecord['Delete_Right']==true? Container(
                                    width: parentWidth*.1,
                                    // height: parentHeight*.1,
                                    color: Colors.transparent,
                                    child:DeleteDialogLayout(
                                        callback: (response ) async{
                                          if(response=="yes"){
                                            showButton=true;
                                            print("##############$response");
                                            if(Item_list[index]['ID']!=0){
                                              var deletedItem=   {
                                                "Item_ID": Item_list[index]['Item_ID'],
                                                "ID": Item_list[index]['ID'],
                                              };
                                              Deleted_list.add(deletedItem);
                                              setState(() {
                                                Deleted_list=Deleted_list;
                                              });
                                            }

                                            var contain = Inserted_list.indexWhere((element) => element['Item_ID']== Item_list[index]['Item_ID']);
                                            print(contain);
                                            if(contain>=0){
                                              print("REMOVE");
                                              Inserted_list.remove(Inserted_list[contain]);
                                            }
                                            Item_list.remove(Item_list[index]);
                                            setState(() {
                                              Item_list=Item_list;
                                              Inserted_list=Inserted_list;
                                            });
                                            print(Inserted_list);
                                            await calculateTotalAmt();
                                            setState(() {
                                              showButton=true;});
                                          }
                                        })
                                    // IconButton(
                                    //   icon:  FaIcon(
                                    //     FontAwesomeIcons.trash,
                                    //     size: 15,
                                    //     color: Colors.redAccent,
                                    //   ),
                                    //   onPressed: ()async{
                                    //     showButton=true;
                                    //     if(Item_list[index]['ID']!=null){
                                    //       var deletedItem=   {
                                    //         "ID": Item_list[index]['ID'],
                                    //         "Item_ID": Item_list[index]['Item_ID']
                                    //       };
                                    //       Deleted_list.add(deletedItem);
                                    //       setState(() {
                                    //         Deleted_list=Deleted_list;
                                    //       });
                                    //     }
                                    //     var contain = Inserted_list.indexWhere((element) => element['Item_ID']== Item_list[index]['Item_ID']);
                                    //     print(contain);
                                    //     if(contain>=0){
                                    //       print("REMOVE");
                                    //       Inserted_list.remove(Inserted_list[contain]);
                                    //     }
                                    //     Item_list.remove(Item_list[index]);
                                    //     setState(() {
                                    //       Item_list=Item_list;
                                    //       Inserted_list=Inserted_list;
                                    //     });
                                    //     print(Inserted_list);
                                    //     await calculateTotalAmt();
                                    //   },
                                    // )
                                ):Container(),
                              ],
                            )
                        ),
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
        return SizedBox(
          height: 5,
        );
      },
    );
  }

  Container InvoiceInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            child: getApplicableFromLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          ),
          SearchableLedgerDropdown(
              apiUrl:ApiConstants().getFilteredFranchisee+"?",
              titleIndicator: false,
              title:  ApplicationLocalizations.of(context)!.translate("franchisee")!,
              callback: (name,id){
                // if(selectedFranchiseeID==id){
                //   var snack=SnackBar(content: Text("Sale Ledger and Party can not be same!"));
                //   ScaffoldMessenger.of(context).showSnackBar(snack);
                // }
                // else {
                  setState(() {
                    //showButton=true;
                    selectedFranchiseeName=name!;
                    selectedFranchiseeID=id!;

                    Item_list=[];
                    Updated_list=[];
                    Inserted_list=[];
                    Deleted_list=[];
                    position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
                    callGetFranchiseeItemOpeningList(1);
                  });
                // }
                print(selectedFranchiseeID);
              },
              ledgerName: selectedFranchiseeName),
          displayLayout==false?Container(): SearchableLedgerDropdown(
              apiUrl: ApiConstants().getFilteredFranchisee + "?",
              titleIndicator: true,
              title: "Copy From",
              callback: (name, id) {
                // if(selectedFranchiseeId==id){
                //   var snack=SnackBar(content: Text("Sale Ledger and Party can not be same!"));
                //   ScaffoldMessenger.of(context).showSnackBar(snack);
                // }
                // else {
                setState(() {
                  // showButton=true;
                  selectedCopyFranchiseeName = name!;
                  selectedCopyFranchiseeId = id!;
                  if(id==""){
                    showButton = false;
                    isApiCall=false;
                    callGetFranchiseeItemOpeningList(1);
                  }else{
                    showButton = true;
                    Item_list=[];
                    callGetCopyFrenchisee(1);}
                });
                // }
                print(selectedCopyFranchiseeId);
              },
              ledgerName: selectedCopyFranchiseeId),

          // getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

        ],
      ),
    );
  }

  Future<Object?> goToAddOrEditProduct(product,updateRight) {
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
                  child: AddProductPurchaseRate(
                    mListener: this,
                    editproduct:product,
                    date:invoiceDate,
                    existingList: Item_list,
                    readOnly: updateRight,
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

  /* Widget to get add Product Layout */
  Widget getApplicableFromLayout(double parentHeight, double parentWidth){
    return GetDateLayout(
        titleIndicator:false,
        title:      ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (name){
          setState(() {
           // showButton=true;
            invoiceDate=name!;
          });
          if (name!.isAfter(widget.viewWorkDDate)) {
            viewWorkDVisible=true;
            print("previousDateTitle  ");
          } else {
            viewWorkDVisible=false;
            print("previousDateTitle   ");
          }
          if(selectedFranchiseeID!=null){
            setState(() {
              Item_list=[];
              Updated_list=[];
              Inserted_list=[];
              Deleted_list=[];
            });
            callGetFranchiseeItemOpeningList(1);
          }else{

          }
        },
        applicablefrom: invoiceDate);

  }

  /* Widget to get Product categoryLayout */
  Widget getProductCategoryLayout() {
    return SearchableSPDropdown(
      listArrya: Item_list,
      titleIndicator: false,
      readOnly: singleRecord['Update_Right'] || singleRecord['Insert_Right'],
      title: ApplicationLocalizations.of(context)!.translate("item")!,
      callback: (item) {
        print("fkjjjggg   $item");
        if(item!=null){
        var indexx=Item_list.indexOf(item);
        setState(() {
            setState(() {
              editedItemIndex = indexx;
            });
            FocusScope.of(context).requestFocus(FocusNode());
            if(viewWorkDVisible==false){
              goToAddOrEditProduct(
                  item, false);
            }else{
            goToAddOrEditProduct(item, singleRecord['Update_Right']);}
        });}
      },);
  }

  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    for(var item  in Item_list ){
      total=total+item['Net_Rate'];
      print("hjfhjfeefbh  ${item['Net_Rate']}");
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }

  @override
  addProductPurchaseRateDetail( dynamic item)async {
    // TODO: implement addProductDetail
    var itemLlist=Item_list;
showButton=true;
    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['ID']=item['ID'];
        // Item_list[index]['Item_ID']=item['New_Item_ID'];
        Item_list[index]['Item_ID']=item['ID']!=null?item['New_Item_ID']:item['Item_ID'];
        Item_list[index]['Name']=item['Name'];
        Item_list[index]['Disc_Percent']=item['Disc_Percent'];
        Item_list[index]['Rate']=item['Rate'];
        Item_list[index]['GST']=item['GST'];
        Item_list[index]['GST_Amount']=item['GST_Amount'];
        Item_list[index]['Net_Rate']=item['Net_Rate'];
        Item_list[index]['Unit']=item['Unit'];
      });
      if(item['New_Item_ID']!=null){
        print("#############3");
        print("present");
        setState(() {
          Item_list[index]['Item_ID']=item['Item_ID'];
          Item_list[index]['New_Item_ID']=item['New_Item_ID'];
        });
      }
      if(item['ID']!=null) {
        var contain = Updated_list.indexWhere((element) => element['Item_ID']== item['Item_ID']);
        print(contain);
        if(contain>=0){
          print("REMOVE");
          Updated_list.remove(Updated_list[contain]);
          Updated_list.add(item);
        }else{
          Updated_list.add(item);
        }
        setState(() {
          Updated_list = Updated_list;
          print("hvhfvbfbv   $Updated_list");
        });
      }
      else{
        setState(() {
          Item_list[index]=item;
        });
      }
    }
    else
    {
      itemLlist.add(item);
      Inserted_list.add(item);
      setState(() {
        Inserted_list=Inserted_list;
      });
      print(itemLlist);

      setState(() {
        Item_list = itemLlist;
      });
    }
    setState(() {
      editedItemIndex=null;
      isApiCall=false;
    });
    await calculateTotalAmt();
    // Sort itemDetails by Item_Name
   // itemLlist.sort((a, b) => a['Name'].compareTo(b['Name']));
    print(Updated_list);
    if(Item_list.length>0){
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.8);
    }else{
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);
    }
  }

  // calculateTotalAmt()async{
  //   print("Here");
  //   var total=0.00;
  //   for(var item  in Item_list ){
  //     print(item['Amount']);
  //     if(item['Amount']!=null||item['Amount']!="") {
  //       total = total + double.parse(item['Amount'].toString());
  //       print(item['Amount']);
  //     }
  //   }
  //   setState(() {
  //     TotalAmount=total.toStringAsFixed(2) ;
  //   });
  //
  // }



  callPostIFranchiseetemOpeningBal() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String lang=await AppPreferences.getLang();
    //var model={};
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      FranchiseeSaleRequest model = FranchiseeSaleRequest(
          companyID: companyId,
          lang:lang,
          Franchisee_ID:selectedFranchiseeID,
          Txn_Type: 'P',
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Item_list.toList(),
          // uPDATE: Updated_list.toList(),
          // dELETE: Deleted_list.toList()
      );
      String apiUrl =baseurl + ApiConstants().franchisee_item_rate;
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=true;
              Item_list=[];
              Inserted_list=[];
              Updated_list=[];
              Deleted_list=[];
            });
            await callGetFranchiseeItemOpeningList(1);

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
          });

    });
  }

}
