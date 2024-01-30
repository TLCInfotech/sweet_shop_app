import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dialog/category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/franchisee_dialog.dart';
import 'package:intl/intl.dart';
class FranchiseeSaleRate extends StatefulWidget {
  const FranchiseeSaleRate({super.key});

  @override
  State<FranchiseeSaleRate> createState() => _FranchiseeSaleRateState();
}

class _FranchiseeSaleRateState extends State<FranchiseeSaleRate> with FranchiseeDialogInterface,CategoryDialogInterface{

  DateTime joinDate =  DateTime.now().add(
      Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime endDate =  DateTime.now().add(
      Duration(minutes: 30 - DateTime.now().minute % 30));
  String startingDate = "";
  String endingDate = "";
  bool isPurchaseDateValidShow = false;
  bool isPurchaseDateMsgValidShow = false;

  Future<void> startDateIOS(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildBottomPicker(
          CupertinoDatePicker(
            backgroundColor: CommonColor.WHITE_COLOR,
            mode: CupertinoDatePickerMode.date,
            initialDateTime: joinDate,
            minimumYear: DateTime.now().year-70,
            maximumYear: DateTime.now().year+100 ,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() => newDateTime);
              joinDate = newDateTime;
              String formattedDate =
              DateFormat('yyyy-MM-dd').format(newDateTime);
              if (mounted)
                setState(() {
                  startingDate = formattedDate;
                  if (startingDate != null) startingDate = formattedDate;
                  isPurchaseDateValidShow = false;
                  isPurchaseDateMsgValidShow = false;
                });
            },
          ),
        );
      },
    );
  }

  double _kPickerSheetHeight = 216.0;
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      // padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.inactiveGray,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.inactiveGray,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Future<void> _startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CommonColor.THEME_COLOR, // <-- SEE HERE
              onPrimary: CommonColor.WHITE_COLOR, // <-- SEE HERE
              onSurface: CommonColor.BLACK_COLOR, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: CommonColor.BLACK_COLOR, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      joinDate = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      if (mounted) {
        setState(() {
          startingDate = formattedDate;
          startingDate = formattedDate;
          isPurchaseDateValidShow = false;
          isPurchaseDateMsgValidShow = false;
        });
      }
    }
  }
  String selectedFranchiseeName="";
  String selectedProductCategory="";
  String applicableFrom="";

  String selectedCopyFranchiseeName="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfffff5),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: SafeArea(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            color: Colors.transparent,
            // color: Colors.red,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),

              backgroundColor: Colors.white,
              title: Text(
                StringEn.FRANCHISE_SALE_RATE,
                style: appbar_text_style,),
            ),
          ),
        ),
      ),
      body:  Container(
        height: SizeConfig.safeUsedHeight,
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xFFfffff5),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              getFieldTitleLayout(StringEn.FRANCHISEE_NAME),
              getFranchiseeNameLayout(),

              getFieldTitleLayout(StringEn.CATEGORY),
              getProductCategoryLayout(),

              getFieldTitleLayout(StringEn.COPY_FROM_FRANCHISEE),
              getApplicableFromLayout()
            ],
          ),
        ),
      ),
    );
  }



  /* Widget to get Product categoryLayout */
  Widget getProductCategoryLayout(){
    return GestureDetector(
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
              color: CommonColor.TexField_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedProductCategory == "" ? StringEn.CATEGORY : selectedProductCategory,
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.caretDown,
                color: Colors.black87.withOpacity(0.8), size: 16,)
            ],
          )
      ),
    );
  }

  /* Widget to get Franchisee Name Layout */
  Widget getFranchiseeNameLayout(){
    return GestureDetector(
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
                    child: FranchiseeDialog(
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
              color: CommonColor.TexField_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedFranchiseeName == "" ? StringEn.FRANCHISEE_NAME : selectedFranchiseeName,
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.caretDown,
                color: Colors.black87.withOpacity(0.8), size: 16,)
            ],
          )
      ),
    );
  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: item_heading_textStyle,
      ),
    );
  }




  /* Widget to get add Product Layout */
  Widget getApplicableFromLayout(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (Platform.isIOS) {
          startDateIOS(context);
        } else if (Platform.isAndroid) {
          _startDate(context);
        }
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: CommonColor.TexField_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Applicable From",
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.calendar,
                color: Colors.black87, size: 16,)
            ],
          )
      ),
    );
  }

  @override
  selectedFranchisee(String id, String name) {
    // TODO: implement selectedFranchisee
    setState(() {
      selectedFranchiseeName=name;
    });
  }

  @override
  selectCategory(String id, String name) {
    // TODO: implement selectCategory
    setState(() {
      selectedProductCategory=name;
    });
  }

}
