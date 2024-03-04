import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_country_layout.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_district_layout.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_state_value.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../common_widget/get_image_from_gallary_or_camera.dart';
import '../../../common_widget/signleLine_TexformField.dart';

class CompanyCreate extends StatefulWidget {
  const CompanyCreate({super.key});

  @override
  State<CompanyCreate> createState() => _CompanyCreateState();
}

class _CompanyCreateState extends State<CompanyCreate> {

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
 File? picImage;
  String countryName = "";
  String countryId = "";
  String stateName = "";
  String stateId = "";
  Color currentColor = CommonColor.THEME_COLOR;
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;

  File? adharFile;
  File? panFile;
  File? gstFile;

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
                title:  Text(
    ApplicationLocalizations.of(context)!.translate("company")! ,
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
    return GetSingleImage(
        height: parentHeight * .25,
        width: parentHeight * .25,
        picImage: picImage,
        callbackFile: (file){
          setState(() {
            picImage=file;
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
    return SingleLineEditableTextFormField(
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
    );

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
    return GetDistrictLayout(
        title: ApplicationLocalizations.of(context)!.translate("city")!,
        callback: (name,id){
          setState(() {
            districtController.text=name!;
          });
        },
        districtName: districtController.text);
  }

  /* Widget for state text from field layout */
  Widget getStateLayout(double parentHeight, double parentWidth) {
    return GetStateLayout(
        title:   ApplicationLocalizations.of(context)!.translate("state")! ,
        callback: (name,id){
          setState(() {
            stateName=name!;
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

}
