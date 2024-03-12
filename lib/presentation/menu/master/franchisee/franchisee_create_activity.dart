

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
import 'package:sweet_shop_app/core/util.dart';
import 'package:sweet_shop_app/data/domain/franchisee/post_franchisee_request_model.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';

import '../../../../core/app_preferance.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../common_widget/get_country_layout.dart';
import '../../../common_widget/get_district_layout.dart';
import '../../../common_widget/get_image_from_gallary_or_camera.dart';
import '../../../common_widget/get_state_value.dart';
import '../../../common_widget/signleLine_TexformField.dart';


class CreateFranchisee extends StatefulWidget {
  final editItem;
  const CreateFranchisee({super.key,this.editItem});

  @override
  _CreateFranchiseeState createState() => _CreateFranchiseeState();
}

class _CreateFranchiseeState extends State<CreateFranchisee> with SingleTickerProviderStateMixin
{


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

  String ?selectedLimitUnit = null;
  File? adharFile ;
  File? panFile ;
  File? gstFile ;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<int> picImageBytes=[];

  List<int> adharImageBytes=[];
  List<int> panImageBytes=[];
  List<int> gstImageBytes=[];

  bool isLoaderShow=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  setData()async{
    if(widget.editItem!=null){
      File ?f=null;
      File ?a=null;
      File ?p=null;
      File ?g=null;
      if(widget.editItem['Photo']!=null&&widget.editItem['Photo']['data']!=null && widget.editItem['Photo']['data'].length>10) {
        f = await CommonWidget.convertBytesToFile(widget.editItem['Photo']['data']);
      }
      if(widget.editItem['Adhar_Card_Image']!=null&&widget.editItem['Adhar_Card_Image']['data']!=null && widget.editItem['Adhar_Card_Image']['data'].length>10) {
        a = await CommonWidget.convertBytesToFile(widget.editItem['Adhar_Card_Image']['data']);
      }
      if(widget.editItem['PAN_Card_Image']!=null&&widget.editItem['PAN_Card_Image']['data']!=null && widget.editItem['PAN_Card_Image']['data'].length>10) {
        p = await CommonWidget.convertBytesToFile(widget.editItem['PAN_Card_Image']['data']);
      }
      if(widget.editItem['GST_Image']!=null&&widget.editItem['GST_Image']['data']!=null && widget.editItem['GST_Image']['data'].length>10) {
        g = await CommonWidget.convertBytesToFile(widget.editItem['GST_Image']['data']);
      }
      setState(()  {
        picImageBytes=(widget.editItem['Photo']!=null && widget.editItem['Photo']['data']!=null && widget.editItem['Photo']['data'].length>10)?(widget.editItem['Photo']['data']).whereType<int>().toList():[];
        picImage=f!=null?f:picImage;
        adharImageBytes=(widget.editItem['Adhar_Card_Image']!=null&&widget.editItem['Adhar_Card_Image']['data']!=null && widget.editItem['Adhar_Card_Image']['data'].length>10)?(widget.editItem['Adhar_Card_Image']['data']).whereType<int>().toList():[];
        adharFile=a!=null?a:adharFile;
        panImageBytes=(widget.editItem['PAN_Card_Image']!=null&&widget.editItem['PAN_Card_Image']['data']!=null && widget.editItem['PAN_Card_Image']['data'].length>10)?(widget.editItem['PAN_Card_Image']['data']).whereType<int>().toList():[];
        panFile=p!=null?p:panFile;
        gstImageBytes=(widget.editItem['GST_Image']!=null&&widget.editItem['GST_Image']['data']!=null && widget.editItem['GST_Image']['data'].length>10)?(widget.editItem['GST_Image']['data']).whereType<int>().toList():[];
        gstFile=g!=null?g:gstFile;
        adharNoController.text=widget.editItem['Adhar_No']!=null?widget.editItem['Adhar_No'].toString():adharNoController.text;
        panNoController.text=widget.editItem['PAN_No']!=null?widget.editItem['PAN_No'].toString():panNoController.text;
        gstNoController.text=widget.editItem['GST_No']!=null?widget.editItem['GST_No'].toString():gstNoController.text;
        bankNameController.text=widget.editItem['Bank_Name']!=null?widget.editItem['Bank_Name'].toString():bankNameController.text;
        bankBranchController.text=widget.editItem['Bank_Branch']!=null?widget.editItem['Bank_Branch'].toString():bankBranchController.text;
        IFSCCodeController.text=widget.editItem['IFSC_Code']!=null?widget.editItem['IFSC_Code'].toString():IFSCCodeController.text;
        accountNoController.text=widget.editItem['Account_No']!=null?widget.editItem['Account_No'].toString():accountNoController.text;
        aCHolderNameController.text=widget.editItem['AC_Holder_Name']!=null?widget.editItem['AC_Holder_Name'].toString(): aCHolderNameController.text;
        franchiseeName.text=widget.editItem['Name']!=null?widget.editItem['Name'].toString(): franchiseeName.text;
        franchiseeContactPerson.text=widget.editItem['Contact_Person']!=null?widget.editItem['Contact_Person'].toString(): franchiseeContactPerson.text;
        franchiseeAddress.text=widget.editItem['Address']!=null?widget.editItem['Address'].toString(): franchiseeAddress.text;
        selectedCity=widget.editItem['District']!=null?widget.editItem['District'].toString(): selectedCity;
        stateName=widget.editItem['State']!=null?widget.editItem['State'].toString(): stateName;
        pincode.text=widget.editItem['Pin_Code']!=null?widget.editItem['Pin_Code'].toString(): pincode.text;
        countryName=widget.editItem['Country']!=null?widget.editItem['Country'].toString(): countryName;
        franchiseeMobileNo.text=widget.editItem['Contact_No']!=null?widget.editItem['Contact_No'].toString(): franchiseeMobileNo.text;
       franchiseeEmail.text=widget.editItem['EMail']!=null?widget.editItem['EMail'].toString(): franchiseeEmail.text;
      franchiseefssaiNo.text=widget.editItem['FSSAI_No']!=null?widget.editItem['FSSAI_No'].toString(): franchiseefssaiNo.text;
        franchiseeOutstandingLimit.text=widget.editItem['Outstanding_Limit']!=null?widget.editItem['Outstanding_Limit'].toString(): franchiseeOutstandingLimit.text;
         selectedLimitUnit=widget.editItem['Outstanding_Limit_Type']!=null?widget.editItem['Outstanding_Limit_Type'].toString(): selectedLimitUnit;
         franchiseePaymentDays.text=widget.editItem['Payment_Days']!=null?widget.editItem['Payment_Days'].toString(): franchiseePaymentDays.text;
      });
    }
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
                title: widget.editItem!=null?
                Text(
                  ApplicationLocalizations.of(context)!.translate("update")!+" "+ApplicationLocalizations.of(context)!.translate("franchisee")!,
                  style: appbar_text_style,
                ) :Text(
                  ApplicationLocalizations.of(context)!.translate("franchisee_new")!,
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
            onTap: () async{
              if (mounted) {
                String baseurl=await AppPreferences.getDomainLink();
                setState(() {
                  disableColor = true;

                  if(widget.editItem!=null){
                    String apiUrl = baseurl + ApiConstants().franchisee+"/"+widget.editItem['ID'].toString();
                    callPostFranchisee(apiRequestHelper.callAPIsForPutAPI,apiUrl);
                    // callUpdateFranchisee();
                  }else{
                    String apiUrl = baseurl + ApiConstants().franchisee;
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
                    child:widget.editItem!=null?
                    Text(
                      ApplicationLocalizations.of(context)!.translate("update")!,
                      style: page_heading_textStyle,
                    )
                        :  Text(
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
                getFieldTitleLayout( ApplicationLocalizations.of(context)!.translate("basic_information")!),
                BasicInfo(),
                SizedBox(height: 20,),
                getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("document_information")!),
                Document_Information(),
                SizedBox(height: 20.0),
                getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("account_information")!),
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
                        callbackFile: (File? file)async {
                          Uint8List? bytes = await file?.readAsBytes();
                          setState(() {
                            adharFile=file;
                            adharImageBytes = (bytes)!.whereType<int>().toList();
                          });
                        },
                        title:      ApplicationLocalizations.of(context)!.translate("adhar_number")!,
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
                        callbackFile: (File? file) async{
                          Uint8List? bytes = await file?.readAsBytes();
                          setState(() {
                            panFile=file;
                            panImageBytes = (bytes)!.whereType<int>().toList();
                          });
                        },
                        title:  ApplicationLocalizations.of(context)!.translate("pan_number")!,
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

                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [
                      getFranchiseeNameLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                      getContactPersonLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                      getAddressLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getCityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
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
    return SingleLineEditableTextFormField(
      controller: bankNameController,
      focuscontroller: _bankNameFocus,
      focusnext: _bankBranchFocus,
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
    return SingleLineEditableTextFormField(
      controller: bankBranchController,
      focuscontroller: _bankBranchFocus,
      focusnext: _IFSCCodeFocus,
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
    return SingleLineEditableTextFormField(
      controller: IFSCCodeController,
      focuscontroller: _IFSCCodeFocus,
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
    return SingleLineEditableTextFormField(
      controller: aCHolderNameController,
      focuscontroller: _aCHolderNameFocus,
      focusnext: _accountNoFocus,
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
    return SingleLineEditableTextFormField(
      controller: accountNoController,
      focuscontroller: _accountNoFocus,
      focusnext: _franchiseeNameFocus,
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
    return GetCountryLayout(
        title:  ApplicationLocalizations.of(context)!.translate("country")!,
        callback: (name,id){
          setState(() {
            countryName=name!;
            countryId=id!;
          });
        },
        countryName: countryName);
  }


  /* Widget for state text from field layout */
  Widget getStateLayout(double parentHeight, double parentWidth) {
    return GetStateLayout(
        title:  ApplicationLocalizations.of(context)!.translate("state")!,
        callback: (name,id){
          setState(() {
            stateName=name!;
            stateId=id!;
          });
        },
        stateName: stateName);
  }

  /* widget for image layout */
  Widget getImageLayout(double parentHeight, double parentWidth) {
    return  GetSingleImage(
        height: parentHeight * .15,
        width: parentHeight * .15,
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
    return SingleLineEditableTextFormField(
      controller: franchiseePaymentDays,
      focuscontroller: _franchiseePaymentDaysFocus,
      focusnext: _bankNameFocus,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: SingleLineEditableTextFormField(
      controller: franchiseeOutstandingLimit,
        focuscontroller: _franchiseeOutstandingLimitFocus,
        focusnext: _adharoFocus,
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
              ApplicationLocalizations.of(context)!.translate("unit")!, style: hint_textfield_Style,),
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
    return SingleLineEditableTextFormField(
      controller: franchiseeEmail,
      focuscontroller: _franchiseeEmailFocus,
      focusnext: _adharoFocus,
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
    return SingleLineEditableTextFormField(
      controller: franchiseeMobileNo,
      focuscontroller: _franchiseeMobileNoFocus,
      focusnext: _franchiseeEmailFocus,
      title: ApplicationLocalizations.of(context)!.translate("mobile_no")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseeMobileNo.text = value;
        });
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
          return ApplicationLocalizations.of(context)!.translate("mobile_no")!;
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
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      controller: pincode,
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
    return GetDistrictLayout(
        title: ApplicationLocalizations.of(context)!.translate("city")!,
        callback: (name,id){
          setState(() {
            selectedCity=name!;
            cityId =id!;
          });
        },
        districtName: selectedCity);

  }

  /* widget for Contact Person layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: franchiseeContactPerson,
      focuscontroller: _franchiseeContactPersonFocus,
      focusnext: _franchiseeAddressFocus,
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
      controller: franchiseeAddress,
      focuscontroller: _franchiseeAddressFocus,
      focusnext: _pincodeFocus,
      title:ApplicationLocalizations.of(context)!.translate("address")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseeAddress.text = value;
        });
      },
      textInput: TextInputType.streetAddress,
      maxlines: 3,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z \,]')),
      validation: (value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("address")!;
        }
        return null;
      },
    );

  }


  /* widget for Franchisee name layout */
  Widget getFranchiseeNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: franchiseeName,
      focuscontroller: _franchiseeNameFocus,
      focusnext: _franchiseeContactPersonFocus,
      title: ApplicationLocalizations.of(context)!.translate("franchisee_name")!,
      callbackOnchage: (value) {
        setState(() {
          franchiseeName.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: ((value) {
        if (value!.isEmpty) {
          return ApplicationLocalizations.of(context)!.translate("franchisee_name")!;
        }
        return null;
      }),
    );
  }

  callPostFranchisee(callmethod,apiUrl) async {

    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostFranchiseeRequestModel model = PostFranchiseeRequestModel(
            name: franchiseeName.text.trim(),
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
            photo: picImageBytes,
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
            pANCardImage: panImageBytes,
            adharCardImage: adharImageBytes,
            gSTImage: gstImageBytes,
      );
      if(widget.editItem!=null){
        model.modifier=creatorName;
        model.modifierMachine=deviceId;
      }
      else{
      model.creator= creatorName;
      model.creatorMachine=deviceId;
      }



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

}

