

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/util.dart';
import 'package:sweet_shop_app/presentation/dialog/city_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/state_dialog.dart';

import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../../core/imagePicker/image_picker_dialog.dart';
import '../../core/imagePicker/image_picker_dialog_for_profile.dart';
import '../../core/imagePicker/image_picker_handler.dart';
import '../../core/size_config.dart';
import '../../core/string_en.dart';
import '../dialog/category_dialog.dart';
import 'package:file_picker/file_picker.dart';

import '../dialog/country_dialog.dart';

class CreateFranchisee extends StatefulWidget {
  @override
  _CreateFranchiseeState createState() => _CreateFranchiseeState();
}

class _CreateFranchiseeState extends State<CreateFranchisee> with SingleTickerProviderStateMixin,CityDialogInterface,StateDialogInterface,
    ImagePickerDialogPostInterface,
    ImagePickerListener,CountryDialogInterface,
    ImagePickerDialogInterface {

  final _formkey = GlobalKey<FormState>();

  late ImagePickerHandler imagePicker;
  late AnimationController _Controller;
  File? picImage;

  TextEditingController franchiseeName = TextEditingController();
  TextEditingController franchiseeContactPerson = TextEditingController();
  TextEditingController franchiseeAddress = TextEditingController();
  TextEditingController franchiseeMobileNo = TextEditingController();
  TextEditingController franchiseeContactNo = TextEditingController();
  TextEditingController franchiseeEmail = TextEditingController();

  TextEditingController franchiseeAadharNo = TextEditingController();
  TextEditingController franchiseeGSTNO = TextEditingController();
  TextEditingController franchiseePanNo = TextEditingController();

  TextEditingController franchiseeOutstandingLimit = TextEditingController();
  TextEditingController franchiseePaymentDays = TextEditingController();


  String selectedState = ""; // Initial dummy data

  String selectedCity = ""; // Initial dummy data

  String selectedCountry = "";

  File? aadharCardFile;

  File? panCardFile;

  File? gstCardFile;

  List<String> LimitDataUnit = ["Cr","Dr"];

  String ?selectedLimitUnit = null;

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
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getImageLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth),
                    getFieldTitleLayout(StringEn.FRANCHISEE_NAME),
                    getFranchiseeNameLayout(),
                    getFieldTitleLayout(StringEn.FRANCHISEE_CONTACT_PERSON),
                    getContactPersonLayout(),
                    getFieldTitleLayout(StringEn.FRANCHISEE_ADDRESS),
                    getAddressLayout(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getFieldTitleLayout(StringEn.FRANCHISEE_CITY),
                            getCityLayout(),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getFieldTitleLayout(StringEn.FRANCHISEE_STATE),
                            getStateayout(),
                          ],
                        ),
                      ],
                    ),
                    getFieldTitleLayout(StringEn.FRANCHISEE_COUNTRY),
                    getCountryayout(),
                    getFieldTitleLayout(StringEn.FRANCHISEE_MOBILENO),
                    getMobileNoLayout(),
                    getFieldTitleLayout(StringEn.FRANCHISEE_EMAIL),
                    getEmailLayout(),

                    getFieldTitleLayout(StringEn.FRANCHISEE_AADHAR_NO),
                    getAdharNoLayout(),
                    SizedBox(height: 5,),
                    getPANNoLayout(),
                    SizedBox(height: 5,),
                    getGSTNoLayout(),
                    getFieldTitleLayout(StringEn.FRANCHISEE_OUTSTANDING_LIMIT),
                    getOutstandingLimit(),
                    getFieldTitleLayout(StringEn.FRANCHISEE_PAYMENT_DAYS),
                    getPaymentDaysLayout(),
                    SizedBox(height: 20.0),
                    getButtonLayout()

                  ],
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }

  /* widget for image layout */
  Widget getImageLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            picImage == null
                ? Container(
              height: parentHeight * .15,
              width: parentHeight * .15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/placeholder.png'),
                  // Replace with your image asset path
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
                          opacity: 1.0,
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


  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: item_heading_textStyle,
      ),
    );
  }


  /* widget for button layout */
  Widget getButtonLayout() {
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
            CommonColor.THEME_COLOR)),
        onPressed: () {
          _formkey.currentState?.validate();
          // Navigator.pop(context);
        },
        child: Text(StringEn.ADD,
            style: button_text_style),
      ),
    );
  }


  /* widget for franchisee payment days layout */
  Widget getPaymentDaysLayout() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: franchiseePaymentDays,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_PAYMENT_DAYS,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Payment Days";
        }
        return null;
      },
    );
  }


  /* widget for franchisee outstanding limit layout */
  Widget getOutstandingLimit() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
            controller: franchiseeOutstandingLimit,
            decoration: textfield_decoration.copyWith(
              hintText: StringEn.FRANCHISEE_OUTSTANDING_LIMIT,
            ),
            onFieldSubmitted: (v) => franchiseeOutstandingLimit.text = double.parse(franchiseeOutstandingLimit.text).toString(),
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Email Address";
              }
              return null;
            },
          ),
        ),
        Container(
          height: 50,
          width: 100,
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: CommonColor.TexField_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
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


  /* widget for franchisee gst no layout */
  Widget getGSTNoLayout() {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: SizeConfig.screenWidth - 110,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: franchiseeGSTNO,
                maxLength: 15,
                decoration: textfield_decoration.copyWith(
                  hintText: StringEn.FRANCHISEE_GST_NO,
                ),
                onChanged:(value){
                  franchiseeGSTNO.text=value.toUpperCase();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter GST No";
                  }
                  else if (!Util.isGSTValid(value)) {
                    return "Enter Valid GST No";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                getPanCardFile();
              },
              child: Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.fileArrowUp, color: Colors.white,
                        size: 20,),
                      Text("Upload", style: subHeading_withBold)
                    ],
                  )
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        gstCardFile != null ?
        getFileLayout(gstCardFile!) : Container()
      ],
    );
  }


  /* widget for franchisee pan no layout */
  Widget getPANNoLayout() {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: SizeConfig.screenWidth - 110,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: franchiseePanNo,
                maxLength: 12,
                decoration: textfield_decoration.copyWith(
                  hintText: StringEn.FRANCHISEE_PAN_NO,
                ),
                onChanged:(value){
                  franchiseePanNo.text=value.toUpperCase();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter PAN No";
                  }
                  else if (Util.isPanValid(value)) {
                    return "Enter Valid PAN";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                getPanCardFile();
              },
              child: Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.fileArrowUp, color: Colors.white,
                        size: 20,),
                      Text("Upload", style: subHeading_withBold)
                    ],
                  )
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        panCardFile != null ?
        getFileLayout(panCardFile!) : Container()
      ],
    );
  }

  /* widget for franchisee aadhar no layout */
  Widget getAdharNoLayout() {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: SizeConfig.screenWidth - 110,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: franchiseeAadharNo,
                maxLength: 12,
                decoration: textfield_decoration.copyWith(
                  hintText: StringEn.FRANCHISEE_AADHAR_NO,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Aadhar No";
                  }
                  else if (Util.isAadharValid(value)) {
                    return "Enter Valid Aadhar";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                getAadharCardFile();
              },
              child: Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.fileArrowUp, color: Colors.white,
                        size: 20,),
                      Text("Upload", style: subHeading_withBold)
                    ],
                  )
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        aadharCardFile != null ?
        getFileLayout(aadharCardFile!) : Container()
      ],
    );
  }

  /* widget for franchisee email layout */
  Widget getEmailLayout() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: franchiseeEmail,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_EMAIL,
      ),
      validator: (value) {
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
  Widget getMobileNoLayout() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: franchiseeMobileNo,
      maxLength: 10,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_MOBILENO,
      ),
      validator: (value) {
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

  /* widget for franchisee country layout */
  Widget getCountryayout() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                    1.0;
                return Transform(
                  transform:
                  Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: a1.value,
                    child: CountryDialog(
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
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: CommonColor.TexField_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedCountry == "" ? "Choose Country" : selectedCountry,
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.caretDown,
                color: Colors.black87.withOpacity(0.8), size: 16,)
            ],
          )
      ),
    );
  }


  /* widget for franchisee state layout */
  Widget getStateayout() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                    1.0;
                return Transform(
                  transform:
                  Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: a1.value,
                    child: StateDialog(
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
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          width: SizeConfig.halfscreenWidth,
          decoration: BoxDecoration(
              color: CommonColor.TexField_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedState == "" ? "Choose State" : selectedState,
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.caretDown,
                color: Colors.black87.withOpacity(0.8), size: 16,)
            ],
          )
      ),
    );
  }

  /* widget for franchisee city layout */
  Widget getCityLayout() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                    1.0;
                return Transform(
                  transform:
                  Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: a1.value,
                    child: CityDialog(
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
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          width: SizeConfig.halfscreenWidth,
          decoration: BoxDecoration(
              color: CommonColor.TexField_COLOR,
              border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedCity == "" ? "Choose City" : selectedCity,
                style: item_regular_textStyle,),
              FaIcon(FontAwesomeIcons.caretDown,
                color: Colors.black87.withOpacity(0.8), size: 16,)
            ],
          )
      ),
    );
  }


  /* widget for Contact Person layout */
  Widget getContactPersonLayout() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: franchiseeContactPerson,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_CONTACT_PERSON,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Contact Person";
        }
        return null;
      },
    );
  }


  /* widget for Address layout */
  Widget getAddressLayout() {
    return TextFormField(
      maxLines: 4,
      keyboardType: TextInputType.streetAddress,
      controller: franchiseeAddress,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_ADDRESS,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Address";
        }
        // else if (Util.isAddressValid(value)) {
        //   return "Enter Valid Address";
        // }
        return null;
      },
    );
  }


  /* widget for Franchisee name layout */
  Widget getFranchiseeNameLayout() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: franchiseeName,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_NAME,
      ),
      validator: ((value) {
        if (value!.isEmpty) {
          return "Enter Franchisee Name";
        }
        return null;
      }),
    );
  }

  //interface function to get city
  @override
  selectCity(String id, String name) {
    // TODO: implement selectCategory
    if (mounted) {
      setState(() {
        selectedCity = name;
        print("jnkgjngtjngjt  $id $name");
      });
    }
  }

  //interface functionn to get state
  @override
  selectState(String id, String name) {
    // TODO: implement selectState
    if (mounted) {
      setState(() {
        selectedState = name;
        print("jnkgjngtjngjt  $id $name");
      });
    }
  }


  // method to pick gst document
  getGstCardFile() async {
    File file = await CommonWidget.pickDocumentFromfile();
    setState(() {
      gstCardFile = file;
    });
  }

  // method to pick pan document
  getPanCardFile() async {
    File file = await CommonWidget.pickDocumentFromfile();
    setState(() {
      panCardFile = file;
    });
  }

  // method to pick aadhar document
  getAadharCardFile() async {
    File file = await CommonWidget.pickDocumentFromfile();
    setState(() {
      aadharCardFile = file;
    });
  }

  //common widget to display file
  Stack getFileLayout(File FileName) {
    return Stack(
      children: [
        FileName!.uri.toString().contains(".pdf") ?
        Container(
            height: 100,
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.6),),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.filePdf, color: Colors.redAccent,),
                Text(FileName!
                    .uri
                    .toString()
                    .split('/')
                    .last, style: item_heading_textStyle,),
              ],
            )
        ) : Container(
          height: 100,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.6),),
              image: DecorationImage(
                image: FileImage(FileName!),
                fit: BoxFit.cover,
              )
          ),

        ),
        Positioned(
            right: 15,
            top: 15,
            child: IconButton(
                onPressed: () {
                  if (FileName == aadharCardFile) {
                    setState(() {
                      aadharCardFile = null;
                    });
                  }
                  else if (FileName == panCardFile) {
                    setState(() {
                      panCardFile = null;
                    });
                  }
                  else if (FileName == gstCardFile) {
                    setState(() {
                      gstCardFile = null;
                    });
                  }
                },
                icon: Icon(Icons.remove_circle_sharp, color: Colors.red,)))
      ],
    );
  }

  @override
  selectCountry(String id, String name) {
    // TODO: implement selectCountry
    setState(() {
      selectedCountry = name;
    });
  }

  @override
  userImage(File image, String comeFrom) {
    // TODO: implement userImage
    setState(() {
      picImage = image;
    });
  }

}

