import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';

import '../../../../core/localss/application_localizations.dart';
import '../../../common_widget/get_diable_textformfield.dart';
import '../../../common_widget/signleLine_TexformField.dart';

class AddProductSaleRate extends StatefulWidget {
  final AddProductSaleRateInterface mListener;
  final dynamic editproduct;

  const AddProductSaleRate({super.key, required this.mListener, required this.editproduct});

  @override
  State<AddProductSaleRate> createState() => _AddProductSaleRateState();
}

class _AddProductSaleRateState extends State<AddProductSaleRate>{

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
                          ApplicationLocalizations.of(context)!.translate("add_item")!,
                          style: page_heading_textStyle
                      ),
                    ),
                  ),
                  getFieldTitleLayout(   ApplicationLocalizations.of(context)!.translate("item")!,),
                  getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                  getProductRateLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                  getProductGSTLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                  getGstAmountLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

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

    print("HE");
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



  /* widget for product net layout */
  Widget getProductNetLayout(double parentHeight, double parentWidth) {
    return GetDisableTextFormField(
      controller: net,
      title:    ApplicationLocalizations.of(context)!.translate("net_rate")!,
    );
  }

  /* widget for gst amount layout */
  Widget getGstAmountLayout(double parentHeight, double parentWidth) {
    return GetDisableTextFormField(
      controller: gstAmt,
      title:    ApplicationLocalizations.of(context)!.translate("gst_amount")!,
    );

  }

  /* widget for product gst layout */
  Widget getProductGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      suffix:Text("%"),
      validation: (value) {
        if (value!.isEmpty) {
          return    ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("gst_percent")!;
        }
        return null;
      },
      controller: gst,
      focuscontroller: null,
      focusnext: null,
      title:ApplicationLocalizations.of(context)!.translate("gst_percent")!,
      callbackOnchage: (value) async{
        print("here");
        setState(() {
          gst.text = value;
        });
        await calculateNetAmt();
        await calculateOriginalAmt();
        await calculateGstAmt();
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 $.]')),
    );

  }
  calculateGstAmt(){
    if(rate.text!="" && gst.text!="") {
      var gstAmtt = double.parse(rate.text) * (double.parse(gst.text) / 100);
      setState(() {
        gstAmt.text = gstAmtt.toStringAsFixed(2).toString();
      });
    }
  }

  /* widget for product rate layout */
  Widget getProductRateLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(

      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ ApplicationLocalizations.of(context)!.translate("sale_rate")!;
        }
        return null;
      },
      controller: rate,
      focuscontroller: null,
      focusnext: null,
      title:  ApplicationLocalizations.of(context)!.translate("sale_rate")!,
      callbackOnchage: (value)async {
        print("#");
        setState(() {
          rate.text = value;
        });
        await calculateNetAmt();
        await calculateGstAmt();
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 $.]')),
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
        keyboardType: TextInputType.text,
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        focusNode: searchFocus,
        style: text_field_textStyle,
        decoration: textfield_decoration.copyWith(
          hintText:    ApplicationLocalizations.of(context)!.translate("item_name")!,
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
          child: Center(
            child: Text(
              ApplicationLocalizations.of(context)!.translate("close")!,
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
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("close")!,
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

              widget.mListener.addProductSaleRateDetail(item);
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
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("save")!,
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


abstract class AddProductSaleRateInterface{
  addProductSaleRateDetail(dynamic item);
}