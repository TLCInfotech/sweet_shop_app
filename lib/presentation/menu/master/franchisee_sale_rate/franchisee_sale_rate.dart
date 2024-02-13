
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/franchisee_dialog.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee_purchase_rate/add_new_purchase_rate_product.dart';
import 'package:sweet_shop_app/presentation/menu/master/franchisee_sale_rate/add_new_sale_rate_product.dart';
import 'copy_sale_rate_product_of_franchisee.dart';


class FranchiseeSaleRate extends StatefulWidget {
  const FranchiseeSaleRate({super.key});

  @override
  State<FranchiseeSaleRate> createState() => _FranchiseeSaleRateState();
}

class _FranchiseeSaleRateState extends State<FranchiseeSaleRate> with AddProductSaleRateInterface, FranchiseeDialogInterface,CategoryDialogInterface,CopySaleRateProductOfFranchiseeInterface{


  final _formkey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  String selectedFranchiseeName="";
  String selectedProductCategory="";
  DateTime applicablefrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  String selectedCopyFranchiseeName="";

  List<dynamic> product_list=[
    {
      "id":1,
      "pname":"Product1",
      "rate":1050.00,
      "gst":10,
      "gstAmt":100,
      "net":1150.00,
    },
    {
      "id":2,
      "pname":"Product2",
      "rate":1050.00,
      "gst":10,
      "gstAmt":100,
      "net":1510.00,
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
    return Scaffold(
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
                StringEn.FRANCHISE_SALE_RATE,
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
              child: getSaveAndFinishButtonLayout(SizeConfig.screenHeight, SizeConfig.screenWidth)),
          CommonWidget.getCommonPadding(
              SizeConfig.screenBottom, CommonColor.WHITE_COLOR),

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
              Text("${product_list.length} Products",style: item_regular_textStyle.copyWith(color: Colors.grey),),
             // Text("Round Off : ${double.parse(TotalAmount).round()}",style:  item_regular_textStyle.copyWith(color: Colors.grey)),
              //Text("${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",style: item_heading_textStyle,),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (mounted) {
              setState(() {
                disableColor = true;
              });
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
                     // product_list.isNotEmpty?getFieldTitleLayout(StringEn.PRODUCT_DETAIL):Container(),
                      GestureDetector(
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (context != null) {
                              goToAddOrEditProduct(null);
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
                                  Text(StringEn.ADD_PRODUCT,
                                    style: item_heading_textStyle,),
                                  FaIcon(FontAwesomeIcons.plusCircle,
                                    color: Colors.black87, size: 20,)
                                ],
                              )

                          )
                      )
                    ],
                  ),
                  product_list.isNotEmpty? get_purchase_list_layout(parentHeight,parentWidth):Container(),
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
    return Container(
      height: parentHeight*.6,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemCount: product_list.length,
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
                                        Text("${(product_list[index]['pname'])} ",style: item_heading_textStyle,),
                                      ],
                                    ),
                                    SizedBox(height: 5 ,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Basic Rate",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                            Text("${(product_list[index]['rate']).toStringAsFixed(2)} ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                          ],
                                        ),
                                        SizedBox(width: 5,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("GST ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                            Text("${(product_list[index]['gst']).toStringAsFixed(2)}%  100.00",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                          ],
                                        ),
                                        SizedBox(width: 5,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Net Rate",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                            Text("${(product_list[index]['net']).toStringAsFixed(2)}",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),
                                          ],
                                        ),

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

  Container InvoiceInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey,width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
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
  /* widget for button layout */
  Widget getButtonLayout() {
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
            CommonColor.THEME_COLOR)),
        onPressed: () {

          Navigator.pop(context);
        },
        child: Text(StringEn.SAVE,
            style: button_text_style),
      ),
    );
  }

  /* Widget to get add Product Layout */
  Widget getAddNewProductLayout(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          goToAddOrEditProduct(null);
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
              Text("Add New Product",
                style: item_heading_textStyle,),
              FaIcon(FontAwesomeIcons.plusCircle,
                color: Colors.black87, size: 20,)
            ],
          )
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

  /* Widget to get product rate list Layout */
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
                "Product Name",
              ),
            ),
            numeric: false,
            tooltip: "This is Product Name",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,

              child: Text(
                "Purchase Rate",
              ),
            ),
            numeric: true,
            tooltip: "Product Rate",

          ),
          DataColumn(
            label: Container(
              width:50,

              child: Text(
                "GST(%)",
              ),
            ),
            numeric: true,
            tooltip: "Product GST",

          ),
          DataColumn(
            label: Container(
              width:SizeConfig.screenWidth/4,
              child: Text(
                "Net",

              ),
            ),
            numeric: true,
            tooltip: "Product Net",

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
        rows: product_list
            .map(
              (product) => DataRow(
              cells: [
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4+50,
                      child: Row(
                        children: [
                          IconButton(onPressed: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (context != null) {
                              goToAddOrEditProduct(product);
                            }
                          }, icon: Icon(Icons.edit,color: Colors.green,size: 18,)),
                          Container(
                              width: SizeConfig.screenWidth/4,
                              child: Text("${product['pname']}",overflow: TextOverflow.clip,)),

                        ],
                      )),
                ),
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((product['rate']).toStringAsFixed(2))}")),
                ),
                DataCell(
                  Container(
                      width: 50,
                      child: Text("${product['gst']}")),
                ),
                DataCell(
                  Container(
                      width: SizeConfig.screenWidth/4,
                      child: Text("${((product['net']).toStringAsFixed(2))}")),
                ),
                DataCell(
                  Container(
                      width: 50,
                      child: GestureDetector(
                          onTap: (){
                            product_list.remove(product);
                            setState(() {
                              product_list=product_list;
                            });
                          },
                          child: FaIcon(FontAwesomeIcons.trash,color: Colors.red,))),
                ),
              ]),
        ) .toList(),
      ),
    );
  }

  /* Widget to get add Product Layout */
  Widget getApplicableFromLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: () async{
        FocusScope.of(context).requestFocus(FocusNode());
        if (Platform.isIOS) {
          var date= await CommonWidget.startDate(context,applicablefrom);
          setState(() {
            applicablefrom=date;
          });
          // startDateIOS(context);
        } else if (Platform.isAndroid) {
          var date= await CommonWidget.startDate(context,applicablefrom) ;
          setState(() {
            applicablefrom=date;
          });
        }
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('yyyy-MM-dd').format(applicablefrom),
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.calendar,
                color: Colors.black87, size: 16,)
            ],
          )
      ),
    );
  }

  /* Widget to get Product categoryLayout */
  Widget getProductCategoryLayout(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                    1.0;
                return Transform(
                  transform:
                  Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: a1.value,
                    child: CategoryDialog(
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
        }
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedProductCategory == "" ? StringEn.CATEGORY : selectedProductCategory,
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.caretDown,
                color: Colors.black87.withOpacity(0.8), size: 16,)
            ],
          )
      ),
    );
  }




  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return Padding(
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


  @override
  selectedFranchisee(String id, String name) {
    // TODO: implement selectedFranchisee
    setState(() {
      selectedFranchiseeName=name;
    });
  }


  @override
  selectCategory(String id, String name) {
    // TODO: implement selectCategory
    setState(() {
      selectedProductCategory=name;
    });
  }

  String TotalAmount="0.00";
  calculateTotalAmt()async{
    print("Here");
    var total=0.00;
    for(var item  in product_list ){
      total=total+item['net'];
      print("hjfhjfeefbh  ${item['net']}");
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }


  @override
  addProductSaleRateDetail( dynamic item)async {
    // TODO: implement addProductDetail
    print(item);
    var productList=product_list;
    if(item['id']!=""){
      var index=product_list.indexWhere((element) => item['id']==element['id']);
      setState(() {
        product_list[index]['pname']=item['pname'];
        product_list[index]['rate']=item['rate'];
        product_list[index]['gst']=item['gst'];
        product_list[index]['net']=item['net'];
      });
    }
    else {
      if (productList.contains(item)) {
        print("Already Exist");
      }
      else {
        productList.add(item);
      }
      setState(() {
        product_list = productList;
      });
    }
   await calculateTotalAmt();
  }



  @override
  selectedFranchiseeToCopySaleRateProduct(String id, String name) {
    // TODO: implement selectedFranchiseeToCopyProduct
    setState(() {
      selectedCopyFranchiseeName=name;
    });
  }




}

