

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/getFranchisee.dart';

import '../../../common_widget/get_date_layout.dart';
import 'add_or_edit_item_opening_bal.dart';

class CreateItemOpeningBal extends StatefulWidget {
  final CreateItemOpeningBalInterface mListener;
  final String dateNew;

  const CreateItemOpeningBal({super.key, required this.dateNew, required this.mListener});
  @override
  State<CreateItemOpeningBal> createState() => _CreateItemOpeningBalState();
}

class _CreateItemOpeningBalState extends State<CreateItemOpeningBal> with SingleTickerProviderStateMixin,AddOrEditItemOpeningBalInterface {

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
      "itemName":"Gulakand Burfi",
      "quantity":2,
      "unit":"kg",
      "rate":200.00,
      "amt":400.00,

    },
    {
      "id":2,
      "itemName":"Mango Burfi",
      "quantity":5,
      "unit":"kg",
      "rate":500.00,
      "amt":2500.00,

    },
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                  StringEn.ADD_OPENING_BAL,
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


  Widget getAllFields(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),

      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [

              //    getFieldTitleLayout("Invoice Detail"),
                  InvoiceInfo(),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    //  Item_list.length>0?getFieldTitleLayout(StringEn.ITEM_DETAIL):Container(),
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
                                  Text("Add Item",
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),
                  Item_list.length>0? get_purchase_list_layout(parentHeight,parentWidth):Container(),

                  SizedBox(height: 10,),

                     //:Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );

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

                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: SizeConfig.screenWidth,
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${(Item_list[index]['quantity'])}.00${Item_list[index]['unit']} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                                Text("${(Item_list[index]['rate']).toStringAsFixed(2)}/${Item_list[index]['unit']} ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                                Text(CommonWidget.getCurrencyFormat(Item_list[index]['amt']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),

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


  Container InvoiceInfo() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10,left: 5,right: 5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width:(SizeConfig.screenWidth)*.32,
              child: getPurchaseDateLayout()),

        SizedBox(width: 5,),
          Expanded(
              child: getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)),
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
    return GetDateLayout(

        titleIndicator: false,
        title: StringEn.DATE,
        callback: (date){
          setState(() {
            invoiceDate=date!;
          });
        },
        applicablefrom: invoiceDate
    );

  }


  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return GetFranchiseeLayout(
      titleIndicator: false,
        title: StringEn.FRANCHISEE_NAME ,
        callback: (name){
          setState(() {
            selectedFranchiseeName=name!;
          });
        },
        franchiseeName: selectedFranchiseeName);

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
              child: AddOrEditItemOpeningBal(
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
                Text("${Item_list.length} Items",style: item_regular_textStyle.copyWith(color: Colors.grey),),
                SizedBox(height: 4,),
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



  @override
  AddOrEditItemOpeningBalDetail(item)async {
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
      total=total+item['amt'];
      print(item['amt']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }


}

abstract class CreateItemOpeningBalInterface {
}