import 'dart:io';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/data/domain/item/post_item_request_model.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_image_from_gallary_or_camera.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_unit_layout.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/item/put_item_request_model.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../common_widget/singleLine_TextformField_without_double.dart';
import '../../../searchable_dropdowns/ledger_searchable_dropdown.dart';
import '../../../searchable_dropdowns/searchable_dropdown_for_string_array.dart';

class ItemCreateActivity extends StatefulWidget {
  final editItem;
  final readOnly;
  const ItemCreateActivity({super.key,this.editItem, this.readOnly});

  // final ItemCreateActivityInterface mListener;

  @override
  State<ItemCreateActivity> createState() => _ItemCreateActivityState();
}

class _ItemCreateActivityState extends State<ItemCreateActivity> {
  final _formkey = GlobalKey<FormState>();

  final _itemNameFocus = FocusNode();
  final itemNameController = TextEditingController();
  final _itemNameKey = GlobalKey<FormFieldState>();

  final _unitFocus = FocusNode();
  final unitController = TextEditingController();
  final _unitKey = GlobalKey<FormFieldState>();

  final _categoryFocus = FocusNode();
  final categoryController = TextEditingController();

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
    if(widget.editItem!=null)
    getData();
  }
  var itemData=null;
  bool isApiCall = false;

  getData()async{
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().item}/${widget.editItem['ID']}?Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data)async{
              setState(()  {

                if(data!=null){
                  setState(() {
                    itemData=data;
                  });
                  print("%%%%%%%%%%%%%%%%%%%%% $itemData");

                }else{
                  isApiCall=true;
                }

              });
              await setData();
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {

              print("Here2=> $e");

              setState(() {
                isLoaderShow=false;
              });
              var val= CommonWidget.errorDialog(context, e);

              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }
    else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  setData()async{
    print(widget.editItem);
    print("&&&&&&&&&&&&&&&&&&&&& ${itemData[0]['Unit']}");
    if(widget.editItem!=null){
      File ?f=null;
      if(itemData[0]['Photo']!=null&&itemData[0]['Photo']['data']!=null && itemData[0]['Photo']['data'].length>10) {
        f = await CommonWidget.convertBytesToFile(itemData[0]['Photo']['data']);
      }

      setState(()  {
        picImage=f;
        itemNameController.text=itemData[0]['Name'];
        categoryName=itemData[0]['Category_Name']!=null?itemData[0]['Category_Name']:categoryName;
        categoryId=itemData[0]['Category_ID']!=null?itemData[0]['Category_ID']:categoryId;
         unitTwoId=itemData[0]['Unit2']!=null?itemData[0]['Unit2']:unitTwoId;
         unitTwoName=itemData[0]['Unit2']!=null?itemData[0]['Unit2']:"";
          unitTwofactorController.text=itemData[0]['Unit2_Factor']!=null?(double.parse(itemData[0]['Unit2_Factor'].toString()).toStringAsFixed(2)).toString():unitTwofactorController.text;
           unitTwoBaseController.text=itemData[0]['Unit2_Base']!=null?(double.parse(itemData[0]['Unit2_Base'].toString())).toStringAsFixed(2):unitTwoBaseController.text;
          unitThreeId=itemData[0]['Unit3']!=null?itemData[0]['Unit3']:unitThreeId;
          unitThreeName=itemData[0]['Unit3']!=null?itemData[0]['Unit3']:"";

        unitThreeBaseController.text=itemData[0]['Unit3_Base']!=null?(double.parse(itemData[0]['Unit3_Base'].toString())).toStringAsFixed(2):unitThreeBaseController.text;
         unitThreefactorController.text=itemData[0]['Unit3_Factor']!=null?(double.parse(itemData[0]['Unit3_Factor'].toString())).toStringAsFixed(2):unitTwofactorController.text;
         packSizeController.text=itemData[0]['Pack_Size']!=null?(itemData[0]['Pack_Size']).toString():packSizeController.text;
        rateController.text=itemData[0]['Rate']!=null?double.parse((itemData[0]['Rate']).toString()).toStringAsFixed(2):rateController.text;
         minController.text=itemData[0]['Min_Stock']!=null?(double.parse(itemData[0]['Min_Stock'].toString())).toStringAsFixed(2):minController.text;
        maxController.text=itemData[0]['Max_Stock']!=null?(double.parse(itemData[0]['Max_Stock'].toString())).toStringAsFixed(2):maxController.text;
        hsnNoController.text=itemData[0]['HSN_No']!=null?itemData[0]['HSN_No']:hsnNoController.text;
        extNameController.text=itemData[0]['Ext_Name']!=null?itemData[0]['Ext_Name']:extNameController.text;
        defaultStoreController.text=itemData[0]['Default_Store']!=null?itemData[0]['Default_Store']:defaultStoreController.text;
         descController.text=itemData[0]['Detail_Desc']!=null?itemData[0]['Detail_Desc']:descController.text;
         measuringUnit=itemData[0]['Unit']!=""?itemData[0]['Unit']:"";
         measuringUnit=itemData[0]['Unit']!=""?itemData[0]['Unit']:"";
        isLoaderShow=false;
      });

    }
  }

  File? adharFile ;
  File? panFile ;
  File? gstFile ;

  final rateController = TextEditingController();
  final _rateFocus = FocusNode();
  final _rateKey = GlobalKey<FormFieldState>();

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
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
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
                            child: widget.editItem!=null?Center(
                          child: Text(
                              ApplicationLocalizations.of(context)!.translate("item")!,
                    style: appbar_text_style,
                  ),
                ): Center(
              child: Text(
              ApplicationLocalizations.of(context)!.translate("create_item")!,
              style: appbar_text_style,
            ),
          ),
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: Colors.white,

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
                widget.readOnly==false?Container(): Container(
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
        readOnly: widget.readOnly,
        callbackFile: (file)async{
          if(file!=null) {
            List<int> bytes = (await file?.readAsBytes()) as List<int>;
            setState(() {
              picImage = file;
              picImageBytes = file != null ? (bytes)!.whereType<int>().toList() : [];
            });
          }
          else{
            setState(() {
              picImage = file;
              picImageBytes = [];
            });
          }
        }
    );

  }


  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():ListView(
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
              child:  Form(
                key: _formkey,
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
        ),
      ],
    );
  }

  /* Widget for name text from field layout */
  Widget getNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      mandatory: true,
      txtkey: _itemNameKey,
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
      controller: itemNameController,
      readOnly: widget.readOnly,
      focuscontroller: _itemNameFocus,
      focusnext: _categoryFocus,
      title: ApplicationLocalizations.of(context)!.translate("item_name")!,
      callbackOnchage: (value) {
        setState(() {
          itemNameController.text = value;
        });
        _itemNameKey.currentState!.validate();
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'^[A-zÀ\s*&^%0-9,.-:)(]+')), 
    );

  }
  final _categoryKey = GlobalKey<FormFieldState>();

  /* Widget For Category Layout */
  Widget getAddCategoryLayout(double parentHeight, double parentWidth){
    return   Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .00),
      child:  SearchableLedgerDropdown(
          mandatory: true,
          txtkey: _categoryKey,
          focuscontroller: categoryController,
          focusnext: _unitFocus,
          apiUrl:ApiConstants().item_category+"?",
          franchisee: widget.editItem!=null?"edit":"",
          readOnly: widget.readOnly,
          franchiseeName: widget.editItem!=null && itemData!=null?itemData[0]['Category_Name']:"",
          title:  ApplicationLocalizations.of(context)!.translate("category")!,
          callback: (name,id){

              setState(() {
                categoryName=name!;
                categoryId=int.parse(id!);
              });
              _categoryKey.currentState!.validate();
          },
          ledgerName: categoryName)
    );

      // GetCategoryLayout(
    //     title: ApplicationLocalizations.of(context)!.translate("category")!,
    //     callback: (value,id){
    //       setState(() {
    //         categoryName=value!;
    //         categoryId=id!;
    //       });
    // },
    //     selectedProductCategory: categoryName
    // );

  }



  /* Widget For measuring unit Layout */
  Widget getMeasuringUnitLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: const EdgeInsets.only(top:3),
      child: SearchableDropdownForStringArray(
          mandatory: true,
          txtkey: _unitKey,
          focuscontroller: unitController,
          focusnext: unitTwofactorController,
          readOnly: widget.readOnly,
          apiUrl:ApiConstants().measuring_unit+"?",
          title:  ApplicationLocalizations.of(context)!.translate("measuring_unit")!,
          callback: (name){

            setState(() {
              measuringUnit=name!;
              // cityId=id.toString()!;
            });
            _unitKey.currentState!.validate();
            print(measuringUnit);
          },
          franchiseeName: widget.editItem!=null&& itemData!=null?itemData[0]['Unit']:"",
          franchisee:widget.editItem!=null&&itemData!=null?"edit":"",
          ledgerName: measuringUnit),
    );

      GetUnitLayout(
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
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: parentWidth,
            child: SearchableDropdownForStringArray(
                readOnly: widget.readOnly,
                apiUrl:ApiConstants().measuring_unit+"?",
                title:  ApplicationLocalizations.of(context)!.translate("unit_two")!,
                callback: (name){

                  setState(() {
                    unitTwoName=name!;
                    // cityId=id.toString()!;
                  });

                  print(unitTwoName);
                },
                franchiseeName: unitTwoName,
                franchisee:widget.editItem!=null&&itemData!=null?"edit":"",
                ledgerName: unitTwoName),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: parentHeight * .055,
                width: parentWidth * .30,
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
                  textInputAction: TextInputAction.next,
                  cursorColor: CommonColor.BLACK_COLOR,
                  readOnly: widget.readOnly!=false?false:true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: parentWidth * .04, right: parentWidth * .02),
                    suffix: unitTwoName==""?Text(""):Text(unitTwoName,style: item_regular_textStyle,),
                    border: InputBorder.none,
                    counterText: '',
                    isDense: true,
                    hintText: ApplicationLocalizations.of(context)!.translate("enter")!+ " "+ApplicationLocalizations.of(context)!.translate("unit_two")!,
                    hintStyle: hint_textfield_Style,
                  ),
                  controller: unitTwofactorController,
                  onEditingComplete: () {
                    _unitTwofactor.unfocus();
                    FocusScope.of(context).requestFocus(_unitTwoBase);
                    setState(() {
                      unitTwofactorController.text =
                          double.parse(unitTwofactorController.text)
                              .toStringAsFixed(2);
                    });
                  },
                  onFieldSubmitted: (v){
                    setState(() {
                      unitTwofactorController.text =
                          double.parse(unitTwofactorController.text)
                              .toStringAsFixed(2);
                    });
                  },
                  onSaved: (v){
                    setState(() {
                      unitTwofactorController.text =
                          double.parse(unitTwofactorController.text)
                              .toStringAsFixed(2);
                    });
                  },
                  onTapOutside: (event){
                    setState(() {
                      unitTwofactorController.text =
                          double.parse(unitTwofactorController.text)
                              .toStringAsFixed(2);
                    });
                  },

                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true
                  ),
                  maxLines: 1,
                 inputFormatters:  <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
                  style: text_field_textStyle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10,left: 10,right: 10),
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
                margin: EdgeInsets.only(top: 10),
                height: parentHeight * .055,
                alignment: Alignment.center,
                width: parentWidth * .45,
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
                  textInputAction: TextInputAction.next,
                  cursorColor: CommonColor.BLACK_COLOR,
                  readOnly: widget.readOnly!=false?false:true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: parentWidth * .04, right: parentWidth * .02),
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
                    setState(() {
                      unitTwoBaseController.text =
                          double.parse(unitTwoBaseController.text)
                              .toStringAsFixed(2);
                    });
                  },
                  onFieldSubmitted: (v){
                    setState(() {
                      unitTwoBaseController.text =
                          double.parse(unitTwoBaseController.text)
                              .toStringAsFixed(2);
                    });
                  },
                  onSaved: (v){
                    setState(() {
                      unitTwoBaseController.text =
                          double.parse(unitTwoBaseController.text)
                              .toStringAsFixed(2);
                    });
                  },
                  onTapOutside: (event){
                    setState(() {
                      unitTwoBaseController.text =
                          double.parse(unitTwoBaseController.text)
                              .toStringAsFixed(2);
                    });
                  },

                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true
                  ),
                  maxLines: 1,
                  inputFormatters:  <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],

                  style: text_field_textStyle,
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
  /* Widget For measuring unit Layout */
  Widget getUnitThreeLayout(double parentHeight, double parentWidth){
    return

      Padding(
        padding: EdgeInsets.only(
            top: parentHeight * .015),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: parentWidth,
              child: SearchableDropdownForStringArray(
                  readOnly: widget.readOnly,
                  apiUrl:ApiConstants().measuring_unit+"?",
                  title:  ApplicationLocalizations.of(context)!.translate("unit_three")!,
                  callback: (name){

                    setState(() {
                      unitThreeName=name!;
                      // cityId=id.toString()!;
                    });

                    print(unitThreeName);
                  },
                  franchiseeName: unitThreeName,
                  franchisee:widget.editItem!=null&&itemData!=null?"edit":"",
                  ledgerName: unitThreeName),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: parentHeight * .055,
                  width: parentWidth * .30,
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
                    textInputAction: TextInputAction.next,
                    cursorColor: CommonColor.BLACK_COLOR,
                    readOnly: widget.readOnly!=false?false:true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      border: InputBorder.none,
                      suffix: unitThreeName==""?Text(""):Text(unitThreeName,style: item_regular_textStyle,),
                      counterText: '',
                      isDense: true,
                      hintText: ApplicationLocalizations.of(context)!.translate("enter")!+" "+  ApplicationLocalizations.of(context)!.translate("unit_three")!,
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: unitThreefactorController,
                    onEditingComplete: () {
                      _unitThreefactor.unfocus();
                      FocusScope.of(context).requestFocus(_unitThreeBase);
                      setState(() {
                        unitThreefactorController.text =
                            double.parse(unitThreefactorController.text)
                                .toStringAsFixed(2);
                      });
                    },
                    onFieldSubmitted: (v){
                      setState(() {
                        unitThreefactorController.text =
                            double.parse(unitThreefactorController.text)
                                .toStringAsFixed(2);
                      });
                    },
                    onSaved: (v){
                      setState(() {
                        unitThreefactorController.text =
                            double.parse(unitThreefactorController.text)
                                .toStringAsFixed(2);
                      });
                    },
                    onTapOutside: (event){
                      setState(() {
                        unitThreefactorController.text =
                            double.parse(unitThreefactorController.text)
                                .toStringAsFixed(2);
                      });
                    },
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true
                    ),
                    maxLines: 1,
                    inputFormatters:  <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],

                    style: text_field_textStyle,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
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
                  margin: EdgeInsets.only(top: 10),
                  height: parentHeight * .055,
                  alignment: Alignment.center,
                  width: parentWidth * .45,
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
                    controller: unitThreeBaseController,
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.words,
                    focusNode: _unitThreeBase,
                    textInputAction: TextInputAction.next,
                    readOnly: widget.readOnly!=false?false:true,
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
                      setState(() {
                        unitThreeBaseController.text =
                            double.parse(unitThreeBaseController.text)
                                .toStringAsFixed(2);
                      });
                    },

                    onFieldSubmitted: (v){
                      setState(() {
                        unitThreeBaseController.text =
                            double.parse(unitThreeBaseController.text)
                                .toStringAsFixed(2);
                      });
                    },
                    onSaved: (v){
                      setState(() {
                        unitThreeBaseController.text =
                            double.parse(unitThreeBaseController.text)
                                .toStringAsFixed(2);
                      });
                    },
                    onTapOutside: (event){
                      setState(() {
                        unitThreeBaseController.text =
                            double.parse(unitThreeBaseController.text)
                                .toStringAsFixed(2);
                      });
                    },
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true
                    ),
                    maxLines: 1,
                    inputFormatters:  <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],

                    style: text_field_textStyle,
                  ),
                ),
              ],
            ),

          ],
        ),
      );

      Padding(
      padding: EdgeInsets.only(
          top: parentHeight * .015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // GetUnitLayout(
          //     parentWidth:parentWidth * .25,
          //     title: ApplicationLocalizations.of(context)!.translate("unit_three")!,
          //     callback: (value){
          //       setState(() {
          //         unitThreeName=value!;
          //       });
          //     },
          //     measuringUnit: unitThreeName
          // ),
          Container(
            width: parentWidth * .30,
            child: SearchableDropdownForStringArray(
                readOnly: widget.readOnly,
                apiUrl:ApiConstants().measuring_unit+"?",
                title:  ApplicationLocalizations.of(context)!.translate("unit_three")!,
                callback: (name){

                  setState(() {
                    unitThreeName=name!;
                    // cityId=id.toString()!;
                  });

                  print(unitThreeName);
                },
                franchiseeName: widget.editItem!=null&&itemData!=null?itemData[0]['Unit3'].toString():"",
                franchisee:widget.editItem!=null&&itemData!=null?"edit":"",
                ledgerName: unitThreeName),
          ),
          Container(
            margin: EdgeInsets.only(top: 35),
            height: parentHeight * .055,
            width: parentWidth * .2,
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
              readOnly: widget.readOnly!=false?false:true,
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
             margin: EdgeInsets.only(top: 35),
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
            margin: EdgeInsets.only(top: 35),

            height: parentHeight * .055,
            alignment: Alignment.center,
            width: parentWidth * .2,
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
              controller: unitThreeBaseController,
              textAlignVertical: TextAlignVertical.center,
              textCapitalization: TextCapitalization.words,
              focusNode: _unitThreeBase,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              readOnly: widget.readOnly!=false?false:true,
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
      readOnly: widget.readOnly,
      focuscontroller: _maxFocus,
      focusnext: _extNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("max_stock")!,
      callbackOnchage: (value) {
        setState(() {
          maxController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(
          decimal: true
      ),

      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),

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
      readOnly: widget.readOnly,
      focuscontroller: _minFocus,
      focusnext: _maxFocus,
      title: ApplicationLocalizations.of(context)!.translate("min_stock")!,
      callbackOnchage: (value) {
        setState(() {
          minController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(
    decimal: true
    ),

      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))


    );

  }


  /* Widget for max text from field layout */
  Widget getExtNameLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("ext_name")!;
        }
        return null;
      },
      controller: extNameController,
      readOnly: widget.readOnly,
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
    return SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("pack_size")!;
        }
        return null;
      },
      controller: packSizeController,
      readOnly: widget.readOnly,
      focuscontroller: _packSizeFocus,
      focusnext: _rateFocus,
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
      mandatory: true,
      txtkey: _rateKey,
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
      controller: rateController,
      readOnly: widget.readOnly,
      focuscontroller: _rateFocus,

      focusnext: _hsnNoFocus,
      title: ApplicationLocalizations.of(context)!.translate("rate")!,
      callbackOnchage: (value) {
        setState(() {
          rateController.text = value;
        });
        _rateKey.currentState!.validate();
      },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );

  }

  /* Widget for max text from field layout */
  Widget getHSNNOLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("hsn_no")!;
        }
        return null;
      },
      capital:true,
      readOnly: widget.readOnly,
      controller: hsnNoController,
      focuscontroller: _hsnNoFocus,
      focusnext: _defaultStoreFocus,
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
    return SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("item_description")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
      controller: descController,
      focuscontroller: _descFocus,
      focusnext: null,
      maxlength: 500,
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
    return SingleLineEditableTextFormFieldWithoubleDouble(
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("default_store")!;
        }
        return null;
      },
      readOnly: widget.readOnly,
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
              bool v=_itemNameKey.currentState!.validate();
              bool q=_categoryKey.currentState!.validate();
              bool u=_unitKey.currentState!.validate();
              bool r=_rateKey.currentState!.validate();

              if (mounted && v && q && r && u ) {
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
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String creatorName = await AppPreferences.getUId();
    //var model={};
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostItemRequestModel model = PostItemRequestModel(
          CompanyID: companyId,
          Name: itemNameController.text.trim(),
          CategoryID: categoryId.toString(),
          Creator: creatorName,
          CreatorMachine: deviceId,
          Unit2: unitTwoName,
          Unit2Base: unitTwoBaseController.text.trim(),
          Unit3:unitThreeName,
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
          Unit: measuringUnit,

        );


      print("IMGE2 : ${(model.Photo)?.length}");

      String apiUrl = baseurl + ApiConstants().item;
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
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String creatorName = await AppPreferences.getUId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        PutItemRequestModel model = PutItemRequestModel(
            CompanyId: companyId,
            Modifier: creatorName,
            Modifier_Machine: deviceId,
            Name: itemNameController.text.trim(),
            CategoryID: categoryId.toString(),
            Unit2: unitTwoName,
            Unit2Base: unitTwoBaseController.text.trim(),
            Unit3:unitThreeName,
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
            Photo: picImageBytes.length==0?null:picImageBytes,
            Unit: measuringUnit,
        );

        print("############55%%%%%%%% ${model.Photo}");

        String apiUrl = baseurl + ApiConstants().item+"/"+widget.editItem['ID'].toString()+"?Company_ID=$companyId";

        print(apiUrl);
        print(model.toJson());
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(value)async{
              print("  Put Call :   $value ");
              var snackBar = SnackBar(content: Text('Item  Updated Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Navigator.pop(context);

            }, onFailure: (error) {

              print(error.toString());
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print(e.toString());
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              print(e.toString());
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
