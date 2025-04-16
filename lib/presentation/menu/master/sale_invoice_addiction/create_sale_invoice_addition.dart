import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/api/request_helper.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/presentation/common_widget/deleteDialog.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_date_layout.dart';
import 'package:sweet_shop_app/presentation/dialog/back_page_dialog.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/ledger_searchable_dropdown.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/searchable_dropdown_for_string_array.dart';
import 'package:sweet_shop_app/presentation/searchable_dropdowns/serchable_drop_down_for_existing_list.dart';
import '../../../../../core/app_preferance.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/common_style.dart';
import '../../../../../core/internet_check.dart';
import '../../../../../core/localss/application_localizations.dart';
import '../../../../../core/size_config.dart';
import 'add_or_edit_sale_invoice_addition.dart';


class CrateSaleOrder extends StatefulWidget {

  final CrateSaleOrderInterface mListener;
  final dateNew;
  final order_No;
  final order_No_Fin;
  final editedItem;
  final come;
  final readOnly;
  final oldUnit;
  final invoiceNo;
  final String title;
  final String itemName;
  final String setText;
  final String logoImage;
  const CrateSaleOrder({super.key, required this.dateNew,
    required this.mListener,
    required this.order_No,
    this.editedItem,
    this.come,
    this.readOnly, this.invoiceNo, required this.logoImage, required this.title, required this.setText, this.order_No_Fin, required this.itemName, this.oldUnit});


  @override
  State<CrateSaleOrder> createState() => _CrateSaleOrderState();
}

class _CrateSaleOrderState extends State<CrateSaleOrder> with SingleTickerProviderStateMixin,AddOrEditInvoiceAdditionInterface{
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  DateTime invoiceDate = DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _voucherNoFocus = FocusNode();
  final VoucherNoController = TextEditingController();

  TextEditingController invoiceNo = TextEditingController();

  String selectedVendorName = "";
  dynamic selectedVendorId = "";
  var selectedVoucherType="";

  List<dynamic> Item_list = [];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  var companyId = "0";
  bool isLoaderShow = false;
  bool showButton = false;
  var editedItemIndex = null;
  var invoice_No;
  double minX = 30;
  double minY = 30;
  double maxX = SizeConfig.screenWidth*0.78;
  double maxY = SizeConfig.screenHeight*0.85;
  Offset position = Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.85);
  String TotalAmount = "0.00";
  var roundoff = "0.00";
  final _formkey = GlobalKey<FormState>();
  String selectedRouteId="";
  String selectedRouteName="";
  String selectedVehicalNo = "";
  String selectedTransporter="";
  String selectedDriverName="";
  String selectedDriverMobile="";
  String finInvoiceNo = "";
  String setText = "";
  var franchiseereadonly=true;
  var company_details=null;
  var partyState=null;

  var sno=null;
  var gno=null;

  void _updateOffset(Offset newOffset) {
    setState(() {
      // Clamp the Offset values to stay within the defined constraints
      double clampedX = newOffset.dx.clamp(minX, maxX);
      double clampedY = newOffset.dy.clamp(minY, maxY);
      position = Offset(clampedX, clampedY);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoice_No = widget.invoiceNo;
    invoiceDate = widget.dateNew;
    setText=widget.setText;
    print("knfnnffnmn  ${widget.setText}  ${widget.title}");
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if(widget.order_No!=null){
      unit=widget.oldUnit;
      selectedItemId=widget.order_No;
      selectedItemName=widget.itemName;
      getOrderInvoice(1);
    }

  }






  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (showButton == true) {
                      await showCustomDialog(context);
                      return false;
                    } else {
                      return true;
                    }
        },
        child: contentBox(context));
  }


  Future<void> showCustomDialog(BuildContext context) async {
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
                if (value == "yes") {
                  if(selectedItemId!=""&&Item_list.length>0) {

                      print("#######");
                      postSaleInvoiceAddition();
                 
                  }
                  else if(selectedItemId==""){
                    var snackBar = SnackBar(content: Text('Select item !'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if(Item_list.length==0){
                    var snackBar=const SnackBar(content: Text("Add atleast one item!"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                }
              },
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation2, animation1) {
        return Container();
      },
    );
  }


  Widget contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: SizeConfig.safeUsedHeight,
          width: SizeConfig.screenWidth,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: CommonColor.BACKGROUND_COLOR,
            // borderRadius: BorderRadius.circular(16.0),
          ),
          child: Scaffold(
            backgroundColor: CommonColor.BACKGROUND_COLOR,
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
                            child:Center(
                              child: Text(
                                ApplicationLocalizations.of(context).translate("sale_invoice_addition"),
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10.0),

                    // color: CommonColor.DASHBOARD_BACKGROUND,
                      child: getAllFields(
                          SizeConfig.screenHeight, SizeConfig.screenWidth)),
                ),
                Item_list.isEmpty && showButton==false?Container(): Container(
                    padding: EdgeInsets.all(10.0),

                    decoration: BoxDecoration(
                      color: CommonColor.WHITE_COLOR,
                      border: Border(
                        top: BorderSide(
                          color: Colors.black.withOpacity(0.08),
                          width: 1.0,
                        ),
                      ),
                    ),
                    height: SizeConfig.safeUsedHeight * .12,
                    child: getSaveAndFinishButtonLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth)),
                CommonWidget.getCommonPadding(
                    SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
              ],
            ),
          ),
        ),

       Positioned(
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
                  backgroundColor: CommonColor.THEME_COLOR,
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white ,
                  ),
                  onPressed: () async {

                    FocusScope.of(context)
                        .requestFocus(FocusNode());

                    if(selectedItemId!="") {
                      editedItemIndex = null;
                      goToAddOrEditItem(null);
                      if (mounted) {
                        setState(() {
                          showButton = false;
                        });
                      }
                    }
                    else if(selectedItemId==""){
                      var snackBar = SnackBar(content: Text('Select item!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }


                  })
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  /* Widget for navigate to next screen button  */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TotalAmount!="0.00"? Container(
          width: SizeConfig.halfscreenWidth,
          padding: EdgeInsets.only(top: 0, bottom: 0),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${ApplicationLocalizations.of(context)!
                    .translate("items")!}: ${Item_list.length} ",
                style:
                item_regular_textStyle.copyWith(color: Colors.grey),
              ),
              Text(
                "${ApplicationLocalizations.of(context)!
                    .translate("round_off")!}:  ${roundoff}",
                style: item_regular_textStyle.copyWith(fontSize: 17),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "${CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble())}",
                style: item_heading_textStyle,
              ),
            ],
          ),
        ):Container(),
       showButton==false?Container(): GestureDetector(
          onTap: () {
            if(selectedItemId!=""&&Item_list.length>0) {
                print("#######");
                postSaleInvoiceAddition();
                       
            }
            else if(selectedItemId==""){
              var snackBar = SnackBar(content: Text('Select item !'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if(Item_list.length==0){
              var snackBar=const SnackBar(content: Text("Add atleast one item!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

          },
          onDoubleTap: () {},
          child: Container(
            width: SizeConfig.halfscreenWidth,
            height: 50,
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
                  child: Text(
                    ApplicationLocalizations.of(context)!
                        .translate("save")!,
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
  bool isItemList=true;
  Widget getAllFieldsList(double parentHeight, double parentWidth) {
    return isLoaderShow
        ? Container()
        : ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              child: Column(
                children: [
                  InvoiceInfo(),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      left: 5,
                      right: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.only(right:0,left: 0,top: 0,bottom: 0),
                      // backgroundColor: CommonColor.THEME_COLOR,
                      // collapsedBackgroundColor: CommonColor.THEME_COLOR,
                      onExpansionChanged: (v){
                        setState(() {
                          isItemList=v;
                        });
                      },
                      title:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth*.70,
                            decoration: BoxDecoration(
                                color: CommonColor.THEME_COLOR,
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  ApplicationLocalizations.of(context)!
                                      .translate("item")!,
                                  style: subHeading_withBold.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),

                          widget.readOnly?(gno!=null||sno!=null)?Container():
                          DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<0?
                          Container():
                          FloatingActionButton(
                            mini: true,
                            backgroundColor: CommonColor.THEME_COLOR,
                            onPressed: () {

                              setState(() {
                                showButton == true;
                                editedItemIndex=null;
                              });
                              goToAddOrEditItem(null);
                            },
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            ),
                          ):Container(),
                        ],
                      ),
                      children: [
                        for (var index = 0; index < Item_list.length; index++)
                          GestureDetector(
                              onTap: () async{
                                print("*************** ${DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))}");

                                setState(() {
                                  editedItemIndex = index;

                                });
                                // if (widget.readOnly == false) {
                                // } else {
                                //   FocusScope.of(context).requestFocus(FocusNode());
                                //   if (context != null) {
                                //   }
                                // }
                                print("OUT ${ DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<=0 } ${(gno!=null)}");

                                if((gno!=null||sno!=null)) {
                                  print("INSIDE ${ DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<=0 } ${(gno!=null)}");
                                }
                                else if( DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))>=0 ){
                                  setState(() {
                                    editedItemIndex = index;
                                  });
                                  await   goToAddOrEditItem(Item_list[index]);
                                }

                                //
                                // if((gno!=null||sno!=null)) {
                                //   print("INSIDE ${ DateFormat("yyyy-MM-dd").format(DateTime.parse((widget.dateNew).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<=0 } ${(gno!=null)}");
                                // }
                                // else if( DateFormat("yyyy-MM-dd").format(DateTime.parse((widget.dateNew).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))>=0 ){
                                //   setState(() {
                                //     editedItemIndex = index;
                                //   });
                                //   goToAddOrEditItem(Item_list[index]);
                                // }


                              },
                              child:Card(
                                // color: CommonColor.WHITE_COLOR,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: CommonColor.THEME_COLOR,

                                        child: Text("${index + 1}", style: TextStyle(color: Colors.white)),
                                      ),
                                      title: Text( "${Item_list[index]['Item_Name']}", style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600)),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // if (product['Unit'].isNotEmpty) Text(product['Unit']),
                                              Item_list[index]['Quantity']!=null? Container(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text( "${Item_list[index]['Unit']} :  "+
                                                      CommonWidget.getCurrencyFormat(
                                                          double.parse(Item_list[
                                                          index]
                                                          [
                                                          'Quantity']
                                                              .toString()))
                                                          .toString() ,
                                                    // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                                    overflow: TextOverflow.clip,
                                                    style: item_heading_textStyle
                                                        .copyWith(
                                                        color:
                                                        Colors.grey),
                                                  )):Container(),
                                              SizedBox(width: 10,),

                                              Item_list[index]['Rate']!=null? Container(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text( "Rate : "+
                                                      CommonWidget.getCurrencyFormat(
                                                          double.parse(Item_list[
                                                          index]
                                                          [
                                                          'Rate']
                                                              .toString()))
                                                          .toString() ,
                                                    // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                                    overflow: TextOverflow.clip,
                                                    style: item_heading_textStyle
                                                        .copyWith(
                                                        color:
                                                        Colors.grey),
                                                  )):Container(),

                                            ],
                                          ),
                                          Container(
                                              alignment:
                                              Alignment.centerLeft,
                                              child: Text("GST : "+CommonWidget.getCurrencyFormat(calculategst(Item_list[index]))
                                                  .toString(),
                                                // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                                overflow: TextOverflow.clip,
                                                style: item_heading_textStyle
                                                    .copyWith(
                                                    color:
                                                    Colors.grey),
                                              )),
                                          SizedBox(height: 5,),
                                          Divider(height: 1,),

                                          DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<0 ?Container():
                                          (gno!=null||sno!=null)? SizedBox(height: 5,):Container(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // if (product['Unit'].isNotEmpty) Text(product['Unit']),


                                              Item_list[index]['Net_Amount']!=null? Container(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    CommonWidget.getCurrencyFormat(
                                                        double.parse(Item_list[
                                                        index]
                                                        [
                                                        'Net_Amount']
                                                            .toString()))
                                                        .toString() ,
                                                    // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                                    overflow: TextOverflow.clip,
                                                    style: item_heading_textStyle
                                                        .copyWith(
                                                        color:
                                                        Colors.blue),
                                                  )):Container(),
                                              (gno!=null||sno!=null)?Container() :
                                              DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<0?
                                              Container():
                                              Container(
                                                  width: parentWidth * .1,
                                                  // height: parentHeight*.1,
                                                  color: Colors.transparent,
                                                  child: DeleteDialogLayout(
                                                      callback: (response) async {
                                                        if (response == "yes") {

                                                          setState(() {
                                                            Item_list.removeAt(index);
                                                            Item_list=Item_list;
                                                            showButton=true;
                                                          });
                                                          await calculateTotalAmt();
                                                        }
                                                      })),
                                            ],
                                          ),

                                        ],
                                      ),
                                      /* trailing:   Container(
                      width: parentWidth * .1,
                      // height: parentHeight*.1,
                      color: Colors.transparent,
                      child: DeleteDialogLayout(
                          callback: (response) async {
                            if (response == "yes") {

                              setState(() {
                                Item_list.removeAt(index);
                                Item_list=Item_list;
                                showButton=true;
                              });
                              await calculateTotalAmt();
                            }
                          })),*/

                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5),
                                      child: Divider(height: 1,),
                                    )
                                  ],
                                ),
                              )
                            // Card(
                            //   child: Row(
                            //     children: [
                            //       Expanded(
                            //         child: Container(
                            //             margin: const EdgeInsets.only(
                            //                 top: 10, left: 10, right: 0, bottom: 10),
                            //             child: Row(
                            //               children: [
                            //                 Container(
                            //                     width: parentWidth * .1,
                            //                     height: parentWidth * .1,
                            //                     decoration: BoxDecoration(
                            //                         color: CommonColor.THEME_COLOR.withOpacity(0.8),
                            //                         borderRadius:
                            //                         BorderRadius.circular(100)),
                            //                     alignment: Alignment.center,
                            //                     child: Text(
                            //                       "${index + 1}",
                            //                       textAlign: TextAlign.center,
                            //                       style: item_list.copyWith(
                            //                           fontSize: 20),
                            //                     )),
                            //                 Container(
                            //                   padding: EdgeInsets.only(left: 10),
                            //                   width: parentWidth * .70,
                            //                   //  height: parentHeight*.1,
                            //                   child: Column(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.start,
                            //                     crossAxisAlignment:
                            //                     CrossAxisAlignment.start,
                            //                     children: [
                            //                       Text(
                            //                         "${Item_list[index]['Item_Name']}",
                            //                         style: item_heading_textStyle,
                            //                       ),
                            //                       SizedBox(
                            //                         height: 5,
                            //                       ),
                            //                       Row(
                            //                         mainAxisAlignment:
                            //                         MainAxisAlignment.spaceBetween,
                            //                         children: [
                            //                           Item_list[
                            //                           index]
                            //                           [
                            //                           'Quantity']!=null? Container(
                            //                               alignment:
                            //                               Alignment.centerRight,
                            //                               child: Row(
                            //                                 children: [
                            //
                            //                                   Item_list[index]['Unit']=="null"?Text(""):Text( "${Item_list[index]['Unit']}:  ",
                            //                                     // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                            //                                     overflow: TextOverflow.clip,
                            //                                     style: item_heading_textStyle
                            //                                         .copyWith(
                            //                                         color:
                            //                                         Colors.black87),
                            //                                   ),
                            //                                   Text(  CommonWidget.getCurrencyFormat(
                            //                                         double.parse(Item_list[
                            //                                         index]
                            //                                         [
                            //                                         'Quantity']
                            //                                             .toString()))
                            //                                         .toString() ,
                            //                                     // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                            //                                     overflow: TextOverflow.clip,
                            //                                     style: item_heading_textStyle
                            //                                         .copyWith(
                            //                                         color:
                            //                                         Colors.black87),
                            //                                   ),
                            //                                 ],
                            //                               )):Container(),
                            //                           Item_list[index]
                            //                           ['Net_Amount']!=null? Container(
                            //                             alignment: Alignment.centerRight,
                            //                             width:
                            //                             SizeConfig.halfscreenWidth -
                            //                                 50,
                            //                             child: Text(
                            //                               CommonWidget.getCurrencyFormat(
                            //                                   Item_list[index]
                            //                                   ['Net_Amount']),
                            //                               overflow: TextOverflow.ellipsis,
                            //                               style: item_heading_textStyle
                            //                                   .copyWith(
                            //                                   color: Colors.blue),
                            //                             ),
                            //                           ):Container(),
                            //                         ],
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //
                            //                 Container(
                            //                     width: parentWidth * .1,
                            //                     // height: parentHeight*.1,
                            //                     color: Colors.transparent,
                            //                     child: DeleteDialogLayout(
                            //                         callback: (response) async {
                            //                           if (response == "yes") {
                            //
                            //                             setState(() {
                            //                               Item_list.removeAt(index);
                            //                               Item_list=Item_list;
                            //                               showButton=true;
                            //                             });
                            //                             await calculateTotalAmt();
                            //                           }
                            //                         })),
                            //               ],
                            //             )),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          ),
                      //     GestureDetector(
                      //         onTap: (){
                      //           if(widget.readOnly) {
                      //             setState(() {
                      //               editedItemIndex=index;
                      //             });
                      //             goToAddOrEditItem(Item_list[index]);
                      //           }
                      //         },
                      //         child:Card(
                      //           child: Column(
                      //             children: [
                      //               ListTile(
                      //                 leading: CircleAvatar(
                      //                   backgroundColor: CommonColor.THEME_COLOR,
                      //                   radius: 20,
                      //                   child: Text("${index + 1}", style: TextStyle(color: Colors.white,fontSize: 14)),
                      //                 ),
                      //                 title: Text( "${Item_list[index]['Item_Name']}", style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600)),
                      //                 subtitle: Column(
                      //                   children: [
                      //                     Row(
                      //                       crossAxisAlignment: CrossAxisAlignment.start,
                      //                       children: [
                      //                         // if (product['Unit'].isNotEmpty) Text(product['Unit']),
                      //                         Item_list[index]['Quantity']!=null? Container(
                      //                             alignment:
                      //                             Alignment.centerLeft,
                      //                             child: Text( "${Item_list[index]['Unit']} :  "+
                      //                                 CommonWidget.getCurrencyFormat(
                      //                                     double.parse(Item_list[
                      //                                     index]
                      //                                     [
                      //                                     'Quantity']
                      //                                         .toString()))
                      //                                     .toString() ,
                      //                               // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                      //                               overflow: TextOverflow.clip,
                      //                               style: item_heading_textStyle
                      //                                   .copyWith(
                      //                                   color:
                      //                                   Colors.grey),
                      //                             )):Container(),
                      //                         SizedBox(width: 10,),
                      //
                      //                         Item_list[index]['Rate']!=null? Container(
                      //                             alignment:
                      //                             Alignment.centerLeft,
                      //                             child: Text( "Rate : "+
                      //                                 CommonWidget.getCurrencyFormat(
                      //                                     double.parse(Item_list[
                      //                                     index]
                      //                                     [
                      //                                     'Rate']
                      //                                         .toString()))
                      //                                     .toString() ,
                      //                               // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                      //                               overflow: TextOverflow.clip,
                      //                               style: item_heading_textStyle
                      //                                   .copyWith(
                      //                                   color:
                      //                                   Colors.grey),
                      //                             )):Container(),
                      //
                      //                       ],
                      //                     ),
                      //                     Container(
                      //                         alignment:
                      //                         Alignment.centerLeft,
                      //                         child: Text("GST : "+CommonWidget.getCurrencyFormat(calculategst(Item_list[index]))
                      //                             .toString(),
                      //                           // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                      //                           overflow: TextOverflow.clip,
                      //                           style: item_heading_textStyle
                      //                               .copyWith(
                      //                               color:
                      //                               Colors.grey),
                      //                         )),
                      //
                      //                     SizedBox(height: 5,),
                      //                     Divider(height: 1,),
                      //                     Row(
                      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //
                      //                       children: [
                      //                         // if (product['Unit'].isNotEmpty) Text(product['Unit']),
                      //
                      //
                      //
                      //                         Item_list[index]['Net_Amount']!=null? Container(
                      //                             alignment:
                      //                             Alignment.centerLeft,
                      //                             child: Text(
                      //                               CommonWidget.getCurrencyFormat(
                      //                                   double.parse(Item_list[
                      //                                   index]
                      //                                   [
                      //                                   'Net_Amount']
                      //                                       .toString()))
                      //                                   .toString() ,
                      //                               // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                      //                               overflow: TextOverflow.clip,
                      //                               style: item_heading_textStyle
                      //                                   .copyWith(
                      //                                   color:
                      //                                   Colors.blue),
                      //                             )):Container(),
                      //
                      //                         Container(
                      //                             width: parentWidth * .1,
                      //                             // height: parentHeight*.1,
                      //                             color: Colors.transparent,
                      //                             child: DeleteDialogLayout(
                      //                                 callback: (response) async {
                      //                                   if (response == "yes") {
                      //
                      //                                     setState(() {
                      //                                       Item_list.removeAt(index);
                      //                                       Item_list=Item_list;
                      //                                       showButton=true;
                      //                                     });
                      //                                     calculateTotalAmt();
                      //                                   }
                      //                                 })),
                      //
                      //                       ],
                      //                     ),
                      //
                      //                   ],
                      //                 ),
                      //                 /* trailing:   Container(
                      // width: parentWidth * .1,
                      // // height: parentHeight*.1,
                      // color: Colors.transparent,
                      // child: DeleteDialogLayout(
                      //     callback: (response) async {
                      //       if (response == "yes") {
                      //
                      //         setState(() {
                      //           Item_list.removeAt(index);
                      //           Item_list=Item_list;
                      //           showButton=true;
                      //         });
                      //         await calculateTotalAmt();
                      //       }
                      //     })),*/
                      //
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.only(left: 5,right: 5),
                      //                 child: Divider(height: 1,),
                      //               )
                      //             ],
                      //           ),
                      //         )
                      //     ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      left: 5,
                      right: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.only(right:0,left: 0,top: 0,bottom: 0),
                      // backgroundColor: CommonColor.THEME_COLOR,
                      // collapsedBackgroundColor: CommonColor.THEME_COLOR,
                      onExpansionChanged: (v){
                        setState(() {
                          isItemList=v;
                        });
                      },
                      title:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth*.70,
                            decoration: BoxDecoration(
                                color: CommonColor.THEME_COLOR,
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  ApplicationLocalizations.of(context)!
                                      .translate("service")!,
                                  style: subHeading_withBold.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          widget.readOnly?(gno!=null||sno!=null)?Container():
                          DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<0?
                          Container():
                          FloatingActionButton(
                            mini: true,
                            backgroundColor: CommonColor.THEME_COLOR,
                            onPressed: () {
                              setState(() {
                                showButton == true;
                                editedItemIndex=null;
                              });
                            },
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            ),
                          ):Container(),
                        ],
                      ),
                      children: [
                        for (var index = 0; index < ServiceList.length; index++)
                          GestureDetector(
                              onTap: (){
                                print("*************** ${DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))}");

                                setState(() {
                                  editedItemIndex = index;

                                });
                                // if (widget.readOnly == false) {
                                // } else {
                                //   FocusScope.of(context).requestFocus(FocusNode());
                                //   if (context != null) {
                                //   }
                                // }
                                print("OUT ${ DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<=0 } ${(gno!=null)}");

                                if((gno!=null||sno!=null)) {
                                  print("INSIDE ${ DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<=0 } ${(gno!=null)}");
                                }
                                else if( DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))>=0 ){
                                  setState(() {
                                    editedItemIndex=index;
                                  });
                                  if(widget.readOnly) {
                             }
                                }


                              },
                              child:Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: CommonColor.THEME_COLOR,
                                        radius: 20,
                                        child: Text("${index + 1}", style: TextStyle(color: Colors.white,fontSize: 14)),
                                      ),
                                      title: Text( "${ServiceList[index]['Charge_Name']}", style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600)),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // if (product['Unit'].isNotEmpty) Text(product['Unit']),
                                              ServiceList[index]['Quantity']!=null? Container(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text( ServiceList[index]['Unit']!=null?"${ServiceList[index]['Unit']} :  ":" "+
                                                      CommonWidget.getCurrencyFormat(
                                                          double.parse(ServiceList[
                                                          index]
                                                          [
                                                          'Quantity']
                                                              .toString()))
                                                          .toString() ,
                                                    // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                                    overflow: TextOverflow.clip,
                                                    style: item_heading_textStyle
                                                        .copyWith(
                                                        color:
                                                        Colors.grey),
                                                  )):Container(),
                                              SizedBox(width: 10,),

                                              ServiceList[index]['Net_Rate']!=null? Container(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text( "Rate : "+
                                                      CommonWidget.getCurrencyFormat(
                                                          double.parse(ServiceList[
                                                          index]
                                                          [
                                                          'Net_Rate']
                                                              .toString()))
                                                          .toString() ,
                                                    // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                                    overflow: TextOverflow.clip,
                                                    style: item_heading_textStyle
                                                        .copyWith(
                                                        color:
                                                        Colors.grey),
                                                  )):Container(),

                                            ],
                                          ),
                                          Container(
                                              alignment:
                                              Alignment.centerLeft,
                                              child: Text("GST : "+CommonWidget.getCurrencyFormat(calculategst(ServiceList[index]))
                                                  .toString(),
                                                // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                                overflow: TextOverflow.clip,
                                                style: item_heading_textStyle
                                                    .copyWith(
                                                    color:
                                                    Colors.grey),
                                              )),

                                          SizedBox(height: 5,),
                                          Divider(height: 1,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              // if (product['Unit'].isNotEmpty) Text(product['Unit']),



                                              ServiceList[index]['Net_Amount']!=null? Container(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    CommonWidget.getCurrencyFormat(
                                                        double.parse(ServiceList[
                                                        index]
                                                        [
                                                        'Net_Amount']
                                                            .toString()))
                                                        .toString() ,
                                                    // "${(double.parse(ServiceList[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                                    overflow: TextOverflow.clip,
                                                    style: item_heading_textStyle
                                                        .copyWith(
                                                        color:
                                                        Colors.blue),
                                                  )):Container(),

                                              (gno!=null||sno!=null)?Container() :
                                              DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<0?
                                              Container(): Container(
                                                  width: parentWidth * .1,
                                                  // height: parentHeight*.1,
                                                  color: Colors.transparent,
                                                  child: DeleteDialogLayout(
                                                      callback: (response) async {
                                                        if (response == "yes") {

                                                          setState(() {
                                                            ServiceList.removeAt(index);
                                                            ServiceList=ServiceList;
                                                            showButton=true;
                                                          });
                                                          calculateTotalAmt();
                                                        }
                                                      })),

                                            ],
                                          ),

                                        ],
                                      ),
                                      /* trailing:   Container(
                      width: parentWidth * .1,
                      // height: parentHeight*.1,
                      color: Colors.transparent,
                      child: DeleteDialogLayout(
                          callback: (response) async {
                            if (response == "yes") {

                              setState(() {
                                Item_list.removeAt(index);
                                Item_list=Item_list;
                                showButton=true;
                              });
                              await calculateTotalAmt();
                            }
                          })),*/

                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5),
                                      child: Divider(height: 1,),
                                    )
                                  ],
                                ),
                              )
                          ),
                      ],
                    ),
                  )
                  // Item_list.length > 0
                  //     ? get_Item_list_layout(SizeConfig.screenHeight,
                  //     SizeConfig.screenWidth)
                  //     : Container()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  List<dynamic> ServiceList = [];

  @override
  AddOrEditServiceDetailDetail(item)async {
    // TODO: implement AddOrEditServiceDetailDetail
    var itemLlist = ServiceList;
    showButton = true;
    if (editedItemIndex != null) {
      var index = editedItemIndex;
      setState(() {
        ServiceList[index]['Charge_Name'] = item['Charge_Name'];
        ServiceList[index]['Charge_Code'] = item['Charge_Code'];
        ServiceList[index]['Quantity'] = item['Quantity'];
        ServiceList[index]['Unit'] = item['Unit'];
        ServiceList[index]['Rate'] = item['Rate'];
        ServiceList[index]['Amount'] = item['Amount'];
        ServiceList[index]['Disc_Percent'] = item['Disc_Percent'];
        ServiceList[index]['Disc_Amount'] = item['Disc_Amount'];
        ServiceList[index]['Taxable_Amount'] = item['Taxable_Amount'];
        ServiceList[index]['IGST_Rate'] = item['IGST_Rate'];
        ServiceList[index]['IGST_Amount'] = item['IGST_Amount'];
        ServiceList[index]['CGST_Rate'] = item['CGST_Rate'];
        ServiceList[index]['CGST_Amount'] = item['CGST_Amount'];
        ServiceList[index]['SGST_Rate'] = item['SGST_Rate'];
        ServiceList[index]['SGST_Amount'] = item['SGST_Amount'];
        ServiceList[index]['Net_Rate'] = item['Net_Rate'];
        ServiceList[index]['Net_Amount'] = item['Net_Amount'];
        ServiceList[index]['Charge_Description'] = item['Charge_Description'];
        ServiceList[index]['HSN_No'] = item['HSN_No'];
      });
      setState(() {
        ServiceList=ServiceList;
      });

    } else {
      itemLlist.add(item);
      print(itemLlist);

      setState(() {
        ServiceList = itemLlist;
      });
    }
    setState(() {
      editedItemIndex = null;
      showButton=true;

    });
    await calculateTotalAmt();
    print("List");
    print(ServiceList);

  }
  calculateTotalAmt() async {
    setState(() {
      TotalAmount = "0.00";
      roundoff = "0.00";
    });
    var total = 0.00;
    for (var item in Item_list) {
      total = total + item['Rate'];
      // print(item['Amount']);
    }

    for (var item in ServiceList) {
      total = total + item['Rate'];
      // print(item['Amount']);
    }
    // var amt = double.parse((total.toString()).substring((total.toString()).length - 3, (total.toString()).length)).toStringAsFixed(3);
    double amt = total % 1;

    print("%%%%%%%%%%%%%%%%%%%%% $amt");
    if (double.parse((total.toString()).substring(
        (total.toString()).length - 3, (total.toString()).length)) ==
        0.0) {
      var total1 = (total).floorToDouble();
      setState(() {
        roundoff = "0.00";
        TotalAmount = total1.toStringAsFixed(2);
      });
    } else {
      if ((amt) < 0.50) {
        print("Here");
        var total1 = (total).floorToDouble();
        var roff = total1 - (total);
        setState(() {
          TotalAmount = total1.toStringAsFixed(2);
          roundoff = roff.toStringAsFixed(2);
        });
      } else if ((amt) >= 0.50) {
        setState(() {
          roundoff = (1 - amt).toStringAsFixed(2);
          TotalAmount = (total.ceilToDouble()).toStringAsFixed(2);
        });
      }
    }
  }

  Widget getAllFields(double parentHeight, double parentWidth) {
    return isLoaderShow
        ? Container()
        : ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              child: Column(
                children: [
                  InvoiceInfo(),
                  SizedBox(
                    height: 10,
                  ),
                  Item_list.length > 0
                      ? get_Item_list_layout(SizeConfig.screenHeight,
                      SizeConfig.screenWidth)
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container InvoiceInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        children: [
          SizedBox(height: 10,),
          getPartyNameLayout(SizeConfig.screenHeight, SizeConfig.halfscreenWidth),
          widget.order_No!=null?Row(
            children: [
              Expanded(child: getPurchaseDateLayout()),
              // SizedBox(width: 5,),
              // getInvoiceNo(SizeConfig.screenHeight, SizeConfig.halfscreenWidth),

            ],
          ):getPurchaseDateLayout(),
          SizedBox(height: 10,),
        /*  setText==StringEn.saleOrder?gettranspoter_detail():Container(),
          //getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
          // SizedBox(width: 5,),*/
        ],
      ),
    );
  }

  GestureDetector gettranspoter_detail() {
    return GestureDetector(
      onTap: ()async{

        print("%%%%%%%%%%%%%");
        print(selectedVehicalNo);
        print(selectedRouteName);
        print(selectedVehicalNo);
        print(selectedRouteName);
      },
      child: Container(
        decoration: BoxDecoration(
            color: CommonColor.THEME_COLOR,
            borderRadius: BorderRadius.circular(5)
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(ApplicationLocalizations.of(context)!.translate("transport_detail")!,style: subHeading_withBold.copyWith(color: Colors.white),),
            Icon(Icons.check_circle_outline,color: Colors.white,size: 18 ,)
          ],
        ),
      ),
    );
  }

  Widget getInvoiceNo(double parentHeight, double parentWidth) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      width: parentWidth,
      height: (SizeConfig.screenHeight) * .057,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: CommonColor.WHITE_COLOR,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Text(
        "${ApplicationLocalizations.of(context)!.translate("order")!}: ${widget.order_No}",
        style: item_heading_textStyle,
      ),
    );
  }

String stateName="";
  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout() {
    return GetDateLayout(
     // readOnly:   (gno!=null||sno!=null)?true:
     //  DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<0?
     //  true:false,
        titleIndicator: true,
        title: ApplicationLocalizations.of(context)!.translate("applicable_form")!,
        callback: (date) {
          setState(() {
            invoiceDate = date!;
            showButton=true;
            // Item_list = [];
          });

        },
      applicablefrom: invoiceDate,
     // fdate:DateFormat("yyyy-MM-dd").format(DateTime.parse(invoiceDate.toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))>=0 ?DateTime.now(): invoiceDate,
    );
  }
  final _fstateKey = GlobalKey<FormFieldState>();
  var partygst=null;
  var itemData=null;
bool visibility=false;
  String selectedItemName = "";
  String selectedItemId = "";
  String unit = "";
  String rate = "";
  List<dynamic> itemL = [];
  FocusNode itemFocus = FocusNode() ;
  final _itemKey = GlobalKey<FormFieldState>();

  TextEditingController quantity = TextEditingController();
  FocusNode quantityFocus = FocusNode() ;
  /* Widget to get Franchisee Name Layout */
  Widget getPartyNameLayout(double parentHeight, double parentWidth) {
    return SearchableDropdownWithExistingList(
      mandatory: true,
      name: selectedItemName,
      come: "",
      focusnext: quantityFocus,
      focuscontroller: itemFocus,
      status: selectedItemName==""?"":"edit",
      apiUrl:"${ApiConstants().item_list}?Date=${DateFormat('yyyy-MM-dd').format(invoiceDate)}&",
      titleIndicator: true,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      insertedList:itemL,
      callback: (item) async {
print("jnngtngt  $item");
if(item!="") {
  setState(() {
    selectedItemId = item['ID'].toString();
    selectedItemName = item['Name'].toString();
    unit = item['Unit'] != null ? item['Unit'] : null;
    rate = item['Rate'] == null ? "" : item['Rate'].toString();
 //   itemL = item;
  });
  print("hgdghdgh  $unit  $rate");
}else{
  setState(() {
    selectedItemId="";
    selectedItemName="";
    unit="";
    rate="";
    itemL=[];
  });

}
      },
    );  /*SearchableLedgerDropdown(
      apiUrl:
      "${ApiConstants().item_list}?Date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}&",
      titleIndicator: true,
      ledgerName: widget.itemName,
      franchisee: "edit",
      franchiseeName: widget.itemName,
      readOnly: true,
      title: ApplicationLocalizations.of(context)!.translate("item")!,
      callback: (name, id) {
        setState(() {
          selectedItemName = name!;
          selectedItemId = id.toString()!;
        });
        // array_list = [];
        // getReportList(1);
      },
    ); */ /* return CommonDropdown(
      mandatory: true,
      apiUrl: ApiConstants().ledger+"?Group_ID=null&",
      nameField:"Name",
      idField:"ID",
      titleIndicator: true,
      ledgerName: selectedVendorName,
      franchiseeName:  selectedVendorName,
      franchisee: selectedVendorName!=null?"edit":"",
      readOnly:widget.editedItem!=null?false: true,
      title: ApplicationLocalizations.of(context)!.translate("party")!,
      callback: (item)async {
        print(item);
        setState(() {
          showButton = true;
          selectedVendorName = item['Name']!;
          selectedVendorId = item['ID'].toString();
          partyState=item['State'];
          partygst=item['GST_No'];
          position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
        });
        print("kghj  $company_details");
        if(company_details!=null){
          visibility=company_details[0]['State']==partyState?true:false;
        }else{
          visibility=false;
        }
        // company_details!=[]?
        // company_details[0]['State']==partyState?true:false:false,
        // cAndsgstApplicable:company_details!=[]?
        // company_details[0]['State']==partyState?true:false:false,
        await getRoutebyPartId();

        print("############3");
        print(selectedVendorId + "\n" + selectedVendorName);

      },
    );
*/

  }



  calculategst(item){

  if(item['IGST_Amount']!=null){
      return double.parse(item['IGST_Amount'].toString());
    }
    else if(item['CGST_Amount']!=null || item['SGST_Amount']!=null){
      var cgst=item['CGST_Amount']==null?0.0:double.parse(item['CGST_Amount'].toString());
      var sgst=item['SGST_Amount']==null?0.0:double.parse(item['SGST_Amount'].toString());
      return cgst+sgst;
    }
    else{
      return 0.00;
  }

  }


  Widget get_Item_list_layout(double parentHeight, double parentWidth) {
    print("kjdfjffjfj  ${Item_list.length}");
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Item_list.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async{
            print("*************** ${DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))}");
            
            setState(() {
              editedItemIndex = index;

            });
            // if (widget.readOnly == false) {
            // } else {
            //   FocusScope.of(context).requestFocus(FocusNode());
            //   if (context != null) {
            //   }
            // }
            print("OUT ${ DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<=0 } ${(gno!=null)}");

            if((gno!=null||sno!=null)) {
              print("INSIDE ${ DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<=0 } ${(gno!=null)}");
            }
            else if( DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))>=0 ){
              setState(() {
                editedItemIndex = index;
              });
            await   goToAddOrEditItem(Item_list[index]);
            }

            //
            // if((gno!=null||sno!=null)) {
            //   print("INSIDE ${ DateFormat("yyyy-MM-dd").format(DateTime.parse((widget.dateNew).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<=0 } ${(gno!=null)}");
            // }
            // else if( DateFormat("yyyy-MM-dd").format(DateTime.parse((widget.dateNew).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))>=0 ){
            //   setState(() {
            //     editedItemIndex = index;
            //   });
            //   goToAddOrEditItem(Item_list[index]);
            // }


          },
          child:Card(
            // color: CommonColor.WHITE_COLOR,
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
            backgroundColor: CommonColor.THEME_COLOR,

              child: Text("${index + 1}", style: TextStyle(color: Colors.white)),
            ),
                  title: Text( "${Item_list[index]['Ledger_Name']}", style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600)),
                  subtitle: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        /*  Item_list[index]['Quantity']!=null? Container(
                              alignment:
                              Alignment.centerLeft,
                              child: Text( "${Item_list[index]['Unit']} :  "+
                                  CommonWidget.getCurrencyFormat(
                                      double.parse(Item_list[
                                      index]
                                      [
                                      'Quantity']
                                          .toString()))
                                      .toString() ,
                                // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                overflow: TextOverflow.clip,
                                style: item_heading_textStyle
                                    .copyWith(
                                    color:
                                    Colors.grey),
                              )):Container(),
                          SizedBox(width: 10,),*/

                          Item_list[index]['Amount']!=null? Container(
                              alignment:
                              Alignment.centerLeft,
                              child: Text(
                                  CommonWidget.getCurrencyFormat(
                                      double.parse(Item_list[
                                      index]
                                      [
                                      'Amount']
                                          .toString()))
                                      .toString() ,
                                // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                overflow: TextOverflow.clip,
                                style: item_heading_textStyle
                                    .copyWith(
                                    color:
                                    Colors.blue),
                              )):Container(),

                        ],
                      ),
                /*    Container(
                          alignment:
                          Alignment.centerLeft,
                          child: Text("GST : "+CommonWidget.getCurrencyFormat(calculategst(Item_list[index]))
                              .toString(),
                            // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                            overflow: TextOverflow.clip,
                            style: item_heading_textStyle
                                .copyWith(
                                color:
                                Colors.grey),
                          )),
                      SizedBox(height: 5,),
                      Divider(height: 1,),*/
/*
                  DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<0 ?Container():
                  (gno!=null||sno!=null)? SizedBox(height: 5,):Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // if (product['Unit'].isNotEmpty) Text(product['Unit']),


                          Item_list[index]['Net_Amount']!=null? Container(
                              alignment:
                              Alignment.centerLeft,
                              child: Text(
                                  CommonWidget.getCurrencyFormat(
                                      double.parse(Item_list[
                                      index]
                                      [
                                      'Net_Amount']
                                          .toString()))
                                      .toString() ,
                                // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
                                overflow: TextOverflow.clip,
                                style: item_heading_textStyle
                                    .copyWith(
                                    color:
                                    Colors.blue),
                              )):Container(),
                          (gno!=null||sno!=null)?Container() :
                          DateFormat("yyyy-MM-dd").format(DateTime.parse((invoiceDate).toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))<0?
                          Container():
                          Container(
                              width: parentWidth * .1,
                              // height: parentHeight*.1,
                              color: Colors.transparent,
                              child: DeleteDialogLayout(
                                  callback: (response) async {
                                    if (response == "yes") {

                                      setState(() {
                                        Item_list.removeAt(index);
                                        Item_list=Item_list;
                                        showButton=true;
                                      });
                                      await calculateTotalAmt();
                                    }
                                  })),
                        ],
                      ),*/

                    ],
                  ),
                   trailing:   Container(
                      width: parentWidth * .1,
                      // height: parentHeight*.1,
                      color: Colors.transparent,
                      child: DeleteDialogLayout(
                          callback: (response) async {
                            if (response == "yes") {

                              setState(() {
                                Item_list.removeAt(index);
                                Item_list=Item_list;
                                showButton=true;
                              });
                              await calculateTotalAmt();
                            }
                          })),

                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: Divider(height: 1,),
                )
              ],
            ),
          )
          // Card(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Container(
          //             margin: const EdgeInsets.only(
          //                 top: 10, left: 10, right: 0, bottom: 10),
          //             child: Row(
          //               children: [
          //                 Container(
          //                     width: parentWidth * .1,
          //                     height: parentWidth * .1,
          //                     decoration: BoxDecoration(
          //                         color: CommonColor.THEME_COLOR.withOpacity(0.8),
          //                         borderRadius:
          //                         BorderRadius.circular(100)),
          //                     alignment: Alignment.center,
          //                     child: Text(
          //                       "${index + 1}",
          //                       textAlign: TextAlign.center,
          //                       style: item_list.copyWith(
          //                           fontSize: 20),
          //                     )),
          //                 Container(
          //                   padding: EdgeInsets.only(left: 10),
          //                   width: parentWidth * .70,
          //                   //  height: parentHeight*.1,
          //                   child: Column(
          //                     mainAxisAlignment:
          //                     MainAxisAlignment.start,
          //                     crossAxisAlignment:
          //                     CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         "${Item_list[index]['Item_Name']}",
          //                         style: item_heading_textStyle,
          //                       ),
          //                       SizedBox(
          //                         height: 5,
          //                       ),
          //                       Row(
          //                         mainAxisAlignment:
          //                         MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Item_list[
          //                           index]
          //                           [
          //                           'Quantity']!=null? Container(
          //                               alignment:
          //                               Alignment.centerRight,
          //                               child: Row(
          //                                 children: [
          //
          //                                   Item_list[index]['Unit']=="null"?Text(""):Text( "${Item_list[index]['Unit']}:  ",
          //                                     // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
          //                                     overflow: TextOverflow.clip,
          //                                     style: item_heading_textStyle
          //                                         .copyWith(
          //                                         color:
          //                                         Colors.black87),
          //                                   ),
          //                                   Text(  CommonWidget.getCurrencyFormat(
          //                                         double.parse(Item_list[
          //                                         index]
          //                                         [
          //                                         'Quantity']
          //                                             .toString()))
          //                                         .toString() ,
          //                                     // "${(double.parse(Item_list[index]['Quantity'].toString())).toStringAsFixed(2)}${Item_list[index]['Unit']}"
          //                                     overflow: TextOverflow.clip,
          //                                     style: item_heading_textStyle
          //                                         .copyWith(
          //                                         color:
          //                                         Colors.black87),
          //                                   ),
          //                                 ],
          //                               )):Container(),
          //                           Item_list[index]
          //                           ['Net_Amount']!=null? Container(
          //                             alignment: Alignment.centerRight,
          //                             width:
          //                             SizeConfig.halfscreenWidth -
          //                                 50,
          //                             child: Text(
          //                               CommonWidget.getCurrencyFormat(
          //                                   Item_list[index]
          //                                   ['Net_Amount']),
          //                               overflow: TextOverflow.ellipsis,
          //                               style: item_heading_textStyle
          //                                   .copyWith(
          //                                   color: Colors.blue),
          //                             ),
          //                           ):Container(),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //
          //                 Container(
          //                     width: parentWidth * .1,
          //                     // height: parentHeight*.1,
          //                     color: Colors.transparent,
          //                     child: DeleteDialogLayout(
          //                         callback: (response) async {
          //                           if (response == "yes") {
          //
          //                             setState(() {
          //                               Item_list.removeAt(index);
          //                               Item_list=Item_list;
          //                               showButton=true;
          //                             });
          //                             await calculateTotalAmt();
          //                           }
          //                         })),
          //               ],
          //             )),
          //       )
          //     ],
          //   ),
          // ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 5,
        );
      },
    );
  }

  var isLoader=true;



  Future<Object?> goToAddOrEditItem(product) {

    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AddOrEditInvoiceAddition(
                unitP: unit,
                rateP: rate,
                gstavailable: null,
                readOnly: DateFormat("yyyy-MM-dd").format(DateTime.parse(invoiceDate.toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now()))>=0  ?true:false,
                mListener: this,
                editproduct: product,
                setText: setText,
                date: invoiceDate.toString(),
                id: selectedVendorId,
                exstingList: Item_list, 
                dateFinal: DateFormat('yyyy-MM-dd').format(invoiceDate),
                igstApplicable:partyState!=null && company_details[0]['State']!=null &&company_details[0]['State']!=partyState?true:false,
                cAndsgstApplicable:partyState==null || company_details[0]['State']==null ||company_details[0]['State']==partyState ?true:false,
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

  @override
  AddOrEditInvoiceAdditionDetail(item) async{
    // TODO: implement AddOrEditInvoiceAdditionDetail
    var itemLlist = Item_list;
    showButton = true;
    setState(() {
      isLoaderShow=true;

    });
    if (editedItemIndex != null) {
      var index = editedItemIndex;

      setState(() {
        Item_list[index]['Ledger_ID'] = item['Ledger_ID'];
        Item_list[index]['Ledger_Name'] = item['Ledger_Name'];
        Item_list[index]['Quantity'] = item['Quantity'];
        //Item_list[index]['Unit'] = item['Unit'];
        Item_list[index]['Rate'] = item['Rate'];
        Item_list[index]['Amount'] = item['Amount'];
      /*  Item_list[index]['Disc_Percent'] = item['Disc_Percent'];
        Item_list[index]['Disc_Amount'] = item['Disc_Amount'];
        Item_list[index]['Taxable_Amount'] = item['Taxable_Amount'];
        Item_list[index]['IGST_Rate'] = item['IGST_Rate'];
        Item_list[index]['IGST_Amount'] = item['IGST_Amount'];
        Item_list[index]['CGST_Rate'] = item['CGST_Rate'];
        Item_list[index]['CGST_Amount'] = item['CGST_Amount'];
        Item_list[index]['SGST_Rate'] = item['SGST_Rate'];
        Item_list[index]['SGST_Amount'] = item['SGST_Amount'];
        Item_list[index]['Net_Rate'] = item['Net_Rate'];
        Item_list[index]['Net_Amount'] = item['Net_Amount'];
        Item_list[index]['Packing_Quantity'] = item['Packing_Quantity'];
        Item_list[index]['Packing_Unit'] = item['Packing_Unit'];*/
      });
      setState(() {
        Item_list=Item_list;
      });

    } else {
      itemLlist.add(item);
      print(itemLlist);

      setState(() {
        Item_list = itemLlist;
      });
    }
    setState(() {
      editedItemIndex = null;
      showButton=true;
      isLoaderShow=false;

    });
    await calculateTotalAmt();
    print("List");
    print(Item_list);

    if(Item_list.length>0){
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
    }else{
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);
    }
  }


/*  calculateTotalAmt() async {
    setState(() {
      TotalAmount = "0.00";
      roundoff = "0.00";
    });
    var total = 0.00;
    for (var item in Item_list) {
      total = total + item['Net_Amount'];
      // print(item['Amount']);
    }
    // var amt = double.parse((total.toString()).substring((total.toString()).length - 3, (total.toString()).length)).toStringAsFixed(3);
    double amt = total % 1;

    print("%%%%%%%%%%%%%%%%%%%%% $amt");
    if (double.parse((total.toString()).substring(
        (total.toString()).length - 3, (total.toString()).length)) ==
        0.0) {
      var total1 = (total).floorToDouble();
      setState(() {
        roundoff = "0.00";
        TotalAmount = total1.toStringAsFixed(2);
      });
    } else {
      if ((amt) < 0.50) {
        print("Here");
        var total1 = (total).floorToDouble();
        var roff = total1 - (total);
        setState(() {
          TotalAmount = total1.toStringAsFixed(2);
          roundoff = roff.toStringAsFixed(2);
        });
      } else if ((amt) >= 0.50) {
        setState(() {
          roundoff = (1 - amt).toStringAsFixed(2);
          TotalAmount = (total.ceilToDouble()).toStringAsFixed(2);
        });
      }
    }
  }*/


  getRoutebyPartId() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
        TokenRequestModel(token: sessionToken, page: "1");
        String apiUrl = "${baseurl}${ApiConstants().item}?Company_ID=$companyId&Party_ID=${selectedVendorId}";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess: (data)async {
              print(data);
              setState(() {
                if (data != null) {

                  setState(() {
                    selectedVendorId=selectedVendorId;
                    selectedVendorName=selectedVendorName;
                    selectedRouteId = data[0]['Route_Code'].toString();
                    selectedRouteName = data[0]['Route_Name'].toString();
                    selectedTransporter=data[0]['Transporter_Code']!=null?data[0]['Transporter_Code']:"";
                    selectedVehicalNo=data[0]['Default_Vehicle']!=null?data[0]['Default_Vehicle']:"";
                  });

                }
                isLoaderShow = false;
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

  getOrderInvoice(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
        TokenRequestModel(token: sessionToken, page: page.toString());
        String apiUrl ="";
       
          apiUrl = "${baseurl}${ApiConstants().saleInvoiceAdditionDetail}?Company_ID=$companyId&Item_ID=$selectedItemId&Applicable_From=${DateFormat('yyyy-MM-dd').format(invoiceDate)}";
      //  http://61.2.227.173:3000/SaleInvoiceAdditionDetails?Company_ID=74&Item_ID=1189&Applicable_From=2024-04-01
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess: (data)async {
              print(data);
              setState(() async {
                if (data != null) {
                  Item_list=data;

                  List<dynamic> _arrList = [];
               //   _arrList = (data['itemDetails']);

                  setState(() {
                    // Item_list = _arrList;
                    // ServiceList = (data['ChargesDetails']);
                    // selectedVendorName = data['voucherDetails']['Vendor_Name']==null?"":data['voucherDetails']['Vendor_Name'];
                    // selectedVendorId = data['voucherDetails']['Vendor_Code']==null?"":data['voucherDetails']['Vendor_Code'].toString();
                    // // partyState=data['voucherDetails']['State'].toString();
                    // TotalAmount =data['voucherDetails']['Total_Amount']==null?TotalAmount: data['voucherDetails']['Total_Amount'].toStringAsFixed(2);
                    // roundoff = data['voucherDetails']['Round_Off']==null?roundoff: data['voucherDetails']['Round_Off'].toStringAsFixed(2);
                    // selectedRouteId=data['voucherDetails']['Route_ID']==null?"":data['voucherDetails']['Route_ID'].toString();
                    // selectedRouteName=data['voucherDetails']['Route_Name']==null?"":data['voucherDetails']['Route_Name'].toString();
                    // selectedDriverName=data['voucherDetails']['Driver']==null?"":data['voucherDetails']['Driver'].toString();
                    // selectedDriverMobile=data['voucherDetails']['Driver_Mob_No']==null?"":data['voucherDetails']['Driver_Mob_No'].toString();
                    // selectedVehicalNo=data['voucherDetails']['Vehicle_No']==null?"":data['voucherDetails']['Vehicle_No'].toString();
                    // selectedTransporter=data['voucherDetails']['Transporter']==null?"":data['voucherDetails']['Transporter'].toString();
                    // selectedVoucherType=data['voucherDetails']['Voucher_Name']==null?"":data['voucherDetails']['Voucher_Name'].toString();
                    // partyState=data['voucherDetails']['Vendor_State']==null?null:data['voucherDetails']['Vendor_State'].toString();
                    // partygst=data['voucherDetails']['GST_No']==null?null:data['voucherDetails']['GST_No'];
                    // sno=data['voucherDetails']['SO_No']!=null?data['voucherDetails']['SO_No'].toString():sno;
                    // gno=data['voucherDetails']['GD_No']!=null?data['voucherDetails']['GD_No'].toString():gno;
                    //
                    // print("##############3");
                    // print(partyState);
                    // print(roundoff);
                    // if(widget.readOnly==true) {
                    //   if (data['voucherDetails']['Order_No'] != null) {
                    //     setState(() {
                    //       franchiseereadonly = false;
                    //     });
                    //   }
                    // }
                    // if(Item_list.length>0){
                    //   position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.78);
                    // }
                  });

                  await calculateTotalAmt();
                }
                isLoaderShow = false;
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

 

  postSaleInvoiceAddition() async {
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl = await AppPreferences.getDomainLink();

    // String totalAmount =CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble());
    double TotalAmountInt = double.parse(TotalAmount).ceilToDouble();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        print("##############Newww ${selectedVendorId}");
        var model ={
          "Company_ID": companyId,
          "Item_ID": selectedItemId,
          "Applicable_From": DateFormat('yyyy-MM-dd').format(invoiceDate),
          "Unit": unit,
          "Creator": creatorName,
          "Creator_Machine": deviceId,
          "INSERT":Item_list.toList(),
        };

        String apiUrl = baseurl + ApiConstants().saleInvoiceAddition+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDynamicPI(apiUrl, model, "",
            onSuccess: (data) async {
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow = true;
                Item_list = [];


              });
              widget.mListener.backToList(invoiceDate);
            }, onFailure: (error) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, e.toString());
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

}

abstract class CrateSaleOrderInterface {
  backToList(DateTime updateDate);
}