import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';

const big_title_style=TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontFamily: "Inter_Bold_Font"
);

const subHeading_withBold=TextStyle(
  fontSize: 16.0,
  color: Colors.white,
  fontFamily: "Inter_Medium_Font"
);

var button_text_style=TextStyle(
    color: Colors.black87,
    fontSize: SizeConfig.blockSizeHorizontal* 4.5,
    fontWeight: FontWeight.w500,
    fontFamily: "Inter_Medium_Font"
);

const textfield_label_style=TextStyle(
    fontSize: 18.0,
    color: Colors.white,
    fontFamily: "Inter_Medium_Font"

);

const hint_textfield_Style = TextStyle(
    fontFamily: 'Inter_Regular_Font',
    color:Colors.grey,
    fontSize: 18
);

const textfield_decoration = InputDecoration(
  hintText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  labelStyle: textfield_label_style,
  fillColor:  Colors.white,
  filled: true,
  hintStyle: hint_textfield_Style,
  floatingLabelStyle: TextStyle(fontFamily: 'Inter_Medium_Font',fontSize: 20,color: Colors.indigo,fontWeight: FontWeight.w700),

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent,width: 0.5),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.transparent,width: 1),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  errorBorder:  OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),

);

var box_decoration=BoxDecoration(
  color: CommonColor.WHITE_COLOR,
  borderRadius: BorderRadius.circular(4),
  boxShadow: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 5,
      color: Colors.black.withOpacity(0.1),
    ),
  ],
);


const appbar_text_style=TextStyle(
    fontSize: 22.0,
    color: Colors.black87,
    fontFamily: "Inter_SemiBold_Font"
);

const page_heading_textStyle=TextStyle(
    fontSize: 20.0,
    color: Colors.black87,
    fontFamily: "Inter_SemiBold_Font"
);

const text_field_textStyle=TextStyle(
    fontSize: 18,
    color: Colors.black87,
    fontFamily: "Inter_SemiBold_Font"
);


const item_heading_textStyle=TextStyle(
    fontSize: 18.0,
    color: Colors.black87,
    fontFamily: "Inter_Medium_Font"
);


const item_regular_textStyle=TextStyle(
    fontSize: 16.0,
    color: Colors.black87,
    fontFamily: "Inter_Light_Font"
);

