import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';

import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../core/string_en.dart';

class SingleLineEditableTextFormField extends StatefulWidget{
  final title;
  final Function(String) callbackOnchage;
  final controller;
  final focuscontroller;
  final focusnext;
  final textInput;
  final maxlines;
  final format;
  final parentWidth;
  final maxlength;
  final String? Function(dynamic value) validation;
  // final Function(String) validation;
  final suffix;
  final readOnly;

  SingleLineEditableTextFormField({required this.title,required this.callbackOnchage,required this.controller,required this.focuscontroller,required this.focusnext,required this.textInput,required this.maxlines,required this.format, this.parentWidth,  this.maxlength, required this.validation, this.suffix,  this.readOnly, });

  @override
  State<SingleLineEditableTextFormField> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SingleLineEditableTextFormField> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: item_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: widget.parentWidth ==null? (SizeConfig.screenWidth ):  widget.parentWidth *.4,
                  height: widget.maxlines>1? (SizeConfig.screenHeight) * .15:(SizeConfig.screenHeight) * .055,
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
                    onChanged: (value){widget.callbackOnchage(value);},
                    readOnly: widget.readOnly!=false?false:true,
                    inputFormatters:<TextInputFormatter>[widget.format],
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.words,
                    focusNode: widget.focuscontroller,
                    keyboardType:widget.textInput,
                    maxLines: widget.maxlines,
                    maxLength: widget.maxlength==null?500:widget.maxlength,
                    scrollPadding: EdgeInsets.only(bottom: (SizeConfig.screenHeight) * .2),
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: (SizeConfig.screenWidth) * .04, right: (SizeConfig.screenWidth) * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: widget.title,
                      hintStyle: hint_textfield_Style,

                      suffix: widget.suffix!=null?widget.suffix:Container(height: 2,width: 2,),
                    ),
                    controller: widget.controller,
                    validator: widget.validation,
                    onEditingComplete: () {
                      if(widget.focuscontroller!=null) {
                        widget.focuscontroller.unfocus();
                        FocusScope.of(context).requestFocus(widget.focusnext);
                      }
                    },

                    style: text_field_textStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}