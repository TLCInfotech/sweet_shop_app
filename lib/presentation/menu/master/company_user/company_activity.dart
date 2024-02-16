import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog_for_profile.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';
import 'package:sweet_shop_app/presentation/dialog/country_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/state_dialog.dart';

import '../../../common_widget/signleLine_TexformField.dart';

class CompanyCreate extends StatefulWidget {
  const CompanyCreate({super.key});


  @override
  State<CompanyCreate> createState() => _CompanyCreateState();
}

class _CompanyCreateState extends State<CompanyCreate>
    with
        SingleTickerProviderStateMixin,
        ImagePickerDialogPostInterface,
        ImagePickerListener,StateDialogInterface,CountryDialogInterface,
        ImagePickerDialogInterface {
  final _nameFocus = FocusNode();
  final nameController = TextEditingController();

  final _contactPersonFocus = FocusNode();
  final contactPersonController = TextEditingController();

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

  late ImagePickerHandler imagePicker;
  late AnimationController _Controller;
  File? picImage;
  String countryName = "";
  String countryId = "";
  String stateName = "";
  String stateId = "";
  Color currentColor = CommonColor.THEME_COLOR;
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;

  String hourlyRate = "\$0";
  DateTime joinDate =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime endDate =
      DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  String startingDate = "";
  String endingDate = "";
  bool isPurchaseDateValidShow = false;
  bool isPurchaseDateMsgValidShow = false;

  @override
  void initState() {

    super.initState();
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = ImagePickerHandler(this, _Controller);
    imagePicker.setListener(this);
    imagePicker.init(context);
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

              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
                title: const Text(
                  StringEn.COMPANY,
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

  double opacityLevel = 1.0;


  // Pick Profile photo
  Widget getImageLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            picImage == null
                ? Container(
                    height: parentHeight * .25,
                    width: parentHeight * .25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/placeholder.png'), // Replace with your image asset path
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
                          opacity: opacityLevel,
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
                  SizedBox(height: 20.0),
                  CommonWidget.getFieldTitleLayout(StringEn.BASIC_INFO),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [

                      getNameLayout(parentHeight, parentWidth),
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
                      getAddressTwoLayout(parentHeight, parentWidth),
                      getDefaultBankLayout(parentHeight, parentWidth),
                      getExtNameLayout(parentHeight, parentWidth),
                    ],
                    ),
                  ),

                  SizedBox(height: 20.0),
                  CommonWidget.getFieldTitleLayout(StringEn.OTHER_INFO),
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

                      getCINNoLayout(parentHeight, parentWidth),
                      getJURISDICTIONLayout(parentHeight, parentWidth),

                      getInvoiceDelcelrationLayout(parentHeight, parentWidth),

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


  /* Widget for name text from field layout */
  Widget getNameLayout(double parentHeight, double parentWidth) {
    return SignleLineEditableTextformField(
      controller: nameController,
      focuscontroller: _nameFocus,
      focusnext: _contactPersonFocus,
      title:StringEn.COMPANY_NAME,
      callbackOnchage: (value ) {
        setState(() {
          nameController.text=value;
        });
      },
      textInput:  TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringEn.COMPANY_NAME,
            style: page_heading_textStyle,
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
                    focusNode: _nameFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: StringEn.COMPANY_NAME,
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: nameController,
                    onEditingComplete: () {
                      _nameFocus.unfocus();
                      FocusScope.of(context).requestFocus(_contactPersonFocus);
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

  /* Widget for contact person text from field layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return  SignleLineEditableTextformField(
      controller: contactPersonController,
      focuscontroller: _contactPersonFocus,
      focusnext: _addressFocus,
      title:StringEn.FRANCHISEE_CONTACT_PERSON,
      callbackOnchage: (value ) {
        setState(() {
          contactPersonController.text=value;
        });
      },
      textInput:  TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
    //   Padding(
    //   padding: EdgeInsets.only(top: parentHeight * 0.02),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             StringEn.FRANCHISEE_CONTACT_PERSON,
    //             style: page_heading_textStyle,
    //           ),
    //         ],
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(top: parentHeight * .005),
    //         child: Container(
    //           height: parentHeight * .055,
    //           alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //             color: CommonColor.WHITE_COLOR,
    //             borderRadius: BorderRadius.circular(4),
    //             boxShadow: [
    //               BoxShadow(
    //                 offset: Offset(0, 1),
    //                 blurRadius: 5,
    //                 color: Colors.black.withOpacity(0.1),
    //               ),
    //             ],
    //           ),
    //           child: TextFormField(
    //             textAlignVertical: TextAlignVertical.center,
    //             textCapitalization: TextCapitalization.words,
    //             focusNode: _contactPersonFocus,
    //             keyboardType: TextInputType.text,
    //             textInputAction: TextInputAction.next,
    //             cursorColor: CommonColor.BLACK_COLOR,
    //             decoration: InputDecoration(
    //               contentPadding: EdgeInsets.only(
    //                   left: parentWidth * .04, right: parentWidth * .02),
    //               border: InputBorder.none,
    //               counterText: '',
    //               isDense: true,
    //               hintText: StringEn.FRANCHISEE_CONTACT_PERSON,
    //               hintStyle: hint_textfield_Style,
    //             ),
    //             controller: contactPersonController,
    //             onEditingComplete: () {
    //               _contactPersonFocus.unfocus();
    //               FocusScope.of(context).requestFocus(_addressFocus);
    //             },
    //             style: text_field_textStyle,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }


  /* Widget for address text from field layout */
  Widget getAddressLayout(double parentHeight, double parentWidth) {
    return  SignleLineEditableTextformField(
      controller: addressController,
      focuscontroller: _addressFocus,
      focusnext: _districtCity,
      title:StringEn.ADDRESS,
      callbackOnchage: (value ) {
        setState(() {
          addressController.text=value;
        });
      },
      textInput:  TextInputType.text,
      maxlines: 6,
      format:FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

      Padding(
      padding: EdgeInsets.only(
        top: parentHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            StringEn.ADDRESS,
            style: page_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: parentHeight * .135,
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
                    padding: EdgeInsets.only(top: parentHeight * .01),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.sentences,
                      scrollPadding: EdgeInsets.only(bottom: parentHeight * .2),
                      focusNode: _addressFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLines: 6,
                      maxLength: 500,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.only(left: parentWidth * .04),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: StringEn.ADDRESS,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: addressController,
                      onEditingComplete: () {
                        _addressFocus.unfocus();
                        FocusScope.of(context).requestFocus(_districtCity);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  /* Widget for getting district and state layout */

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


  /* Widget for getting pincode and country layout */
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
    return SignleLineEditableTextformField(
      controller: contactController,
      focuscontroller: _contactFocus,
      focusnext: _emailFocus,
      title: StringEn.CONTACT_NO,
      callbackOnchage: (value ) {
        setState(() {
          contactController.text=value;
        });
      },
      textInput:   TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    );
      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.CONTACT_NO,
              style: page_heading_textStyle,
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
                      focusNode: _contactFocus,
                      keyboardType:
                      TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,

                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: StringEn.CONTACT_NO,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: contactController,
                      onEditingComplete: () {
                        _contactFocus.unfocus();
                        FocusScope.of(context).requestFocus(_emailFocus);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  /* Widget for  email  text from field layout */
  Widget getEmilLayout(double parentHeight, double parentWidth) {
    return  SignleLineEditableTextformField(
      controller: emailController,
      focuscontroller: _emailFocus,
      focusnext: _addTwoFocus,
      title:StringEn.ADDRESS,
      callbackOnchage: (value ) {
        setState(() {
          emailController.text=value;
        });
      },
      textInput:   TextInputType.emailAddress,
      maxlines: 1,
      format:   FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z  @ .]')),
    );

      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.EMAIL,
              style: page_heading_textStyle,
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z]'))
                      ],
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _emailFocus,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText:  StringEn.EMAIL,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: emailController,
                      onEditingComplete: () {
                        _emailFocus.unfocus();
                        FocusScope.of(context).requestFocus(_addTwoFocus);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

/* Widget for address two from field layout */
  Widget getAddressTwoLayout(double parentHeight, double parentWidth) {
    return  SignleLineEditableTextformField(
      controller: addTwoController,
      focuscontroller: _addTwoFocus,
      focusnext: _defaultBankFocus,
      title:StringEn.ADDRESS_TWO,
      callbackOnchage: (value ) {
        setState(() {
          addTwoController.text=value;
        });
      },
      textInput:   TextInputType.text,
      maxlines: 6,
      format:FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

      Padding(
      padding: EdgeInsets.only(
        top: parentHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            StringEn.ADDRESS_TWO,
            style: page_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: parentHeight * .135,
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
                    padding: EdgeInsets.only(top: parentHeight * .01),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.sentences,
                      scrollPadding: EdgeInsets.only(bottom: parentHeight * .2),
                      focusNode: _addTwoFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLines: 6,
                      maxLength: 500,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.only(left: parentWidth * .04),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText:  StringEn.ADDRESS_TWO,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: addTwoController,
                      onEditingComplete: () {
                        _addTwoFocus.unfocus();
                        FocusScope.of(context).requestFocus(_adharoFocus);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  /* Widget for cin no  text from field layout */
  Widget getCINNoLayout(double parentHeight, double parentWidth) {
    return   SignleLineEditableTextformField(
      controller: cinNoController,
      focuscontroller: _cinNoFocus,
      focusnext: _jurisdictionFocus,
      title:StringEn.CIN_NO,
      callbackOnchage: (value ) {
        setState(() {
          cinNoController.text=value;
        });
      },
      textInput:   TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.CIN_NO,
              style: page_heading_textStyle,
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

                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z]'))
                      ],
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _cinNoFocus,
                      keyboardType:TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: "Enter cin no",
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: cinNoController,
                      onEditingComplete: () {
                        _cinNoFocus.unfocus();
                        FocusScope.of(context).requestFocus(_jurisdictionFocus);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  /* Widget for JURISDICTION text from field layout */
  Widget getJURISDICTIONLayout(double parentHeight, double parentWidth) {
    return  SignleLineEditableTextformField(
      controller: jurisdictionController,
      focuscontroller: _jurisdictionFocus,
      focusnext: _invoiceFocus,
      title:StringEn.JURISDICTION,
      callbackOnchage: (value ) {
        setState(() {
          jurisdictionController.text=value;
        });
      },
      textInput:   TextInputType.emailAddress,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.JURISDICTION,
              style: page_heading_textStyle,
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
                      focusNode: _jurisdictionFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText:  StringEn.JURISDICTION,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: jurisdictionController,
                      onEditingComplete: () {
                        _jurisdictionFocus.unfocus();
                        FocusScope.of(context).requestFocus(_defaultBankFocus);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ) ;
  }


  /* Widget for default bank text from field layout */
  Widget getDefaultBankLayout(double parentHeight, double parentWidth) {
    return SignleLineEditableTextformField(
      controller: defaultBankController,
      focuscontroller: _defaultBankFocus,
      focusnext: _extNameFocus,
      title:StringEn.DEFAULT_BANK,
      callbackOnchage: (value ) {
        setState(() {
          defaultBankController.text=value;
        });
      },
      textInput:   TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'[ A-Z a-z]')),
    );
      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.DEFAULT_BANK,
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
                    focusNode: _defaultBankFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText:  StringEn.DEFAULT_BANK,
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: defaultBankController,
                    onEditingComplete: () {
                      _defaultBankFocus.unfocus();
                      FocusScope.of(context).requestFocus(_extNameFocus);
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

  /* Widget for ext name text from field layout */
  Widget getExtNameLayout(double parentHeight, double parentWidth) {
    return  SignleLineEditableTextformField(
      controller: extNameController,
      focuscontroller: _extNameFocus,
      focusnext: _adharoFocus,
      title:StringEn.EXT_NAME,
      callbackOnchage: (value ) {
        setState(() {
          extNameController.text=value;
        });
      },
      textInput:   TextInputType.emailAddress,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'[A-Z a-z]')),
    );
      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.EXT_NAME,
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
                    focusNode: _extNameFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText:  StringEn.EXT_NAME,
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: extNameController,
                    onEditingComplete: () {
                      _extNameFocus.unfocus();
                      FocusScope.of(context).requestFocus(_invoiceFocus);
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

/* Widget for invoice declaration text from field layout */
  Widget getInvoiceDelcelrationLayout(double parentHeight, double parentWidth) {
    return  SignleLineEditableTextformField(
      controller: invoiceController,
      focuscontroller: _invoiceFocus,
      focusnext: null,
      title:StringEn.INVOICE_DECLERATION,
      callbackOnchage: (value ) {
        setState(() {
          nameController.text=value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 6,
      format:FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
      Padding(
      padding: EdgeInsets.only(
        top: parentHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            StringEn.INVOICE_DECLERATION,
            style: page_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: parentHeight * .15,
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
                    padding: EdgeInsets.only(top: parentHeight * .01),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.sentences,
                      scrollPadding: EdgeInsets.only(bottom: parentHeight * .2),
                      focusNode: _invoiceFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      maxLines: 6,
                      maxLength: 500,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.only(left: parentWidth * .04),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: StringEn.INVOICE_DECLERATION,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: invoiceController,
                      onEditingComplete: () {
                        _invoiceFocus.unfocus();
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  //common widget to display file
  Stack getFileLayout(File fileName) {
    return Stack(
      children: [
        fileName.uri.toString().contains(".pdf")?
        Container(
            height: 100,
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.filePdf,color: Colors.redAccent,),
                Text(fileName.uri.toString().split('/').last,style: item_heading_textStyle,),
              ],
            )
        ): Container(
          height: 100,
          margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
              image: DecorationImage(
                image: FileImage(fileName),
                fit: BoxFit.cover,
              )
          ),
        ),
        Positioned(
            right: 1,
            top: 1,
            child: IconButton(
                onPressed: (){
                  if(fileName==adharFile){
                    setState(() {
                      adharFile=null;
                    });
                  }
                  else if(fileName==panFile){
                    setState(() {
                      panFile=null;
                    });
                  }
                  else if(fileName==gstFile){
                    setState(() {
                      gstFile=null;
                    });
                  }
                },
                icon: Icon(Icons.remove_circle_sharp,color: Colors.red,)))
      ],
    );
  }
  


  /* Widget for distric text from field layout */
  Widget getDistrictCityLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.DISTRICTCITY,
              style: page_heading_textStyle,
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
                      focusNode: _districtCity,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText:StringEn.DISTRICTCITY,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: districtController,
                      onEditingComplete: () {
                        _districtCity.unfocus();
                        FocusScope.of(context).requestFocus(_pinCodeFocus);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                          stateName == "" ? StringEn.SELECT_STATE: stateName,
                          style: stateName == ""
                              ? hint_textfield_Style
                              : text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,

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


  /* Widget for pin code text from field layout */
  Widget getPinCodeLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.PIN_CODE,
              style: page_heading_textStyle,
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
                      focusNode: _pinCodeFocus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText:  StringEn.PIN_CODE,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: pinCodeController,
                      onEditingComplete: () {
                        _pinCodeFocus.unfocus();
                        FocusScope.of(context).requestFocus(_contactFocus);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget for country text from field layout */
  Widget getCountryLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
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
                          countryName == "" ? StringEn.SELECT_COUNTRY: countryName,
                          style: countryName == ""
                              ? hint_textfield_Style
                              : text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,

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
  userImage(File image, String comeFrom) {

    if (mounted) {
      setState(() {
        picImage = image;
      });
    }
    print("neweww  $image");
  }

  @override
  selectState(String id, String name) {

setState(() {
  stateName=name;
});
  }

  @override
  selectCountry(String id, String name) {

    setState(() {
      countryName=name;
    });
  }
}

