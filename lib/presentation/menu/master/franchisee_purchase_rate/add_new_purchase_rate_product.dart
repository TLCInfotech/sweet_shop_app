import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';

class AddProductPurchaseRate extends StatefulWidget {
  final AddProductPurchaseRateInterface mListener;
  final dynamic editproduct;

  const AddProductPurchaseRate({super.key, required this.mListener, required this.editproduct});

  @override
  State<AddProductPurchaseRate> createState() => _AddProductPurchaseRateState();
}

class _AddProductPurchaseRateState extends State<AddProductPurchaseRate>{

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController net = TextEditingController();
  TextEditingController gstAmt = TextEditingController();

  FocusNode searchFocus = FocusNode() ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
  }

  setVal(){
    if(widget.editproduct!=null){
      setState(() {
        _textController.text=widget.editproduct['pname'];
        rate.text=widget.editproduct['rate'].toString();
        gst.text=widget.editproduct['gst'].toString();
        net.text=widget.editproduct['net'].toString();
        gstAmt.text=widget.editproduct['gstAmt'].toString();

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: Container(
              height: SizeConfig.screenHeight*0.7,
              decoration: BoxDecoration(
                color: Color(0xFFfffff5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.screenHeight*.08,
                    child: Center(
                      child: Text(
                          StringEn.ADD_ITEMS,
                          style: page_heading_textStyle
                      ),
                    ),
                  ),
                  getFieldTitleLayout(StringEn.ITEM),
                  getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                  getFieldTitleLayout(StringEn.SALE_RATE),
                  getProductRateLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                  getFieldTitleLayout("${StringEn.GST}%"),
                  getProductGSTLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                  getFieldTitleLayout(StringEn.GST_AMT),
                  getGstAmountLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                  getFieldTitleLayout(StringEn.NET_RATE),
                  getProductNetLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth*.05,right: SizeConfig.screenWidth*.05),
            child: getAddForButtonsLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          ),
        ],
      ),
    );
  }

  calculateNetAmt(){

    if(rate.text!="" && gst.text!=""){
      var netAmt=double.parse(rate.text)+((double.parse(rate.text)*(double.parse(gst.text))) / 100);
      print(netAmt);
      setState(() {
        net.text=(netAmt.toStringAsFixed(2)).toString();
      });
    }
    else{
      net.clear();
    }
  }

  calculateOriginalAmt(){
    if(net.text!="" && gst.text!=""){
      var gstamt =double.parse(net.text) - (double.parse(net.text) / (1 + (double.parse(gst.text)/100)));
      var originalAmt = double.parse(net.text)- gstamt;

      setState(() {
        rate.text=(originalAmt.toStringAsFixed(2)).toString();
      });
    }
    else{
      net.clear();
    }
  }
  
  /* widget for button layout */
  Widget getButtonLayout() {
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
            CommonColor.THEME_COLOR)),
        onPressed: () {

          var item={
            "id":widget.editproduct!=null?widget.editproduct['id']:"",
            "pname":_textController.text,
            "rate":double.parse(rate.text),
            "gst":double.parse(gst.text),
            "net":double.parse(net.text)
          };
          if(widget.mListener!=null){

            widget.mListener.addProductPurchaseRateDetail(item);
            Navigator.pop(context);
          }

          // Navigator.pop(context);
        },
        child: Text(StringEn.ADD,
            style: button_text_style),
      ),
    );
  }


  /* widget for product net layout */
  Widget getProductNetLayout(double parentHeight, double parentWidth) {
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
        keyboardType: TextInputType.number,
        controller: net,
        readOnly: true,
        decoration: textfield_decoration.copyWith(
            hintText: StringEn.NET_RATE,
            fillColor: CommonColor.TexField_COLOR
        ),
        onChanged: (value){

          calculateOriginalAmt();
        },
        validator: ((value) {
          if (value!.isEmpty) {
            return "Net Amt.";
          }
          return null;
        }),
        onTapOutside: (event) {
          setState(() {
            net.text=(double.parse(net.text).toStringAsFixed(2)).toString();
          });
        },
      ),
    );
  }

  /* widget for gst amount layout */
  Widget getGstAmountLayout(double parentHeight, double parentWidth) {
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

        keyboardType: TextInputType.number,
        controller: gstAmt,
        readOnly: true,
        decoration: textfield_decoration.copyWith(
            hintText: StringEn.GST_AMT,
            fillColor: CommonColor.TexField_COLOR
        ),
        onChanged: (value){

        },
        validator: ((value) {
          if (value!.isEmpty) {
            return "Net Amt.";
          }
          return null;
        }),
        onTapOutside: (event) {
          setState(() {
            gstAmt.text=(double.parse(net.text).toStringAsFixed(2)).toString();
          });
        },
      ),
    );
  }

  /* widget for product gst layout */
  Widget getProductGSTLayout(double parentHeight, double parentWidth) {
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
        keyboardType: TextInputType.number,
        controller: gst,
        decoration: textfield_decoration.copyWith(
            hintText: StringEn.RATE,
            suffix: Text("%")
        ),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Enter Product GST";
          }
          return null;
        }),
        onChanged: (value){
          calculateNetAmt();
          calculateOriginalAmt();
          calculateGstAmt();
        },
      ),
    );
  }
  calculateGstAmt(){
    var gstAmtt=double.parse(rate.text)*(double.parse(gst.text)/100);
    setState(() {
      gstAmt.text=gstAmtt.toStringAsFixed(2);
    });
  }

  /* widget for product rate layout */
  Widget getProductRateLayout(double parentHeight, double parentWidth) {
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
        keyboardType: TextInputType.numberWithOptions(
            decimal: true
        ),
        controller: rate,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.SALE_RATE,
        ),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Enter Product Rate";
          }
          return null;
        }),
        onChanged: (value){

          calculateNetAmt();
          calculateGstAmt();
        },
        onTapOutside: (event) {
          setState(() {
            rate.text=(double.parse(rate.text).toStringAsFixed(2)).toString();
          });
        },
      ),
    );
  }

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
        keyboardType: TextInputType.emailAddress,
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        focusNode: searchFocus,
        style: text_field_textStyle,
        decoration: textfield_decoration.copyWith(
          hintText:StringEn.ITEM_NAME,
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
  
  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: item_heading_textStyle,
      ),
    );
  }


  Widget getCloseButton(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .05, right: parentWidth * .05),
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
          // Scaffold.of(context).openDrawer();
        },
        child: Container(
          height: parentHeight*.065,
          decoration: const BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7),
              bottomRight: Radius.circular(7),
            ),
          ),
          child:const Center(
            child: Text(
              StringEn.CLOSE,
              textAlign: TextAlign.center,
              style: text_field_textStyle,
            ),
          ),
        ),
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
              "pname":_textController.text,
              "rate":double.parse(rate.text),
              "gst":double.parse(gst.text),
              "net":double.parse(net.text)
            };
            if(widget.mListener!=null){

              widget.mListener.addProductPurchaseRateDetail(item);
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



}


abstract class AddProductPurchaseRateInterface{
  addProductPurchaseRateDetail(dynamic item);
}