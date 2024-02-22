import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';

import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../core/imagePicker/image_picker_dialog.dart';
import '../../core/imagePicker/image_picker_dialog_for_profile.dart';
import '../../core/imagePicker/image_picker_handler.dart';
import '../../core/string_en.dart';
import '../dialog/franchisee_dialog.dart';
import '../dialog/state_dialog.dart';

class GetStateLayout extends StatefulWidget{
  final title;
  final stateName;
  final Function(String?) callback;

  GetStateLayout({required this.title, required this.callback, required this.stateName});

  @override
  State<GetStateLayout> createState() => _GetStateLayoutState();
}

class _GetStateLayoutState extends State<GetStateLayout> with     SingleTickerProviderStateMixin,StateDialogInterface {

  @override
  Widget build(BuildContext context) {
    return    Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02),
      child: Container(
        width: (SizeConfig.screenWidth) * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              widget.title,
              style: item_heading_textStyle,
            ),
            GestureDetector(
              onTap: () {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: StateDialog(
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
              onDoubleTap: () {},
              child: Padding(
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
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.stateName == "" ? StringEn.SELECT_STATE : widget.stateName,
                          style: widget.stateName == ""
                              ? hint_textfield_Style
                              : text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: (SizeConfig.screenHeight) * .03,
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
      ),
    );
  }
  @override
  selectState(String id, String name) {
    widget.callback(name);
  }

}