import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

import 'copy_purchase_rate_product_of_franchisee.dart';

class FranchiseePurchaseRate extends StatefulWidget {
  const FranchiseePurchaseRate({super.key});

  @override
  State<FranchiseePurchaseRate> createState() => _FranchiseePurchaseRateState();
}

class _FranchiseePurchaseRateState extends State<FranchiseePurchaseRate> with AddProductPurchaseRateInterface, FranchiseeDialogInterface,CategoryDialogInterface,CopyPurchaseRateProductOfFranchiseeInterface{


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
      "net":1150.00,
    },
    {
      "id":2,
      "pname":"Product2",
      "rate":1050.00,
      "gst":10,
      "net":1510.00,
    },
  ];

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
              title: Text(
                StringEn.FRANCHISE_PURCHASE_RATE,
                style: appbar_text_style,),
            ),
          ),
        ),
      ),
      body:  Container(
        height: SizeConfig.safeUsedHeight,
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xFFfffff5),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.halfscreenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getFieldTitleLayout(StringEn.CATEGORY),
                        getProductCategoryLayout(),
                      ],
                    ),
                  ),

                  Container(
                    width: SizeConfig.halfscreenWidth,
                    child: Column(
                      children: [
                        getFieldTitleLayout(StringEn.APPLICABLE_FROM),
                        getApplicableFromLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                      ],
                    ),
                  )
                ],
              ),

              CopyPurchaseRateProductOfFranchisee(mListener: this,),

              product_list.length>0?getFieldTitleLayout(StringEn.PRODUCTS):Container(),

              getProductRateListLayout(),
              SizedBox(height: 20,),
              getAddNewProductLayout(),
              SizedBox(height: 20,),

              getButtonLayout()

            ],
          ),
        ),
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
                  child: AddProductPurchaseRate(
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

  @override
  selectedFranchiseeToCopyPurchaseRateProduct(String id, String name) {
    // TODO: implement selectedFranchiseeToCopyProduct
    setState(() {
      selectedCopyFranchiseeName=name;
    });
  }



  @override
  addProductPurchaseRateDetail( dynamic item) {
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
  }

}
