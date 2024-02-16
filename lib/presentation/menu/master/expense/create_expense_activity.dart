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
import 'package:sweet_shop_app/presentation/dialog/country_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/state_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/tax_category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/tax_type_dialog.dart';

class CreateExpenseActivity extends StatefulWidget {
  const CreateExpenseActivity({super.key});

  // final CreateExpenseActivityInterface mListener;

  @override
  State<CreateExpenseActivity> createState() => _CreateExpenseActivityState();
}

class _CreateExpenseActivityState extends State<CreateExpenseActivity>
    with
        SingleTickerProviderStateMixin,
        ImagePickerDialogPostInterface,
        ImagePickerListener,StateDialogInterface,CountryDialogInterface,
        ImagePickerDialogInterface,TaxDialogInterface , TaxCategoryDialogInterface {
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

                      SizedBox(height:10,),
                      // getRegTypeLayout(parentHeight, parentWidth),
                      getAdharLayout(parentHeight, parentWidth),
                      getPanLayout(parentHeight, parentWidth),
                      getGstLayout(parentHeight, parentWidth),
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


  /* Widget for name text from field layout */
  Widget getNameLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.NAME,
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
                  decoration: box_decoration,
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
                      hintText: StringEn.NAME,
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: nameController,
                    onEditingComplete: () {
                      _nameFocus.unfocus();
                      FocusScope.of(context).requestFocus(_leaderGroupFocus);
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

  /* Widget for leader group text from field layout */
  Widget getLeaderGroupLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.LEADER_GROUP,
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
                focusNode: _leaderGroupFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText:StringEn.LEADER_GROUP,
                  hintStyle: hint_textfield_Style,
                ),
                controller: leaderGroupController,
                onEditingComplete: () {
                  _leaderGroupFocus.unfocus();
                FocusScope.of(context).requestFocus(_contactPersonFocus);
                },
                style: text_field_textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }


  /* Widget for contact person text from field layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.FRANCHISEE_CONTACT_PERSON,
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
                focusNode: _contactPersonFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText: StringEn.FRANCHISEE_CONTACT_PERSON,
                  hintStyle: hint_textfield_Style,
                ),
                controller: contactPersonController,
                onEditingComplete: () {
                  _contactPersonFocus.unfocus();
                  FocusScope.of(context).requestFocus(_addressFocus);
                },
                style: text_field_textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for description text from field layout */
  Widget getAddressLayout(double parentHeight, double parentWidth) {
    return Padding(
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
                  decoration:box_decoration,
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
                        hintText:  StringEn.ADDRESS,
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


  /* Widget for select contract layout */

  Widget getLeftLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(right: parentWidth * .01),
      child: Column(
        children: [
          getDistrictCityLayout(parentHeight, parentWidth),
          getStateLayout(parentHeight, parentWidth),
          //getVendorLayout(parentHeight, parentWidth),
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
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        //width: parentWidth * .43,
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
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.none,
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
                        hintText:  StringEn.CONTACT_NO,
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
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        //width: parentWidth * .43,
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
                    decoration: box_decoration,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z]'))
                      ],
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.none,
                      focusNode: _emailFocus,
                      keyboardType:TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText:StringEn.EMAIL,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: emailController,
                      onEditingComplete: () {
                        _emailFocus.unfocus();
                        FocusScope.of(context).requestFocus(_outstandingLimitFocus);
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



  /* Widget for outstanding limit text from field layout */
  Widget getOutstandingLimitLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.OUTSTANDING_LIMIT,
                style: page_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:  EdgeInsets.only(right: parentWidth*.01),                  child: Container(
                    height: parentHeight * .055,
                    width: parentWidth*.5,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _outstandingLimitFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: StringEn.OUTSTANDING_LIMIT,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: outstandingLimitController,
                      onEditingComplete: () {
                        _outstandingLimitFocus.unfocus();
                          FocusScope.of(context).requestFocus(_adharoFocus);
                      },
                      style: text_field_textStyle,
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: parentWidth*.01),
                  child: Container(
                    height: parentHeight * .055,
                    width: parentWidth*.3,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
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
            Container(
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
            Container(
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
                  hintText: StringEn.PAN_NO,
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
            Container(
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
                maxLength: 15,

                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.characters,
                focusNode: _gstNoFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText:   StringEn.GST_NO,
                  hintStyle: hint_textfield_Style,
                ),
                controller:gstNoController,
                onEditingComplete: () {
                  _gstNoFocus.unfocus();
                },
                style: text_field_textStyle,
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
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.HSN_NO,
              style: page_heading_textStyle,
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: parentHeight * .055,
                    // width: parentWidth * .85,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _hsnNoFocus,
                      keyboardType:
                      TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText:  StringEn.HSN_NO,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: hsnNoController,
                      onEditingComplete: () {
                        _hsnNoFocus.unfocus();
                        FocusScope.of(context).requestFocus(_taxRateFocus);
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



  /* Widget for CGST text from field layout */
  Widget getCGSTLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.CGST,
              style: page_heading_textStyle,
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: parentHeight * .055,
                    // width: parentWidth * .85,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _CGSTFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText:      StringEn.CGST,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: CGSTController,
                      onEditingComplete: () {
                        _CGSTFocus.unfocus();
                        FocusScope.of(context).requestFocus(_SGSTFocus);
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

/* Widget for cess text from field layout */
  Widget getCessLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.CESS,
              style: page_heading_textStyle,
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: parentHeight * .055,
                    // width: parentWidth * .85,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _cessFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: StringEn.CESS,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: cessController,
                      onEditingComplete: () {
                        _cessFocus.unfocus();
                        FocusScope.of(context).requestFocus(_addCessFocus);
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
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.TAX_RATE,
              style: page_heading_textStyle,
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: parentHeight * .055,
                    // width: parentWidth * .85,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _taxRateFocus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: StringEn.TAX_RATE,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: taxRateController,
                      onEditingComplete: () {
                        _taxRateFocus.unfocus();
                        FocusScope.of(context).requestFocus(_CGSTFocus);
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



  /* Widget for SGST text from field layout */
  Widget getSGSTLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.SGST,
              style: page_heading_textStyle,
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: parentHeight * .055,
                    // width: parentWidth * .85,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _SGSTFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: StringEn.SGST,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: SGSTController,
                      onEditingComplete: () {
                        _SGSTFocus.unfocus();
                        FocusScope.of(context).requestFocus(_cessFocus);
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



  /* Widget for add cess text from field layout */
  Widget getAddCessLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Container(
        width: parentWidth * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringEn.ADD_CESS,
              style: page_heading_textStyle,
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .005),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: parentHeight * .055,
                    // width: parentWidth * .85,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _addCessFocus,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,

                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: StringEn.ADD_CESS,
                        hintStyle: hint_textfield_Style,
                      ),
                      controller: addCessController,
                      onEditingComplete: () {
                        _addCessFocus.unfocus();
                        //FocusScope.of(context).requestFocus(_contactFocus);
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




  /* Widget for distric/city text from field layout */
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
                    // width: parentWidth * .85,
                    alignment: Alignment.center,
                    decoration: box_decoration,
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
                        hintText: "Enter a district",
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
                  decoration: box_decoration,
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
                    // width: parentWidth * .85,
                    alignment: Alignment.center,
                    decoration: box_decoration,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _pinCodeFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: CommonColor.BLACK_COLOR,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: parentWidth * .04, right: parentWidth * .02),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        hintText: "Enter a pin code",
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
                decoration: box_decoration,
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
      ),
    );
  }


  /* Widget for ext name text from field layout */
  Widget getExtNameLayout(double parentHeight, double parentWidth) {
    return Padding(
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
                  decoration: box_decoration,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.words,
                    focusNode: _extNameFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Enter a ext name",
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
                  hintText: StringEn.BANK_NAME,
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z]'))
                ],
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.characters,
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
                  hintText: StringEn.BANT_BRACH,
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
                  hintText: StringEn.IFSC_CODE,
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
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText:  StringEn.ACCOUNT_NO,
                  hintStyle: hint_textfield_Style,
                ),
                controller: accountNoController,
                onEditingComplete: () {
                  _accountNoFocus.unfocus();
                  FocusScope.of(context).requestFocus(_extNameFocus);
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
  userImage(File image, String comeFrom) {
    // TODO: implement userImage
    if (mounted) {
      setState(() {
        picImage = image;
      });
    }
    print("neweww  $image");
  }

  @override
  selectState(String id, String name) {
    // TODO: implement selectState
    setState(() {
      stateName=name;
    });
  }

  @override
  selectCountry(String id, String name) {
    // TODO: implement selectCountry
    setState(() {
      countryName=name;
    });
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
