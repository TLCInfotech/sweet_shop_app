import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/core/util.dart';
import 'package:sweet_shop_app/data/domain/franchisee/post_franchisee_request_model.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../common_widget/get_image_from_gallary_or_camera.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../common_widget/singleLine_TextformField_without_double.dart';
import '../../../dialog/amount_type_dialog.dart';
import '../../../searchable_dropdowns/searchable_dropdown_for_string_array.dart';


class CreateFranchisee extends StatefulWidget {
  final editItem;
  final readOnly;
  final String logoImage;
  const CreateFranchisee({super.key,this.editItem, this.readOnly, required this.logoImage});

  @override
  _CreateFranchiseeState createState() => _CreateFranchiseeState();
}

class _CreateFranchiseeState extends State<CreateFranchisee> with SingleTickerProviderStateMixin,AmountTypeDialogInterface
{
  final _formkey = GlobalKey<FormState>();

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
  final _fnameKey = GlobalKey<FormFieldState>();

  TextEditingController franchiseeContactPerson = TextEditingController();
  final _franchiseeContactPersonFocus=FocusNode();

  TextEditingController franchiseeAddress = TextEditingController();
  final _franchiseeAddressFocus=FocusNode();
  final _faddressKey = GlobalKey<FormFieldState>();

  final _fcityKey = GlobalKey<FormFieldState>();
  final _fstateKey = GlobalKey<FormFieldState>();
  final _fcountryKey = GlobalKey<FormFieldState>();
  final _mobilenoKey = GlobalKey<FormFieldState>();

  TextEditingController franchiseeMobileNo = TextEditingController();
  final _franchiseeMobileNoFocus=FocusNode();

  TextEditingController franchiseeEmail = TextEditingController();
  final _franchiseeEmailFocus=FocusNode();

  TextEditingController pincode = TextEditingController();
  final _pincodeFocus=FocusNode();

  TextEditingController franchiseeAadharNo = TextEditingController();
  TextEditingController franchiseeGSTNO = TextEditingController();
  TextEditingController franchiseePanNo = TextEditingController();
  final _franchiseefssaiNo = FocusNode();
  final franchiseefssaiNo = TextEditingController();

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
  String countryId = "";
  String stateId = "";

  String stateName="";
  String cityId = "";
  String selectedState = ""; // Initial dummy data

  String selectedCity = ""; // Initial dummy data

  String selectedCountry = "";

  List<String> LimitDataUnit = ["Cr","Dr"];

  var selectedLimitUnit = null;
  File? adharFile ;
  File? panFile ;
  File? gstFile ;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<int> picImageBytes=[];

  List<int> adharImageBytes=[];
  List<int> panImageBytes=[];
  List<int> gstImageBytes=[];

  bool isLoaderShow=false;

  var itemData=null;
  bool isApiCall = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVal();
    if(widget.editItem!=null)
      getData();

  }

  final _langFocus = FocusNode();
  final langController = TextEditingController();
  String langu = "en_IN";
  setVal()async{
    langu=await AppPreferences.getLang();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: SizeConfig.safeUsedHeight,
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFfffff5),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFFfffff5),
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
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                child: const FaIcon(Icons.arrow_back),
                              ),
                              widget.logoImage!=""? Container(
                                height:SizeConfig.screenHeight*.05,
                                width:SizeConfig.screenHeight*.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: FileImage(File(widget.logoImage)),
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ):Container(),
                              Expanded(
                                child:  Center(
                                  child: Text(
                                    ApplicationLocalizations.of(context).translate("franchisee_new"),
                                    style: appbar_text_style,),
                                ),
                              ),
                            ],
                          ),
                        ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),

                    backgroundColor: Colors.white,

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
                widget.readOnly==false?Container():    Container(
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
              bool v=_fnameKey.currentState!.validate();
              bool q=_faddressKey.currentState!.validate();
              bool u=_fcityKey.currentState!.validate();
              bool r=_fstateKey.currentState!.validate();
              bool s=_fcountryKey.currentState!.validate();
              bool t=_mobilenoKey.currentState!.validate();


              if (mounted && v && q && u && r && s && t) {
                String baseurl=await AppPreferences.getDomainLink();
                String lang=await AppPreferences.getLang();
                String companyId = await AppPreferences.getCompanyId();
                setState(() {
                  disableColor = true;

                  if(widget.editItem!=null){
                    String apiUrl = baseurl + ApiConstants().franchisee+"/"+widget.editItem['ID'].toString()+"?Company_ID=$companyId&${StringEn.lang}=$lang";
                    callPostFranchisee(apiRequestHelper.callAPIsForPutAPI,apiUrl);
                    // callUpdateFranchisee();
                  }else{
                    String apiUrl = baseurl + ApiConstants().franchisee+"?${StringEn.lang}=$lang";
                    callPostFranchisee(apiRequestHelper.callAPIsForDynamicPI,apiUrl);
                  }
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
                    child: Text(
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

  Widget getAllFields(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  getImageLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                  const SizedBox(height: 20,),
                  getFieldTitleLayout( ApplicationLocalizations.of(context)!.translate("basic_information")!),
                  BasicInfo(),
                  const SizedBox(height: 20,),
                  getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("document_information")!),
                  Document_Information(),
                  const SizedBox(height: 20.0),
                  getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("account_information")!),
                  Container(
                    padding: const EdgeInsets.all(10),
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
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }

  Container Document_Information() {
    return Container(

                    padding: const EdgeInsets.all(10),
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
                        callbackFile: (File? file)async {
                          Uint8List? bytes = await file?.readAsBytes();
                          setState(() {
                            adharFile=file;
                            adharImageBytes = (bytes)!.whereType<int>().toList();
                          });
                        },
                        title:      ApplicationLocalizations.of(context)!.translate("adhar_number")!,
                        documentFile: adharFile,
                        readOnly: widget.readOnly,
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
                        callbackFile: (File? file) async{
                          Uint8List? bytes = await file?.readAsBytes();
                          setState(() {
                            panFile=file;
                            panImageBytes = (bytes)!.whereType<int>().toList();
                          });
                        },
                        title:  ApplicationLocalizations.of(context)!.translate("pan_number")!,
                        documentFile: panFile,
                        readOnly: widget.readOnly,
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
                        callbackFile: (File? file) async{
                          Uint8List? bytes = await file?.readAsBytes();
                          setState(() {
                            gstFile=file;
                            gstImageBytes = (bytes)!.whereType<int>().toList();
                          });
                        },
                        title:  ApplicationLocalizations.of(context)!.translate("gst_number")!,
                        documentFile: gstFile,
                        controller: gstNoController,
                        readOnly: widget.readOnly,
                        focuscontroller: _gstNoFocus,
                        focusnext: _franchiseePaymentDaysFocus,
                      ),
                      getFSSAINoLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                      getPaymentDaysLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                    ],
                    ),
                  );
  }

  Container BasicInfo() {
    return Container(

                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [
                      getFranchiseeNameLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                     langu=="en_IN"?Container(): getLangNameLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                      getContactPersonLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                      getAddressLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getCityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                          const SizedBox(width: 5,),
                          getPincodeLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                        ],
                      ),
                      getStateLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                      getCountryLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                      getMobileNoLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                      getEmailLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                      getOutstandingLimit(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                    ],
                    ),
                  );
  }


  /* Widget for bank name text from field layout */
  Widget getBankNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      controller: bankNameController,
      focuscontroller: _bankNameFocus,
      focusnext: _bankBranchFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("bank_name")!,
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
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("bank_name")!;
        }

        return null;
      },
    );

  }

  /* Widget for bank branch name text from field layout */
  Widget getBankBranchNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      controller: bankBranchController,
      focuscontroller: _bankBranchFocus,
      focusnext: _IFSCCodeFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("bank_branch")!,
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
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("bank_branch")!;
        }
        return null;
      },
    );

  }
  /* Widget for IFSC Code text from field layout */
  Widget getFSCCodeLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      controller: IFSCCodeController,
      focuscontroller: _IFSCCodeFocus,
      readOnly: widget.readOnly,
      focusnext: _aCHolderNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("ifsc_branch")!,
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
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("ifsc_branch")!;
        }
        return null;
      },
    );

  }

  /* Widget for Account holder name text from field layout */
  Widget getACHolderNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      controller: aCHolderNameController,
      focuscontroller: _aCHolderNameFocus,
      focusnext: _accountNoFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("ac_holder_name")!,
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
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("ac_holder_name")!;
        }
        return null;
      },
    );

  }

  /* Widget for Account No name text from field layout */
  Widget getAcoountNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      controller: accountNoController,
      focuscontroller: _accountNoFocus,
      focusnext: _franchiseeNameFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("account_no")!,
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
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("account_no")!;
        }
        return null;
      },
    );

  }

  /* Widget for country text from field layout */
  Widget getCountryLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: const EdgeInsets.only(top:3),
      child: SearchableDropdownForStringArray(
        mandatory: true,
          txtkey: _fcountryKey,
          readOnly: widget.readOnly,
          apiUrl:ApiConstants().country+"?",
          title:  ApplicationLocalizations.of(context)!.translate("country")!,
          callback: (name){

            setState(() {
              countryName=name!;
              // cityId=id.toString()!;
            });

            _fcountryKey.currentState!.validate();
            print(countryName);
          },
          franchiseeName: widget.editItem!=null&&itemData!=null?itemData[0]['Country'].toString(): "",
          franchisee:  widget.editItem!=null &&itemData!=null?"edit":"",
          ledgerName: countryName),
    );
      // GetCountryLayout(
      //   title:  ApplicationLocalizations.of(context)!.translate("country")!,
      //   callback: (name,id){
      //     setState(() {
      //       countryName=name!;
      //       countryId=id!;
      //     });
      //   },
      //   countryName: countryName);
  }


  /* Widget for state text from field layout */
  Widget getStateLayout(double parentHeight, double parentWidth) {
    return  Padding(
      padding: const EdgeInsets.only(top:3),
      child: SearchableDropdownForStringArray(
        mandatory: true,
          txtkey: _fstateKey,
          readOnly: widget.readOnly,
          apiUrl:ApiConstants().state+"?",

          title:  ApplicationLocalizations.of(context)!.translate("state")!,
          callback: (name){

            setState(() {
              stateName=name!;
              // cityId=id.toString()!;
            });
            _fstateKey.currentState!.validate();
            print(stateName);
          },
          franchiseeName:widget.editItem!=null && itemData!=null?itemData[0]['State'].toString(): "",
          franchisee:  widget.editItem!=null &&  itemData!=null?"edit":"",
          ledgerName: stateName),
    );

      // GetStateLayout(
      //   title:  ApplicationLocalizations.of(context)!.translate("state")!,
      //   callback: (name,id){
      //     setState(() {
      //       stateName=name!;
      //       stateId=id!;
      //     });
      //   },
      //   stateName: stateName);
  }

  /* widget for image layout */
  Widget getImageLayout(double parentHeight, double parentWidth) {
    return  GetSingleImage(
        height: parentHeight * .25,
        width: parentHeight * .25,
        picImage: picImage,
        readOnly: widget.readOnly,
        callbackFile: (file)async{
          if(file!=null) {
            List<int> bytes = (await file?.readAsBytes()) as List<int>;
            setState(()  {
              picImage=file;
              picImageBytes=bytes;
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



  /* widget for franchisee fssai layout */
  Widget getFSSAINoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: franchiseefssaiNo,
      focuscontroller: _franchiseefssaiNo,
      focusnext: _franchiseePaymentDaysFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("fssai")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseefssaiNo.text = value;
        });
      },
      textInput: TextInputType.streetAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("payment_days")!;
        }
        return null;
      },
    );

  }



  /* widget for franchisee payment days layout */
  Widget getPaymentDaysLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      controller: franchiseePaymentDays,
      focuscontroller: _franchiseePaymentDaysFocus,
      focusnext: _bankNameFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("payment_days")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseePaymentDays.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("payment_days")!;
        }
        return null;
      },
    );

  }


  /* widget for franchisee outstanding limit layout */
  Widget getOutstandingLimit(double parentHeight, double parentWidth) {
    return
      Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleLineEditableTextFormFieldWithoubleDouble(
      controller: franchiseeOutstandingLimit,
        focuscontroller: _franchiseeOutstandingLimitFocus,
        focusnext: _adharoFocus,
            readOnly: widget.readOnly,
        title: ApplicationLocalizations.of(context)!.translate("outstanding_limit")!,
        callbackOnchage: (value) {
          setState(() {
            franchiseeOutstandingLimit.text = value;
          });
        },
        textInput: TextInputType.number,
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
        validation: (value) {
          if (value!.isEmpty) {
            return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("outstanding_limit")!;
          }

          return null;
        },
      )
        ),
        AmountTypeDialog(mListener: this,
          selectedType: selectedLimitUnit,width:130,mandatory: false,)
        // Container(
        //   height: 50,
        //   width: 130,
        //   margin: EdgeInsets.only(left: 5,top: 30),
        //   child: GestureDetector(
        //     onTap: () {
        //       FocusScope.of(context).requestFocus(FocusNode());
        //       if (context != null) {
        //         showGeneralDialog(
        //             barrierColor: Colors.black.withOpacity(0.5),
        //             transitionBuilder: (context, a1, a2, widget) {
        //               final curvedValue =
        //                   Curves.easeInOutBack.transform(a1.value) -
        //                       1.0;
        //               return Transform(
        //                 transform: Matrix4.translationValues(
        //                     0.0, curvedValue * 200, 0.0),
        //                 child: Opacity(
        //                   opacity: a1.value,
        //                   child: AmountTypeDialog(
        //                     mListener: this,
        //                   ),
        //                 ),
        //               );
        //             },
        //             transitionDuration: Duration(milliseconds: 200),
        //             barrierDismissible: true,
        //             barrierLabel: '',
        //             context: context,
        //             pageBuilder: (context, animation2, animation1) {
        //               throw Exception(
        //                   'No widget to return in pageBuilder');
        //             });
        //       }
        //     },
        //     child: Container(
        //         height: parentHeight * .055,
        //         margin: EdgeInsets.only(top: 10),
        //         padding: EdgeInsets.only(left: 10, right: 10),
        //         alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           color: CommonColor.WHITE_COLOR,
        //           borderRadius: BorderRadius.circular(4),
        //           boxShadow: [
        //             BoxShadow(
        //               offset: Offset(0, 1),
        //               blurRadius: 5,
        //               color: Colors.black.withOpacity(0.1),
        //             ),
        //           ],
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               selectedLimitUnit == null ? ApplicationLocalizations.of(context)!.translate("amount_type")!
        //                   : selectedLimitUnit,
        //               style: selectedLimitUnit == null ? item_regular_textStyle : text_field_textStyle,
        //             ),
        //             FaIcon(
        //               FontAwesomeIcons.caretDown,
        //               color: Colors.black87.withOpacity(0.8),
        //               size: 16,
        //             )
        //           ],
        //         )),
        //   ),
        // )

      ],
    );
  }

  /* widget for franchisee email layout */
  Widget getEmailLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      controller: franchiseeEmail,
      focuscontroller: _franchiseeEmailFocus,
      focusnext: _adharoFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("email_address")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseeEmail.text = value;
        });
      },
      textInput: TextInputType.emailAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z \.\@]')),
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("email_address")!;
        }
        else if (Util.isEmailValid(value)) {
          return ApplicationLocalizations.of(context)!.translate("valid")!+ApplicationLocalizations.of(context)!.translate("email_address")!;
        }
        return null;
      },
    );

  }

  /* widget for franchisee mobile layout */

  Widget getMobileNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      mandatory: true,
      txtkey: _mobilenoKey,
      controller: franchiseeMobileNo,
      focuscontroller: _franchiseeMobileNoFocus,
      focusnext: _franchiseeEmailFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("mobile_no")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseeMobileNo.text = value;
        });
        _mobilenoKey.currentState!.validate();
      },
      textInput: TextInputType.number,
      maxlines: 1,
      maxlength: 10,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        // String pattern =r'^[6-9]\d{9}$';
        // RegExp regExp = new RegExp(pattern);
        // print(Util.isMobileValid(value!));
        if (value!.isEmpty) {
          return "";
        }
        else if (Util.isMobileValid(value)) {
          return ApplicationLocalizations.of(context)!.translate("valid")!+ApplicationLocalizations.of(context)!.translate("mobile_no")!;
        }

        return null;
      },
    );

  }


  /* widget for Contact Person layout */
  Widget getPincodeLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      parentWidth: parentWidth,
      controller: pincode,
      readOnly: widget.readOnly,
      focuscontroller: _pincodeFocus,
      focusnext: _franchiseeMobileNoFocus,
      title: ApplicationLocalizations.of(context)!.translate("pin_code")!,
      callbackOnchage: (value) {
        setState(() {
          pincode.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("pin_code")!;
        }
        return null;
      },
    );
  }

  /* Widget for city text from field layout */
  Widget getCityLayout(double parentHeight, double parentWidth) {
    return Expanded(
      child:  Padding(
        padding: const EdgeInsets.only(top:3),
        child:  SearchableDropdownForStringArray(
            mandatory: true,
            txtkey: _fcityKey,
            apiUrl:ApiConstants().city+"?",
            ledgerName: selectedCity,
            readOnly: widget.readOnly,
            franchiseeName: widget.editItem!=null && itemData!=null?itemData[0]['District'].toString(): "",
            franchisee: widget.editItem!=null&& itemData!=null?"edit":"",
            title:  ApplicationLocalizations.of(context)!.translate("city")!,
            callback: (name){
              setState(() {
                selectedCity=name!;
                // cityId=id.toString()!;
              });

              print(selectedCity);
              _fcityKey.currentState!.validate();
            },
            ),
      ),
    );

      // GetDistrictLayout(
      //   title: ApplicationLocalizations.of(context)!.translate("city")!,
      //   callback: (name,id){
      //     setState(() {
      //       selectedCity=name!;
      //       cityId =id!;
      //     });
      //   },
      //   districtName: selectedCity);

  }

  /* widget for Contact Person layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: franchiseeContactPerson,
      focuscontroller: _franchiseeContactPersonFocus,
      focusnext: _franchiseeAddressFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context)!.translate("contact_person")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseeContactPerson.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("contact_person")!;
        }
        return null;
      },
    );

  }

  /* widget for Address layout */
  Widget getAddressLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      mandatory: true,
      txtkey: _faddressKey,
      controller: franchiseeAddress,
      focuscontroller: _franchiseeAddressFocus,
      focusnext: _pincodeFocus,
      readOnly: widget.readOnly,
      title:ApplicationLocalizations.of(context)!.translate("address")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseeAddress.text = value;
        });
        _faddressKey.currentState!.validate();
      },
      textInput: TextInputType.streetAddress,
      maxlines: 5,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z \,]')),
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
    );

  }


  /* widget for Franchisee name layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      mandatory: true,
      txtkey:_fnameKey,
      controller: franchiseeName,
      focuscontroller: _franchiseeNameFocus,
      focusnext: langController,
      readOnly: widget.readOnly,
      title:"Branch Name (English)",
     // title: ApplicationLocalizations.of(context).translate("franchisee_name"),
      callbackOnchage: (value) {
        setState(() {
          franchiseeName.text = value;
        });
        _fnameKey.currentState!.validate();
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow(RegExp(r'^[A-zÀ\s*&^%0-9,.-:)(]+')),
      validation: ((value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      }),
    );
  }


  /* widget for Franchisee name layout */
  Widget getLangNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormFieldWithoubleDouble(
      mandatory: false,
      controller: langController,
      focuscontroller: _langFocus,
      focusnext: _franchiseeContactPersonFocus,
      readOnly: widget.readOnly,
      title: ApplicationLocalizations.of(context).translate("franchisee_name")+ApplicationLocalizations.of(context).translate("langu"),
      callbackOnchage: (value) {
        setState(() {
          langController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format:FilteringTextInputFormatter.allow( RegExp(r'^[\u0900-\u097F\sA-Za-z0-9&^%*.,:)(-]+$')),
      validation: ((value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      }),
    );
  }

  callPostFranchisee(callmethod,apiUrl) async {

    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String lang = await AppPreferences.getLang();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostFranchiseeRequestModel model = PostFranchiseeRequestModel(
            name: franchiseeName.text.trim(),
            Lang: langController.text.trim(),
            companyID: int.parse(companyId),
            startDate: null,
            contactPerson: franchiseeContactPerson.text.trim(),
            address: franchiseeAddress.text.trim(),
            district: selectedCity,
            state:stateName,
            pinCode: pincode.text.trim(),
            country: countryName,
            contactNo: franchiseeMobileNo.text.trim(),
            eMail: franchiseeEmail.text.trim(),
            pANNo: panNoController.text.trim(),
            photo: picImageBytes.length==0?null:picImageBytes,
            extName: "cscddc",
            adharNo: adharNoController.text.trim(),
            gSTNo: gstNoController.text.trim(),
            fSSAINo: franchiseefssaiNo.text.trim(),
            outstandingLimit:franchiseeOutstandingLimit.text!=""?int.parse( franchiseeOutstandingLimit.text.trim()):null,
            outstandingLimitType: selectedLimitUnit,
            paymentDays:franchiseePaymentDays.text!=""?int.parse(franchiseePaymentDays.text.trim()):null,
            bankName: bankNameController.text.trim(),
            bankBranch: bankBranchController.text.trim(),
            iFSCCode: IFSCCodeController.text.trim(),
            aCHolderName:aCHolderNameController.text.trim() ,
            accountNo: accountNoController.text.trim(),
            declaration: "rrr",
            cINNo: "145",
            pANCardImage:panImageBytes.length==0?null: panImageBytes,
            adharCardImage: adharImageBytes.length==0?null:adharImageBytes,
            gSTImage: gstImageBytes.length==0?null:gstImageBytes,
      );

      if(widget.editItem!=null){
        model.modifier=creatorName;
        model.modifierMachine=deviceId;
      }
      else{
      model.creator= creatorName;
      model.creatorMachine=deviceId;
      }


      print(apiUrl);
      print("jfhjfhjjhrjhr   ${model.toJson()} ");
      callmethod(apiUrl, model.toJson(), "",
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

  @override
  selectedAmountType(String name) {
    // TODO: implement selectedAmountType
    setState(() {
      selectedLimitUnit=name;
    });
  }
  getData()async{
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    String lang = await AppPreferences.getLang();
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
        String apiUrl = "${baseurl}${ApiConstants().franchisee}/${widget.editItem['ID']}?Company_ID=$companyId&${StringEn.lang}=$lang";
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
    print("EDITED: ${widget.editItem}");
    if(widget.editItem!=null){
      File ?f=null;
      File ?a=null;
      File ?p=null;
      File ?g=null;
      if(itemData[0]['Photo']!=null&&itemData[0]['Photo']['data']!=null && itemData[0]['Photo']['data'].length>10) {
        f = await CommonWidget.convertBytesToFile(itemData[0]['Photo']['data']);
      }
      if(itemData[0]['Adhar_Card_Image']!=null&&itemData[0]['Adhar_Card_Image']['data']!=null && itemData[0]['Adhar_Card_Image']['data'].length>10) {
        a = await CommonWidget.convertBytesToFile(itemData[0]['Adhar_Card_Image']['data']);
      }
      if(itemData[0]['PAN_Card_Image']!=null&&itemData[0]['PAN_Card_Image']['data']!=null && itemData[0]['PAN_Card_Image']['data'].length>10) {
        p = await CommonWidget.convertBytesToFile(itemData[0]['PAN_Card_Image']['data']);
      }
      if(itemData[0]['GST_Image']!=null&&itemData[0]['GST_Image']['data']!=null && itemData[0]['GST_Image']['data'].length>10) {
        g = await CommonWidget.convertBytesToFile(itemData[0]['GST_Image']['data']);
      }
      setState(()  {
        picImageBytes=(itemData[0]['Photo']!=null && itemData[0]['Photo']['data']!=null && itemData[0]['Photo']['data'].length>10)?(itemData[0]['Photo']['data']).whereType<int>().toList():[];
        picImage=f!=null?f:picImage;
        adharImageBytes=(itemData[0]['Adhar_Card_Image']!=null&&itemData[0]['Adhar_Card_Image']['data']!=null && itemData[0]['Adhar_Card_Image']['data'].length>10)?(itemData[0]['Adhar_Card_Image']['data']).whereType<int>().toList():[];
        adharFile=a!=null?a:adharFile;
        panImageBytes=(itemData[0]['PAN_Card_Image']!=null&&itemData[0]['PAN_Card_Image']['data']!=null && itemData[0]['PAN_Card_Image']['data'].length>10)?(itemData[0]['PAN_Card_Image']['data']).whereType<int>().toList():[];
        panFile=p!=null?p:panFile;
        gstImageBytes=(itemData[0]['GST_Image']!=null&&itemData[0]['GST_Image']['data']!=null && itemData[0]['GST_Image']['data'].length>10)?(itemData[0]['GST_Image']['data']).whereType<int>().toList():[];
        gstFile=g!=null?g:gstFile;
        adharNoController.text=itemData[0]['Adhar_No']!=null?itemData[0]['Adhar_No'].toString():adharNoController.text;
        panNoController.text=itemData[0]['PAN_No']!=null?itemData[0]['PAN_No'].toString():panNoController.text;
        gstNoController.text=itemData[0]['GST_No']!=null?itemData[0]['GST_No'].toString():gstNoController.text;
        bankNameController.text=itemData[0]['Bank_Name']!=null?itemData[0]['Bank_Name'].toString():bankNameController.text;
        langController.text=itemData[0]['Name_Locale']!=null?itemData[0]['Name_Locale'].toString():langController.text;
        bankBranchController.text=itemData[0]['Bank_Branch']!=null?itemData[0]['Bank_Branch'].toString():bankBranchController.text;
        IFSCCodeController.text=itemData[0]['IFSC_Code']!=null?itemData[0]['IFSC_Code'].toString():IFSCCodeController.text;
        accountNoController.text=itemData[0]['Account_No']!=null?itemData[0]['Account_No'].toString():accountNoController.text;
        aCHolderNameController.text=itemData[0]['AC_Holder_Name']!=null?itemData[0]['AC_Holder_Name'].toString(): aCHolderNameController.text;
        franchiseeName.text=itemData[0]['Name']!=null?itemData[0]['Name'].toString(): franchiseeName.text;
        franchiseeContactPerson.text=itemData[0]['Contact_Person']!=null?itemData[0]['Contact_Person'].toString(): franchiseeContactPerson.text;
        franchiseeAddress.text=itemData[0]['Address']!=null?itemData[0]['Address'].toString(): franchiseeAddress.text;
        selectedCity=itemData[0]['District']!=null?itemData[0]['District'].toString(): selectedCity;
        stateName=itemData[0]['State']!=null?itemData[0]['State'].toString(): stateName;
        pincode.text=itemData[0]['Pin_Code']!=null?itemData[0]['Pin_Code'].toString(): pincode.text;
        countryName=itemData[0]['Country']!=null?itemData[0]['Country'].toString(): countryName;
        franchiseeMobileNo.text=itemData[0]['Contact_No']!=null?itemData[0]['Contact_No'].toString(): franchiseeMobileNo.text;
        franchiseeEmail.text=itemData[0]['EMail']!=null?itemData[0]['EMail'].toString(): franchiseeEmail.text;
        franchiseefssaiNo.text=itemData[0]['FSSAI_No']!=null?itemData[0]['FSSAI_No'].toString(): franchiseefssaiNo.text;
        franchiseeOutstandingLimit.text=itemData[0]['Outstanding_Limit']!=null?itemData[0]['Outstanding_Limit'].toString(): franchiseeOutstandingLimit.text;
        selectedLimitUnit= itemData[0]['Outstanding_Limit_Type']!=null?itemData[0]['Outstanding_Limit_Type'].toString():selectedLimitUnit;
        franchiseePaymentDays.text=itemData[0]['Payment_Days']!=null?itemData[0]['Payment_Days'].toString(): franchiseePaymentDays.text;
        isLoaderShow=false;
      });
    }
  }

}

