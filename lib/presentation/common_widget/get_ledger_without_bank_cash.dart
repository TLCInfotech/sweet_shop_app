import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dialog/get_ledger_without_bank_cash_dailog.dart';

import '../../core/colors.dart';
import '../../core/common.dart';
import '../../core/common_style.dart';
import '../../core/imagePicker/image_picker_dialog.dart';
import '../../core/imagePicker/image_picker_dialog_for_profile.dart';
import '../../core/imagePicker/image_picker_handler.dart';
import '../../core/localss/application_localizations.dart';
import '../../core/string_en.dart';
import '../dialog/franchisee_dialog.dart';
import '../dialog/get_bank_cash_ledger_dialog.dart';

class GetLedgerWithoutBankCash extends StatefulWidget{
  final title;
  final bankCashLedger;
  final Function(String?,String?) callback;
  final titleIndicator;

  GetLedgerWithoutBankCash({required this.title, required this.callback, required this.bankCashLedger,   this.titleIndicator});

  @override
  State<GetLedgerWithoutBankCash> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<GetLedgerWithoutBankCash> with     SingleTickerProviderStateMixin,LedgerWithoutBankCashInterface {

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
            child: GestureDetector(
              onTap: (){
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform:
                        Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child:LedgerWithoutBankCashDialog(
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
              onDoubleTap: (){},
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
                child:  Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.bankCashLedger == "" ? ApplicationLocalizations.of(context)!.translate("ledger_without_bank_cash")!  : widget.bankCashLedger,
                        style: widget.bankCashLedger == ""
                            ? hint_textfield_Style
                            : text_field_textStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        // textScaleFactor: 1.02,
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
          )
        ],
      ),
    );
  }



  @override
  selectedLedgerWithoutBankCashInterface(String id, String name) {
    // TODO: implement selectedLedgerWithoutBankCashInterface
    widget.callback(name,id);
  }
}