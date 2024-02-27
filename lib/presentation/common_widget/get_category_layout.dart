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

class GetCategoryLayout extends StatefulWidget{
  final title;
  final selectedProductCategory;
  final Function(String?,int?) callback;
  final titleIndicator;

  GetCategoryLayout({required this.title, required this.callback, required this.selectedProductCategory,   this.titleIndicator});

  @override
  State<GetCategoryLayout> createState() => _GetCategoryLayoutState();
}

class _GetCategoryLayoutState extends State<GetCategoryLayout> with SingleTickerProviderStateMixin,CategoryDialogInterface {

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
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (context != null) {
                    showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                              1.0;
                          return Transform(
                            transform:
                            Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                            child: Opacity(
                              opacity: a1.value,
                              child: CategoryDialog(
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
                        Text(widget.selectedProductCategory == "" ? widget.title : widget.selectedProductCategory,
                          style:widget.selectedProductCategory == "" ? item_regular_textStyle:text_field_textStyle,),
                        FaIcon(FontAwesomeIcons.caretDown,
                          color: Colors.black87.withOpacity(0.8), size: 16,)
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



  @override
  selectCategory(int id, String name) {
    // TODO: implement selectCategory
    widget.callback(name,id);
  }
}