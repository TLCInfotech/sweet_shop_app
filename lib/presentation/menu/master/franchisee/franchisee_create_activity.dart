

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
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';

import '../../../common_widget/get_country_layout.dart';
import '../../../common_widget/get_district_layout.dart';
import '../../../common_widget/get_image_from_gallary_or_camera.dart';
import '../../../common_widget/get_state_value.dart';
import '../../../common_widget/signleLine_TexformField.dart';


class CreateFranchisee extends StatefulWidget {
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
String stateName="";

  String selectedState = ""; // Initial dummy data

  String selectedCity = ""; // Initial dummy data

  String selectedCountry = "";

  File? aadharCardFile;

  File? panCardFile;

  File? gstCardFile;

  List<String> LimitDataUnit = ["Cr","Dr"];

  String ?selectedLimitUnit = null;
  File? adharFile ;
  File? panFile ;
  File? gstFile ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                title: Text(
                  StringEn.ADD_FRANCHISEE,
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
                getFieldTitleLayout(StringEn.BASIC_INFO),
                BasicInfo(),
                SizedBox(height: 20,),
                getFieldTitleLayout(StringEn.DOCUMENT_INFO),
                Document_Information(),
                SizedBox(height: 20.0),
                getFieldTitleLayout(StringEn.ACCOUNT_INFO),
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
                        focusnext: _franchiseePaymentDaysFocus,
                      ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getStateLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                          getCountryLayout(   SizeConfig.screenHeight, SizeConfig.screenWidth),
                        ],
                      ),

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
      title: StringEn.BANK_NAME,
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
          return StringEn.ENTER+StringEn.BANK_NAME;
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
      title: StringEn.BANT_BRACH,
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
          return StringEn.ENTER+StringEn.BANT_BRACH;
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
      title: StringEn.IFSC_CODE,
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
          return StringEn.ENTER+StringEn.BANT_BRACH;
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
      title: StringEn.ACCOUNT_HOLDER_NAME,
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
          return StringEn.ENTER+StringEn.BANT_BRACH;
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
      title: StringEn.ACCOUNT_NO,
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
          return StringEn.ENTER+StringEn.BANT_BRACH;
        }
        return null;
      },
    );

  }

  /* Widget for country text from field layout */
  Widget getCountryLayout(double parentHeight, double parentWidth) {
    return GetCountryLayout(
        title:  StringEn.COUNTRY,
        callback: (name){
          setState(() {
            countryName=name!;
          });
        },
        countryName: countryName);
  }


  /* Widget for state text from field layout */
  Widget getStateLayout(double parentHeight, double parentWidth) {
    return GetStateLayout(
        title:  StringEn.STATE,
        callback: (name){
          setState(() {
            stateName=name!;
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
        callbackFile: (file){
          setState(() {
            picImage=file;
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



  /* widget for franchisee payment days layout */
  Widget getPaymentDaysLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      controller: franchiseePaymentDays,
      focuscontroller: _franchiseePaymentDaysFocus,
      focusnext: _bankNameFocus,
      title: StringEn.FRANCHISEE_PAYMENT_DAYS,
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
          return StringEn.ENTER+StringEn.PAYMENT_DAYS;
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
        title: StringEn.FRANCHISEE_OUTSTANDING_LIMIT,
        callbackOnchage: (value) {
          setState(() {
            franchiseeOutstandingLimit.text = value;
          });
        },
        textInput: TextInputType.emailAddress,
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
        validation: (value) {
          if (value!.isEmpty) {
            return StringEn.ENTER+StringEn.FRANCHISEE_OUTSTANDING_LIMIT;
          }
          else if (Util.isEmailValid(value)) {
            return "Enter Valid Email";
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
      title: StringEn.FRANCHISEE_EMAIL,
      callbackOnchage: (value) {
        setState(() {
          franchiseeEmail.text = value;
        });
      },
      textInput: TextInputType.emailAddress,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return "Enter Email Address";
        }
        else if (Util.isEmailValid(value)) {
          return "Enter Valid Email";
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
      title: StringEn.FRANCHISEE_MOBILENO,
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
          return "Enter Mobile No.";
        }
        else if (Util.isMobileValid(value)) {
          return "Enter Valid Mobile No.";
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
      title: StringEn.PIN_CODE,
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
          return "Enter Contact Person";
        }
        return null;
      },
    );
  }

  /* Widget for city text from field layout */
  Widget getCityLayout(double parentHeight, double parentWidth) {
    return GetDistrictLayout(
        title:  StringEn.CITY,
        callback: (name){
          setState(() {
            selectedCity=name!;
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
      title: StringEn.USER_NAME,
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
          return "Enter Contact Person";
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
      title: StringEn.FRANCHISEE_ADDRESS,
      callbackOnchage: (value) {
        setState(() {
          franchiseeAddress.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 3,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
      validation: (value) {
        if (value!.isEmpty) {
          return "Enter Contact Person";
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
      title: StringEn.FRANCHISEE_NAME,
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
          return "Enter Franchisee Name";
        }
        return null;
      }),
    );

  }



}

