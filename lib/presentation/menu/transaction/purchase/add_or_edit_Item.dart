import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';

class AddOrEditItem extends StatefulWidget {
  final AddOrEditItemInterface mListener;
  final dynamic editproduct;

  const AddOrEditItem({super.key, required this.mListener, required this.editproduct});

  @override
  State<AddOrEditItem> createState() => _AddOrEditItemState();
}

class _AddOrEditItemState extends State<AddOrEditItem>{

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  FocusNode itemFocus = FocusNode() ;

  TextEditingController quantity = TextEditingController();
  FocusNode quantityFocus = FocusNode() ;

  TextEditingController unit = TextEditingController();

  TextEditingController rate = TextEditingController();

  TextEditingController amount = TextEditingController();

  TextEditingController discount = TextEditingController();
  FocusNode discountFocus = FocusNode() ;

  TextEditingController discountAmt = TextEditingController();

  TextEditingController taxableAmt = TextEditingController();

  TextEditingController gst = TextEditingController();
  FocusNode gstFocus = FocusNode() ;

  TextEditingController gstAmount = TextEditingController();

  TextEditingController netRate = TextEditingController();

  TextEditingController netAmount = TextEditingController();


  FocusNode searchFocus = FocusNode() ;
  //
  // _onChangeHandler(value ) {
  //   const duration = Duration(milliseconds:800); // set the duration that you want call search() after that.
  //   if (searchOnStoppedTyping != null) {
  //     setState(() => searchOnStoppedTyping.cancel()); // clear timer
  //   }
  //   setState(() => searchOnStoppedTyping =  Timer(duration, () => search(value)));
  // }
  //
  // search(value) {
  //   searchFocus.unfocus();
  //   isApiCall = false;
  //   page = 0;
  //   isPagination = true;
  //   callGetNoticeListingApi(page,value,true);
  //   print('hello world from search . the value is $value');
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  setVal()async{
    if(widget.editproduct!=null){
      setState(() {
        _textController.text=widget.editproduct['itemName'];
        unit.text=widget.editproduct['unit'].toString();
        quantity.text=widget.editproduct['quantity'].toString();
        rate.text=widget.editproduct['rate'].toString();
        amount.text=widget.editproduct['amount'].toString();
        discount.text=widget.editproduct['discount']==null?"0":widget.editproduct['discount'].toString();
        discountAmt.text=widget.editproduct['discountAmt'].toString();
        taxableAmt.text=widget.editproduct['taxableAmt'].toString();
        gst.text=widget.editproduct['gst'].toString();
        gstAmount.text=widget.editproduct['gstAmt'].toString();
        netRate.text=widget.editproduct['netRate'].toString();
        netAmount.text=widget.editproduct['netAmt'].toString();


      });
      await calculateRates();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: Container(
              height: SizeConfig.screenHeight*0.8,
              decoration: const BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight*.08,
                      child: const Center(
                        child: Text(
                            StringEn.ADD_ITEM_DETAIL,
                            style: page_heading_textStyle
                        ),
                      ),
                    ),
                    getFieldTitleLayout(StringEn.ITEM_NAME),
                    getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getFieldTitleLayout(StringEn.QUANTITY),
                    getItemQuantityLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     getItemQuantityLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                    //     getUnitLayout(SizeConfig.screenHeight,SizeConfig.screenWidth)
                    //   ],
                    // ),

                    getRateAndAmount(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getItemDiscountandAmtLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getTaxableAmtLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getITemgstAndGstAmtLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                    getItemNetRateAndNetAmtLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: getAddForButtonsLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          ),        ],
      ),
    );
  }
//franchisee name
  Widget getAddSearchLayout(double parentHeight, double parentWidth){
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
        textInputAction: TextInputAction.done,
        // autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.text,
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        focusNode: searchFocus,
        style: text_field_textStyle,
        decoration: textfield_decoration.copyWith(
          hintText: "Item Name",
          prefixIcon: Container(
              width: 50,
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
        ),
        // onChanged: _onChangeHandler,
      ),
    );
  }


  /* widget for item quantity layout */
  Widget getItemQuantityLayout(double parentHeight, double parentWidth) {
    return Container(
      height: parentHeight * .055,
      // width: (parentWidth*0.8)/2,
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
        keyboardType: TextInputType.number,
        controller: quantity,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.QUANTITY,
          suffix: Container(
              width: 50,
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Text("${unit.text}",style: item_regular_textStyle,)),
        ),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Enter Item Quantity";
          }
          return null;
        }),
        onChanged: (value)async{
          await calculateRates();
        },
        onTapOutside: (event) {

        },
      ),
    );
  }

  // rate amount layout
  Widget getRateAndAmount(double parentHeight, double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.RATE),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.TexField_COLOR,
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
                keyboardType: TextInputType.number,
                controller: rate,
                readOnly: true,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.RATE,
                    fillColor: CommonColor.TexField_COLOR
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Rate";
                  }
                  return null;
                }),
                onChanged: (value){

                },
                onTapOutside: (event) {

                },
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.AMOUNT),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.TexField_COLOR,
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
                keyboardType: TextInputType.number,
                controller: amount,
                readOnly: true,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.AMOUNT,
                    fillColor: CommonColor.TexField_COLOR
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Amt";
                  }
                  return null;
                }),
                onChanged: (value){

                },
                onTapOutside: (event) {

                },
              ),
            )
          ],
        )

      ],
    );
  }


  /* widget for product discount layout */
  Widget getItemDiscountandAmtLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.DICOUNT),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
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
                keyboardType: TextInputType.number,
                controller: discount,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.DICOUNT,
                    suffix: Text("%")
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Item discount";
                  }
                  return null;
                }),
                onChanged: (value){
                  calculateRates();
                },
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.DISCOUNT_AMT),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.TexField_COLOR,
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
                keyboardType: TextInputType.number,
                controller: discountAmt,
                readOnly: true,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.DISCOUNT_AMT,
                    fillColor: CommonColor.TexField_COLOR
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Discount";
                  }
                  return null;
                }),
                onChanged: (value){

                },
                onTapOutside: (event) {

                },
              ),
            )
          ],
        ),
      ],
    );
  }


  /* widget for product gst layout */
  Widget getTaxableAmtLayout(double parentHeight, double parentWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFieldTitleLayout(StringEn.TAX_AMT),
        Container(
          height: parentHeight * .055,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CommonColor.TexField_COLOR,
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
            keyboardType: TextInputType.number,
            controller: taxableAmt,
            readOnly: true,
            decoration: textfield_decoration.copyWith(
                hintText: StringEn.TAX_AMT,
                fillColor: CommonColor.TexField_COLOR
            ),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Enter taxable amt";
              }
              return null;
            }),
            onChanged: (value){

            },
            onTapOutside: (event) {

            },
          ),
        )
      ],
    );
  }


  /* widget for product gst layout */
  Widget getITemgstAndGstAmtLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.GST+"%"),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
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
                keyboardType: TextInputType.number,
                controller: gst,
                decoration: textfield_decoration.copyWith(
                    hintText: "${StringEn.GST}%",
                    suffix: Text("%")
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Item gst";
                  }
                  return null;
                }),
                onChanged: (value){
                  calculateRates();
                },
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.GST_AMT),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.TexField_COLOR,
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
                keyboardType: TextInputType.number,
                controller: gstAmount,
                readOnly: true,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.GST_AMT,
                    fillColor: CommonColor.TexField_COLOR
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter gst amt";
                  }
                  return null;
                }),
                onChanged: (value){

                },
                onTapOutside: (event) {

                },
              ),
            )
          ],
        ),
      ],
    );
  }


  /* widget for product gst layout */
  Widget getItemNetRateAndNetAmtLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.NET_RATE),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.TexField_COLOR,
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
                keyboardType: TextInputType.number,
                controller: netRate,
                readOnly: true,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.NET_RATE,
                    fillColor: CommonColor.TexField_COLOR

                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter Item net rate";
                  }
                  return null;
                }),
                onChanged: (value){

                },
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getFieldTitleLayout(StringEn.NET),
            Container(
              height: parentHeight * .055,
              width: (parentWidth*0.8)/2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CommonColor.TexField_COLOR,
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
                keyboardType: TextInputType.number,
                controller: netAmount,
                readOnly: true,
                decoration: textfield_decoration.copyWith(
                    hintText: StringEn.NET,
                    fillColor: CommonColor.TexField_COLOR
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter net amt";
                  }
                  return null;
                }),
                onChanged: (value){

                },
                onTapOutside: (event) {

                },
              ),
            )
          ],
        ),
      ],
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


  /* Widget for Buttons Layout0 */
  Widget getAddForButtonsLayout(double parentHeight,double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onDoubleTap: () {},
          child: Container(
            height:parentHeight*.05,
            width: parentWidth*.45,
            // width: SizeConfig.blockSizeVertical * 20.0,
            decoration: const BoxDecoration(
              color: CommonColor.HINT_TEXT,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringEn.CLOSE,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            var item={
              "id":widget.editproduct!=null?widget.editproduct['id']:"",
              "itemName":_textController.text,
              "quantity":int.parse(quantity.text),
              "unit":"kg",
              "rate":double.parse(rate.text),
              "amt":double.parse(amount.text),
              "discount":discount.text==""||discount.text==null?double.parse("00.00"):double.parse(discount.text),
              "discountAmt":double.parse(discountAmt.text),
              "taxableAmt":double.parse(taxableAmt.text),
              "gst":gst.text==""||gst.text==null?double.parse("00.00"):double.parse(gst.text),
              "gstAmt":double.parse(gstAmount.text),
              "netRate":double.parse(netRate.text),
              "netAmount":double.parse(netAmount.text)
            };
            if(widget.mListener!=null){

              widget.mListener.AddOrEditItemDetail(item);
              Navigator.pop(context);
            }
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth*.45,
            decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringEn.SAVE,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  calculateAmt(){
    var amt=int.parse(quantity.text)*double.parse(rate.text);
    setState(() {
      amount.text=amt.toStringAsFixed(2);
    });
  }

  calculateDiscountAmt(){
    var disAmt=double.parse(amount.text)*(double.parse(discount.text)/100);
    setState(() {
      discountAmt.text=disAmt.toStringAsFixed(2);
    });
  }

  calculateTaxableAmt(){
    var taxAmt=double.parse(amount.text)-double.parse(discountAmt.text);
    setState(() {
      taxableAmt.text=taxAmt.toStringAsFixed(2);
    });
  }

  calculateGstAmt(){
    var gstAmt=double.parse(taxableAmt.text)*(double.parse(gst.text)/100);
    setState(() {
      gstAmount.text=gstAmt.toStringAsFixed(2);
    });
  }

  calculateNetAmt(){
    var netamt=double.parse(taxableAmt.text)+double.parse(gstAmount.text);
    setState(() {
      netAmount.text=netamt.toStringAsFixed(2);
    });
  }

  calculateNetRate(){
    var netRates=double.parse(netAmount.text)/int.parse(quantity.text);
    setState(() {
      netRate.text=netRates.toStringAsFixed(2);
    });
  }

  calculateRates()async{
    if(quantity.text!=""&&rate.text!="") {
      await calculateAmt();

      if(discount.text!="") {
        await calculateDiscountAmt();
        await calculateTaxableAmt();

        if(gst.text!="")
        {
          await calculateGstAmt();
          await calculateNetAmt();
          await calculateNetRate();
        }
      }
    }

  }


}


abstract class AddOrEditItemInterface{
  AddOrEditItemDetail(dynamic item);
}