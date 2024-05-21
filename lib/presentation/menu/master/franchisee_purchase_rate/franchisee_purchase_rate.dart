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
import 'package:sweet_shop_app/presentation/menu/master/franchisee_purchase_rate/add_new_purchase_rate_product.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/franchiseeSaleRate/franchisee_sale_rate_request_model.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../dialog/exit_screen_dialog.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';

class FranchiseePurchaseRate extends StatefulWidget {
  final String compId;
  final  formId;
  final  arrData;
  const FranchiseePurchaseRate({super.key, required this.compId, this.formId, this.arrData});

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
  String selectedCopyFranchiseeName="";

  List<dynamic> Item_list=[];

  String selectedFranchiseeName="";
  var selectedFranchiseeID=null;

  String TotalAmount="0.00";

  List<dynamic> Updated_list=[];

  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();


  bool isLoaderShow=false;

  var editedItemIndex=null;
  var  singleRecord;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
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
        String apiUrl = "${baseurl}${ApiConstants().franchisee_item_rate_list}?Franchisee_ID=$selectedFranchiseeID&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&Company_ID=$companyId&Txn_Type=P&PageNumber=$page&PageSize=10";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
               setState(() {
                 isLoaderShow=false;
                disableColor = false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList=data;


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
                }else{
                  isApiCall=true;
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
        print("${Deleted_list.length} ${Updated_list.length} ${Inserted_list.length}");
        if(Inserted_list.length!=0||Deleted_list.length!=0||Updated_list.length!=0){
          print("Without saving");
          showCupertinoDialog(
            context: context,
            useRootNavigator: true,
            barrierDismissible: true,
            builder: (context) {
              return ExitScreenDialog(
                isDialogType: "1",
              );
            },
          );
          return false;
        }
        else {
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
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: FaIcon(Icons.arrow_back),
                          ),
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
            body:  Column(
              children: [
                Expanded(
                  child: Container(
                    // color: CommonColor.DASHBOARD_BACKGROUND,
                      child: getAllFields(SizeConfig.screenHeight, SizeConfig.screenWidth)),
                ),
                Container(
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
          ),
          Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
        ],
      ),
    );
  }

  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: SizeConfig.halfscreenWidth,
          padding: EdgeInsets.only(top: 10,bottom:10),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${Item_list.length} ${ApplicationLocalizations.of(context)!.translate("items")!}",style: item_regular_textStyle.copyWith(color: Colors.grey),),
                ],
          ),
        ),
        singleRecord['Insert_Right']==true || singleRecord['Update_Right']==true ?  GestureDetector(
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
            else if(Item_list.length==0){
              var snackBar=SnackBar(content: Text("Add atleast one Item!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else if(selectedFranchiseeID!=null && Item_list.length>0) {
              if (mounted) {
                setState(() {
                  disableColor = true;
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
        ):Container(),
      ],
    );
  }




  Widget getAllFields(double parentHeight, double parentWidth) {
    return ListView(
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
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      singleRecord['Insert_Right']==true||singleRecord['Update_Right']==true?       GestureDetector(
                          onTap: (){
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

                          },
                          child: Container(
                              width: 140,
                              padding: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: CommonColor.THEME_COLOR,
                                  border: Border.all(color: Colors.grey.withOpacity(0.5))
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(    ApplicationLocalizations.of(context)!.translate("add_item")!,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      ):Container()
                    ],
                  ),
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
    return   Container(
      height: parentHeight*.6,
      child: ListView.separated(
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
          if(singleRecord['Update_Right']==true) {
            setState(() {
              editedItemIndex = index;
            });
            FocusScope.of(context).requestFocus(FocusNode());
            if (context != null) {
              goToAddOrEditProduct(
                  Item_list[index], singleRecord['Update_Right']);
            }
          }
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

                                                Text("${(Item_list[index]['Rate']).toStringAsFixed(2)}/${Item_list[index]['Unit']} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),),
                                                //Text("${(Item_list[index]['gst']).toStringAsFixed(2)}% ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                                Text("${(Item_list[index]['Net_Rate']).toStringAsFixed(2)}/${Item_list[index]['Unit']} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),

                                              ],
                                            ),

                                          ),


                                        ],
                                      ),
                                    ),
                                  ),

                                  singleRecord['Delete_Right']==true? Container(
                                      width: parentWidth*.1,
                                      // height: parentHeight*.1,
                                      color: Colors.transparent,
                                      child:IconButton(
                                        icon:  FaIcon(
                                          FontAwesomeIcons.trash,
                                          size: 15,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: ()async{
                                          if(Item_list[index]['ID']!=null){
                                            var deletedItem=   {
                                              "ID": Item_list[index]['ID'],
                                              "Item_ID": Item_list[index]['Item_ID']
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
                                        },
                                      )
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
      ),
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
              apiUrl:ApiConstants().franchisee+"?",
              titleIndicator: false,
              title:  ApplicationLocalizations.of(context)!.translate("franchisee")!,
              callback: (name,id){
                if(selectedFranchiseeID==id){
                  var snack=SnackBar(content: Text("Sale Ledger and Party can not be same!"));
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                }
                else {
                  setState(() {
                    selectedCopyFranchiseeName=name!;
                    selectedFranchiseeID=id!;

                    Item_list=[];
                    Updated_list=[];
                    Inserted_list=[];
                    Deleted_list=[];
                    callGetFranchiseeItemOpeningList(1);
                  });
                }
                print(selectedFranchiseeID);
              },
              ledgerName: selectedCopyFranchiseeName),
          Container(
            width: SizeConfig.screenWidth,
            child: getProductCategoryLayout(),
          ),
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
            invoiceDate=name!;
          });
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
  Widget getProductCategoryLayout(){
    return SearchableLedgerDropdown(
        apiUrl:ApiConstants().item_category+"?",
        titleIndicator: false,
        readOnly: singleRecord['Update_Right']||singleRecord['Insert_Right'],
        title:  ApplicationLocalizations.of(context)!.translate("category")!,
        callback: (name,id){

          setState(() {
            selectedProductCategory=name!;
            selectedCategoryID=id;
          });

          print(selectedProductCategory);
        },
        ledgerName: selectedProductCategory);
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

    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['ID']=item['ID'];
        Item_list[index]['Item_ID']=item['New_Item_ID'];
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
    });
    await calculateTotalAmt();

    print(Updated_list);
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
    //var model={};
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      FranchiseeSaleRequest model = FranchiseeSaleRequest(
          companyID: companyId,
          Franchisee_ID:selectedFranchiseeID,
          Txn_Type: 'P',
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Inserted_list.toList(),
          uPDATE: Updated_list.toList(),
          dELETE: Deleted_list.toList()
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
