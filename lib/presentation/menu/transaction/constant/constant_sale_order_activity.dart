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
import 'package:sweet_shop_app/presentation/menu/transaction/order/create_oredr_invoice_activity.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/transaction/saleInvoice/sale_invoice_request_model.dart';
import '../../../common_widget/deleteDialog.dart';
import '../../../common_widget/get_date_layout.dart';


class ConstantOrderActivity extends StatefulWidget {
  final String? comeFor;
  const ConstantOrderActivity({super.key, required mListener,  this.comeFor});

  @override
  State<ConstantOrderActivity> createState() => _ConstantOrderActivityState();
}

class _ConstantOrderActivityState extends State<ConstantOrderActivity>with CreateOrderInvoiceInterface {
  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<dynamic> saleInvoice_list=[];
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  bool isApiCall=false;
  bool disableColor = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    getSaleOrderedList(page);
  }
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getSaleOrderedList(page);
      }
    }
  }
  setDataToList(List<dynamic> _list) {
    if (saleInvoice_list.isNotEmpty) saleInvoice_list.clear();
    if (mounted) {
      setState(() {
        saleInvoice_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        saleInvoice_list.addAll(_list);
      });
    }
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
                  title:  Container(
                    width: SizeConfig.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.comeFor=="dash"?Container():GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: FaIcon(Icons.arrow_back),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              ApplicationLocalizations.of(context)!.translate("constant_order_invoice")!,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child:  Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4,left: 15,right: 15,bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getPurchaseDateLayout(),
                          const SizedBox(
                            height: 10,
                          ),
                          saleInvoice_list.isNotEmpty? getTotalCountAndAmount():
                          Container(),
                          const SizedBox(
                            height: .5,
                          ),
                          get_purchase_list_layout()
                        ],
                      ),
                    ),
                    Visibility(
                        visible: saleInvoice_list.isEmpty && isApiCall  ? true : false,
                        child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
                  ],
                ),
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
    );
  }

  /* Widget for navigate to next screen button  */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: ()async {
          print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^ $selectedItems");
          if (mounted) {
            setState(() {
              disableColor = true;
            });
          }
         await callPostToConverOrderToSale();

        },
        onDoubleTap: () {},
        child: Container(
          width: SizeConfig.screenWidth,
          height: 30,
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
                padding: EdgeInsets.only(left: parentWidth * .005) ,
                child:  Text(
                  ApplicationLocalizations.of(context)!.translate("save")!,
                  style: page_heading_textStyle,
                ),
              ),
            ],
          ),
        ),
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
          "No data available.",
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
              Text("${saleInvoice_list.length} ${ApplicationLocalizations.of(context)!.translate("orders")!} ", style: subHeading_withBold,),
              Text(CommonWidget.getCurrencyFormat(double.parse(TotalAmount)), style: subHeading_withBold,),
            ],
          )
      ),
    );
  }
  String TotalAmount="0.00";
  calculateTotalAmt()async{
    var total=0.00;
    for(var item  in saleInvoice_list ){
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
            saleInvoice_list.clear();
          });
          setState(() {
            invoiceDate=date!;
          });
          getSaleOrderedList(1);
        },
        applicablefrom: invoiceDate
    );
  }
  List selectedItems =[];
  Expanded get_purchase_list_layout() {

    return Expanded(
      child: ListView.separated(
        itemCount: saleInvoice_list.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: CheckboxListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ) ,

              tileColor: Colors.transparent,
              value: selectedItems.contains(saleInvoice_list[index]['Order_No']),
              onChanged: (bool? value) {
 

                if( value!){
                  setState(() {
                    selectedItems.add(saleInvoice_list[index]['Order_No']);
                  });
                }
                else{
                  setState(() {
                    selectedItems.remove(saleInvoice_list[index]['Order_No']);

                  });
                }
              },
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateOrderInvoice(
                        dateNew: invoiceDate,
                        Invoice_No: saleInvoice_list[index]['Order_No'],
                        mListener: this,
                        editedItem: saleInvoice_list[index],
                        come: "edit",
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 40, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${saleInvoice_list[index]['Vendor_Name']}", style: item_heading_textStyle),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.fileInvoice, size: 15, color: Colors.black.withOpacity(0.7)),
                          SizedBox(width: 10),
                          Expanded(child: Text("Order No. - ${saleInvoice_list[index]['Fin_Order_No']}", overflow: TextOverflow.clip, style: item_regular_textStyle)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FaIcon(FontAwesomeIcons.moneyBill1Wave, size: 15, color: Colors.black.withOpacity(0.7)),
                          SizedBox(width: 10),
                          Expanded(child: Text(CommonWidget.getCurrencyFormat(saleInvoice_list[index]['Total_Amount']), overflow: TextOverflow.clip, style: item_regular_textStyle)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 5);
        },
      ),
    );

  }


  getSaleOrderedList(int page) async {
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
        String apiUrl = "${baseurl}${ApiConstants().getOrderVendorList}?Company_ID=$companyId&Date=${DateFormat("yyyy-MM-dd").format(invoiceDate)}&pageNumber=$page&pageSize=10";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  List<dynamic> _arrList = [];
                  _arrList.clear();
                  _arrList=data;
                  print("orderDate    $data");
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

  callPostToConverOrderToSale() async {
    String creatorName = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    String companyId = await AppPreferences.getCompanyId();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if(netStatus==InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        // postSaleInvoiceRequestModel model = postSaleInvoiceRequestModel(
        //     companyID: companyId ,
        //     voucherName: "Sale",
        //     totalAmount:TotalAmountInt,
        //     date: DateFormat('yyyy-MM-dd').format(invoiceDate),
        //     creator: creatorName,
        //     creatorMachine: deviceId,
        //     iNSERT: selectedItems.toList(),
        //     remark: "Inserted"
        // );


          var model=  {
                        "Orders": selectedItems,
                        "Modifier":creatorName,
                        "Modifier_Machine":deviceId
                      };

          print(model);
        String apiUrl =baseurl + ApiConstants().orderToSaleConvert+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDynamicPI(apiUrl, model, "",
            onSuccess:(data)async{
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow=false;
                disableColor = false;
              });
              getSaleOrderedList(1);

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

  @override
  backToList(DateTime updateDate) {
    // TODO: implement backToList

    setState(() {
      saleInvoice_list.clear();
      invoiceDate=updateDate;
    });
    getSaleOrderedList(1);
    Navigator.pop(context);
  }
}
