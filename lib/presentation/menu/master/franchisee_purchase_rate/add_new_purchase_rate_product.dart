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

  setVal(){
    if(widget.editproduct!=null){
      setState(() {
        _textController.text=widget.editproduct['pname'];
        rate.text=widget.editproduct['rate'].toString();
        gst.text=widget.editproduct['gst'].toString();
        net.text=widget.editproduct['net'].toString();

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
              height: SizeConfig.screenHeight*0.8,
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
                          StringEn.ADDPRODUCT,
                          style: page_heading_textStyle
                      ),
                    ),
                  ),
                  getFieldTitleLayout(StringEn.PRODUCTS),
                  getAddSearchLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

                  getFieldTitleLayout(StringEn.PURCHASE_RATE),
                  getProductRateLayout(),

                  getFieldTitleLayout(StringEn.GST),
                  getProductGSTLayout(),

                  getFieldTitleLayout(StringEn.NET),
                  getProductNetLayout(),

                  SizedBox(height: 20,),
                  getButtonLayout()


                ],
              ),
            ),
          ),
          getCloseButton(SizeConfig.screenHeight,SizeConfig.screenWidth),
        ],
      ),
    );
  }

  calculateNetAmt(){

    if(rate.text!="" && gst.text!=""){
      var netAmt=double.parse(rate.text)+((double.parse(rate.text)*(double.parse(gst.text))) / 100);
      print(netAmt);
      setState(() {
        net.text=netAmt.toString();
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
  Widget getProductNetLayout() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: net,
      readOnly: true,
      decoration: textfield_decoration.copyWith(
          hintText: StringEn.NET,
        fillColor:  CommonColor.TexField_COLOR,

      ),
      validator: ((value) {
        if (value!.isEmpty) {
          return "Net Amt.";
        }
        return null;
      }),
    );
  }


  /* widget for product gst layout */
  Widget getProductGSTLayout() {
    return TextFormField(
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
      },
    );
  }
  
  /* widget for product rate layout */
  Widget getProductRateLayout() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(
        decimal: true
      ),
      controller: rate,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.PURCHASE_RATE,
      ),
      validator: ((value) {
        if (value!.isEmpty) {
          return "Enter Product Rate";
        }
        return null;
      }),
      onChanged: (value){
        calculateNetAmt();
      },
    );
  }

  Widget getAddSearchLayout(double parentHeight, double parentWidth){
    return TextFormField(
      textInputAction: TextInputAction.done,
      // autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      controller: _textController,
      textAlignVertical: TextAlignVertical.center,
      focusNode: searchFocus,
      style: text_field_textStyle,
      decoration: textfield_decoration.copyWith(
        hintText: "Product Name",
        prefixIcon: Container(
            width: 50,
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: FaIcon(FontAwesomeIcons.search,size: 20,color: Colors.grey,)),
      ),
      // onChanged: _onChangeHandler,
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

}


abstract class AddProductPurchaseRateInterface{
  addProductPurchaseRateDetail(dynamic item);
}