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
import 'package:sweet_shop_app/presentation/menu/master/franchisee_sale_rate/add_new_sale_rate_product.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/franchiseeSaleRate/franchisee_sale_rate_request_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_category_layout.dart';
import '../../../common_widget/get_date_layout.dart';
import '../../../dialog/exit_screen_dialog.dart';

class FranchiseeSaleRate extends StatefulWidget {
  const FranchiseeSaleRate({super.key});

  @override
  State<FranchiseeSaleRate> createState() => _FranchiseeSaleRateState();
}

class _FranchiseeSaleRateState extends State<FranchiseeSaleRate> with AddProductSaleRateInterface{

  final _formkey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  String selectedFranchiseeName="";
  String selectedProductCategory="";
  DateTime applicablefrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  String selectedCopyFranchiseeName="";
  String selectedCopyFranchiseeId="";
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

/*  List<dynamic> Item_list=[
    {
      "id":1,
      "pname":"Gulakand Burfi",
      "rate":1000.00,
      "gst":12,
      "gstAmt":120,
      "net":1120.00,
    },
    {
      "id":2,
      "pname":"Mango Burfi",
      "rate":800.00,
      "gst":12,
      "gstAmt":96,
      "net":896.00,
    },
  ];*/
  List<dynamic> Item_list=[];
  List<dynamic> Updated_list=[];
  var editedItemIndex=null;
  List<dynamic> Inserted_list=[];

  List<dynamic> Deleted_list=[];
  bool isLoaderShow=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateTotalAmt();
    _scrollController.addListener(_scrollListener);
    if(selectedCopyFranchiseeId!=""){
      callGetFrenchisee(page);
    }

  }

  int page = 1;
  bool isPagination = true;


  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        callGetFrenchisee(page);
      }
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
              return const ExitScreenDialog(
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),

                    backgroundColor: Colors.white,
                    title: Text(
                      ApplicationLocalizations.of(context)!.translate("franchisee_sale_rate")!,
                      style: appbar_text_style,),
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
            if (mounted) {
              setState(() {
                disableColor = true;
              });
            }
            callPostItemOpeningBal();
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

                      GestureDetector(
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              editedItemIndex=null;
                            });
                      if(selectedCopyFranchiseeId!=""){
                        goToAddOrEditProduct(null);
                      }else{
                        CommonWidget.errorDialog(context, "Select franchisee first.");
                      }
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
                                  Text(   ApplicationLocalizations.of(context)!.translate("add_item")!,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
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
                    setState(() {
                      editedItemIndex=index;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (context != null) {
                      goToAddOrEditProduct(Item_list[index]);
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
                                      child: Text("0${index+1}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontSize: 14),)
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
                                          /*  Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child:
                                            Text("${(Item_list[index]['quantity'])}.00 ${Item_list[index]['unit']} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                          ),
                                          SizedBox(height: 5,),*/
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${(Item_list[index]['Rate']).toStringAsFixed(2)}/kg ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),),
                                                //Text("${(Item_list[index]['gst']).toStringAsFixed(2)}% ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                                Text("${(Item_list[index]['Net_Rate']).toStringAsFixed(2)}/kg ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),

                                                //  Text(CommonWidget.getCurrencyFormat(Item_list[index]['net']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),

                                              ],
                                            ),

                                          ),


                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(
                                      width: parentWidth*.1,
                                      // height: parentHeight*.1,
                                      color: Colors.transparent,
                                      child:DeleteDialogLayout(
                                        callback: (response ) async{
                                          if(response=="yes"){
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
                                            await calculateTotalAmt();  }
                                        })
                                  ),
                                ],
                              )
                          ),
                        )],
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

  // String getFrenchiseeItemRateList="getFranchaiseeItemRateList";
  // String frenchiseeItemRate="franchiseeItemRate";
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
          GetFranchiseeLayout(
              titleIndicator:false,
              title:  ApplicationLocalizations.of(context)!.translate("franchisee")!,
              callback: (name,id){
                setState(() {
                  selectedCopyFranchiseeName=name!;
                  selectedCopyFranchiseeId=id!;
                });
                setState(() {
                  Item_list=[];
                  Updated_list=[];
                  Inserted_list=[];
                  Deleted_list=[];
                });    callGetFrenchisee(1);
              },
              franchiseeName: selectedCopyFranchiseeName),
          // getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          Padding(
            padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.halfscreenWidth,
                  child: getProductCategoryLayout(),
                ),

                Container(
                  width: SizeConfig.halfscreenWidth,
                  child: getApplicableFromLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Object?> goToAddOrEditProduct(product) {
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
              child: AddProductSaleRate(
                mListener: this,
                editproduct:product,
                dateNew:DateFormat('yyyy-MM-dd').format(applicablefrom),
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
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (name){
          setState(() {
            applicablefrom=name!;
          });
          if(selectedCopyFranchiseeId!=""){
            setState(() {
              Item_list=[];
              Updated_list=[];
              Inserted_list=[];
              Deleted_list=[];
            });
            callGetFrenchisee(1);
          }
        },
        applicablefrom: applicablefrom);

  }

  /* Widget to get Product categoryLayout */
  Widget getProductCategoryLayout(){
    return  GetCategoryLayout(
        titleIndicator:false,
        title:    ApplicationLocalizations.of(context)!.translate("category")!,
        callback: (name,id){
          setState(() {
            selectedProductCategory=name!;
          });
        },
        selectedProductCategory: selectedProductCategory);

  }

  String TotalAmount="0.00";
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
  addProductSaleRateDetail( dynamic item)async {
    // TODO: implement addProductDetail
    print(item);
    var itemLlist=Item_list;

    if(editedItemIndex!=null){
      var index=editedItemIndex;
      setState(() {
        Item_list[index]['ID']=item['ID'];
        Item_list[index]['Item_ID']=item['Item_ID'];
        Item_list[index]['New_Item_ID']=item['New_Item_ID'];
        Item_list[index]['Name']=item['Name'];
        Item_list[index]['Disc_Percent']=item['Disc_Percent'];
        Item_list[index]['Rate']=item['Rate'];
        Item_list[index]['GST']=item['GST'];
        Item_list[index]['GST_Amount']=item['GST_Amount'];
        Item_list[index]['Net_Rate']=item['Net_Rate'];
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
        Updated_list.add(item);
        setState(() {
          Updated_list = Updated_list;
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


  callPostItemOpeningBal() async {
    String baseurl=await AppPreferences.getDomainLink();
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      FranchiseeSaleRequest model = FranchiseeSaleRequest(
          companyID: companyId,
          Franchisee_ID: selectedCopyFranchiseeId,
          Txn_Type:"S",
          date: DateFormat('yyyy-MM-dd').format(applicablefrom),
          modifier: creatorName,
          modifierMachine: deviceId,
          iNSERT: Inserted_list.toList(),
          uPDATE: Updated_list.toList(),
          dELETE: Deleted_list.toList()
      );
print("mosdeemmm  ${model.toJson()}");
      String apiUrl = baseurl + ApiConstants().franchisee_item_rate;
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=false;
              Item_list=[];
              Inserted_list=[];
              Updated_list=[];
              Deleted_list=[];
            });
            await callGetFrenchisee(1);

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

  bool isApiCall = false;
  callGetFrenchisee(int page) async {
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
            page: ""
        );
        String apiUrl = "$baseurl${ApiConstants().franchisee_item_rate_list}?Franchisee_ID=$selectedCopyFranchiseeId&Date=${DateFormat('yyyy-MM-dd').format(applicablefrom)}&Company_ID=$companyId&Txn_Type=S&pageNumber=$page&pageSize=10";
        print("newwww  $apiUrl   $baseurl ");
        //  "?pageNumber=$page&pageSize=12";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                 // Item_list=data;
                  print("ledger opening data....  $data");

                  List<dynamic> _arrList = [];
                //  _arrList.clear();
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

}

