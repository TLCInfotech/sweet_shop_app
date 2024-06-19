import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/colors.dart';
import '../../../../core/common.dart';
import '../../../../core/common_style.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../data/api/constant.dart';
import '../../../common_widget/getFranchisee.dart';
import '../../../common_widget/get_category_layout.dart';
import '../../../common_widget/get_date_layout.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_item_layout.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_report_type_layout.dart';

import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../searchable_dropdowns/searchable_dropdown_with_object.dart';

class PurchaseReportActivity extends StatefulWidget {
  const PurchaseReportActivity({super.key});
  @override
  State<PurchaseReportActivity> createState() => _PurchaseReportActivityState();
}

class _PurchaseReportActivityState extends State<PurchaseReportActivity> {
  final _formkey = GlobalKey<FormState>();
  final _reportTypeKey = GlobalKey<FormFieldState>();

  String reportType = "";
  String reportId = "";
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;

  DateTime applicablefrom =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime applicableTo =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  String selectedFranchiseeName="";
  String selectedFranchiseeId = "";

  String ItemName="";
  String ItemID = "";

  String categoryId="";
  String categoryName="";


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
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
               title:  Container(
                 width: SizeConfig.screenWidth,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     GestureDetector(
                       onTap: () {
                         Navigator.pop(context);
                       },
                       child: FaIcon(Icons.arrow_back),
                     ),
                     Expanded(
                       child: Center(
                         child: Text(
                           ApplicationLocalizations.of(context)!.translate("purchase_report")!,
                           style: appbar_text_style,),
                       ),
                     ),
                   ],
                 ),
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
              child: Form(
                key: _formkey,
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
                    getFranchiseeNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                    getItemameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                    getAddCategoryLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /* Widget for report type  layout */
  Widget getReportTypeLayout(double parentHeight, double parentWidth) {
    return SearchableLedgerDropdown(
      mandatory: true,
      txtkey: _reportTypeKey,
      apiUrl: "${ApiConstants().report}?Form_Name=PURCHASE&",
      titleIndicator: true,
      ledgerName: reportType,
      readOnly: true,
      title: ApplicationLocalizations.of(context)!.translate("report_type")!,
      callback: (name, id) {
        setState(() {
          reportType = name!;
          reportId = id.toString()!;
        });
        _reportTypeKey.currentState!.validate();
      },
    );
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
        title:ApplicationLocalizations.of(context)!.translate("to_date")!,
        callback: (date){
          setState(() {
            applicableTo=date!;
          });
        },
        applicablefrom: applicableTo
    );
  }


  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return SearchableLedgerDropdown(
      apiUrl: "${ApiConstants().franchisee}?",
      titleIndicator: true,
      ledgerName: selectedFranchiseeName,
      readOnly: true,
      title:
      ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
      callback: (name, id) {
        setState(() {
          selectedFranchiseeName = name!;
          selectedFranchiseeId = id.toString()!;
        });
      },
    );

  }


  /* Widget to get Franchisee Name Layout */
  Widget getItemameLayout(double parentHeight, double parentWidth) {
    return SearchableDropdownWithObject(
      name: ItemName,
      focuscontroller: null,
      focusnext: null,
      apiUrl:
      "${ApiConstants().item_list}?Date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}&",
      titleIndicator: true,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callback: (item) async {
        setState(() {
          // ItemName=item['Name'];
          ItemID = item['ID'].toString();
          ItemName = item['Name'].toString();
        });
      },
    );
      GetItemLayout(
          title:ApplicationLocalizations.of(context)!.translate("item")!,
          callback: (value){
            setState(() {
              ItemName=value!;
            });
          },
          selectedItem: ItemName
      );
  }


  /* Widget For Category Layout */
  Widget getAddCategoryLayout(double parentHeight, double parentWidth){
    return SearchableDropdownWithObject(
      name: categoryName,
      focuscontroller: null,
      focusnext: null,
      apiUrl: "${ApiConstants().item_category}?",
      titleIndicator: true,
      title: ApplicationLocalizations.of(context)!.translate("item_category")!,
      callback: (item) async {
        setState(() {
          // ItemName=item['Name'];
          categoryId = item['ID'].toString();
          categoryName = item['Name'].toString();
        });
      },
    );
      GetCategoryLayout(
        title:ApplicationLocalizations.of(context)!.translate("item_category")!,
        callback: (value,id){
          setState(() {
            categoryName=value!;
          });
        },
        selectedProductCategory: categoryName
    );
  }


  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Column(
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
                      ApplicationLocalizations.of(context)!.translate("show_report")!,
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

}

