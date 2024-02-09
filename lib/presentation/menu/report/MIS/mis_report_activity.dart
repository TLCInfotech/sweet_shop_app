import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/report_type_dialog.dart';

class MisReportActivity extends StatefulWidget {
  const MisReportActivity({super.key});

  // final MisReportActivityInterface mListener;

  @override
  State<MisReportActivity> createState() => _MisReportActivityState();
}

class _MisReportActivityState extends State<MisReportActivity>with ReportTypeDialogInterface {
  final _leaderFocus = FocusNode();
  final leaderController = TextEditingController();

  final bankcashFocus = FocusNode();
  final bankCashController = TextEditingController();

  String reportType = "";
  String reportId = "";
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;


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
              // color: Colors.red,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
                title: const Text(
                  StringEn.MIS_REPORT,
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
                // color: CommonColor.DASHBOARD_BACKGROUND,
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




  /* Widget for create first project layout */
  Widget getTopBarSubTextLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
          top: parentHeight * .01,
          left: parentWidth * 0.04,
          right: parentWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "  StringEn.CREATE_FIRST_PROJECT",
            style: TextStyle(
              color: CommonColor.WHITE_COLOR,
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontFamily: 'Raleway_Bold_Font',
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "StringEn.THREE_THREE",
            style: TextStyle(
              color: CommonColor.WHITE_COLOR,
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontFamily: 'Raleway_Bold_Font',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
                    children: [
                      getDateONELayout(parentHeight, parentWidth),
                      getDateTwoLayout(parentHeight, parentWidth),
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
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        //width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.REPORT_TYPE,
              style: page_heading_textStyle,
            ),
            GestureDetector(
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
                          child: ReportTypeDialog(
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
              child: Padding(
                padding: EdgeInsets.only(top: parentHeight * .005),
                child: Container(
                  height: parentHeight * .055,
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
                          reportType == "" ? "Select report type" : reportType,
                          style: reportType == ""
                              ? hint_textfield_Style
                              : text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // textScaleFactor: 1.02,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: parentHeight * .03,
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


  DateTime applicablefrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTwofrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));


  /* Widget for date one layout */
  Widget getDateONELayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02,right: parentWidth*.02),
      child: Container(
        width: parentWidth * .42,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.DATE_ONE,
              style: page_heading_textStyle,
            ),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if (Platform.isIOS) {
                  var date= await CommonWidget.startDate(context,applicablefrom);
                  setState(() {
                    applicablefrom=date;
                  });
                  // startDateIOS(context);
                } else if (Platform.isAndroid) {
                  var date= await CommonWidget.startDate(context,applicablefrom) ;
                  setState(() {
                    applicablefrom=date;
                  });
                }
              },
              onDoubleTap: (){},
              child: Padding(
                padding: EdgeInsets.only(top: parentHeight * .005),
                child: Container(
                  height: parentHeight * .055,
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
                          DateFormat('yyyy-MM-dd').format(applicablefrom),
                          style: applicablefrom == null
                              ? hint_textfield_Style
                              : text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // textScaleFactor: 1.02,
                        ),
                        const FaIcon(FontAwesomeIcons.calendar,
                          color: Colors.black87, size: 16,)
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
  /* Widget for date two layout */
  Widget getDateTwoLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02,left: parentWidth*.02),
      child: Container(
        width: parentWidth * .42,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.DATE_TWO,
              style: page_heading_textStyle,
            ),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if (Platform.isIOS) {
                  var date= await CommonWidget.startDate(context,applicableTwofrom);
                  setState(() {
                    applicableTwofrom=date;
                  });
                  // startDateIOS(context);
                } else if (Platform.isAndroid) {
                  var date= await CommonWidget.startDate(context,applicableTwofrom) ;
                  setState(() {
                    applicableTwofrom=date;
                  });
                }
              },
              onDoubleTap: (){},
              child: Padding(
                padding: EdgeInsets.only(top: parentHeight * .005),
                child: Container(
                  height: parentHeight * .055,
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
                          DateFormat('yyyy-MM-dd').format(applicableTwofrom),
                          style: applicableTwofrom == null
                              ? hint_textfield_Style
                              : text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // textScaleFactor: 1.02,
                        ),
                        const FaIcon(FontAwesomeIcons.calendar,
                          color: Colors.black87, size: 16,)
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

  /* Widget for name text from field layout */
  Widget getLeaderNameLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.FRANCHISEE,
                style: page_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: parentHeight * .055,
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
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.words,
                    focusNode: _leaderFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Enter a franchisee name",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: leaderController,
                    onEditingComplete: () {
                      _leaderFocus.unfocus();
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

  /* Widget for bank cash ledger layout */
  Widget getBankCashLedgerLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.BANK_CASH_LEDGER,
                style: page_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Container(
              height: parentHeight * .055,
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
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.words,
                focusNode: bankcashFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText: "Enter a bank / cash",
                  hintStyle: hint_textfield_Style,
                ),
                controller: bankCashController,
                onEditingComplete: () {
                  bankcashFocus.unfocus();
                },
                style: text_field_textStyle,
              ),
            ),
          ),
        ],
      ),
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
                    child: const Text(
                      StringEn.SAVE,
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

  @override
  selectedReportType(String id, String name) {
    // TODO: implement selectedReportType
    setState(() {
      reportType=name;
    });
  }

}

// abstract class MisReportActivityInterface {
// }
