import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';
import 'package:sweet_shop_app/presentation/dialog/tax_category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/tax_type_dialog.dart';

import '../../../../core/util.dart';
import '../../../common_widget/get_country_layout.dart';
import '../../../common_widget/get_district_layout.dart';
import '../../../common_widget/get_image_from_gallary_or_camera.dart';
import '../../../common_widget/get_state_value.dart';
import '../../../common_widget/signleLine_TexformField.dart';

class CreateExpenseActivity extends StatefulWidget {
  const CreateExpenseActivity({super.key});


  @override
  State<CreateExpenseActivity> createState() => _CreateExpenseActivityState();
}

class _CreateExpenseActivityState extends State<CreateExpenseActivity>
    with
        SingleTickerProviderStateMixin, TaxDialogInterface , TaxCategoryDialogInterface {
  bool checkActiveValue = false;
  final _nameFocus = FocusNode();
  final nameController = TextEditingController();

  final _branchNameFocus = FocusNode();
  final branchNameController = TextEditingController();

  final _addressFocus = FocusNode();
  final addressController = TextEditingController();

  final _districtCity = FocusNode();
  final districtController = TextEditingController();

  final _contactFocus = FocusNode();
  final contactController = TextEditingController();

  final _extNameFocus = FocusNode();
  final extNameController = TextEditingController();
  final _invoiceFocus = FocusNode();
  final invoiceController = TextEditingController();
  final _addTwoFocus = FocusNode();
  final addTwoController = TextEditingController();
  final _defaultBankFocus = FocusNode();
  final defaultBankController = TextEditingController();
  final _jurisdictionFocus = FocusNode();
  final jurisdictionController = TextEditingController();
  final _cityFocus = FocusNode();
  final cityController = TextEditingController();
  final _emailFocus = FocusNode();
  final emailController = TextEditingController();
  final _pinCodeFocus = FocusNode();
  final pinCodeController = TextEditingController();
  final _panNoFocus = FocusNode();
  final panNoController = TextEditingController();
  final _gstNoFocus = FocusNode();
  final gstNoController = TextEditingController();
  final _cinNoFocus = FocusNode();
  final cinNoController = TextEditingController();
  final _adharoFocus = FocusNode();
  final adharNoController = TextEditingController();

  final _leaderGroupFocus = FocusNode();
  final leaderGroupController = TextEditingController();
  final _contactPersonFocus = FocusNode();
  final contactPersonController = TextEditingController();
  final _regTypeFocus = FocusNode();
  final regTypeController = TextEditingController();
  final _outstandingLimitFocus = FocusNode();
  final outstandingLimitController = TextEditingController();
  final _vendorCodeFocus = FocusNode();
  final vendorCodeController = TextEditingController();
  final _paymentDaysFocus = FocusNode();
  final paymentDaysController = TextEditingController();
  final _taxesFocus = FocusNode();
  final taxesController = TextEditingController();
  final _taxRateFocus = FocusNode();
  final taxRateController = TextEditingController();
  final _CGSTFocus = FocusNode();
  final CGSTController = TextEditingController();
  final _SGSTFocus = FocusNode();
  final SGSTController = TextEditingController();
  final _cessFocus = FocusNode();
  final cessController = TextEditingController();
  final _hsnNoFocus = FocusNode();
  final hsnNoController = TextEditingController();
  final _accountNoFocus = FocusNode();
  final accountNoController = TextEditingController();
  final _aCHolderNameFocus = FocusNode();
  final aCHolderNameController = TextEditingController();
  final _IFSCCodeFocus = FocusNode();
  final IFSCCodeController = TextEditingController();
  final _bankBranchFocus = FocusNode();
  final bankBranchController = TextEditingController();
  final _bankNameFocus = FocusNode();
  final bankNameController = TextEditingController();
  final _addCessFocus = FocusNode();
  final addCessController = TextEditingController();

  late ImagePickerHandler imagePicker;
  late AnimationController _Controller;
  File? picImage;
  String countryName = "";
  String countryId = "";
  String stateName = "";
  String stateId = "";
  String taxTypeName = "";
  String taxTypeId = "";
  String taxCategoryName = "";
  String taxCategoryId = "";
  String regTypeName = "";
  String regTypeId = "";
  Color currentColor = CommonColor.THEME_COLOR;
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  File? adharFile ;
  File? panFile ;
  File? gstFile ;



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
                  StringEn.CREATE_EXPENSE,
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

  /* Widget for TopBar Layout */
  Widget getAddTopBarLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
          top: parentHeight * .05,
          left: parentWidth * 0.0,
          right: parentWidth * 0.05),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onDoubleTap: () {},
          child: Container(
            color: Colors.transparent,
            width: parentWidth * .25,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: parentWidth * .05),
                    child: Image(
                      image: AssetImage("assets/images/back.png"),
                      height: parentHeight * .035,
                      width: parentHeight * .035,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          "Create Item",
          style: TextStyle(
            fontFamily: "Montserrat_Bold",
            fontSize: SizeConfig.blockSizeHorizontal * 5.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          width: parentWidth * .2,
          decoration: BoxDecoration(
            color: CommonColor.THEME_COLOR,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: parentHeight * .01, bottom: parentHeight * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringEn.POST,
                  style: TextStyle(
                    color: CommonColor.BLACK_COLOR,
                    fontSize: SizeConfig.blockSizeHorizontal * 4.3,
                    fontFamily: 'Inter_Regular_Font',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  List<String> LimitDataUnit = ["Cr","Dr"];

  String ?selectedLimitUnit = null;

  double opacityLevel = 1.0;

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
                children: [
                  getImageLayout(parentHeight, parentWidth),
                  SizedBox(height: 20,),
                  getFieldTitleLayout(StringEn.BASIC_INFO),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [
                      getNameLayout(parentHeight, parentWidth),
                      getLeaderGroupLayout(parentHeight, parentWidth),
                      getContactPersonLayout(parentHeight, parentWidth),
                      getAddressLayout(parentHeight, parentWidth),
                      Row(
                        children: [
                          getLeftLayout(parentHeight, parentWidth),
                          getRightLayout(parentHeight, parentWidth),
                        ],
                      ),
                      getContactNoLayout(parentHeight, parentWidth),
                      getEmilLayout(parentHeight, parentWidth),
                      getOutstandingLimitLayout(parentHeight, parentWidth),
                      getExtNameLayout(parentHeight, parentWidth),
                    ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  getFieldTitleLayout(StringEn.DOCUMENT_INFO),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [
                      // addhar
                      PickDocument(
                        callbackOnchage: (value ) {
                          setState(() {
                            adharNoController.text=value;
                          });
                        },
                        callbackFile: (File? file) {
                          setState(() {
                            adharFile=file;
                          });
                        },
                        title:  StringEn.FRANCHISEE_AADHAR_NO,
                        documentFile: adharFile,
                        controller: adharNoController,
                        focuscontroller: _adharoFocus,
                        focusnext: _panNoFocus,
                      ),
                      // pan
                      PickDocument(
                        callbackOnchage: (value ) {
                          setState(() {
                            panNoController.text=value;
                          });
                        },
                        callbackFile: (File? file) {
                          setState(() {
                            panFile=file;
                          });
                        },
                        title:  StringEn.FRANCHISEE_PAN_NO,
                        documentFile: panFile,
                        controller: panNoController,
                        focuscontroller: _panNoFocus,
                        focusnext: _gstNoFocus,
                      ),
                      // gst
                      PickDocument(
                        callbackOnchage: (value ) {
                          setState(() {
                            gstNoController.text=value;
                          });
                        },
                        callbackFile: (File? file) {
                          setState(() {
                            gstFile=file;
                          });
                        },
                        title:  StringEn.FRANCHISEE_GST_NO,
                        documentFile: gstFile,
                        controller: gstNoController,
                        focuscontroller: _gstNoFocus,
                        focusnext: _cinNoFocus,
                      ),
                    ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  getFieldTitleLayout(StringEn.TAX_INFO),
                  Container(

                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [
                      Row(
                        children: [
                          getTaxLeftLayout(parentHeight, parentWidth),
                          getTaxRightLayout(parentHeight, parentWidth),
                        ],
                      ),
                    ],
                    ),
                  ),


                  // getTaxLayout(parentHeight, parentWidth),

                  SizedBox(height: 20,),
                  getFieldTitleLayout(StringEn.ACCOUNT_INFO),
                  Container(

                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [

                      // getAccountInfoLayout(parentHeight, parentWidth),
                      getBankNameLayout(parentHeight, parentWidth),
                      getBankBranchNameLayout(parentHeight, parentWidth),
                      getFSCCodeLayout(parentHeight, parentWidth),
                      getACHolderNameLayout(parentHeight, parentWidth),
                      getAcoountNoLayout(parentHeight, parentWidth),

                    ],
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

  Widget getImageLayout(double parentHeight, double parentWidth) {
    return GetSingleImage(
        height: parentHeight * .25,
        width: parentHeight * .25,
        picImage: picImage,
        callbackFile: (file){
          setState(() {
            picImage=file;
          });
        }
    );

  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }


  /* Widget for name text from field layout */
  Widget getNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.NAME;
        }
        return null;
      },
      controller: nameController,
      focuscontroller: _nameFocus,
      focusnext: _leaderGroupFocus,
      title: StringEn.NAME,
      callbackOnchage: (value) {
        setState(() {
          nameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }

  /* Widget for leader group text from field layout */
  Widget getLeaderGroupLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.LEADER_GROUP;
        }
        return null;
      },
      controller: leaderGroupController,
      focuscontroller: _leaderGroupFocus,
      focusnext: _contactPersonFocus,
      title: StringEn.LEADER_GROUP,
      callbackOnchage: (value) {
        setState(() {
          leaderGroupController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );


  }


  /* Widget for contact person text from field layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.FRANCHISEE_CONTACT_PERSON;
        }
        return null;
      },
      controller: contactPersonController,
      focuscontroller: _contactPersonFocus,
      focusnext: _addressFocus,
      title: StringEn.FRANCHISEE_CONTACT_PERSON,
      callbackOnchage: (value) {
        setState(() {
          contactPersonController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }

  /* Widget for description text from field layout */
  Widget getAddressLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.ADDRESS;
        }
        return null;
      },
      controller: addressController,
      focuscontroller: _addressFocus,
      focusnext: _districtCity,
      title: StringEn.ADDRESS,
      callbackOnchage: (value) {
        setState(() {
          addressController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 3,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }


  /* Widget for select contract layout */

  Widget getLeftLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(right: parentWidth * .01),
      child: Column(
        children: [
          getDistrictCityLayout(parentHeight, parentWidth),
          getStateLayout(parentHeight, parentWidth),
        ],
      ),
    );
  }


  Widget getRightLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .01),
      child: Column(
        children: [
          getPinCodeLayout(parentHeight, parentWidth),
          getCountryLayout(parentHeight, parentWidth),
        ],
      ),
    );
  }

  /* Widget for contact no  text from field layout */
  Widget getContactNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField( validation: (value) {
      if (value!.isEmpty) {
        return StringEn.ENTER+StringEn.CONTACT_NO;
      }
      return null;
    },
      controller: contactController,
      focuscontroller: _contactFocus,
      focusnext: _emailFocus,
      title: StringEn.CONTACT_NO,
      callbackOnchage: (value) {
        setState(() {
          contactController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    );

  }


  /* Widget for  email  text from field layout */
  Widget getEmilLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField( validation: (value) {
      if (value!.isEmpty) {
        return StringEn.ENTER+StringEn.EMAIL;
      }
      return null;
    },
      controller: emailController,
      focuscontroller: _emailFocus,
      focusnext: _addTwoFocus,
      title: StringEn.EMAIL,
      callbackOnchage: (value) {
        setState(() {
          emailController.text = value;
        });
      },
      textInput: TextInputType.emailAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z  @ .]')),
    );

  }



  /* Widget for outstanding limit text from field layout */
  Widget getOutstandingLimitLayout(double parentHeight, double parentWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: SingleLineEditableTextFormField(
              controller: outstandingLimitController,
              focuscontroller: _outstandingLimitFocus,
              focusnext: _extNameFocus,
              title: StringEn.FRANCHISEE_OUTSTANDING_LIMIT,
              callbackOnchage: (value) {
                setState(() {
                  outstandingLimitController.text = value;
                });
              },
              textInput: TextInputType.number,
              maxlines: 1,
              format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              validation: (value) {
                if (value!.isEmpty) {
                  return StringEn.ENTER+StringEn.FRANCHISEE_OUTSTANDING_LIMIT;
                }
                else if (Util.isEmailValid(value)) {
                  return "Enter Valid Email";
                }
                return null;
              },
            )

        ),
        Container(
          height: parentHeight * .055,
          width: 100,
          margin: EdgeInsets.only(left: 10,top: 40),
          padding: EdgeInsets.only(left: 10, right: 10),
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
          child: DropdownButton<dynamic>(
            hint: Text(
              StringEn.UNIT, style: hint_textfield_Style,),
            underline: SizedBox(),
            isExpanded: true,
            value: selectedLimitUnit,
            onChanged: (newValue) {
              setState(() {
                selectedLimitUnit = newValue!;
              });
            },
            items: LimitDataUnit.map((dynamic limit) {
              return DropdownMenuItem<dynamic>(
                value: limit,
                child: Text(limit.toString(), style: item_regular_textStyle),
              );
            }).toList(),
          ),
        )
      ],
    );


  }


  Widget getTaxLeftLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(right: parentWidth * .01),
      child: Column(
        children: [
          getTaxTypeLayout(parentHeight,parentWidth),
          getHSNLayout(parentHeight,parentWidth),
          getCGSTLayout(parentHeight,parentWidth),
          getCessLayout(parentHeight,parentWidth),
        ],
      ),
    );
  }


  /* Widget for taxt type layout */
  Widget getTaxTypeLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.TAX_TYPE,
              style: item_heading_textStyle,
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
                          child: TaxDialog(
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
                  decoration: box_decoration,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          taxTypeName == "" ? "Select type" : taxTypeName,
                          style: taxTypeName == ""
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


  /* Widget for HSN text from field layout */
  Widget getHSNLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.HSN_NO;
        }
        return null;
      },
      controller: hsnNoController,
      focuscontroller: _hsnNoFocus,
      focusnext: _taxRateFocus,
      title: StringEn.HSN_NO,
      callbackOnchage: (value) {
        setState(() {
          hsnNoController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z]')),
    );


  }



  /* Widget for CGST text from field layout */
  Widget getCGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.CGST;
        }
        return null;
      },
      controller: CGSTController,
      focuscontroller: _CGSTFocus,
      focusnext: _SGSTFocus,
      title: StringEn.CGST,
      callbackOnchage: (value) {
        setState(() {
          CGSTController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }

/* Widget for cess text from field layout */
  Widget getCessLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.CESS;
        }
        return null;
      },
      controller: cessController,
      focuscontroller: _cessFocus,
      focusnext: _addCessFocus,
      title: StringEn.CESS,
      callbackOnchage: (value) {
        setState(() {
          cessController.text = value;
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );


  }





  Widget getTaxRightLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(left: parentWidth * .01),
      child: Column(
        children: [
          getTaxCategoryLayout(parentHeight,parentWidth),
          getTaxRateLayout(parentHeight,parentWidth),
          getSGSTLayout(parentHeight,parentWidth),
          getAddCessLayout(parentHeight,parentWidth),
        ],
      ),
    );
  }


  /* Widget for taxt category layout */
  Widget getTaxCategoryLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.TAX_CATEGORY,
              style: item_heading_textStyle,
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
                          child: TaxCategoryDialog(
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
                  decoration: box_decoration,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            taxCategoryName == "" ? "Select category" : taxCategoryName,
                            style: taxCategoryName == ""
                                ? hint_textfield_Style
                                : text_field_textStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            // textScaleFactor: 1.02,
                          ),
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


  /* Widget for tax rate text from field layout */
  Widget getTaxRateLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.TAX_RATE;
        }
        return null;
      },
      controller: taxRateController,
      focuscontroller: _taxRateFocus,
      focusnext: _CGSTFocus,
      title: StringEn.TAX_RATE,
      callbackOnchage: (value) {
        setState(() {
          taxRateController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 \.]')),
    );

  }



  /* Widget for SGST text from field layout */
  Widget getSGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.SGST;
        }
        return null;
      },
      controller: SGSTController,
      focuscontroller: _SGSTFocus,
      focusnext: _cessFocus,
      title: StringEn.SGST,
      callbackOnchage: (value) {
        setState(() {
          SGSTController.text = value;
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }



  /* Widget for add cess text from field layout */
  Widget getAddCessLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.ADD_CESS;
        }
        return null;
      },
      controller: addCessController,
      focuscontroller: _addCessFocus,
      focusnext: _bankNameFocus,
      title: StringEn.ADD_CESS,
      callbackOnchage: (value) {
        setState(() {
          addCessController.text = value;
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }






  /* Widget for distric/city text from field layout */
  Widget getDistrictCityLayout(double parentHeight, double parentWidth) {
    return GetDistrictLayout(
        title:  StringEn.DISTRICTCITY,
        callback: (name){
          setState(() {
            districtController.text=name!;
          });
        },
        districtName: districtController.text);

  }

  /* Widget for state text from field layout */
  Widget getStateLayout(double parentHeight, double parentWidth) {
    return GetStateLayout(
        title:  StringEn.STATE,
        callback: (name){
          setState(() {
            stateName=name!;
          });
        },
        stateName: stateName);

  }


  /* Widget for pin code text from field layout */
  Widget getPinCodeLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: pinCodeController,
      focuscontroller: _pinCodeFocus,
      focusnext: _contactFocus,
      title: StringEn.PIN_CODE,
      callbackOnchage: (value) {
        setState(() {
          pinCodeController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return "Enter Contact Person";
        }
        return null;
      },
      parentWidth: (SizeConfig.screenWidth ),
    );

  }


  /* Widget for country text from field layout */
  Widget getCountryLayout(double parentHeight, double parentWidth) {
    return GetCountryLayout(
        title:  StringEn.COUNTRY,
        callback: (name){
          setState(() {
            countryName=name!;
          });
        },
        countryName: countryName);

  }


  /* Widget for ext name text from field layout */
  Widget getExtNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.EXT_NAME;
        }
        return null;
      },
      controller: extNameController,
      focuscontroller: _extNameFocus,
      focusnext: _adharoFocus,
      title: StringEn.EXT_NAME,
      callbackOnchage: (value) {
        setState(() {
          extNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }



  /*Widget for TCS / TDS Applicable Layout*/
  Widget getTCSTDSApplicableLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .016),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (mounted) {
                setState(() {
                  if (!checkActiveValue) {
                    checkActiveValue = true;
                  } else {
                    checkActiveValue = false;
                  }
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.only(top: parentHeight * .01),
              child: Stack(
                children: <Widget>[
                  Container(
                      height: parentHeight * .025,
                      width: parentHeight * .025,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: checkActiveValue == true
                            ? CommonColor.THEME_COLOR
                            : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            color: checkActiveValue == true
                                ? CommonColor.HINT_TEXT_COLOR
                                .withOpacity(0.5)
                                : CommonColor.THEME_COLOR,
                            width: 1),
                      ),
                      child: Visibility(
                        visible: checkActiveValue,
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Image(
                            image:
                            AssetImage('assets/images/checkmark.png'),
                            color: CommonColor.WHITE_COLOR,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    left: parentWidth * .02, top: parentHeight * .01),
                child:const Text(StringEn.TCS_TDS_APPLICABLE,
                  style: page_heading_textStyle,)
            ),
          ),
        ],
      ),
    );
  }





  /* Widget for bank name text from field layout */
  Widget getBankNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: bankNameController,
      focuscontroller: _bankNameFocus,
      focusnext: _bankBranchFocus,
      title: StringEn.BANK_NAME,
      callbackOnchage: (value) {
        setState(() {
          bankNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.BANK_NAME;
        }

        return null;
      },
    );


  }

  /* Widget for bank branch name text from field layout */
  Widget getBankBranchNameLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      controller: bankBranchController,
      focuscontroller: _bankBranchFocus,
      focusnext: _IFSCCodeFocus,
      title: StringEn.BANT_BRACH,
      callbackOnchage: (value) {
        setState(() {
          bankBranchController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.BANT_BRACH;
        }
        return null;
      },
    );

  }
 /* Widget for IFSC Code text from field layout */
  Widget getFSCCodeLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: IFSCCodeController,
      focuscontroller: _IFSCCodeFocus,
      focusnext: _aCHolderNameFocus,
      title: StringEn.IFSC_CODE,
      callbackOnchage: (value) {
        setState(() {
          IFSCCodeController.text = value;
        });
      },
      textInput: TextInputType.emailAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.BANT_BRACH;
        }
        return null;
      },
    );

  }

 /* Widget for Account holder name text from field layout */
  Widget getACHolderNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: aCHolderNameController,
      focuscontroller: _aCHolderNameFocus,
      focusnext: _accountNoFocus,
      title: StringEn.ACCOUNT_HOLDER_NAME,
      callbackOnchage: (value) {
        setState(() {
          aCHolderNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.BANT_BRACH;
        }
        return null;
      },
    );

  }

 /* Widget for Account No name text from field layout */
  Widget getAcoountNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: accountNoController,
      focuscontroller: _accountNoFocus,
      focusnext: _bankNameFocus,
      title: StringEn.ACCOUNT_NO,
      callbackOnchage: (value) {
        setState(() {
          accountNoController.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      validation: (value) {
        if (value!.isEmpty) {
          return StringEn.ENTER+StringEn.BANT_BRACH;
        }
        return null;
      },
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
              // if(widget.comeFrom=="clientInfoList"){
              //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ClientInformationListingPage(
              //   )));
              // }if(widget.comeFrom=="Projects"){
              //   Navigator.pop(context,false);
              // }
              // else if(widget.comeFrom=="edit"){
              //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ClientInformationDetails(
              //   )));
              // }
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
  selectTaxCate(String id, String name) {
    // TODO: implement selectTaxCate
    setState(() {
      taxCategoryName=name;
    });
  }

  @override
  selectTaxType(String id, String name) {
    // TODO: implement selectTaxType
    setState(() {
      taxTypeName=name;
    });
  }
}

// abstract class CreateExpenseActivityInterface {
// }
