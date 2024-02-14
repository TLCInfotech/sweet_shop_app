

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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


class CreatePurchaseInvoice extends StatefulWidget {
  final CreatePurchaseInvoiceInterface mListener;
  final String dateNew;

  const CreatePurchaseInvoice({super.key,required this.mListener, required this.dateNew});

  @override
  _CreatePurchaseInvoiceState createState() => _CreatePurchaseInvoiceState();
}



class _CreatePurchaseInvoiceState extends State<CreatePurchaseInvoice> with SingleTickerProviderStateMixin,FranchiseeDialogInterface,AddOrEditItemInterface {

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
      "itemName":"Item Name - Gulakand Burfi With Dry Fruit",
      "quantity":10,
      "unit":"Kg",
      "rate":200,
      "amt":2000.00,
      "discount":5,
      "discountAmt":100.00,
      "taxableAmt":1900.00,
      "gst":18,
      "gstAmt":342.00,
      "netRate":242.00,
      "netAmount":2242.00
    },
    {
      "id":2,
      "itemName":"Item Name - Mango Burfi",
      "quantity":25,
      "unit":"Kg",
      "rate":500,
      "amt":12500.00,
      "discount":10,
      "discountAmt":1250.00,
      "taxableAmt":11250.00,
      "gst":18,
      "gstAmt":2025.00,
      "netRate":531.00,
      "netAmount":13275.00
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
                  StringEn.ADD_PURCHASE,
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
                height: SizeConfig.safeUsedHeight * .12,
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
    return Padding(
      padding: const EdgeInsets.only(top: 5,bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TotalAmount!="0.00"? Container(
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
                Text("${Item_list.length} Items",style: item_regular_textStyle.copyWith(color: Colors.grey),),
                Text("Round Off : ${TotalAmount.substring(TotalAmount.length-3,TotalAmount.length)}",style: item_regular_textStyle.copyWith(fontSize: 17),),
                SizedBox(height: 4,),
                Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,),
              ],
            ),
          ):Container(),
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
                    child: const Text(
                      StringEn.SAVE,
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

                 // getFieldTitleLayout(StringEn.INVOICE_DETAILS),
                  InvoiceInfo(),
                  SizedBox(height: 10,),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Item_list.length>0?getFieldTitleLayout(StringEn.ITEM_DETAIL):Container(),
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
                  Item_list.length>0? get_Item_list_layout(SizeConfig.screenHeight,SizeConfig.screenWidth):Container(),

                  SizedBox(height: 10,),

                ],
              ),
            ),
          ),
        ),
      ],
    );

  }


  Widget get_Item_list_layout(double parentHeight, double parentWidth) {
    return Container(
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
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (context != null) {
                      goToAddOrEditItem(Item_list[index]);
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
                                          Text("${Item_list[index]['itemName']}",style: item_heading_textStyle,),

                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Text("${(Item_list[index]['quantity'])}.00${Item_list[index]['unit']}",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),)),

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(CommonWidget.getCurrencyFormat(Item_list[index]['netAmount']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(
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
                                          Item_list.remove(Item_list[index]);
                                          setState(() {
                                            Item_list=Item_list;
                                          });
                                          await calculateTotalAmt();
                                        },
                                      )
                                  ),
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
              child: AddOrEditItem(
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
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getPurchaseDateLayout(),
          // getFieldTitleLayout(StringEn.INVOICE_NO),
          // getInvoiceNoLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
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
          width: (SizeConfig.screenWidth)*0.3,
          height: (SizeConfig.screenHeight) * .055,
          padding: EdgeInsets.all(8),
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
                style: item_regular_textStyle,),
              SizedBox(width: 2,),
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
      padding: EdgeInsets.all(8),
      child: Container(
        width: parentWidth*0.52,
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
    );
  }



  @override
  selectedFranchisee(String id, String name) {
    // TODO: implement selectedFranchisee
    setState(() {
      selectedFranchiseeName=name;
    });
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

  @override
  AddOrEditItemDetail(item)async {
    // TODO: implement AddOrEditItemDetail
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

}

abstract class CreatePurchaseInvoiceInterface {
}