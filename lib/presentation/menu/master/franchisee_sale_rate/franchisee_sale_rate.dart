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
import 'package:sweet_shop_app/presentation/menu/master/franchisee_sale_rate/add_new_sale_rate_product.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_category_layout.dart';
import '../../../common_widget/get_date_layout.dart';

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

  List<dynamic> product_list=[
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
              title: Text(
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
              child: getSaveAndFinishButtonLayout(
                  SizeConfig.screenHeight, SizeConfig.screenWidth)),
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
              Text("${product_list.length} Items",style: item_regular_textStyle.copyWith(color: Colors.grey),),
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
                      //product_list.isNotEmpty?getFieldTitleLayout(StringEn.PRODUCT_DETAIL):Container(),
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
    return   Container(
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (context != null) {
                      goToAddOrEditProduct(product_list[index]);
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
                                          Text("${product_list[index]['pname']}",style: item_heading_textStyle,),

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
                                                Text("${(product_list[index]['rate']).toStringAsFixed(2)}/kg ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.black87),),
                                                //Text("${(product_list[index]['gst']).toStringAsFixed(2)}% ",overflow: TextOverflow.clip,style: item_regular_textStyle,),
                                                Text("${(product_list[index]['net']).toStringAsFixed(2)}/kg ",overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),

                                                //  Text(CommonWidget.getCurrencyFormat(product_list[index]['net']),overflow: TextOverflow.clip,style: item_heading_textStyle.copyWith(color: Colors.blue),),

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
                                          product_list.remove(product_list[index]);
                                          setState(() {
                                            product_list=product_list;
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
              title:  StringEn.FRANCHISE,
              callback: (name){
                setState(() {
                  selectedCopyFranchiseeName=name!;
                });
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
        title:  StringEn.DATE ,
        callback: (name){
          setState(() {
            applicablefrom=name!;
          });
        },
        applicablefrom: applicablefrom);

  }

  /* Widget to get Product categoryLayout */
  Widget getProductCategoryLayout(){
    return  GetCategoryLayout(
        titleIndicator:false,
        title:  StringEn.CATEGORY ,
        callback: (name){
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




}

