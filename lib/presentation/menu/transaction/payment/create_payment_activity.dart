

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog_for_profile.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/core/util.dart';
import 'package:sweet_shop_app/presentation/dialog/city_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/country_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/state_dialog.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/receipt/add_edit_ledger.dart';

import '../../../dialog/franchisee_dialog.dart';
import 'add_edit_ledger_for_payment.dart';

class CreatePayment extends StatefulWidget {
  final CreatePaymentInterface mListener;
  final String dateNew;

  const CreatePayment({super.key,required this.mListener, required this.dateNew});
  @override
  _CreatePaymentState createState() => _CreatePaymentState();
}



class _CreatePaymentState extends State<CreatePayment> with SingleTickerProviderStateMixin,FranchiseeDialogInterface,AddOrEditLedgerForPaymentInterface {

  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _voucherNoFocus = FocusNode();
  final VoucherNoController = TextEditingController();


  String selectedFranchiseeName="";

  List<dynamic> Ledger_list=[
    {
      "id":1,
      "ledgerName":"Ladger1",
      "currentBal":10,
      "amount":100.00,
      "narration":""

    },
    {
      "id":2,
      "ledgerName":"Ladger2",
      "currentBal":20,
      "amount":100.00,
      "narration":""

    },
  ];


  String TotalAmount="0.00";

  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    for(var item  in Ledger_list ){
      total=total+item['amount'];
      print(item['amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    calculateTotalAmt();
  }

  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  Widget contentBox(BuildContext context) {
    return Container(
      height: SizeConfig.safeUsedHeight,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xFFfffff5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Scaffold(
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
                  StringEn.CREATE_PAYMENT,
                  style: appbar_text_style,),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }


  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: parentWidth * .04,
              right: parentWidth * 0.04,
              top: parentHeight * .015),
          child: GestureDetector(
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
            },
            onDoubleTap: () {},
            child: Container(
              height: parentHeight * .06,
              decoration: BoxDecoration(
                color: disableColor == true
                    ? CommonColor.THEME_COLOR.withOpacity(.5)
                    : CommonColor.THEME_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: parentWidth * .005),
                    child: const Text(
                      StringEn.SAVE,
                      style: page_heading_textStyle,
                    ),
                  ),
                ],
              ),
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
      // padding: EdgeInsets.only(
      //     left: parentWidth * 0.04,
      //     right: parentWidth * 0.04,
      //     top: parentHeight * 0.01,
      //     bottom: parentHeight * 0.02),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [

                  getFieldTitleLayout(StringEn.PAYMENT_DETAIL),
                  PaymentInfo(),

                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Ledger_list.length>0?getFieldTitleLayout(StringEn.LEADER_DETAIL):Container(),
                      GestureDetector(
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (context != null) {
                              goToAddOrEditItem(null);
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
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(StringEn.ADD_LEADER,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),
                  Ledger_list.length>0?    getLedgerListLayout():Container(),

                  SizedBox(height: 10,),
                  TotalAmount!="0.00"?Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CommonColor.DARK_BLUE,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Round Off : ${double.parse(TotalAmount).round()}",style: subHeading_withBold,),
                        SizedBox(height: 10,),
                        Text("Total Amount : ${TotalAmount}",style: subHeading_withBold,)
                      ],
                    ),
                  ):Container(),



                ],
              ),
            ),
          ),
        ),
      ],
    );

  }
  /* Widget to get add Product Layout */
  Widget getAddNewProductLayout(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          goToAddOrEditItem(null);
        }
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add New Ledger",
                style: item_heading_textStyle,),
              FaIcon(FontAwesomeIcons.plusCircle,
                color: Colors.black87, size: 20,)
            ],
          )
      ),
    );
  }

  Future<Object?> goToAddOrEditItem(product) {
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
              child: AddOrEditLedgerForPayment(
                mListener: this,
                editproduct:product,
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



  /* Widget to get item  list Layout */
  SingleChildScrollView getLedgerListLayout() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataRowHeight: 50,
        dividerThickness: 2,
        horizontalMargin: 10,
        dataTextStyle: item_regular_textStyle,
        headingRowColor: MaterialStateColor.resolveWith((states) => CommonColor.DARK_BLUE),
        headingTextStyle: item_heading_textStyle.copyWith(fontSize: 16,color: Colors.white,overflow: TextOverflow.clip),
        decoration: BoxDecoration(border: Border.all(color: CommonColor.THEME_COLOR, width:0)),
        showBottomBorder: true,
        columns: [
          DataColumn(
            label: Container(
              width: SizeConfig.screenWidth/4,
              child: Text(
                "Ledger Name",
              ),
            ),
            numeric: false,
            tooltip: "This is Ledger Name",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,

              child: Text(
                "Amount",
              ),
            ),
            numeric: true,
            tooltip: "Ledger Amt",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,

              child: Text(
                "Current Bal",
              ),
            ),
            numeric: true,
            tooltip: "Current Bal",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
                "Narration",

              ),
            ),
            numeric: true,
            tooltip: "Ledger Narration",

          ),

          DataColumn(
            label: Container(
              width:50,
              child: Text(
                "Action",
              ),
            ),
            numeric: true,
            tooltip: "",

          ),
        ],
        rows: Ledger_list
            .map(
              (item) => DataRow(
              cells: [
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4+50,
                      child: Row(
                        children: [
                          IconButton(onPressed: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (context != null) {
                              goToAddOrEditItem(item);
                            }
                          }, icon: Icon(Icons.edit,color: Colors.green,size: 18,)),
                          Container(
                              width: SizeConfig.screenWidth/4,
                              child: Text("${item['ledgerName']}",overflow: TextOverflow.clip,)),

                        ],
                      )),
                ),
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((item['amount']).toStringAsFixed(2))}")),
                ),
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${item['currentBal']}")),
                ),
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${item['narration']}")),
                ),

                DataCell(
                  Container(
                      width: 50,
                      child: GestureDetector(
                          onTap: (){
                            Ledger_list.remove(item);
                            setState(() {
                              Ledger_list=Ledger_list;
                            });
                          },
                          child: FaIcon(FontAwesomeIcons.trash,color: Colors.red,))),
                ),
              ]),
        ) .toList(),
      ),
    );
  }

  Container PaymentInfo() {
    return Container(

      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Column(children: [
        getFieldTitleLayout(StringEn.DATE),
        getReceiptDateLayout(),
        // getFieldTitleLayout(StringEn.VOUCHER_NO),
        // getVoucherNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
        getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
        SizedBox(height: 10,)
      ],
      ),
    );
  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }



  /* Widget to get add Invoice date Layout */
  Widget getReceiptDateLayout(){
    return GestureDetector(
      onTap: () async{
/*        FocusScope.of(context).requestFocus(FocusNode());
        if (Platform.isIOS) {
          var date= await CommonWidget.startDate(context,invoiceDate);
          setState(() {
            invoiceDate=date;
          });
          // startDateIOS(context);
        } else if (Platform.isAndroid) {
          var date= await CommonWidget.startDate(context,invoiceDate) ;
          setState(() {
            invoiceDate=date;
          });
        }*/
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(color: Colors.grey.withOpacity(0.5))
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),]

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.dateNew,
                style: page_heading_textStyle,),
              FaIcon(FontAwesomeIcons.calendar,
                color: Colors.black87, size: 16,)
            ],
          )
      ),
    );
  }

  /* Widget for Invoice No text from field layout */
  Widget getVoucherNoLayout(double parentHeight, double parentWidth) {
    return Container(
      height: parentHeight * .055,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CommonColor.WHITE_COLOR,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        textCapitalization: TextCapitalization.words,
        focusNode: _voucherNoFocus,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        cursorColor: CommonColor.BLACK_COLOR,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
              left: parentWidth * .04, right: parentWidth * .02),
          border: InputBorder.none,
          counterText: '',
          isDense: true,
          hintText: "Enter a Voucher No",
          hintStyle: hint_textfield_Style,
        ),
        controller: VoucherNoController,
        onEditingComplete: () {
          _voucherNoFocus.unfocus();
        },
        style: text_field_textStyle,
      ),
    );
  }


  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            StringEn.FRANCHISEE_NAME,
            style: page_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Container(
              height: parentHeight * .055,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.WHITE_COLOR,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child:  GestureDetector(
                onTap: (){
                  showGeneralDialog(
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionBuilder: (context, a1, a2, widget) {
                        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                        return Transform(
                          transform:
                          Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                          child: Opacity(
                            opacity: a1.value,
                            child:FranchiseeDialog(
                              mListener: this,
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
                },
                onDoubleTap: (){},
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedFranchiseeName == "" ? StringEn.FRANCHISEE_NAME : selectedFranchiseeName,
                        style: selectedFranchiseeName == ""
                            ? hint_textfield_Style
                            : text_field_textStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        // textScaleFactor: 1.02,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: parentHeight * .03,
                        color: /*pollName == ""
                                ? CommonColor.HINT_TEXT
                                :*/
                        CommonColor.BLACK_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }




  @override
  selectedFranchisee(String id, String name) {
    // TODO: implement selectedFranchisee
    setState(() {
      selectedFranchiseeName=name;
    });
  }

  @override
  AddOrEditLedgerForPaymentDetail(item) {
    // TODO: implement AddOrEditItemDetail
    var itemLlist=Ledger_list;
    if(item['id']!=""){
      var index=Ledger_list.indexWhere((element) => item['id']==element['id']);
      setState(() {
        Ledger_list[index]['ledgerName']=item['ledgerName'];
        Ledger_list[index]['currentBal']=item['currentBal'];
        Ledger_list[index]['amount']=item['amount'];
        Ledger_list[index]['narration']=item['narration'];
      });
    }
    else {
      if (itemLlist.contains(item)) {
        print("Already Exist");
      }
      else {
        itemLlist.add(item);
      }
      setState(() {
        Ledger_list = itemLlist;
      });
    }
  }


}

abstract class CreatePaymentInterface {
}