

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog_for_profile.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/core/util.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';
import 'package:sweet_shop_app/presentation/dialog/city_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/country_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/state_dialog.dart';


class CreateFranchisee extends StatefulWidget {
  @override
  _CreateFranchiseeState createState() => _CreateFranchiseeState();
}

class _CreateFranchiseeState extends State<CreateFranchisee> with SingleTickerProviderStateMixin,CityDialogInterface,StateDialogInterface,
    ImagePickerDialogPostInterface,
    ImagePickerListener,CountryDialogInterface,
    ImagePickerDialogInterface {


  final ScrollController _scrollController = ScrollController();
  final _panNoFocus = FocusNode();
  final panNoController = TextEditingController();
  final _gstNoFocus = FocusNode();
  final gstNoController = TextEditingController();
  final _adharoFocus = FocusNode();
  final adharNoController = TextEditingController();

  late ImagePickerHandler imagePicker;
  late AnimationController _Controller;
  File? picImage;

  TextEditingController franchiseeName = TextEditingController();
  final _franchiseeNameFocus=FocusNode();
  TextEditingController franchiseeContactPerson = TextEditingController();
  final _franchiseeContactPersonFocus=FocusNode();
  TextEditingController franchiseeAddress = TextEditingController();
  final _franchiseeAddressFocus=FocusNode();
  TextEditingController franchiseeMobileNo = TextEditingController();
  final _franchiseeMobileNoFocus=FocusNode();
  TextEditingController franchiseeEmail = TextEditingController();
  final _franchiseeEmailFocus=FocusNode();

  TextEditingController pincode = TextEditingController();
  final _pincodeFocus=FocusNode();

  TextEditingController franchiseeAadharNo = TextEditingController();
  TextEditingController franchiseeGSTNO = TextEditingController();
  TextEditingController franchiseePanNo = TextEditingController();

  TextEditingController franchiseeOutstandingLimit = TextEditingController();
  final _franchiseeOutstandingLimitFocus = FocusNode();
  TextEditingController franchiseePaymentDays = TextEditingController();
  final _franchiseePaymentDaysFocus = FocusNode();

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
  bool disableColor = false;
String countryName="";
String stateName="";

  String selectedState = ""; // Initial dummy data

  String selectedCity = ""; // Initial dummy data

  String selectedCountry = "";

  File? aadharCardFile;

  File? panCardFile;

  File? gstCardFile;

  List<String> LimitDataUnit = ["Cr","Dr"];

  String ?selectedLimitUnit = null;
  File? adharFile ;
  File? panFile ;
  File? gstFile ;
  // method to pick adhar document
  getAadharFile()async{
    File file=await CommonWidget.pickDocumentFromfile();
    setState(() {
      adharFile=file;
    });
  }
  // method to pick pan document
  getPanFile()async{
    File file=await CommonWidget.pickDocumentFromfile();
    setState(() {
      panFile=file;
    });
  }
  // method to pick gst document
  getGstFile()async{
    File file=await CommonWidget.pickDocumentFromfile();
    setState(() {
      gstFile=file;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = ImagePickerHandler(this, _Controller);
    imagePicker.setListener(this);
    imagePicker.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  Widget contentBox(BuildContext context) {
    return Container(
      height: SizeConfig.safeUsedHeight,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xFFfffff5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Scaffold(
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
                  StringEn.ADD_FRANCHISEE,
                  style: appbar_text_style,),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                // color: CommonColor.DASHBOARD_BACKGROUND,
                  child: getAllFields(SizeConfig.screenHeight, SizeConfig.screenWidth)),
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
  Widget getAllFields(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 20,),
                getImageLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                SizedBox(height: 20,),
                getFieldTitleLayout(StringEn.BASIC_INFO),
                BasicInfo(),
                SizedBox(height: 20,),
                getFieldTitleLayout(StringEn.DOCUMENT_INFO),
                Document_Information(),
                SizedBox(height: 20.0),
                getFieldTitleLayout(StringEn.ACCOUNT_INFO),
                Container(

                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey,width: 1),
                  ),
                  child: Column(children: [
                    getBankNameLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getBankBranchNameLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getFSCCodeLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getACHolderNameLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getAcoountNoLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                  ],
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ],
    );

  }

  Container Document_Information() {
    return Container(

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
                        focusnext: _franchiseePaymentDaysFocus,
                      ),
                      getFieldTitleLayout(StringEn.FRANCHISEE_PAYMENT_DAYS),
                      getPaymentDaysLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                    ],
                    ),
                  );
  }

  Container BasicInfo() {
    return Container(

                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [
                      getFieldTitleLayout(StringEn.FRANCHISEE_NAME),
                      getFranchiseeNameLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getFieldTitleLayout(StringEn.FRANCHISEE_CONTACT_PERSON),
                      getContactPersonLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getFieldTitleLayout(StringEn.FRANCHISEE_ADDRESS),
                      getAddressLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getCityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                          getPincodeLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getStateLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                          getCountryLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                        ],
                      ),
                      getFieldTitleLayout(StringEn.FRANCHISEE_MOBILENO),
                      getMobileNoLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getFieldTitleLayout(StringEn.FRANCHISEE_EMAIL),
                      getEmailLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getFieldTitleLayout(StringEn.FRANCHISEE_OUTSTANDING_LIMIT),
                      getOutstandingLimit(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                    ],
                    ),
                  );
  }


  /* Widget for bank name text from field layout */
  Widget getBankNameLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.BANK_NAME,
                style: page_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Container(
              height: parentHeight * .055,
              alignment: Alignment.center,
              decoration: box_decoration,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.words,
                focusNode: _bankNameFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText:StringEn.BANK_NAME,
                  hintStyle: hint_textfield_Style,
                ),
                controller: bankNameController,
                onEditingComplete: () {
                  _bankNameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_bankBranchFocus);
                },
                style: text_field_textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for bank branch name text from field layout */
  Widget getBankBranchNameLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.BANT_BRACH,
                style: page_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Container(
              height: parentHeight * .055,
              alignment: Alignment.center,
              decoration: box_decoration,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.words,
                focusNode: _bankBranchFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText:StringEn.BANT_BRACH,
                  hintStyle: hint_textfield_Style,
                ),
                controller: bankBranchController,
                onEditingComplete: () {
                  _bankBranchFocus.unfocus();
                  FocusScope.of(context).requestFocus(_IFSCCodeFocus);
                },
                style: text_field_textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
  /* Widget for IFSC Code text from field layout */
  Widget getFSCCodeLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.IFSC_CODE,
                style: page_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Container(
              height: parentHeight * .055,
              alignment: Alignment.center,
              decoration: box_decoration,
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z]'))
                ],
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.words,
                focusNode: _IFSCCodeFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText:  StringEn.IFSC_CODE,
                  hintStyle: hint_textfield_Style,
                ),
                controller: IFSCCodeController,
                onEditingComplete: () {
                  _IFSCCodeFocus.unfocus();
                  FocusScope.of(context).requestFocus(_aCHolderNameFocus);
                },
                style: text_field_textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for Account holder name text from field layout */
  Widget getACHolderNameLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.ACCOUNT_HOLDER_NAME,
                style: page_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Container(
              height: parentHeight * .055,
              alignment: Alignment.center,
              decoration: box_decoration,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.words,
                focusNode: _aCHolderNameFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText:  StringEn.ACCOUNT_HOLDER_NAME,
                  hintStyle: hint_textfield_Style,
                ),
                controller: aCHolderNameController,
                onEditingComplete: () {
                  _aCHolderNameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_accountNoFocus);
                },
                style: text_field_textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for Account No name text from field layout */
  Widget getAcoountNoLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.ACCOUNT_NO,
                style: page_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Container(
              height: parentHeight * .055,
              alignment: Alignment.center,
              decoration: box_decoration,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.words,
                focusNode: _accountNoFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText: StringEn.ACCOUNT_NO,
                  hintStyle: hint_textfield_Style,
                ),
                controller: accountNoController,
                onEditingComplete: () {
                  _accountNoFocus.unfocus();
                  //FocusScope.of(context).requestFocus(_addressFocus);
                },
                style: text_field_textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for country text from field layout */
  Widget getCountryLayout(double parentHeight, double parentWidth) {
    return Container(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.COUNTRY,
              style: page_heading_textStyle,
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
                child:  GestureDetector(
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
                              child:CountryDialog(
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
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          countryName == "" ? "Select country" : countryName,
                          style: countryName == ""
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

    );
  }


  /* Widget for state text from field layout */
  Widget getStateLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.STATE,
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
                          stateName == "" ? "Select state" : stateName,
                          style: stateName == ""
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

  /* widget for image layout */
  Widget getImageLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            picImage == null
                ? Container(
              height: parentHeight * .15,
              width: parentHeight * .15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/placeholder.png'),
                  // Replace with your image asset path
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
            )
                : Container(
              height: parentHeight * .25,
              width: parentHeight * .25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: FileImage(picImage!),
                    fit: BoxFit.cover,
                  )),
            ),
            GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(seconds: 2),
                          child: ImagePickerDialogPost(
                            imagePicker,
                            _Controller,
                            context,
                            this,
                            isOpenFrom: '',
                          ),
                        );
                      },
                    );
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: parentWidth * .08),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: parentHeight * .05,
                      width: parentHeight * .05,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .white, // Change the color to your desired fill color
                      ),
                      /*     decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/edit_post.png'), // Replace with your image asset path
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),*/
                    ),
                    Container(
                        height: parentHeight * .03,
                        width: parentHeight * .03,
                        child: const Image(
                          image: AssetImage("assets/images/edit_post.png"),
                          fit: BoxFit.contain,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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



  /* widget for franchisee payment days layout */
  Widget getPaymentDaysLayout(double parentHeight, double parentWidth) {
    return Container(
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
        focusNode: _franchiseePaymentDaysFocus,
        keyboardType: TextInputType.number,
        controller: franchiseePaymentDays,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.FRANCHISEE_PAYMENT_DAYS,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return StringEn.PAYMENT_DAYS;
          }
          return null;
        },
        onEditingComplete: () {
          _franchiseePaymentDaysFocus.unfocus();
          FocusScope.of(context).requestFocus(_bankNameFocus);
        },
      ),
    );
  }


  /* widget for franchisee outstanding limit layout */
  Widget getOutstandingLimit(double parentHeight, double parentWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
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
              focusNode: _franchiseeOutstandingLimitFocus,
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: franchiseeOutstandingLimit,
              decoration: textfield_decoration.copyWith(
                hintText: StringEn.FRANCHISEE_OUTSTANDING_LIMIT,
              ),
              onFieldSubmitted: (v) => franchiseeOutstandingLimit.text = double.parse(franchiseeOutstandingLimit.text).toString(),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Email Address";
                }
                return null;
              },
              onEditingComplete: () {
                _franchiseeOutstandingLimitFocus.unfocus();
                FocusScope.of(context).requestFocus(_franchiseePaymentDaysFocus);
              },
            ),
          ),
        ),
        Container(
          height: parentHeight * .055,
          width: 100,
          margin: EdgeInsets.only(left: 10),
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

  /* widget for franchisee email layout */
  Widget getEmailLayout(double parentHeight, double parentWidth) {
    return Container(
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

        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z]'))
        ],
        focusNode: _franchiseeEmailFocus,
        textAlignVertical: TextAlignVertical.center,
        textCapitalization: TextCapitalization.none,
        cursorColor: CommonColor.BLACK_COLOR,
        keyboardType: TextInputType.emailAddress,
        controller: franchiseeEmail,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.FRANCHISEE_EMAIL,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Email Address";
          }
          else if (Util.isEmailValid(value)) {
            return "Enter Valid Email";
          }
          return null;
        },
        onEditingComplete: () {
          _franchiseeEmailFocus.unfocus();
          FocusScope.of(context).requestFocus(_adharoFocus);
        },
      ),
    );
  }


  /* Widget for branch name text from field layout */
  Widget getPanLayout(double parentHeight, double parentWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringEn.PAN_NO,
          style: page_heading_textStyle,
        ),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Container(
                height: parentHeight * .055,
                width: parentWidth*.7,
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z]'))
                  ],
                  maxLength: 10,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.characters,
                  focusNode: _panNoFocus,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: CommonColor.BLACK_COLOR,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: parentWidth * .04, right: parentWidth * .02),
                    border: InputBorder.none,
                    counterText: '',
                    isDense: true,
                    hintText:StringEn.PAN_NO,
                    hintStyle: hint_textfield_Style,
                  ),
                  controller: panNoController,
                  onEditingComplete: () {
                    _panNoFocus.unfocus();
                    FocusScope.of(context).requestFocus(_gstNoFocus);
                  },
                  style: text_field_textStyle,
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                getPanFile();
              },
              child: Padding(
                padding:  EdgeInsets.only(right: parentWidth*.0),
                child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.fileArrowUp,color: Colors.white,size: 20,),
                        Text("Upload",style: subHeading_withBold)
                      ],
                    )
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        panFile!=null?
        getFileLayout(panFile!):Container()
      ],
    );
  }
  /* Widget for branch name text from field layout */
  Widget getAdharLayout(double parentHeight, double parentWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          StringEn.FRANCHISEE_AADHAR_NO,
          style: page_heading_textStyle,
        ),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Container(
                height: parentHeight * .055,
                width: parentWidth*.7,
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 12,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.words,
                  focusNode: _adharoFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  cursorColor: CommonColor.BLACK_COLOR,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: parentWidth * .04, right: parentWidth * .02),
                    border: InputBorder.none,
                    counterText: '',
                    isDense: true,
                    hintText: StringEn.FRANCHISEE_AADHAR_NO,
                    hintStyle: hint_textfield_Style,
                  ),
                  controller: adharNoController,
                  onEditingComplete: () {
                    _adharoFocus.unfocus();
                    FocusScope.of(context).requestFocus(_panNoFocus);
                  },
                  style: text_field_textStyle,
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                getAadharFile();
              },
              child: Padding(
                padding:  EdgeInsets.only(right: parentWidth*.0),
                child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.fileArrowUp,color: Colors.white,size: 20,),
                        Text("Upload",style: subHeading_withBold)
                      ],
                    )
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        adharFile!=null?
        getFileLayout(adharFile!):Container()
      ],
    );
  }
  /* Widget for branch name text from field layout */
  Widget getGstLayout(double parentHeight, double parentWidth) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringEn.GST_NO,
          style: page_heading_textStyle,
        ),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Container(
                height: parentHeight * .055,
                width: parentWidth*.7,
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z]'))
                  ],
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 15,
                  focusNode: _gstNoFocus,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: CommonColor.BLACK_COLOR,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: parentWidth * .04, right: parentWidth * .02),
                    border: InputBorder.none,
                    counterText: '',
                    isDense: true,
                    hintText:  StringEn.GST_NO,
                    hintStyle: hint_textfield_Style,
                  ),
                  controller:gstNoController,
                  onEditingComplete: () {
                    _gstNoFocus.unfocus();
                    FocusScope.of(context).requestFocus(_franchiseeOutstandingLimitFocus);
                  },
                  style: text_field_textStyle,
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                getGstFile();
              },
              child: Padding(
                padding:  EdgeInsets.only(right: parentWidth*.0),
                child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.fileArrowUp,color: Colors.white,size: 20,),
                        Text("Upload",style: subHeading_withBold)
                      ],
                    )
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        gstFile!=null?
        getFileLayout(gstFile!):Container()
      ],
    );
  }
  /* widget for franchisee mobile layout */

  Widget getMobileNoLayout(double parentHeight, double parentWidth) {
    return Container(
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
        focusNode: _franchiseeMobileNoFocus,
        keyboardType: TextInputType.phone,
        controller: franchiseeMobileNo,
        maxLength: 10,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.FRANCHISEE_MOBILENO,
        ),
        validator: (value) {
          // String pattern =r'^[6-9]\d{9}$';
          // RegExp regExp = new RegExp(pattern);
          // print(Util.isMobileValid(value!));
          if (value!.isEmpty) {
            return "Enter Mobile No.";
          }
          else if (Util.isMobileValid(value)) {
            return "Enter Valid Mobile No.";
          }

          return null;
        },
        onEditingComplete: () {
          _franchiseeMobileNoFocus.unfocus();
          FocusScope.of(context).requestFocus(_franchiseeEmailFocus);
        },
      ),
    );
  }


  /* widget for Contact Person layout */
  Widget getPincodeLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            StringEn.PIN_CODE,
            style: page_heading_textStyle,
          ),
          Container(
            width: parentWidth*.4,
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
              keyboardType: TextInputType.number,
              controller: pincode,
              focusNode: _pincodeFocus,
              decoration: textfield_decoration.copyWith(
                hintText: StringEn.PIN_CODE,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Contact Person";
                }
                return null;
              },
              onEditingComplete: () {
                _pincodeFocus.unfocus();
                FocusScope.of(context).requestFocus(_franchiseeMobileNoFocus);
              },
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for city text from field layout */
  Widget getCityLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth*.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.FRANCHISEE_CITY,
              style: page_heading_textStyle,
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
                child:  GestureDetector(
                  onTap: (){
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
                                child: CityDialog(
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
                  onDoubleTap: (){},
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCity == "" ? "Select city" : selectedCity,
                          style: selectedCity == ""
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

  /* widget for Contact Person layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return Container(
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
        focusNode: _franchiseeContactPersonFocus,
        keyboardType: TextInputType.text,
        controller: franchiseeContactPerson,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.FRANCHISEE_CONTACT_PERSON,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Contact Person";
          }
          return null;
        },
        onEditingComplete: () {
          _franchiseeContactPersonFocus.unfocus();
          FocusScope.of(context).requestFocus(_franchiseeAddressFocus);
        },
      ),
    );
  }


  /* widget for Address layout */
  Widget getAddressLayout(double parentHeight, double parentWidth) {
    return Container(
     // height: parentHeight * .055,
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
        maxLines: 4,
        focusNode: _franchiseeAddressFocus,
        keyboardType: TextInputType.streetAddress,
        controller: franchiseeAddress,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.FRANCHISEE_ADDRESS,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Address";
          }
          // else if (Util.isAddressValid(value)) {
          //   return "Enter Valid Address";
          // }
          return null;
        },
        onEditingComplete: () {
          _franchiseeAddressFocus.unfocus();
          FocusScope.of(context).requestFocus(_pincodeFocus);
        },
      ),
    );
  }


  /* widget for Franchisee name layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return Container(
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
        focusNode: _franchiseeNameFocus,
        keyboardType: TextInputType.text,
        controller: franchiseeName,
        decoration: textfield_decoration.copyWith(
          hintText: StringEn.FRANCHISEE_NAME,
        ),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Enter Franchisee Name";
          }
          return null;
        }),
        onEditingComplete: () {
          _franchiseeNameFocus.unfocus();
          FocusScope.of(context).requestFocus(_franchiseeContactPersonFocus);
        },
      ),
    );
  }

  //interface function to get city
  @override
  selectCity(String id, String name) {
    // TODO: implement selectCategory
    if (mounted) {
      setState(() {
        selectedCity = name;
        print("jnkgjngtjngjt  $id $name");
      });
    }
  }

  //interface functionn to get state
  @override
  selectState(String id, String name) {
    // TODO: implement selectState
    if (mounted) {
      setState(() {
        selectedState = name;
        print("jnkgjngtjngjt  $id $name");
      });
    }
  }


  // method to pick gst document
  getGstCardFile() async {
    File file = await CommonWidget.pickDocumentFromfile();
    setState(() {
      gstCardFile = file;
    });
  }

  // method to pick pan document
  getPanCardFile() async {
    File file = await CommonWidget.pickDocumentFromfile();
    setState(() {
      panCardFile = file;
    });
  }

  // method to pick aadhar document
  getAadharCardFile() async {
    File file = await CommonWidget.pickDocumentFromfile();
    setState(() {
      aadharCardFile = file;
    });
  }

  //common widget to display file
  Stack getFileLayout(File FileName) {
    return Stack(
      children: [
        FileName!.uri.toString().contains(".pdf") ?
        Container(
            height: 100,
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.6),),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.filePdf, color: Colors.redAccent,),
                Text(FileName!
                    .uri
                    .toString()
                    .split('/')
                    .last, style: item_heading_textStyle,),
              ],
            )
        ) : Container(
          height: 100,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.6),),
              image: DecorationImage(
                image: FileImage(FileName!),
                fit: BoxFit.cover,
              )
          ),

        ),
        Positioned(
            right: 15,
            top: 15,
            child: IconButton(
                onPressed: () {
                  if (FileName == aadharCardFile) {
                    setState(() {
                      aadharCardFile = null;
                    });
                  }
                  else if (FileName == panCardFile) {
                    setState(() {
                      panCardFile = null;
                    });
                  }
                  else if (FileName == gstCardFile) {
                    setState(() {
                      gstCardFile = null;
                    });
                  }
                },
                icon: Icon(Icons.remove_circle_sharp, color: Colors.red,)))
      ],
    );
  }

  @override
  selectCountry(String id, String name) {
    // TODO: implement selectCountry
    setState(() {
      selectedCountry = name;
    });
  }

  @override
  userImage(File image, String comeFrom) {
    // TODO: implement userImage
    setState(() {
      picImage = image;
    });
  }

}

