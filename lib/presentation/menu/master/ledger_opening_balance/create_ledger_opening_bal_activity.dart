
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
import 'add_or_edit_ledger_opening_bal.dart';

class CreateLedgerOpeningBal extends StatefulWidget {
  final CreateItemOpeningBalInterface mListener;
  final String dateNew;

  const CreateLedgerOpeningBal({super.key, required this.dateNew, required this.mListener});
  @override
  State<CreateLedgerOpeningBal> createState() => _CreateItemOpeningBalState();
}

class _CreateItemOpeningBalState extends State<CreateLedgerOpeningBal> with SingleTickerProviderStateMixin,FranchiseeDialogInterface,AddOrEditItemOpeningBalInterface {

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
      "itemName":"Ledger 1",
      "amt":550.00,
      "amtType":"Cr",
    },
    {
      "id":2,
      "itemName":"Ledger 2",
      "amt":550.00,
      "amtType":"Dr",

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
                  StringEn.ADD_LEDGER_OPENING_BAL,
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
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: Row(
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
                Text("${Item_list.length} Ledgers",style: item_regular_textStyle.copyWith(color: Colors.grey),),
                SizedBox(height: 5,),
                Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,)
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

                //  getFieldTitleLayout("Invoice Detail"),
                  InvoiceInfo(),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Item_list.isNotEmpty?getFieldTitleLayout("Ledger Detail"):Container(),
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
                                  Text("Add Ledger",
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
              child: AddOrEditLedgerOpeningBal(
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


  Widget get_purchase_list_layout(double parentHeight, double parentWidth) {
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
                child: Card(
                  child: Row(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: Container(
                      //     height: 40,
                      //       width: 40,
                      //       alignment: Alignment.center,
                      //       padding: EdgeInsets.all(10),
                      //       decoration: BoxDecoration(
                      //           color: (index)%2==0?Colors.green:Colors.blueAccent,
                      //           borderRadius: BorderRadius.circular(5)
                      //       ),
                      //       child:
                      //      Text((index+1).toString(),style: page_heading_textStyle),
                      //   ),
                      // ),
                      Expanded(
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10,left: 10,right: 10 ,bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                color: Colors.purple.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            alignment: Alignment.center,
                                            child: Text("0${index+1}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontSize: 14),)),
                                        SizedBox(width: 5,),
                                        Text("${(Item_list[index]['itemName'])} ",style: item_heading_textStyle,),
                                      ],
                                    ),
                                    SizedBox(height: 5 ,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("  ${(Item_list[index]['amt']).toStringAsFixed(2)} ${Item_list[index]['amtType']} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue)),
                                        SizedBox(width: 5,),

                                      ],
                                    ),
                                    SizedBox(height: 5,),

                                  ],
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child:IconButton(
                                    icon:  FaIcon(
                                      FontAwesomeIcons.trash,
                                      size: 15,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: (){},
                                  ) ),
                              // Positioned(
                              //     bottom: 10,
                              //     right: 10,
                              //     child:
                              //     Text(CommonWidget.getCurrencyFormat(Item_list[index]['amt']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),)
                              // )
                            ],
                          )

                      )
                    ],
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
                "Ledger Name",
              ),
            ),
            numeric: false,
            tooltip: "This is Item Name",

          ),

          DataColumn(
            label: Container(
              width:50,
              child: Text(
                "Amount",

              ),
            ),
            numeric: true,
            tooltip: " Amt",

          ),


          DataColumn(
            label: Container(
              width:50,
              child: Text(
                "Type",
                overflow: TextOverflow.clip,
              ),
            ),
            numeric: true,
            tooltip: " Amt",

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
                      width: 50,
                      child: Text("${((item['amt']).toStringAsFixed(2))}")),
                ),



                DataCell(
                  Container(
                      width: 50,
                      child: Text("${((item['amtType']))}")),
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Column(
        children: [
         // getFieldTitleLayout(StringEn.DATE),
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

  /* Widget for Invoice No text from field layout */
  Widget getInvoiceNoLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
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
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          textCapitalization: TextCapitalization.words,
          focusNode: _InvoiceNoFocus,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          cursorColor: CommonColor.BLACK_COLOR,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: parentWidth * .04, right: parentWidth * .02),
            border: InputBorder.none,
            counterText: '',
            isDense: true,
            hintText: "Enter a item name",
            hintStyle: hint_textfield_Style,
          ),
          controller: InvoiceNoController,
          onEditingComplete: () {
            _InvoiceNoFocus.unfocus();
          },
          style: text_field_textStyle,
        ),
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
       /*   const Text(
            StringEn.FRANCHISEE_NAME,
            style: page_heading_textStyle,
          ),*/
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
  AddOrEditItemOpeningBalDetail(item)async {
    // TODO: implement AddOrEditItemSellDetail
    var itemLlist=Item_list;
    if(item['id']!=""){
      var index=Item_list.indexWhere((element) => item['id']==element['id']);
      setState(() {
        Item_list[index]['itemName']=item['itemName'];
        Item_list[index]['amt']=item['amt'];
        Item_list[index]['amtType']=item['amtType'];
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
      total=total+item['amt'];
      print(item['netAmount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }


}

abstract class CreateItemOpeningBalInterface {
}