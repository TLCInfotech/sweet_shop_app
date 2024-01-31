import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:sweet_shop_app/presentation/dialog/category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/country_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/measuring_unit_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/state_dialog.dart';

class ItemCreateActivity extends StatefulWidget {
  const ItemCreateActivity({super.key});

  // final ItemCreateActivityInterface mListener;

  @override
  State<ItemCreateActivity> createState() => _ItemCreateActivityState();
}

class _ItemCreateActivityState extends State<ItemCreateActivity>
    with
        SingleTickerProviderStateMixin,
        ImagePickerDialogPostInterface,
        ImagePickerListener,CategoryDialogInterface,MeasuringUnitDialogInterface,
        ImagePickerDialogInterface {
  final _itemNameFocus = FocusNode();
  final itemNameController = TextEditingController();

  final _branchNameFocus = FocusNode();
  final branchNameController = TextEditingController();

  final _addressFocus = FocusNode();
  final addressController = TextEditingController();

  final _districtCity = FocusNode();
  final districtController = TextEditingController();

  final _contactFocus = FocusNode();
  final contactController = TextEditingController();
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

  final minController = TextEditingController();
  final _minFocus = FocusNode();
  final maxController = TextEditingController();
  final _maxFocus = FocusNode();
  final _extNameFocus = FocusNode();
  final extNameController = TextEditingController();
  final _defaultStoreFocus = FocusNode();
  final defaultStoreController = TextEditingController();
  final _packSizeFocus = FocusNode();
  final packSizeController = TextEditingController();
  final _hsnNoFocus = FocusNode();
  final hsnNoController = TextEditingController();
  final descController = TextEditingController();
  final _descFocus = FocusNode();
  bool isCategoryValidShow = false;
  bool isCategoryMsgValidShow = false;
  bool isDescriptionValid = false;
  bool isDescriptionMsgValid = false;
  final postLength = 550;
  String categoryId="";
  String categoryName="";
  String unitTwoId="";
  String unitTwoName="";
  String unitThreeId="";
  String unitThreeName="";
  String measuringUnit="";
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
                  "Create Item",
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

  double opacityLevel = 1.0;
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
                  getNameLayout(parentHeight, parentWidth),
                  getAddCategoryLayout(parentHeight, parentWidth),
                  getMeasuringUnitLayout(parentHeight, parentWidth),
                  getUnitTwoLayout(parentHeight, parentWidth),
                  getUnitThreeLayout(parentHeight, parentWidth),
                  getPackSizeLayout(parentHeight, parentWidth),
                  getHSNNOLayout(parentHeight, parentWidth),
                  getDefaultStoreLayout(parentHeight, parentWidth),
                  getMinStockLayout(parentHeight, parentWidth),
                  getMaxStockLayout(parentHeight, parentWidth),
                  getExtNameLayout(parentHeight, parentWidth),
                  getAddDescriptionLayout(parentHeight, parentWidth),

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
                    focusNode: _itemNameFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Enter a item name",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: itemNameController,
                    onEditingComplete: () {
                      _itemNameFocus.unfocus();
                      FocusScope.of(context).requestFocus(_branchNameFocus);
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


  /* Widget For Category Layout */
  Widget getAddCategoryLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * .015,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Category",
            style: page_heading_textStyle,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if(mounted){
                setState(() {
                  isCategoryMsgValidShow=false;
                  isCategoryValidShow=false;
                });
              }
              if (context != null) {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
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
            onDoubleTap: () {},
            child: Padding(
              padding: EdgeInsets.only(
                top: parentHeight * .01,
              ),
              child: Stack(
                  alignment: Alignment.centerRight,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: parentHeight * .058,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                              categoryName==""?"Select category":categoryName,
                              style:categoryName == ""? hint_textfield_Style:
                              text_field_textStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              // textScaleFactor: 1.02,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: parentHeight * .03,
                              color: /*pollName == ""
                                  ? CommonColor.HINT_TEXT
                                  :*/ CommonColor.BLACK_COLOR,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isCategoryValidShow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: parentHeight * .0,
                            right: parentWidth * .0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  isCategoryMsgValidShow = !isCategoryMsgValidShow;
                                });
                              }
                            },
                            onDoubleTap: () {},
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                      parentHeight * .045,
                      parentWidth * .01,
                      SizeConfig.blockSizeHorizontal * 2.5,
                      isCategoryMsgValidShow,
                      StringEn.ADD_CATEGORY,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }



  /* Widget For measuring unit Layout */
  Widget getMeasuringUnitLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
           StringEn.MEASURING_UNIT ,
            style: page_heading_textStyle,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if(mounted){
                setState(() {
                  isCategoryMsgValidShow=false;
                  isCategoryValidShow=false;
                });
              }
              if (context != null) {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform:
                        Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: MeasuringUnitDialog(
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
            onDoubleTap: () {},
            child: Padding(
              padding: EdgeInsets.only(
                top: parentHeight * .01,
              ),
              child: Stack(
                  alignment: Alignment.centerRight,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: parentHeight * .058,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                              measuringUnit==""?"Select measuring unit":measuringUnit,
                              style:measuringUnit == ""? hint_textfield_Style:
                              text_field_textStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              // textScaleFactor: 1.02,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: parentHeight * .03,
                              color: /*pollName == ""
                                  ? CommonColor.HINT_TEXT
                                  :*/ CommonColor.BLACK_COLOR,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isCategoryValidShow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: parentHeight * .0,
                            right: parentWidth * .0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  isCategoryMsgValidShow = !isCategoryMsgValidShow;
                                });
                              }
                            },
                            onDoubleTap: () {},
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                      parentHeight * .045,
                      parentWidth * .01,
                      SizeConfig.blockSizeHorizontal * 2.5,
                      isCategoryMsgValidShow,
                      StringEn.ADD_CATEGORY,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget For measuring unit Layout */
  Widget getUnitTwoLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
           StringEn.UNIT_TWO ,
            style: page_heading_textStyle,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if(mounted){
                setState(() {
                  isCategoryMsgValidShow=false;
                  isCategoryValidShow=false;
                });
              }
              if (context != null) {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform:
                        Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: MeasuringUnitDialog(
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
            onDoubleTap: () {},
            child: Padding(
              padding: EdgeInsets.only(
                top: parentHeight * .01,
              ),
              child: Stack(
                  alignment: Alignment.centerRight,
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: parentHeight * .058,
                          width: parentWidth * .32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                  measuringUnit==""?"Select":measuringUnit,
                                  style:measuringUnit == ""? hint_textfield_Style:
                                  text_field_textStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  // textScaleFactor: 1.02,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: parentHeight * .03,
                                  color: /*pollName == ""
                                      ? CommonColor.HINT_TEXT
                                      :*/ CommonColor.BLACK_COLOR,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: parentHeight * .055,
                          width: parentWidth * .25,
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
                           // focusNode: _itemNameFocus,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: CommonColor.BLACK_COLOR,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: parentWidth * .04, right: parentWidth * .02),
                              border: InputBorder.none,
                              counterText: '',
                              isDense: true,
                              hintText: "Enter a item name",
                              hintStyle: hint_textfield_Style,
                            ),
                           // controller: itemNameController,
                            onEditingComplete: () {
                            //  _itemNameFocus.unfocus();
                              FocusScope.of(context).requestFocus(_branchNameFocus);
                            },
                            style: text_field_textStyle,
                          ),
                        ),
                        const Text(
                          "=",
                          style:
                          text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // textScaleFactor: 1.02,
                        ),
                        Container(
                          height: parentHeight * .055,
                          alignment: Alignment.center,
                          width: parentWidth * .25,
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
                           // focusNode: _itemNameFocus,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: CommonColor.BLACK_COLOR,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: parentWidth * .04, right: parentWidth * .02),
                              border: InputBorder.none,
                              counterText: '',
                              isDense: true,
                              hintText: "Enter a item name",
                              hintStyle: hint_textfield_Style,
                            ),
                            //controller: itemNameController,
                            onEditingComplete: () {
                              _itemNameFocus.unfocus();
                              FocusScope.of(context).requestFocus(_branchNameFocus);
                            },
                            style: text_field_textStyle,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isCategoryValidShow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: parentHeight * .0,
                            right: parentWidth * .0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  isCategoryMsgValidShow = !isCategoryMsgValidShow;
                                });
                              }
                            },
                            onDoubleTap: () {},
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                      parentHeight * .045,
                      parentWidth * .01,
                      SizeConfig.blockSizeHorizontal * 2.5,
                      isCategoryMsgValidShow,
                      StringEn.ADD_CATEGORY,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
  /* Widget For measuring unit Layout */
  Widget getUnitThreeLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
           StringEn.UNIT_THREE ,
            style: page_heading_textStyle,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if(mounted){
                setState(() {
                  isCategoryMsgValidShow=false;
                  isCategoryValidShow=false;
                });
              }
              if (context != null) {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform:
                        Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: MeasuringUnitDialog(
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
            onDoubleTap: () {},
            child: Padding(
              padding: EdgeInsets.only(
                top: parentHeight * .01,
              ),
              child: Stack(
                  alignment: Alignment.centerRight,
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: parentHeight * .058,
                          width: parentWidth * .32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                  unitThreeId==""?"Select":unitThreeId,
                                  style:unitThreeId == ""? hint_textfield_Style:
                                  text_field_textStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  // textScaleFactor: 1.02,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: parentHeight * .03,
                                  color: /*pollName == ""
                                      ? CommonColor.HINT_TEXT
                                      :*/ CommonColor.BLACK_COLOR,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: parentHeight * .055,
                          width: parentWidth * .25,
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
                           // focusNode: _itemNameFocus,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: CommonColor.BLACK_COLOR,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: parentWidth * .04, right: parentWidth * .02),
                              border: InputBorder.none,
                              counterText: '',
                              isDense: true,
                              hintText: "Enter a item name",
                              hintStyle: hint_textfield_Style,
                            ),
                            //controller: itemNameController,
                            onEditingComplete: () {
                           //   _itemNameFocus.unfocus();
                              FocusScope.of(context).requestFocus(_branchNameFocus);
                            },
                            style: text_field_textStyle,
                          ),
                        ),
                        const Text(
                         "=",
                          style:
                          text_field_textStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // textScaleFactor: 1.02,
                        ),
                        Container(
                          height: parentHeight * .055,
                          alignment: Alignment.center,
                          width: parentWidth * .25,
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
                            //focusNode: _itemNameFocus,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: CommonColor.BLACK_COLOR,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: parentWidth * .04, right: parentWidth * .02),
                              border: InputBorder.none,
                              counterText: '',
                              isDense: true,
                              hintText: "Enter a item name",
                              hintStyle: hint_textfield_Style,
                            ),
                           // controller: itemNameController,
                            onEditingComplete: () {
                             // _itemNameFocus.unfocus();
                              FocusScope.of(context).requestFocus(_branchNameFocus);
                            },
                            style: text_field_textStyle,
                          ),
                        ),

                      ],
                    ),
                    Visibility(
                      visible: isCategoryValidShow,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: parentHeight * .0,
                            right: parentWidth * .0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  isCategoryMsgValidShow = !isCategoryMsgValidShow;
                                });
                              }
                            },
                            onDoubleTap: () {},
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                      parentHeight * .045,
                      parentWidth * .01,
                      SizeConfig.blockSizeHorizontal * 2.5,
                      isCategoryMsgValidShow,
                      StringEn.ADD_CATEGORY,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for max text from field layout */
  Widget getMaxStockLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.MAX_STOCK,
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
                    focusNode: _maxFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Enter a max stock",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: maxController,
                    onEditingComplete: () {
                      _maxFocus.unfocus();
                      FocusScope.of(context).requestFocus(_branchNameFocus);
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


  /* Widget for max text from field layout */
  Widget getMinStockLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.MIN_STOCK,
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
                    focusNode: _minFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Enter a min stock",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: minController,
                    onEditingComplete: () {
                      _minFocus.unfocus();
                      FocusScope.of(context).requestFocus(_branchNameFocus);
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


  /* Widget for max text from field layout */
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
                      hintText: "Enter a ext name",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: extNameController,
                    onEditingComplete: () {
                      _extNameFocus.unfocus();
                      FocusScope.of(context).requestFocus(_branchNameFocus);
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

  /* Widget for max text from field layout */
  Widget getPackSizeLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.PACK_SIZE,
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
                    focusNode: _packSizeFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Enter a pack size name",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: packSizeController,
                    onEditingComplete: () {
                      _packSizeFocus.unfocus();
                      FocusScope.of(context).requestFocus(_branchNameFocus);
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

  /* Widget for max text from field layout */
  Widget getHSNNOLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.HSN_NO,
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
                    focusNode: _hsnNoFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Enter a hsn no.",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: hsnNoController,
                    onEditingComplete: () {
                      _hsnNoFocus.unfocus();
                      FocusScope.of(context).requestFocus(_branchNameFocus);
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


  /* Widget for Description Layout */
  Widget getAddDescriptionLayout(double parentHeight, double parentWidth){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_descFocus);
      },
      onDoubleTap: () {},
      child:  Padding(
        padding: EdgeInsets.only(top: parentHeight * .015,left: parentWidth*.03,right: parentWidth*.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Row(
              children: [
                Text(
                  StringEn.ITEM_DESCRIPTION,
                  style: page_heading_textStyle,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: parentHeight * .01),
              child: Container(
                alignment: Alignment.topLeft,
                height: parentHeight * .2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: parentWidth * .025),
                      child: TextFormField(
                        focusNode: _descFocus,
                        // autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        maxLength: postLength,
                        onEditingComplete: () {
                          _descFocus.unfocus();
                        },
                        controller: descController,
                        scrollPadding: EdgeInsets.only(bottom: parentHeight*.2),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: parentHeight*.01,bottom: parentHeight*.01),
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Enter a description..",
                          hintStyle:hint_textfield_Style,
                        ),
                        style: text_field_textStyle,
                      ),
                    ),
                    Visibility(
                      visible: isDescriptionValid,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: parentHeight * .015, right: parentWidth * .01),
                        child: Container(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    isDescriptionMsgValid = !isDescriptionMsgValid;
                                  });
                                }
                              },
                              child: const Icon(Icons.error, color: Colors.red)),
                        ),
                      ),
                    ),
                    CommonWidget.getShowError(
                        parentHeight * .047,
                        parentWidth * .01,
                        SizeConfig.blockSizeHorizontal * 2.5,
                        isDescriptionMsgValid,
                        descController.text.trim().length  <= 3
                            ? StringEn.ENTER_VALID_DESCRIPTION
                            : StringEn.ENTER_DESCRIPTION),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: parentHeight * .01,
                  right: parentWidth * .02),
              child: Text(
                "${descController.text.length}/$postLength",
                style: item_regular_textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget for max text from field layout */
  Widget getDefaultStoreLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringEn.DEFAULT_STORE,
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
                    focusNode: _defaultStoreFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Enter a default store",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: defaultStoreController,
                    onEditingComplete: () {
                      _defaultStoreFocus.unfocus();
                      FocusScope.of(context).requestFocus(_branchNameFocus);
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

  /* Widget for branch name text from field layout */
  Widget getBranchNameLayout(double parentHeight, double parentWidth) {
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
                focusNode: _branchNameFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: CommonColor.BLACK_COLOR,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: parentWidth * .04, right: parentWidth * .02),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  hintText: "Enter a name",
                  hintStyle: hint_textfield_Style,
                ),
                controller: branchNameController,
                onEditingComplete: () {
                  _branchNameFocus.unfocus();
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
  /* Widget for branch name text from field layout */
  Widget getPanLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringEn.PAN_NO,
                        style: page_heading_textStyle,
                      ),
                    ],
                  ),
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
                        textAlignVertical: TextAlignVertical.center,
                        textCapitalization: TextCapitalization.words,
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
                          hintText: "Enter a pan no.",
                          hintStyle: hint_textfield_Style,
                        ),
                        controller: panNoController,
                        onEditingComplete: () {
                          _panNoFocus.unfocus();
                          FocusScope.of(context).requestFocus(_addressFocus);
                        },
                        style: text_field_textStyle,
                      ),
                    ),
                  ),
                ],
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
      ),
    );
  }
  /* Widget for branch name text from field layout */
  Widget getAdharLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringEn.FRANCHISEE_AADHAR_NO,
                        style: page_heading_textStyle,
                      ),
                    ],
                  ),
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
                          hintText: "Enter a adhar no.",
                          hintStyle: hint_textfield_Style,
                        ),
                        controller: adharNoController,
                        onEditingComplete: () {
                          _adharoFocus.unfocus();
                          FocusScope.of(context).requestFocus(_addressFocus);
                        },
                        style: text_field_textStyle,
                      ),
                    ),
                  ),
                ],
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
      ),
    );
  }
  /* Widget for branch name text from field layout */
  Widget getGstLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringEn.GST_NO,
                        style: page_heading_textStyle,
                      ),
                    ],
                  ),
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
                        textAlignVertical: TextAlignVertical.center,
                        textCapitalization: TextCapitalization.words,
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
                          hintText: "Enter a gst no",
                          hintStyle: hint_textfield_Style,
                        ),
                        controller:gstNoController,
                        onEditingComplete: () {
                          _gstNoFocus.unfocus();
                          FocusScope.of(context).requestFocus(_addressFocus);
                        },
                        style: text_field_textStyle,
                      ),
                    ),
                  ),
                ],
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
  selectCategory(String id, String name) {
    // TODO: implement selectCategory
    if(mounted){
      setState(() {
        categoryId=id;
        categoryName=name;
        print("jnkgjngtjngjt  $id $name");
      });
    }
  }

  @override
  selectCountry(String id, String name) {
    // TODO: implement selectCountry
    setState(() {
      countryName=name;
    });
  }

  @override
  selectMeasuringUnit(String id, String name) {
    // TODO: implement selectMeasuringUnit
    setState(() {
      measuringUnit=name;
    });
  }
}

// abstract class ItemCreateActivityInterface {
// }
