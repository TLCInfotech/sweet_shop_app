import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dialog/country_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/district_dialog.dart';

import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../core/imagePicker/image_picker_dialog.dart';
import '../../core/imagePicker/image_picker_dialog_for_profile.dart';
import '../../core/imagePicker/image_picker_handler.dart';
import '../../core/localss/application_localizations.dart';
import '../../core/string_en.dart';
import '../dialog/franchisee_dialog.dart';
import '../dialog/state_dialog.dart';

class GetDistrictLayout extends StatefulWidget{
  final title;
  final districtName;
  final Function(String?,String?) callback;

  GetDistrictLayout({required this.title, required this.callback, required this.districtName});

  @override
  State<GetDistrictLayout> createState() => _GetDistrictLayoutState();
}
class _GetDistrictLayoutState extends State<GetDistrictLayout> with SingleTickerProviderStateMixin, DistrictDialogInterface {

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
                          child: DistrictDialog(
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
                        Container(
                          width:((SizeConfig.screenWidth) * .4 )- 40,
                         child: Text(
                            widget.districtName == "" ? ApplicationLocalizations.of(context)!.translate("select_city")!  : widget.districtName,
                            style: widget.districtName == ""
                                ? hint_textfield_Style
                                : text_field_textStyle,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
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
  selectDistrict(String id, String name) {
    // TODO: implement selectDistrict
    widget.callback(name,id);
    print("frbfbjjfbjb  $name");
  }

}