import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/domain/company/put_company_request_model.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_country_layout.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_district_layout.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_state_value.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/commonRequest/get_toakn_request.dart';
import '../../../../data/domain/company/post_compnay_request_model.dart';
import '../../../common_widget/get_image_from_gallary_or_camera.dart';
import '../../../common_widget/signleLine_TexformField.dart';
import '../../../dashboard/dashboard_activity.dart';
import '../../../dialog/default_bank_dialog.dart';
import '../../../dialog/district_dialog.dart';

class CompanyCreate extends StatefulWidget {
  final companyId;
  const CompanyCreate({super.key, this.companyId});

  @override
  State<CompanyCreate> createState() => _CompanyCreateState();
}

class _CompanyCreateState extends State<CompanyCreate> with DistrictDialogInterface,DefaultBankDialogInterface{

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

  final _ifscFocus = FocusNode();
  final ifscController = TextEditingController();

  final _fssaiFocus = FocusNode();
  final fssaiController = TextEditingController();

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
 File? picImage;
  String countryName = "";
  String countryId = "";
  String stateName = "";
  String cityId = "";
  String cityName = "";
  String stateId = "";
  Color currentColor = CommonColor.THEME_COLOR;
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;

  File? adharFile;
  File? panFile;
  File? gstFile;
bool isLoaderShow=false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  List<int> picImageBytes=[];
  List comapny = [];
   @override
  initState(){
     super.initState();
     getApiCall();
   }
   String companyId="";
   String defaultBankName="";
   String defaultBankId="";
  List<dynamic> _arrList = [];
   getApiCall()async{
     companyId=await AppPreferences.getCompanyId();
print("hjthghh  $companyId");
     setState(() {
     });
     if(companyId!=""){
       getCompany();

       print("jfjfjbf ${companyId}");
     }else{
       print("emtyyyyy   $companyId");
     }
   }
  setData()async{
    if(_arrList[0]!=null){
      File ?f=null;
      if(_arrList[0]['Photo']!=null&&_arrList[0]['Photo']['data']!=null && _arrList[0]['Photo']['data'].length>10) {
        f = await CommonWidget.convertBytesToFile(_arrList[0]['Photo']['data']);
      }

      picImageBytes=(_arrList[0]['Photo']!=null && _arrList[0]['Photo']['data']!=null && _arrList[0]['Photo']['data'].length>10)?(_arrList[0]['Photo']['data']).whereType<int>().toList():[];
      picImage=f!=null?f:picImage;
      nameController.text=_arrList[0]['Name'] ?? nameController.text;
      contactPersonController.text=_arrList[0]['Contact_Person'] ?? contactPersonController.text;
   addressController.text=_arrList[0]['Address'] ?? addressController.text;
   cityName=_arrList[0]['District'] ?? cityName;
   pinCodeController.text=_arrList[0]['Pin_Code'] ?? pinCodeController.text;
   stateId=_arrList[0]['State'] ?? stateId;
   stateName=_arrList[0]['State'] ?? stateName;
   countryId=_arrList[0]['Country'] ?? countryId;
   countryName=_arrList[0]['Country'] ?? countryName;
   contactController.text=_arrList[0]['Contact_No'] ?? contactController.text;
   emailController.text=_arrList[0]['EMail'] ?? emailController.text;
   addTwoController.text=_arrList[0]['Address2'] ?? addTwoController.text;
      defaultBankName=_arrList[0]['Bank_Name'] ?? defaultBankName;
   extNameController.text=_arrList[0]['Ext_Name'] ?? extNameController.text;
   adharNoController.text=_arrList[0]['Adhar_No'] ?? adharNoController.text;
   panNoController.text=_arrList[0]['PAN_No'] ?? panNoController.text;
   gstNoController.text=_arrList[0]['GST_No'] ?? gstNoController.text;
        cinNoController.text=_arrList[0]['CIN_No'] ?? cinNoController.text;
        jurisdictionController.text=_arrList[0]['Jurisdiction'] ?? jurisdictionController.text;
        invoiceController.text=_arrList[0]['Declaration'] ?? invoiceController.text;
      fssaiController.text=_arrList[0]['FSSAI_No'] ?? fssaiController.text;
      }
    }


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
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!.translate("company")! ,
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

  double opacityLevel = 1.0;

  // Pick Profile photo
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
                  SizedBox(height: 20.0),
                  CommonWidget.getFieldTitleLayout( ApplicationLocalizations.of(context)!.translate("basic_information")! ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      children: [
                        getNameLayout(parentHeight, parentWidth),
                        getContactPersonLayout(parentHeight, parentWidth),
                        getAddressLayout(parentHeight, parentWidth),
                        Row(
                          children: [
                            getLeftLayout(parentHeight, parentWidth),
                            getRightLayout(parentHeight, parentWidth),
                          ],
                        ),
                        getStateLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                        getCountryLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),

                        getContactNoLayout(parentHeight, parentWidth),
                        getEmilLayout(parentHeight, parentWidth),
                        getAddressTwoLayout(parentHeight, parentWidth),
                        getDefaultBankLayout(parentHeight, parentWidth),
                        getExtNameLayout(parentHeight, parentWidth),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  CommonWidget.getFieldTitleLayout( ApplicationLocalizations.of(context)!.translate("other_information")! ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      children: [
                        // addhar
                        PickDocument(
                          callbackOnchage: (value) {
                            setState(() {
                              adharNoController.text = value;
                            });
                          },
                          callbackFile: (File? file) {
                            setState(() {
                              adharFile = file;
                            });
                          },
                          title:  ApplicationLocalizations.of(context)!.translate("adhar_number")! ,
                          documentFile: adharFile,
                          controller: adharNoController,
                          focuscontroller: _adharoFocus,
                          focusnext: _panNoFocus,
                        ),
                        // pan
                        PickDocument(
                          callbackOnchage: (value) {
                            setState(() {
                              panNoController.text = value;
                            });
                          },
                          callbackFile: (File? file) {
                            setState(() {
                              panFile = file;
                            });
                          },
                          title: ApplicationLocalizations.of(context)!.translate("pan_number")! ,
                          documentFile: panFile,
                          controller: panNoController,
                          focuscontroller: _panNoFocus,
                          focusnext: _gstNoFocus,
                        ),
                        // gst
                        PickDocument(
                          callbackOnchage: (value) {
                            setState(() {
                              gstNoController.text = value;
                            });
                          },
                          callbackFile: (File? file) {
                            setState(() {
                              gstFile = file;
                            });
                          },
                          title:  ApplicationLocalizations.of(context)!.translate("gst_number")! ,
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
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("company_name")!;
          }
          return null;
        },
      controller: nameController,
      focuscontroller: _nameFocus,
      focusnext: _contactPersonFocus,
      title: ApplicationLocalizations.of(context)!.translate("company_name")!,
      callbackOnchage: (value) {
        setState(() {
          nameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
  }

  /* Widget for contact person text from field layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")!  +ApplicationLocalizations.of(context)!.translate("contact_person")!;
          }
          return null;
        },
      controller: contactPersonController,
      focuscontroller: _contactPersonFocus,
      focusnext: _addressFocus,
      title: ApplicationLocalizations.of(context)!.translate("contact_person")!,
      callbackOnchage: (value) {
        setState(() {
          contactPersonController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
  }

  /* Widget for address text from field layout */
  Widget getAddressLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("address")!;
          }
          return null;
        },
      controller: addressController,
      focuscontroller: _addressFocus,
      focusnext: _districtCity,
      title: ApplicationLocalizations.of(context)!.translate("address")!,
      callbackOnchage: (value) {
        setState(() {
          addressController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 6,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
  }

  /* Widget for getting district and state layout */

  Widget getLeftLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(right: parentWidth * .01),
      child: Column(
        children: [
          getDistrictCityLayout(parentHeight, parentWidth),
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
        ],
      ),
    );
  }

  /* Widget for contact no  text from field layout */
  Widget getContactNoLayout(double parentHeight, double parentWidth) {
    return
      SingleLineEditableTextFormField(
        validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("contact_no")!;
          }
          return null;
        },
      controller: contactController,
      focuscontroller: _contactFocus,
      focusnext: _emailFocus,
      title: ApplicationLocalizations.of(context)!.translate("contact_no")!,
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
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("email_address")!;
          }
          return null;
        },
      controller: emailController,
      focuscontroller: _emailFocus,
      focusnext: _addTwoFocus,
      title:ApplicationLocalizations.of(context)!.translate("email_address")!,
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

/* Widget for address two from field layout */
  Widget getAddressTwoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("address_two")!;
          }
          return null;
        },
      controller: addTwoController,
      focuscontroller: _addTwoFocus,
      focusnext: _defaultBankFocus,
      title: ApplicationLocalizations.of(context)!.translate("address_two")!,
      callbackOnchage: (value) {
        setState(() {
          addTwoController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 6,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }

  /* Widget for cin no  text from field layout */
  Widget getFssciNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("cin_no")!;
          }
          return null;
        },
      controller: fssaiController,
      focuscontroller: _fssaiFocus,
      focusnext: _cinNoFocus,
      title:ApplicationLocalizations.of(context)!.translate("cin_no")!,
      callbackOnchage: (value) {
        setState(() {
          fssaiController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }

  /* Widget for cin no  text from field layout */
  Widget getCINNoLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("cin_no")!;
          }
          return null;
        },
      controller: cinNoController,
      focuscontroller: _cinNoFocus,
      focusnext: _jurisdictionFocus,
      title:ApplicationLocalizations.of(context)!.translate("cin_no")!,
      callbackOnchage: (value) {
        setState(() {
          cinNoController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }

  /* Widget for JURISDICTION text from field layout */
  Widget getJURISDICTIONLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("jurisdiction")!;
          }
          return null;
        },
      controller: jurisdictionController,
      focuscontroller: _jurisdictionFocus,
      focusnext: _invoiceFocus,
      title:ApplicationLocalizations.of(context)!.translate("jurisdiction")!,
      callbackOnchage: (value) {
        setState(() {
          jurisdictionController.text = value;
        });
      },
      textInput: TextInputType.emailAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }

  /* Widget for default bank text from field layout */
  Widget getDefaultBankLayout(double parentHeight, double parentWidth) {
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ApplicationLocalizations.of(context)!.translate("default_bank")!,
            style: item_heading_textStyle,
          ),
          GestureDetector(
            onTap: () {
              showGeneralDialog(
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionBuilder: (context, a1, a2, widget) {
                    final curvedValue =
                        Curves.easeInOutBack.transform(a1.value) - 1.0;
                    return Transform(
                      transform: Matrix4.translationValues(
                          0.0, curvedValue * 200, 0.0),
                      child: Opacity(
                        opacity: a1.value,
                        child: DefaultBankDialog(
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
            onDoubleTap: () {},
            child: Padding(
              padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
              child: Container(
                height: (SizeConfig.screenHeight) * .055,
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
                        defaultBankName == "" ? ApplicationLocalizations.of(context)!.translate("default_bank")!  :defaultBankName,
                        style: defaultBankName == ""
                            ? hint_textfield_Style
                            : text_field_textStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: (SizeConfig.screenHeight) * .03,
                        color:
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
    ); /*SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("default_bank")!;
          }
          return null;
        },
      controller: defaultBankController,
      focuscontroller: _defaultBankFocus,
      focusnext: _extNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("default_bank")!,
      callbackOnchage: (value) {
        setState(() {
          defaultBankController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[ A-Z a-z]')),
    );*/

  }

  /* Widget for ext name text from field layout */
  Widget getExtNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("ext_name")!;
          }
          return null;
        },
      controller: extNameController,
      focuscontroller: _extNameFocus,
      focusnext: _adharoFocus,
      title:ApplicationLocalizations.of(context)!.translate("ext_name")!,
      callbackOnchage: (value) {
        setState(() {
          extNameController.text = value;
        });
      },
      textInput: TextInputType.emailAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[A-Z a-z]')),
    );

  }

/* Widget for invoice declaration text from field layout */
  Widget getInvoiceDelcelrationLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")! + ApplicationLocalizations.of(context)!.translate("invoice_declaration")! ;
          }
          return null;
        },
      controller: invoiceController,
      focuscontroller: _invoiceFocus,
      focusnext: null,
      title:ApplicationLocalizations.of(context)!.translate("invoice_declaration")!,
      callbackOnchage: (value) {
        setState(() {
          nameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 6,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );
  }


  /* Widget for distric text from field layout */
  Widget getDistrictCityLayout(double parentHeight, double parentWidth) {
    return Container(
      width: (SizeConfig.screenWidth) * .4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ApplicationLocalizations.of(context)!.translate("select_city")!,
            style: item_heading_textStyle,
          ),
          GestureDetector(
            onTap: () {
              showGeneralDialog(
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionBuilder: (context, a1, a2, widget) {
                    final curvedValue =
                        Curves.easeInOutBack.transform(a1.value) - 1.0;
                    return Transform(
                      transform: Matrix4.translationValues(
                          0.0, curvedValue * 200, 0.0),
                      child: Opacity(
                        opacity: a1.value,
                        child: DistrictDialog(
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
            onDoubleTap: () {},
            child: Padding(
              padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
              child: Container(
                height: (SizeConfig.screenHeight) * .055,
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
                      Container(
                        width:((SizeConfig.screenWidth) * .4 )- 40,
                        child: Text(
                          cityName == "" ? ApplicationLocalizations.of(context)!.translate("select_city")!  : cityName,
                          style: cityName == ""
                              ? hint_textfield_Style
                              : text_field_textStyle,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
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
    return GetStateLayout(
        title:   ApplicationLocalizations.of(context)!.translate("state")! ,
        callback: (name,id){
          setState(() {
            stateName=name!;
            stateId=id!;
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
      title: ApplicationLocalizations.of(context)!.translate("pin_code")! ,
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
          return ApplicationLocalizations.of(context)!.translate("pin_code")!;
        }
        return null;
      },
      parentWidth: (SizeConfig.screenWidth ),
    );
  }

  /* Widget for country text from field layout */
  Widget getCountryLayout(double parentHeight, double parentWidth) {
    return GetCountryLayout(
        title:  ApplicationLocalizations.of(context)!.translate("country")! ,
        callback: (name,id){
          setState(() {
            countryName=name!;
            countryId=id!;
          });
        },
        countryName: countryName);
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
            onTap: () async{
              if(picImage!=null) {
                Uint8List? bytes = await picImage?.readAsBytes();

                setState(() {
                  picImageBytes = (bytes)!.whereType<int>().toList();
                });
                print("IMGE1 : ${picImageBytes.length}");
              }
              if(companyId!=""){
                callCompanyUpdate();
              }else{
                callCompany();
              }
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
                    child:  Text(
    ApplicationLocalizations.of(context)!.translate("save")! ,
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


getCompany()async{
    String sessionToken = await AppPreferences.getSessionToken();
    String baseurl=await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: ""
        );
        String apiUrl = "$baseurl${ApiConstants().company}/$companyId?Company_ID=$companyId";

        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                if(data!=null){

                  _arrList=data;
                  setData();
                }else{
               //   isApiCall=true;
                }

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());

              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
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
              // widget.mListener.loaderShow(false);
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



  callCompany() async {
    String creatorName = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      CompanyRequestModel model = CompanyRequestModel(
        name:nameController.text,
        contactPerson: contactPersonController.text,
        address: addressController.text,
        address2: addTwoController.text,
        district: cityName,
        state: stateName,
        pinCode:pinCodeController.text,
        country: countryName,
        bankName: defaultBankName ,
        ifscCode: "",
        contactNo: contactController.text,
        email:  emailController.text,
        panNo:  panNoController.text,
        photo: picImageBytes.length==0?null:picImageBytes,
        extName: extNameController.text,
        adharNo:  adharNoController.text,
        gstImage: "",
        gstNo: gstNoController.text,
        fssaiNo: fssaiController.text,
        declaration:   invoiceController.text,
        jurisdiction:  jurisdictionController.text,
        cinNo: cinNoController.text,
        panCardImage: "",
        adharCardImage: "",
        creatorMachine: deviceId,
        creator: creatorName
      );
      //  print("IMGE2 : ${(model.Photo)?.length}");
      String apiUrl = baseurl + ApiConstants().company;

      print("CompanyRequestModel       ${model.toJson()}  $apiUrl");

      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            print("  ITEM  $data ");
            setState(() {
             AppPreferences.setCompanyId(data['ID'].toString());
              print("jhjjhjhhjjh  ${data['ID']}");
              isLoaderShow=false;
            });
            var snackBar = SnackBar(content: Text('company created succesfully'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity()));
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
          });

    });
  }

  callCompanyUpdate() async {
    String companyId = await AppPreferences.getCompanyId();
    String creatorName = await AppPreferences.getUId();
    String baseurl=await AppPreferences.getDomainLink();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PutCompanyRequestModel model = PutCompanyRequestModel(
          name:nameController.text,
          contactPerson: contactPersonController.text,
          address: addressController.text,
          address2: addTwoController.text,
          district: cityName,
          state: stateName,
          pinCode:pinCodeController.text,
          country: countryName,
          bankName:defaultBankName ,
          ifscCode: "",
          contactNo: contactController.text,
          email:  emailController.text,
          panNo:  panNoController.text,
          photo: picImageBytes.length==0?null:picImageBytes,
          extName: extNameController.text,
          adharNo:  adharNoController.text,
          gstImage: "",
          gstNo: gstNoController.text,
          fssaiNo: fssaiController.text,
          declaration:   invoiceController.text,
          jurisdiction:  jurisdictionController.text,
          cinNo: cinNoController.text,
          panCardImage: "",
          adharCardImage: "",
          creatorMachine: deviceId,
          creator: creatorName
      );
      //  print("IMGE2 : ${(model.Photo)?.length}");
      String apiUrl = "${baseurl}${ApiConstants().company}/$companyId?Company_ID=$companyId"/*+"/"+_arrList[0]['ID'].toString()*/;
      apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(),"",
          onSuccess:(data){
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=false;
            });
            var snackBar = SnackBar(content: Text('company updated succesfully'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity()));

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
          });

    });
  }

  @override
  selectDistrict(String id, String name) {
    // TODO: implement selectDistrict
setState(() {
  cityName=name;
  cityId=id;
});
  }

  @override
  selctedBank(int id, String name) {
    // TODO: implement selctedBank
    setState(() {
      defaultBankName=name;
      defaultBankId=id.toString();
    });
  }
}
