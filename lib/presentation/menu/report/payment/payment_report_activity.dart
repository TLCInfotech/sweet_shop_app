import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/report_type_dialog.dart';

import '../../../common_widget/get_date_layout.dart';
import '../../../common_widget/get_report_type_layout.dart';
import '../../../common_widget/signleLine_TexformField.dart';

class PaymentReportActivity extends StatefulWidget {
  const PaymentReportActivity({super.key});
  // final PaymentReportActivityInterface mListener;
  @override
  State<PaymentReportActivity> createState() => _PaymentReportActivityState();
}

class _PaymentReportActivityState extends State<PaymentReportActivity> {
  final _leaderFocus = FocusNode();
  final leaderController = TextEditingController();

  final bankcashFocus = FocusNode();
  final bankCashController = TextEditingController();

  String reportType = "";
  String reportId = "";
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;

  DateTime applicablefrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTwofrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: CommonColor.BACKGROUND_COLOR,
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
                title:  Text(
                  ApplicationLocalizations.of(context)!.translate("payment_report")!,
                  style: appbar_text_style,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  child: getAllTextFormFieldLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth)),
            ),
            Container(
                decoration: BoxDecoration(
                  color: CommonColor.WHITE_COLOR,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withOpacity(0.08),
                      width: 1.0,
                    ),
                  ),
                ),
                height: SizeConfig.safeUsedHeight * .08,
                child: getSaveAndFinishButtonLayout(
                    SizeConfig.screenHeight, SizeConfig.screenWidth)),
            CommonWidget.getCommonPadding(
                SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
          ],
        ),
      ),
    );
  }


  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          left: parentWidth * 0.04,
          right: parentWidth * 0.04,
          top: parentHeight * 0.01,
          bottom: parentHeight * 0.02),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: parentWidth * .01, right: parentWidth * .01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getReportTypeLayout(parentHeight, parentWidth),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width:(SizeConfig.halfscreenWidth),
                          child: getDateONELayout(parentHeight, parentWidth)),
                      Container(

                          width:(SizeConfig.halfscreenWidth),
                          child: getDateTwoLayout(parentHeight, parentWidth)),
                    ],
                  ),
                  getLeaderNameLayout(parentHeight, parentWidth),
                  getBankCashLedgerLayout(parentHeight, parentWidth),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /* Widget for report type  layout */
  Widget getReportTypeLayout(double parentHeight, double parentWidth) {
    return GetReportTypeLayout(
        title:ApplicationLocalizations.of(context)!.translate("report_type")!,
        callback: (name){
          setState(() {
            reportType=name!;
          });
        },
        reportType: reportType);
  }

  /* Widget for date one layout */
  Widget getDateONELayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title:ApplicationLocalizations.of(context)!.translate("from_date")!,
        callback: (date){
          setState(() {
            applicablefrom=date!;
          });
        },
        applicablefrom: applicablefrom
    );

  }

  /* Widget for date two layout */
  Widget getDateTwoLayout(double parentHeight, double parentWidth) {
    return GetDateLayout(
        title:       ApplicationLocalizations.of(context)!.translate("to_date")!,
        callback: (date){
          setState(() {
            applicableTwofrom=date!;
          });
        },
        applicablefrom: applicableTwofrom
    );
  }


  /* Widget for name text from field layout */
  Widget getLeaderNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.LEDGER;
        }
        return null;
      },
      controller: leaderController,
      focuscontroller: _leaderFocus,
      focusnext: null,
      title:       ApplicationLocalizations.of(context)!.translate("ledger_name")!,
      callbackOnchage: (value) {
        setState(() {
          leaderController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
  }

  /* Widget for bank cash ledger layout */
  Widget getBankCashLedgerLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.BANK_CASH_LEDGER;
        }
        return null;
      },
      controller: bankCashController,
      focuscontroller: bankcashFocus,
      focusnext: null,
      title:       ApplicationLocalizations.of(context)!.translate("bank_cash_ledger")!,
      callbackOnchage: (value) {
        setState(() {
          bankCashController.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    );

  }



  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: parentWidth * .04,
              right: parentWidth * 0.04,
              top: parentHeight * .015),
          child: GestureDetector(
            onTap: () {
              if (mounted) {
                setState(() {
                  disableColor = true;
                });
              }
            },
            onDoubleTap: () {},
            child: Container(
              height: parentHeight * .06,
              decoration: BoxDecoration(
                color: disableColor == true
                    ? CommonColor.THEME_COLOR.withOpacity(.5)
                    : CommonColor.THEME_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: parentWidth * .005),
                    child:  Text(
                      ApplicationLocalizations.of(context)!.translate("save")!,
                      style: page_heading_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  /* Widget for get report drop down layout */

}

// abstract class PaymentReportActivityInterface {
// }
