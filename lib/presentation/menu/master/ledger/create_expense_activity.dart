import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/imagePicker/image_picker_handler.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/common_widget/document_picker.dart';
import 'package:sweet_shop_app/presentation/dialog/tax_category_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/tax_type_dialog.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/ledger/post_ledger_request_model.dart';
import '../../../../data/domain/ledger/put_ledger_request_model.dart';
import '../../../common_widget/get_country_layout.dart';
import '../../../common_widget/get_district_layout.dart';
import '../../../common_widget/get_image_from_gallary_or_camera.dart';
import '../../../common_widget/get_state_value.dart';
import '../../../common_widget/signleLine_TexformField.dart';

class CreateExpenseActivity extends StatefulWidget {
  final CreateExpenseActivityInterface mListener;
  final   ledgerList;
  const CreateExpenseActivity({super.key, required this.mListener,  this.ledgerList});


  @override
  State<CreateExpenseActivity> createState() => _CreateExpenseActivityState();
}

class _CreateExpenseActivityState extends State<CreateExpenseActivity>
    with
        SingleTickerProviderStateMixin, TaxDialogInterface , TaxCategoryDialogInterface {
  bool checkActiveValue = false;
  final _nameFocus = FocusNode();
  final nameController = TextEditingController();

  final _addressFocus = FocusNode();
  final addressController = TextEditingController();

  final _districtCity = FocusNode();
  final districtController = TextEditingController();

  final _contactFocus = FocusNode();
  final contactController = TextEditingController();

  final _extNameFocus = FocusNode();
  final extNameController = TextEditingController();
  final _addTwoFocus = FocusNode();
  final addTwoController = TextEditingController();
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
  final _outstandingLimitFocus = FocusNode();
  final outstandingLimitController = TextEditingController();
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
  bool isApiCall = false;
  late InternetConnectionStatus internetStatus;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  bool isLoaderShow=false;

  var editedItem=null;
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

/*  String name = nameController.text.trim();
  String contactPerson = contactPersonController.text.trim();
  String address = addressController.text.trim();
  String pinCode = pinCodeController.text.trim();
  String contactNo = contactController.text.trim();
  String emailAdd = emailController.text.trim();
  String outLimit = outstandingLimitController.text.trim();
  String extName = extNameController.text.trim();
  String adharNo = adharNoController.text.trim();
  String panNo = panNoController.text.trim();
  String gstNo = gstNoController.text.trim();
  String hsnNo = hsnNoController.text.trim();
  String taxRate = taxRateController.text.trim();
  String cgstNo = CGSTController.text.trim();
  String sgstNo = SGSTController.text.trim();
  String cess = cessController.text.trim();
  String addCess = addCessController.text.trim();
  String bankName = bankNameController.text.trim();
  String bankBranch = bankBranchController.text.trim();
  String ifscCode = IFSCCodeController.text.trim();
  String accountNo = accountNoController.text.trim();
  String aCHName = aCHolderNameController.text.trim();*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }
  File? adharFile ;
  File? panFile ;
  File? gstFile ;

setData()async{
  if(widget.ledgerList!=null){
    nameController.text=widget.ledgerList['Name'];
    contactPersonController.text=widget.ledgerList['Contact_Person']!=null?widget.ledgerList['Contact_Person']:contactPersonController.text;

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
                  // color: Colors.red,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: AppBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: Colors.white,
                    title:  Text(
                      ApplicationLocalizations.of(context)!.translate("ledger_new")!,
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


  List<String> LimitDataUnit = ["Cr","Dr"];

  String ?selectedLimitUnit = null;

  double opacityLevel = 1.0;


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
                  getFieldTitleLayout(ApplicationLocalizations.of(context)!.translate("basic_information")!, ),
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
                  getFieldTitleLayout(    ApplicationLocalizations.of(context)!.translate("document_information")!, ),
                  Container(
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
                        title: ApplicationLocalizations.of(context)!.translate("adhar_number")!, 
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
                        title:      ApplicationLocalizations.of(context)!.translate("pan_number")! ,
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
                        title:      ApplicationLocalizations.of(context)!.translate("gst_number")!,
                        documentFile: gstFile,
                        controller: gstNoController,
                        focuscontroller: _gstNoFocus,
                        focusnext: _cinNoFocus,
                      ),
                    ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  getFieldTitleLayout(    ApplicationLocalizations.of(context)!.translate("tax_information")!, ),
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
                  getFieldTitleLayout(    ApplicationLocalizations.of(context)!.translate("account_information")!, ),
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
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! + ApplicationLocalizations.of(context)!.translate("name")! ;
        }
        return null;
      },
      controller: nameController,
      focuscontroller: _nameFocus,
      focusnext: _leaderGroupFocus,
      title:     ApplicationLocalizations.of(context)!.translate("name")! ,
      callbackOnchage: (value) {
        setState(() {
          nameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }

  /* Widget for leader group text from field layout */
  Widget getLeaderGroupLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +    ApplicationLocalizations.of(context)!.translate("ledger_group")! ;
        }
        return null;
      },
      controller: leaderGroupController,
      focuscontroller: _leaderGroupFocus,
      focusnext: _contactPersonFocus,
      title:     ApplicationLocalizations.of(context)!.translate("ledger_group")! ,
      callbackOnchage: (value) {
        setState(() {
          leaderGroupController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );


  }


  /* Widget for contact person text from field layout */
  Widget getContactPersonLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! + ApplicationLocalizations.of(context)!.translate("contact_person")! ;
        }
        return null;
      },
      controller: contactPersonController,
      focuscontroller: _contactPersonFocus,
      focusnext: _addressFocus,
      title:     ApplicationLocalizations.of(context)!.translate("contact_person")! ,
      callbackOnchage: (value) {
        setState(() {
          contactPersonController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
    );

  }

  /* Widget for description text from field layout */
  Widget getAddressLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("address")!;
        }
        return null;
      },
      controller: addressController,
      focuscontroller: _addressFocus,
      focusnext: _districtCity,
      title:     ApplicationLocalizations.of(context)!.translate("address")! ,
      callbackOnchage: (value) {
        setState(() {
          addressController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 3,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
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
    return SingleLineEditableTextFormField( validation: (value) {
      if (value!.isEmpty) {
        return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("contact_no")! ;
      }
      return null;
    },
      controller: contactController,
      focuscontroller: _contactFocus,
      focusnext: _emailFocus,
      title:   ApplicationLocalizations.of(context)!.translate("contact_no")! ,
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
    return SingleLineEditableTextFormField( validation: (value) {
      if (value!.isEmpty) {
        return     ApplicationLocalizations.of(context)!.translate("enter")! +   ApplicationLocalizations.of(context)!.translate("email_address")! ;
      }
      return null;
    },
      controller: emailController,
      focuscontroller: _emailFocus,
      focusnext: _addTwoFocus,
      title:  ApplicationLocalizations.of(context)!.translate("email_address")! ,
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



  /* Widget for outstanding limit text from field layout */
  Widget getOutstandingLimitLayout(double parentHeight, double parentWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: SingleLineEditableTextFormField(
              controller: outstandingLimitController,
              focuscontroller: _outstandingLimitFocus,
              focusnext: _extNameFocus,
              title: ApplicationLocalizations.of(context)!.translate("outstanding_limit")!,
              callbackOnchage: (value) {
                setState(() {
                  outstandingLimitController.text = value;
                });
              },
              textInput: TextInputType.number,
              maxlines: 1,
              format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              validation: (value) {
                if (value!.isEmpty) {
                  return     ApplicationLocalizations.of(context)!.translate("enter")! + ApplicationLocalizations.of(context)!.translate("outstanding_limit")! ;
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
             Text(
              ApplicationLocalizations.of(context)!.translate("tax_type")!,
              style: item_heading_textStyle,
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
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("hsn_no")!;
        }
        return null;
      },
      controller: hsnNoController,
      focuscontroller: _hsnNoFocus,
      focusnext: _taxRateFocus,
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



  /* Widget for CGST text from field layout */
  Widget getCGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("cgst_percent")!;
        }
        return null;
      },
      controller: CGSTController,
      focuscontroller: _CGSTFocus,
      focusnext: _SGSTFocus,
      title: ApplicationLocalizations.of(context)!.translate("cgst_percent")!,
      callbackOnchage: (value) {
        setState(() {
          CGSTController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }

/* Widget for cess text from field layout */
  Widget getCessLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("cess_percent")!;
        }
        return null;
      },
      controller: cessController,
      focuscontroller: _cessFocus,
      focusnext: _addCessFocus,
      title: ApplicationLocalizations.of(context)!.translate("cess_percent")!,
      callbackOnchage: (value) {
        setState(() {
          cessController.text = value;
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
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
             Text(
              ApplicationLocalizations.of(context)!.translate("tax_category")!,
              style: item_heading_textStyle,
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
                            taxCategoryName == "" ? ApplicationLocalizations.of(context)!.translate("select_category")!: taxCategoryName,
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
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("tax_rate")!;
        }
        return null;
      },
      controller: taxRateController,
      focuscontroller: _taxRateFocus,
      focusnext: _CGSTFocus,
      title: ApplicationLocalizations.of(context)!.translate("tax_rate")!,
      callbackOnchage: (value) {
        setState(() {
          taxRateController.text = value;
        });
      },
      textInput: TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 \.]')),
    );

  }



  /* Widget for SGST text from field layout */
  Widget getSGSTLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("sgst_percent")!;
        }
        return null;
      },
      controller: SGSTController,
      focuscontroller: _SGSTFocus,
      focusnext: _cessFocus,
      title: ApplicationLocalizations.of(context)!.translate("sgst_percent")!,
      callbackOnchage: (value) {
        setState(() {
          SGSTController.text = value;
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }



  /* Widget for add cess text from field layout */
  Widget getAddCessLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      parentWidth: parentWidth,
      validation: (value) {

        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("add_cess_percent")!;
        }
        return null;
      },
      controller: addCessController,
      focuscontroller: _addCessFocus,
      focusnext: _bankNameFocus,
      title: ApplicationLocalizations.of(context)!.translate("add_cess_percent")!,
      callbackOnchage: (value) {
        setState(() {
          addCessController.text = value;
        });
      },
      textInput:  TextInputType.numberWithOptions(decimal: true),
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z \.]')),
    );

  }






  /* Widget for distric/city text from field layout */
  Widget getDistrictCityLayout(double parentHeight, double parentWidth) {
    return GetDistrictLayout(
        title:  ApplicationLocalizations.of(context)!.translate("city")!,
        callback: (name){
          setState(() {
            districtController.text=name!;
          });
        },
        districtName: districtController.text);

  }

  /* Widget for state text from field layout */
  Widget getStateLayout(double parentHeight, double parentWidth) {
    return GetStateLayout(
        title:  ApplicationLocalizations.of(context)!.translate("state")!,
        callback: (name){
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
      title: ApplicationLocalizations.of(context)!.translate("pin_code")!,
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
          return ApplicationLocalizations.of(context)!.translate("enter")!+ApplicationLocalizations.of(context)!.translate("pin_code")!;
        }
        return null;
      },
      parentWidth: (SizeConfig.screenWidth ),
    );

  }


  /* Widget for country text from field layout */
  Widget getCountryLayout(double parentHeight, double parentWidth) {
    return GetCountryLayout(
        title:  ApplicationLocalizations.of(context)!.translate("country")!,
        callback: (name){
          setState(() {
            countryName=name!;
          });
        },
        countryName: countryName);

  }


  /* Widget for ext name text from field layout */
  Widget getExtNameLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
        if (value!.isEmpty) {
          return     ApplicationLocalizations.of(context)!.translate("enter")! + ApplicationLocalizations.of(context)!.translate("ext_name")!;
        }
        return null;
      },
      controller: extNameController,
      focuscontroller: _extNameFocus,
      focusnext: _adharoFocus,
      title:  ApplicationLocalizations.of(context)!.translate("ext_name")!,
      callbackOnchage: (value) {
        setState(() {
          extNameController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z]')),
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
                child: Text( ApplicationLocalizations.of(context)!.translate("tsc_tds_applicable")!,
                  style: page_heading_textStyle,)
            ),
          ),
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
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("bank_name")!;
        }

        return null;
      },
    );


  }

  /* Widget for bank branch name text from field layout */
  Widget getBankBranchNameLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormField(
      controller: bankBranchController,
      focuscontroller: _bankBranchFocus,
      focusnext: _IFSCCodeFocus,
      title:     ApplicationLocalizations.of(context)!.translate("bank_branch")! ,
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
          return     ApplicationLocalizations.of(context)!.translate("enter")! +    ApplicationLocalizations.of(context)!.translate("bank_branch")! ;
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
          return     ApplicationLocalizations.of(context)!.translate("enter")! +    ApplicationLocalizations.of(context)!.translate("bank_branch")! ;
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
      title:ApplicationLocalizations.of(context)!.translate("ac_holder_name")!,
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
          return     ApplicationLocalizations.of(context)!.translate("enter")! +    ApplicationLocalizations.of(context)!.translate("bank_branch")! ;
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
      focusnext: _bankNameFocus,
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
          return     ApplicationLocalizations.of(context)!.translate("enter")! +ApplicationLocalizations.of(context)!.translate("bank_branch")! ;
        }
        return null;
      },
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
              if (mounted) {
                setState(() {
                  disableColor = true;
                  callPostLedgerGroup();
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

  callPostLedgerGroup() async {
    String name = nameController.text.trim();
    String contactPerson = contactPersonController.text.trim();
    String address = addressController.text.trim();
    String pinCode = pinCodeController.text.trim();
    String contactNo = contactController.text.trim();
    String emailAdd = emailController.text.trim();
    String outLimit = outstandingLimitController.text.trim();
    String extName = extNameController.text.trim();
    String adharNo = adharNoController.text.trim();
    String panNo = panNoController.text.trim();
    String gstNo = gstNoController.text.trim();
    String hsnNo = hsnNoController.text.trim();
    String taxRate = taxRateController.text.trim();
    String cgstNo = CGSTController.text.trim();
    String sgstNo = SGSTController.text.trim();
    String cess = cessController.text.trim();
    String addCess = addCessController.text.trim();
    String bankName = bankNameController.text.trim();
    String bankBranch = bankBranchController.text.trim();
    String ifscCode = IFSCCodeController.text.trim();
    String accountNo = accountNoController.text.trim();
    String aCHName = aCHolderNameController.text.trim();
    String creatorName = await AppPreferences.getUId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        PostLedgerRequestModel model = PostLedgerRequestModel(
name: name,
          groupID: "1",
          contactPerson: contactPerson,
          address: address,
          district: "1",
          state: "2",
          pinCode: pinCode,
          country: "4",
          contactNo: contactNo,
          email: emailAdd,
          panNo: panNo,
          adharNo: adharNo,
          gstNo: gstNo,
          cinNo: "",
          fssaiNo: "",
          outstandingLimit: outLimit,
          bankName: bankName,
          bankBranch: bankBranch,
          ifscCode: ifscCode,
            accountNo: accountNo,
            acHolderName: aCHName,
            hsnNo: hsnNo,
            gstRate: "",
            cgstRate: cgstNo,
            sgstRate: sgstNo,
            cessRate: cess,
            addCessRate: addCess,
            taxCategory: "",//drop
            gstType: "",
            tcsApplicable: "",
            extName: extName,
            remark: "",
            creator: creatorName,
          creatorMachine: deviceId
        );
        String apiUrl = ApiConstants().baseUrl + ApiConstants().ledger;
        apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                widget.mListener.createPostLedger();
              });


            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
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
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }

  }

  callUpdateLadgerGroup() async {
    String name = nameController.text.trim();
    String contactPerson = contactPersonController.text.trim();
    String address = addressController.text.trim();
    String pinCode = pinCodeController.text.trim();
    String contactNo = contactController.text.trim();
    String emailAdd = emailController.text.trim();
    String outLimit = outstandingLimitController.text.trim();
    String extName = extNameController.text.trim();
    String adharNo = adharNoController.text.trim();
    String panNo = panNoController.text.trim();
    String gstNo = gstNoController.text.trim();
    String hsnNo = hsnNoController.text.trim();
    String taxRate = taxRateController.text.trim();
    String cgstNo = CGSTController.text.trim();
    String sgstNo = SGSTController.text.trim();
    String cess = cessController.text.trim();
    String addCess = addCessController.text.trim();
    String bankName = bankNameController.text.trim();
    String bankBranch = bankBranchController.text.trim();
    String ifscCode = IFSCCodeController.text.trim();
    String accountNo = accountNoController.text.trim();
    String aCHName = aCHolderNameController.text.trim();
    String creatorName = await AppPreferences.getUId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        PutLedgerRequestModel model = PutLedgerRequestModel(
            name: name,
            groupID:"1",
          creator: creatorName,
          creatorMachine: deviceId
        );
        print("MODAL");
        print(model.toJson());
        String apiUrl = ApiConstants().baseUrl + ApiConstants().ledger+"/"+editedItem['ID'].toString();
        print(apiUrl);
        apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
            onSuccess:(value)async{
              print("  Put Call :   $value ");
              setState(() {
                editedItem=null;
                widget.mListener.updatePostLedger();
              });
              var snackBar = SnackBar(content: Text('ledger Updated Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

abstract class CreateExpenseActivityInterface {
  createPostLedger();
  updatePostLedger();
}
