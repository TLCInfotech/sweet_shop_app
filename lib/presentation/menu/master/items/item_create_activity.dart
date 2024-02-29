import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_dialog_for_profile.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/domain/item/post_item_request_model.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_category_layout.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_image_from_gallary_or_camera.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_unit_layout.dart';
import 'package:sweet_shop_app/presentation/dialog/category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/measuring_unit_dialog.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../common_widget/signleLine_TexformField.dart';

class ItemCreateActivity extends StatefulWidget {
  final editItem;
  const ItemCreateActivity({super.key,this.editItem});

  // final ItemCreateActivityInterface mListener;

  @override
  State<ItemCreateActivity> createState() => _ItemCreateActivityState();
}

class _ItemCreateActivityState extends State<ItemCreateActivity> {
  final _itemNameFocus = FocusNode();
  final itemNameController = TextEditingController();

  final _branchNameFocus = FocusNode();
  final branchNameController = TextEditingController();

  final _addressFocus = FocusNode();
  final addressController = TextEditingController();

  final _panNoFocus = FocusNode();
  final panNoController = TextEditingController();
  final _gstNoFocus = FocusNode();
  final gstNoController = TextEditingController();
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  File? adharFile ;
  File? panFile ;
  File? gstFile ;


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
  int categoryId=0;
  String categoryName="";
  String unitTwoId="";
  String unitTwoName="";
  String unitThreeId="";
  String unitThreeName="";
  String measuringUnit="";

  dynamic picImageBytes;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  bool isLoaderShow=false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
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
                    title:  Text(
                      ApplicationLocalizations.of(context)!.translate("create_item")!,
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
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
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
          ApplicationLocalizations.of(context)!.translate("create_item")!,
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
                  ApplicationLocalizations.of(context)!.translate("post")!,
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
    return GetSingleImage(
        height: parentHeight * .25,
        width: parentHeight * .25,
        picImage: picImage,
        callbackFile: (file)async{
          List<int> bytes = (await file?.readAsBytes()) as List<int>;
          setState(()  {
            picImage=file;
            picImageBytes=bytes;
          });
        }
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
                  getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("basic_information")!),
                  Container(

                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [
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
                  )


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
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("working_days")!;
        }
        return null;
      },
      controller: itemNameController,
      focuscontroller: _itemNameFocus,
      focusnext: _branchNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callbackOnchage: (value) {
        setState(() {
          itemNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }


  /* Widget For Category Layout */
  Widget getAddCategoryLayout(double parentHeight, double parentWidth){
    return GetCategoryLayout(
        title: ApplicationLocalizations.of(context)!.translate("category")!,
        callback: (value,id){
          setState(() {
            categoryName=value!;
            categoryId=id!;
          });
    },
        selectedProductCategory: categoryName
    );

  }



  /* Widget For measuring unit Layout */
  Widget getMeasuringUnitLayout(double parentHeight, double parentWidth){
    return GetUnitLayout(
      parentWidth: (SizeConfig.screenWidth),
        title:ApplicationLocalizations.of(context)!.translate("measuring_unit")!,
        callback: (value){
          setState(() {
            measuringUnit=value!;
          });
        },
        measuringUnit: measuringUnit
    );

  }

  /* Widget For measuring unit Layout */
  Widget getUnitTwoLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * .015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GetUnitLayout(
          parentWidth:parentWidth * .25,
        title: ApplicationLocalizations.of(context)!.translate("unit_two")!,
        callback: (value){
          setState(() {
            unitTwoName=value!;
          });
        },
        measuringUnit: unitTwoName
       ),
          Container(
            margin: EdgeInsets.only(top: 40),
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
                hintText: ApplicationLocalizations.of(context)!.translate("enter")!,
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

          Container(
            margin: EdgeInsets.only(top: 40),
            child: const Text(
              "=",
              style:
              text_field_textStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              // textScaleFactor: 1.02,
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 40),

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
                hintText: ApplicationLocalizations.of(context)!.translate("enter")!,
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
    );
  }
  /* Widget For measuring unit Layout */
  Widget getUnitThreeLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(
          top: parentHeight * .015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GetUnitLayout(
              parentWidth:parentWidth * .25,
              title: ApplicationLocalizations.of(context)!.translate("unit_three")!,
              callback: (value){
                setState(() {
                  unitThreeName=value!;
                });
              },
              measuringUnit: unitThreeName
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
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
                hintText: ApplicationLocalizations.of(context)!.translate("enter")!,
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

           Container(
             margin: EdgeInsets.only(top: 40),
             child: Text(
              "=",
              style:
              text_field_textStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              // textScaleFactor: 1.02,
                       ),
           ),

          Container(
            margin: EdgeInsets.only(top: 40),

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
                hintText: ApplicationLocalizations.of(context)!.translate("enter")!,
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
    );
  }

  /* Widget for max text from field layout */
  Widget getMaxStockLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("max_stock")!;
        }
        return null;
      },
      controller: maxController,
      focuscontroller: _maxFocus,
      focusnext: _branchNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("max_stock")!,
      callbackOnchage: (value) {
        setState(() {
          maxController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }


  /* Widget for max text from field layout */
  Widget getMinStockLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("min_stock")!;
        }
        return null;
      },
      controller: minController,
      focuscontroller: _minFocus,
      focusnext: _branchNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("min_stock")!,
      callbackOnchage: (value) {
        setState(() {
          minController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }


  /* Widget for max text from field layout */
  Widget getExtNameLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("ext_name")!;
        }
        return null;
      },
      controller: extNameController,
      focuscontroller: _extNameFocus,
      focusnext: _branchNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("ext_name")!,
      callbackOnchage: (value) {
        setState(() {
          extNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }

  /* Widget for max text from field layout */
  Widget getPackSizeLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("pack_size")!;
        }
        return null;
      },
      controller: packSizeController,
      focuscontroller: _packSizeFocus,
      focusnext: _branchNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("pack_size")!,
      callbackOnchage: (value) {
        setState(() {
          packSizeController.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
    );

  }

  /* Widget for max text from field layout */
  Widget getHSNNOLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("hsn_no")!;
        }
        return null;
      },
      controller: hsnNoController,
      focuscontroller: _hsnNoFocus,
      focusnext: _branchNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("hsn_no")!,
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


  /* Widget for Description Layout */
  Widget getAddDescriptionLayout(double parentHeight, double parentWidth){
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("item_description")!;
        }
        return null;
      },
      controller: descController,
      focuscontroller: _descFocus,
      focusnext: _branchNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("item_description")!,
      callbackOnchage: (value) {
        setState(() {
          descController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 4,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }

  /* Widget for max text from field layout */
  Widget getDefaultStoreLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("default_store")!;
        }
        return null;
      },
      controller: defaultStoreController,
      focuscontroller: _defaultStoreFocus,
      focusnext: _branchNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("default_store")!,
      callbackOnchage: (value) {
        setState(() {
          defaultStoreController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }

  /* Widget for branch name text from field layout */
  Widget getBranchNameLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ApplicationLocalizations.of(context)!.translate("name")!,
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
                  hintText: ApplicationLocalizations.of(context)!.translate("bank_branch")!,
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
            onTap: () async{
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
                Uint8List? bytes = await picImage?.readAsBytes();
                // ByteData? byte = await picImage?.readAsBytes()
                // // change here
                //     .then((Uint8List data) => ByteData.view(data.buffer));
                // print(byte);
                JsonEncoder encoder = new JsonEncoder.withIndent('  ');
                String prettyprint = encoder.convert((bytes));
                debugPrint(prettyprint);

                setState(() {

                  picImageBytes=bytes;
                  print("piccccccc. $picImage    ");
                });
                await callPostItem();
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

  callPostItem() async {

    String creatorName = await AppPreferences.getUId();
    //var model={};
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostItemRequestModel model = PostItemRequestModel(
          Name: itemNameController.text.trim(),
          CategoryID: categoryId.toString(),
          Creator: creatorName,
          CreatorMachine: deviceId,
          Unit2: "",
          Unit2Base: "",
          Unit3: "",
          Unit2Factor: "",
          Unit3Base: "",
          Unit3Factor: "",
          PackSize: "",
          Rate: "",
          MinStock: "",
          MaxStock: "",
          HSNNo: "",
          ExtName: "",
          DefaultStore: "",
          DetailDesc: "",
          Photo: picImageBytes.toString(),
          Unit: ""
        );
      String apiUrl = ApiConstants().baseUrl + ApiConstants().item;
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=false;
            });
            Navigator.pop(context);

          }, onFailure: (error) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.errorDialog(context, error.toString());
          },
          onException: (e) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.errorDialog(context, e.toString());

          },sessionExpire: (e) {
            setState(() {
              isLoaderShow=false;
            });
            CommonWidget.gotoLoginScreen(context);
            // widget.mListener.loaderShow(false);
          });

    });
  }



}
