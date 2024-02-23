import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dialog/category_dialog.dart';

import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../core/imagePicker/image_picker_dialog.dart';
import '../../core/imagePicker/image_picker_dialog_for_profile.dart';
import '../../core/imagePicker/image_picker_handler.dart';
import '../../core/localss/application_localizations.dart';
import '../../core/string_en.dart';
import '../dialog/franchisee_dialog.dart';

class GetAmountTypeCrDr extends StatefulWidget{
  final title;
  final Function(dynamic?) callback;
  final titleIndicator;
  final selectedType;

  GetAmountTypeCrDr({required this.title, required this.callback,   this.titleIndicator,required this.selectedType});

  @override
  State<GetAmountTypeCrDr> createState() => _GetAmountTypeCrDrState();
}

class _GetAmountTypeCrDrState extends State<GetAmountTypeCrDr> {
  List<String> AmountType = ["Cr","Dr"];

  String ?selectedType = null;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  widget.titleIndicator!=false?EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02):EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.titleIndicator!=false? Text(
            widget.title,
            style: item_heading_textStyle,
          ):Container(),
          Padding(
            padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
            child:    Container(
              height: (SizeConfig.screenHeight) * .055,
              padding: EdgeInsets.only(left: 10, right: 10),
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
              child: DropdownButton<dynamic>(
                hint: Text(
                  ApplicationLocalizations.of(context)!.translate("amount_type")!, style: hint_textfield_Style,),
                underline: SizedBox(),
                isExpanded: true,
                value:widget.selectedType,
                onChanged: (newValue) {
                  widget.callback(newValue);
                },
                items: AmountType.map((dynamic limit) {
                  return DropdownMenuItem<dynamic>(
                    value: limit,
                    child: Text(limit.toString(), style: item_regular_textStyle),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

}