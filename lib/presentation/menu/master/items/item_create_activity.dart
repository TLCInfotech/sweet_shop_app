import 'dart:convert';
import 'dart:io';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
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
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/item/put_item_request_model.dart';
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

  final _unitTwofactor = FocusNode();
  final unitTwofactorController = TextEditingController();
  final _unitTwoBase = FocusNode();
  final unitTwoBaseController = TextEditingController();


  final _unitThreefactor = FocusNode();
  final unitThreefactorController = TextEditingController();
  final _unitThreeBase = FocusNode();
  final unitThreeBaseController = TextEditingController();

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
    setData();
  }

  setData()async{
    if(widget.editItem!=null){
      File ?f=null;
      if(widget.editItem['Photo']!=null&&widget.editItem['Photo']['data']!=null && widget.editItem['Photo']['data'].length>10) {
        f = await CommonWidget.convertBytesToFile(widget.editItem['Photo']['data']);
      }

      setState(()  {
        picImage=f;
        itemNameController.text=widget.editItem['Name'];
        categoryName=widget.editItem['Category_Name']!=null?widget.editItem['Category_Name']:categoryName;
         unitTwoId=widget.editItem['Unit2']!=null?widget.editItem['Unit2']:unitTwoId;
          unitTwofactorController.text=widget.editItem['Unit2_Factor']!=null?(widget.editItem['Unit2_Factor']).toString():unitTwofactorController.text;
           unitTwoBaseController.text=widget.editItem['Unit2_Base']!=null?(widget.editItem['Unit2_Base']).toString():unitTwoBaseController.text;
          unitThreeId=widget.editItem['Unit3']!=null?widget.editItem['Unit3']:unitThreeId;
         unitThreeBaseController.text=widget.editItem['Unit3_Base']!=null?(widget.editItem['Unit3_Base']).toString():unitThreeBaseController.text;
         unitThreefactorController.text=widget.editItem['Unit3_Factor']!=null?(widget.editItem['Unit3_Factor']).toString():unitTwofactorController.text;
         packSizeController.text=widget.editItem['Pack_Size']!=null?(widget.editItem['Pack_Size']).toString():packSizeController.text;
        rateController.text=widget.editItem['Rate']!=null?(widget.editItem['Rate']).toString():rateController.text;
         minController.text=widget.editItem['Min_Stock']!=null?(widget.editItem['Min_Stock']).toString():minController.text;
        maxController.text=widget.editItem['Max_Stock']!=null?(widget.editItem['Max_Stock']).toString():maxController.text;
        hsnNoController.text=widget.editItem['HSN_No']!=null?widget.editItem['HSN_No']:hsnNoController.text;
        extNameController.text=widget.editItem['Ext_Name']!=null?widget.editItem['Ext_Name']:extNameController.text;
        defaultStoreController.text=widget.editItem['Default_Store']!=null?widget.editItem['Default_Store']:defaultStoreController.text;
         descController.text=widget.editItem['Detail_Desc']!=null?widget.editItem['Detail_Desc']:descController.text;
         measuringUnit=widget.editItem['Unit']!=null?widget.editItem['Unit']:"";
      });
    }
  }

  File? adharFile ;
  File? panFile ;
  File? gstFile ;

  final rateController = TextEditingController();
  final _rateFocus = FocusNode();
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

  List<int> picImageBytes=[];

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
                    title: widget.editItem!=null?Text(
    ApplicationLocalizations.of(context)!.translate("update")!+" "+ApplicationLocalizations.of(context)!.translate("item")!,
    style: appbar_text_style,
    ): Text(
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
                      getRateLayout(parentHeight, parentWidth),
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
              focusNode: _unitTwofactor,
              keyboardType: TextInputType.number,
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
              controller: unitTwofactorController,
              onEditingComplete: () {
                 _unitTwofactor.unfocus();
                FocusScope.of(context).requestFocus(_unitTwoBase);
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
              focusNode: _unitTwoBase,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              cursorColor: CommonColor.BLACK_COLOR,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: parentWidth * .04, right: parentWidth * .02),
                border: InputBorder.none,
                suffix: measuringUnit==""?Text(""):Text(measuringUnit,style: item_regular_textStyle,),
                counterText: '',
                isDense: true,
                hintText: ApplicationLocalizations.of(context)!.translate("enter")!,
                hintStyle: hint_textfield_Style,
              ),
              controller: unitTwoBaseController,
              onEditingComplete: () {
                _unitTwoBase.unfocus();
                FocusScope.of(context).requestFocus(_unitThreefactor);
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
              focusNode: _unitThreefactor,
              keyboardType: TextInputType.number,
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
              controller: unitThreefactorController,
              onEditingComplete: () {
                 _unitThreefactor.unfocus();
                FocusScope.of(context).requestFocus(_unitThreeBase);
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
              focusNode: _unitThreeBase,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              cursorColor: CommonColor.BLACK_COLOR,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: parentWidth * .04, right: parentWidth * .02),
                border: InputBorder.none,
                counterText: '',
                suffix: measuringUnit==""?Text(""):Text(measuringUnit,style: item_regular_textStyle,),
                isDense: true,
                hintText: ApplicationLocalizations.of(context)!.translate("enter")!,
                hintStyle: hint_textfield_Style,
              ),
              //controller: itemNameController,
              onEditingComplete: () {
                _unitThreeBase.unfocus();
                FocusScope.of(context).requestFocus(_packSizeFocus);
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
      focusnext: _extNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("max_stock")!,
      callbackOnchage: (value) {
        setState(() {
          maxController.text = value;
        });
      },
      textInput: TextInputType.number,
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
      focusnext: _maxFocus,
      title: ApplicationLocalizations.of(context)!.translate("min_stock")!,
      callbackOnchage: (value) {
        setState(() {
          minController.text = value;
        });
      },
      textInput: TextInputType.number,
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
      focusnext: _descFocus,
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
      focusnext: _hsnNoFocus,
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


  /* Widget for rate text from field layout */
  Widget getRateLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("pack_size")!;
        }
        return null;
      },
      controller: rateController,
      focuscontroller: _rateFocus,
      focusnext: _hsnNoFocus,
      title: ApplicationLocalizations.of(context)!.translate("rate")!,
      callbackOnchage: (value) {
        setState(() {
          rateController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 \.]')),
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
      capital:true,
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
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
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
      focusnext: _minFocus,
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

                if(picImage!=null) {
                  Uint8List? bytes = await picImage?.readAsBytes();

                  setState(() {
                    picImageBytes = (bytes)!.whereType<int>().toList();
                  });
                  print("IMGE1 : ${picImageBytes.length}");
                }
                if(widget.editItem!=null){
                  await callUpdateItem();
                }
                else {
                  await callPostItem();
                }
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
                    child: widget.editItem!=null? Text(
                      ApplicationLocalizations.of(context)!.translate("update")!,
                      style: page_heading_textStyle,
                    ): Text(
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
          Unit2: unitTwoId,
          Unit2Base: unitTwoBaseController.text.trim(),
          Unit3:unitThreeId,
          Unit2Factor:unitTwofactorController.text.trim(),
          Unit3Base:unitThreeBaseController.text.trim(),
          Unit3Factor: unitThreefactorController.text.trim(),
          PackSize: packSizeController.text.trim(),
          Rate: rateController.text.trim(),
          MinStock: minController.text.trim(),
          MaxStock:maxController.text.trim(),
          HSNNo:hsnNoController.text.trim(),
          ExtName: extNameController.text.trim(),
          DefaultStore:defaultStoreController.text.trim(),
          DetailDesc: descController.text.trim(),
          Photo: picImageBytes,
          Unit: measuringUnit
        );


      print("IMGE2 : ${(model.Photo)?.length}");

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

  callUpdateItem() async {

    String creatorName = await AppPreferences.getUId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        PutItemRequestModel model = PutItemRequestModel(
            Modifier: creatorName,
            Modifier_Machine: deviceId,
            Name: itemNameController.text.trim(),
            CategoryID: categoryId.toString(),
            Unit2: unitTwoId,
            Unit2Base: unitTwoBaseController.text.trim(),
            Unit3:unitThreeId,
            Unit2Factor:unitTwofactorController.text.trim(),
            Unit3Base:unitThreeBaseController.text.trim(),
            Unit3Factor: unitThreefactorController.text.trim(),
            PackSize: packSizeController.text.trim(),
            Rate: rateController.text.trim(),
            MinStock: minController.text.trim(),
            MaxStock:maxController.text.trim(),
            HSNNo:hsnNoController.text.trim(),
            ExtName: extNameController.text.trim(),
            DefaultStore:defaultStoreController.text.trim(),
            DetailDesc: descController.text.trim(),
            Photo: picImageBytes,
            Unit: measuringUnit
        );

        String apiUrl = ApiConstants().baseUrl + ApiConstants().item+"/"+widget.editItem['ID'].toString();

        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), "",
            onSuccess:(value)async{
              print("  Put Call :   $value ");
              var snackBar = SnackBar(content: Text('Item  Updated Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Navigator.pop(context);

            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }

  }



}
