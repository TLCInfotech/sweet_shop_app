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
import '../dialog/measuring_unit_dialog.dart';

class GetUnitLayout extends StatefulWidget{
  final title;
  final measuringUnit;
  final Function(String?) callback;
  final titleIndicator;
  final parentWidth;

  GetUnitLayout({required this.title, required this.callback, required this.measuringUnit,   this.titleIndicator,this.parentWidth});

  @override
  State<GetUnitLayout> createState() => _GetUnitLayoutState();
}

class _GetUnitLayoutState extends State<GetUnitLayout> with SingleTickerProviderStateMixin,MeasuringUnitDialogInterface {
  bool isCategoryValidShow = false;
  bool isCategoryMsgValidShow = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.titleIndicator!=false? Text(
            widget.title,
            style: item_heading_textStyle,
          ):Container(),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if(mounted){
                setState(() {
                  isCategoryMsgValidShow=false;
                  isCategoryValidShow=false;
                });
              }
              if (context != null) {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform:
                        Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: MeasuringUnitDialog(
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
              }
            },
            onDoubleTap: () {},
            child: Padding(
              padding: EdgeInsets.only(
                top: (SizeConfig.screenHeight) * .01,
              ),
              child: Stack(
                  alignment: Alignment.centerRight,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: widget.parentWidth,
                      height: (SizeConfig.screenHeight) * .058,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                              widget.measuringUnit==""?widget.title:widget.measuringUnit,
                              style:widget.measuringUnit == ""? hint_textfield_Style:
                              text_field_textStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              // textScaleFactor: 1.02,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: (SizeConfig.screenHeight) * .03,
                              color: /*pollName == ""
                                  ? CommonColor.HINT_TEXT
                                  :*/ CommonColor.BLACK_COLOR,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isCategoryValidShow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: (SizeConfig.screenHeight) * .0,
                            right: (SizeConfig.screenWidth) * .0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  isCategoryMsgValidShow = !isCategoryMsgValidShow;
                                });
                              }
                            },
                            onDoubleTap: () {},
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                      (SizeConfig.screenHeight) * .045,
                      (SizeConfig.screenWidth) * .01,
                      SizeConfig.blockSizeHorizontal * 2.5,
                      isCategoryMsgValidShow,
                      ApplicationLocalizations.of(context)!.translate("unit")! ,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  selectMeasuringUnit(String id, String name) {
    // TODO: implement selectMeasuringUnit
    widget.callback(name);
  }
}