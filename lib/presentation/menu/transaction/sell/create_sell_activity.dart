

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

import '../../../dialog/franchisee_dialog.dart';
import 'add_or_edit_Item.dart';


class CreateSellInvoice extends StatefulWidget {
  final CreateSellInvoiceInterface mListener;
  final String dateNew;

  const CreateSellInvoice({super.key, required this.dateNew, required this.mListener});
  @override
  _CreateSellInvoiceState createState() => _CreateSellInvoiceState();
}

class _CreateSellInvoiceState extends State<CreateSellInvoice> with SingleTickerProviderStateMixin,FranchiseeDialogInterface,AddOrEditItemSellInterface {

  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;
  
  DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _InvoiceNoFocus = FocusNode();
  final InvoiceNoController = TextEditingController();


  String selectedFranchiseeName="";

  String TotalAmount="0.00";

  List<dynamic> Item_list=[
    {
      "id":1,
      "itemName":"Item1",
      "quantity":2,
      "unit":"kg",
      "rate":200,
      "amt":550.00,
      "discount":null,
      "discountAmt":00.00,
      "taxableAmt":550.00,
      "gst":10,
      "gstAmt":550.00,
      "netRate":252.00,
      "netAmount":590
    },
    {
      "id":2,
      "itemName":"Item2",
      "quantity":5,
      "unit":"kg",
      "rate":500,
      "amt":550.00,
      "discount":null,
      "discountAmt":00.00,
      "taxableAmt":550.00,
      "gst":10,
      "gstAmt":550.00,
      "netRate":252.00,
      "netAmount":590
    },
  ];


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
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xFFfffff5),
       // borderRadius: BorderRadius.circular(16.0),
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
                title: const Text(
                  StringEn.ADD_SELL,
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

                  getFieldTitleLayout(StringEn.INVOICE_DETAIL),
                  InvoiceInfo(),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Item_list.length>0?getFieldTitleLayout(StringEn.SELL_ITEM):Container(),
                      GestureDetector(
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (context != null) {
                              goToAddOrEditItem(null);
                            }
                          },
                          child: Container(
                              width: 120,
                              padding: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: CommonColor.THEME_COLOR,
                                  border: Border.all(color: Colors.grey.withOpacity(0.5))
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(StringEn.ADD_ITEMS,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),
                  Item_list.length>0? getProductRateListLayout():Container(),

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
  Widget getAddNewProductLayout(double parentHeight, double parentWidth){
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add New Item",
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
              child: AddOrEditItemSell(
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
  SingleChildScrollView getProductRateListLayout() {
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
                StringEn.ITEM_NAME,
              ),
            ),
            numeric: false,
            tooltip: "This is Item Name",

          ),
          DataColumn(
            label: Container(
              width:60,

              child: Text(
                StringEn.QUANTITY,
              ),
            ),
            numeric: true,
            tooltip: "Item Quantity",

          ),
          DataColumn(
            label: Container(
              width:50,

              child: Text(
                StringEn.UNIT,
              ),
            ),
            numeric: true,
            tooltip: "Item Unit",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
                StringEn.RATE,

              ),
            ),
            numeric: true,
            tooltip: "Item Rate",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
                StringEn.AMOUNT,

              ),
            ),
            numeric: true,
            tooltip: "Item Amt",

          ),
          DataColumn(
            label: Container(
              width:80,
              child: Text(
                StringEn.DICOUNT,
              ),
            ),
            numeric: true,
            tooltip: "Item discount",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
                StringEn.DISCOUNT_AMT,

              ),
            ),
            numeric: true,
            tooltip: "Discount Amt",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
                StringEn.TAX_AMT,

              ),
            ),
            numeric: true,
            tooltip: "Item Taxable Amt",

          ),
          DataColumn(
            label: Container(
              width:60,
              child: Text(
                StringEn.GST_PER,

              ),
            ),
            numeric: true,
            tooltip: "Item gst",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
                StringEn.GST_AMT,

              ),
            ),
            numeric: true,
            tooltip: "Item gst Amt",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
                StringEn.NET_RATE,

              ),
            ),
            numeric: true,
            tooltip: "Item net rate",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
               StringEn.NET,

              ),
            ),
            numeric: true,
            tooltip: "Item net Amt",

          ),

          DataColumn(
            label: Container(
              width:50,
              child: Text(
                StringEn.ACTION,
              ),
            ),
            numeric: true,
            tooltip: "",

          ),
        ],
        rows: Item_list
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
                              child: Text("${item['itemName']}",overflow: TextOverflow.clip,)),

                        ],
                      )),
                ),
                DataCell(
                  Container(
                      width: 60,
                      child: Text("${item['quantity']}")),
                ),

                DataCell(
                  Container(
                      width: 50,
                      child: Text("${item['unit']}")),
                ),
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((item['rate']).toStringAsFixed(2))}")),
                ),

                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((item['amt']).toStringAsFixed(2))}")),
                ),
                DataCell(
                  Container(
                      width: 80,
                      child: Text(item['discount']==null?"0":"${item['discount']}")),
                ),
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((item['discountAmt']).toStringAsFixed(2))}")),
                ),
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((item['taxableAmt']).toStringAsFixed(2))}")),
                ),

                DataCell(
                  Container(
                      width: 60,
                      child: Text("${((item['gst']))}")),
                ),

                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((item['gstAmt']).toStringAsFixed(2))}")),
                ),

                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((item['netRate']).toStringAsFixed(2))}")),
                ),

                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((item['netAmount']).toStringAsFixed(2))}")),
                ),
                DataCell(
                  Container(
                      width: 50,
                      child: GestureDetector(
                          onTap: ()async{
                            Item_list.remove(item);
                            setState(() {
                              Item_list=Item_list;
                            });
                            await calculateTotalAmt();
                          },
                          child: FaIcon(FontAwesomeIcons.trash,color: Colors.red,))),
                ),
              ]),
        ) .toList(),
      ),
    );
  }

  Container InvoiceInfo() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Column(
        children: [
        getFieldTitleLayout(StringEn.DATE),
        getPurchaseDateLayout(),
        // getFieldTitleLayout(StringEn.INVOICE_NO),
        // getInvoiceNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
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
  Widget getPurchaseDateLayout(){
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
  AddOrEditItemSellDetail(item)async {
    // TODO: implement AddOrEditItemSellDetail
    var itemLlist=Item_list;
    if(item['id']!=""){
      var index=Item_list.indexWhere((element) => item['id']==element['id']);
      setState(() {
        Item_list[index]['itemName']=item['itemName'];
        Item_list[index]['quantity']=item['quantity'];
        Item_list[index]['unit']=item['unit'];
        Item_list[index]['rate']=item['rate'];
        Item_list[index]['amt']=item['amt'];
        Item_list[index]['discount']=item['discount'];
        Item_list[index]['discountAmt']=item['discountAmt'];
        Item_list[index]['taxableAmt']=item['taxableAmt'];
        Item_list[index]['gst']=item['gst'];
        Item_list[index]['gstAmt']=item['gstAmt'];
        Item_list[index]['netRate']=item['netRate'];
        Item_list[index]['netAmount']=item['netAmount'];

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
        Item_list = itemLlist;
      });
    }
    await calculateTotalAmt();
  }

  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    for(var item  in Item_list ){
      total=total+item['netAmount'];
      print(item['netAmount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }
}

abstract class CreateSellInvoiceInterface {
}
