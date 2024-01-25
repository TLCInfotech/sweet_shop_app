import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sweet_shop_app/core/util.dart';
import 'package:sweet_shop_app/presentation/dialog/city_dialog.dart';
import 'package:sweet_shop_app/presentation/dialog/state_dialog.dart';

import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../../core/size_config.dart';
import '../../core/string_en.dart';
import '../dialog/category_dialog.dart';

class CreateFranchisee extends StatefulWidget {
  @override
  _CreateFranchiseeState createState() => _CreateFranchiseeState();
}

class _CreateFranchiseeState extends State<CreateFranchisee> with CityDialogInterface,StateDialogInterface {

  final _formkey=GlobalKey<FormState>();
  TextEditingController franchiseeName = TextEditingController();
  TextEditingController franchiseeContactPerson = TextEditingController();
  TextEditingController franchiseeAddress = TextEditingController();
  TextEditingController franchiseeMobileNo = TextEditingController();
  TextEditingController franchiseeContactNo= TextEditingController();
  TextEditingController franchiseeEmail = TextEditingController();



  String selectedState = ""; // Initial dummy data

  String selectedCity = ""; // Initial dummy data


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
        color:  Color(0xFFfffff5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFfffff5),
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child:  Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),
              color: Colors.transparent,
              // color: Colors.red,
              margin: EdgeInsets.only(top: 10,left: 10,right: 10),
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
                    getFieldTitleLayout(StringEn.FRANCHISEE_MOBILENO),
                    getMobileNoLayout(),
                    getFieldTitleLayout(StringEn.FRANCHISEE_EMAIL),
                    getEmailLayout(),
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

  /* widget for button layout */
  Widget getFieldTitleLayout(String title){
    return  Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10,bottom: 10,),
      child: Text(
        "$title",
        style: item_heading_textStyle,
      ),
    );
  }


  /* widget for button layout */
  Widget getButtonLayout(){
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CommonColor.THEME_COLOR)),
        onPressed: () {
            _formkey.currentState?.validate();
          // Navigator.pop(context);
        },
        child:  Text(StringEn.ADD,
            style: button_text_style),
      ),
    );
  }

  /* widget for franchisee email layout */
  Widget getEmailLayout(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: franchiseeEmail,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_EMAIL,
      ),
      validator: (value){
        if(value!.isEmpty){
          return "Enter Email Address";
        }
        else if(Util.isEmailValid(value)){
          return "Enter Valid Email";
        }
        return null;
      },
    );
  }


  /* widget for franchisee mobile layout */
  Widget getMobileNoLayout(){
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: franchiseeMobileNo,
      maxLength: 10,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_MOBILENO,
      ),
      validator: (value){
        // String pattern =r'^[6-9]\d{9}$';
        // RegExp regExp = new RegExp(pattern);
        // print(Util.isMobileValid(value!));
        if(value!.isEmpty){
          return "Enter Mobile No.";
        }
        else if(Util.isMobileValid(value)){
          return "Enter Valid Mobile No.";
        }

        return null;
      },
    );
  }

  /* widget for franchisee state layout */
  Widget getStateayout(){
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                return Transform(
                  transform:
                  Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: a1.value,
                    child:  StateDialog(
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
          padding: EdgeInsets.only(left: 10,right: 10),
          width: SizeConfig.halfscreenWidth,
          decoration: BoxDecoration(
              color: CommonColor.TexField_COLOR,
              border:Border.all(color: Colors.grey.withOpacity(0.5))
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedState==""?"Choose State":selectedState,style:item_regular_textStyle ,),
              FaIcon(FontAwesomeIcons.caretDown,color: Colors.black87.withOpacity(0.8),size: 16,)
            ],
          )
      ),
    );
  }

  /* widget for franchisee city layout */
  Widget getCityLayout(){
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        if (context != null) {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                return Transform(
                  transform:
                  Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: a1.value,
                    child:  CityDialog(
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
        padding: EdgeInsets.only(left: 10,right: 10),
        width: SizeConfig.halfscreenWidth,
        decoration: BoxDecoration(
            color: CommonColor.TexField_COLOR,
            border:Border.all(color: Colors.grey.withOpacity(0.5))
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedCity==""?"Choose City":selectedCity,style:item_regular_textStyle ,),
            FaIcon(FontAwesomeIcons.caretDown,color: Colors.black87.withOpacity(0.8),size: 16,)
          ],
        )
      ),
    );
  }


  /* widget for Contact Person layout */
  Widget getContactPersonLayout(){
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: franchiseeContactPerson,
      decoration: textfield_decoration.copyWith(
        hintText:StringEn.FRANCHISEE_CONTACT_PERSON,
      ),
      validator: (value){
        if(value!.isEmpty){
          return "Enter Contact Person";
        }
        return null;
      },
    );
  }


  /* widget for Address layout */
  Widget getAddressLayout(){
    return TextFormField(
      maxLines: 4,
      keyboardType: TextInputType.streetAddress,
      controller: franchiseeAddress,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_ADDRESS,
      ),
      validator: (value){
        if(value!.isEmpty){
          return "Enter Address";
        }
        else if(Util.isAddressValid(value)){
          return "Enter Valid Address";
        }
        return null;
      },
    );
  }


  /* widget for Franchisee name layout */
  Widget getFranchiseeNameLayout(){
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: franchiseeName,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.FRANCHISEE_NAME,
      ),
      validator: ((value) {
        if(value!.isEmpty){
          return "Enter Franchisee Name";
        }
        return null;
      }),
    );
  }

  @override
  selectCity(String id, String name) {
    // TODO: implement selectCategory
    if(mounted){
      setState(() {
        selectedCity=name;
        print("jnkgjngtjngjt  $id $name");
      });
    }
  }

  @override
  selectState(String id, String name) {
    // TODO: implement selectState
    if(mounted){
      setState(() {
        selectedState=name;
        print("jnkgjngtjngjt  $id $name");
      });
    }
  }
}

