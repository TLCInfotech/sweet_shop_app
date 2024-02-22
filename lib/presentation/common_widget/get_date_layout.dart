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
import '../../core/string_en.dart';
import '../dialog/franchisee_dialog.dart';

class GetDateLayout extends StatefulWidget{
  final title;
  final applicablefrom;
  final Function(DateTime?) callback;
  final titleIndicator;

  GetDateLayout({required this.title, required this.callback, required this.applicablefrom,   this.titleIndicator});

  @override
  State<GetDateLayout> createState() => _GetDateLayoutState();
}

class _GetDateLayoutState extends State<GetDateLayout> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  widget.titleIndicator!=false?EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02):EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.titleIndicator!=false? Text(
            widget.title,
            style: page_heading_textStyle,
          ):Container(),
          Padding(
            padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
            child: Container(
              height: (SizeConfig.screenHeight) * .055,
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
                onTap: () async{
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (Platform.isIOS) {
                    var date= await CommonWidget.startDate(context,widget.applicablefrom);
                     widget.callback(date);
                    // startDateIOS(context);
                  } else if (Platform.isAndroid) {
                    var date= await CommonWidget.startDate(context,widget.applicablefrom) ;
                    widget.callback(date);
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
                        Text(
                          CommonWidget.getDateLayout(widget.applicablefrom),
                          //DateFormat('dd-MM-yyyy').format(applicablefrom),
                          style: item_regular_textStyle,),
                        FaIcon(FontAwesomeIcons.calendar,
                          color: Colors.black87, size: 16,)
                      ],
                    )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}