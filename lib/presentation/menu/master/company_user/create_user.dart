import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/common_widget/getFranchisee.dart';
import 'package:sweet_shop_app/presentation/common_widget/get_image_from_gallary_or_camera.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../data/api/constant.dart';
import '../../../../data/api/request_helper.dart';
import '../../../../data/domain/user/post_user_request_model.dart';
import '../../../../data/domain/user/put_user_request_model.dart';
import '../../../common_widget/signleLine_TexformField.dart';

class UserCreate extends StatefulWidget {
 final editUser;
  const UserCreate({super.key, required this.mListener, this.editUser});

   final UserCreateInterface mListener;

  @override
  State<UserCreate> createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  final _userFocus = FocusNode();
  final userController = TextEditingController();

  final _workingdaysFocus = FocusNode();
  final workingdaysController = TextEditingController();

  final _passwordFocus = FocusNode();
  final passwordController = TextEditingController();

  final _franchiseFocus = FocusNode();
  final afranchiseController = TextEditingController();

  bool checkPasswordValue = false;
  bool checkActiveValue = false;
  File? picImage;
  String countryName = "";
  String countryId = "";
  String franchiseeName = "";
  String franchiseeId = "";
  String stateName = "";
  String stateId = "";
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isLoaderShow=false;
  bool isApiCall=false;
  final _formkey=GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
    localData();
  }
  String companyIds="";
  localData()async{
    companyIds = await AppPreferences.getCompanyId();
    print("newwww  $companyIds");
    setState(() {

    });
  }

String oldUid="";
  setData()async{
    if(widget.editUser!=null){
      userController.text=widget.editUser["UID"];
      oldUid=widget.editUser["UID"];
      print("jhjfhjf  ${widget.editUser["Active"]}  $oldUid");
      workingdaysController.text=widget.editUser["Working_Days"].toString();
      franchiseeId=widget.editUser["Ledger_ID"].toString();
      franchiseeName=widget.editUser["Ledger_Name"];
      checkActiveValue=widget.editUser["Active"];
      checkPasswordValue=widget.editUser["Reset_Password"];
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: Colors.white,
                    title:  Text(
                      ApplicationLocalizations.of(context)!.translate("user_new")!,
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
                      child: Form(
                        key: _formkey,
                        child: getAllTextFormFieldLayout(
                            SizeConfig.screenHeight, SizeConfig.screenWidth),
                      )),
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

 Widget getImageLayout(double parentHeight, double parentWidth) {
    return  GetSingleImage(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getImageLayout(parentHeight, parentWidth),
                  getNameLayout(parentHeight, parentWidth),
                  getWorkingDaysLayout(parentHeight, parentWidth),
                 // widget.editUser!=null? getPasswordLayout(parentHeight, parentWidth):
                 //  Container(),
                  getFranchiseeLayout(parentHeight, parentWidth),
                  widget.editUser==null?Container():  getResetPswwordLayout(parentHeight, parentWidth),
                  widget.editUser==null?Container():getActiveLayout(parentHeight, parentWidth),
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
            return     ApplicationLocalizations.of(context)!.translate("enter")!+    ApplicationLocalizations.of(context)!.translate("user_name")!;
          }
          return null;
        },
      controller: userController,
      focuscontroller: _userFocus,
      focusnext: _workingdaysFocus,
      title:     ApplicationLocalizations.of(context)!.translate("user_name")!,
      callbackOnchage: (value) {
        setState(() {
          userController.text = value;
        });
      },
      textInput: TextInputType.text,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 A-Z a-z]')),
    );

  }

  /* Widget for working days text from field layout */
  Widget getWorkingDaysLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")!+    ApplicationLocalizations.of(context)!.translate("working_days")!;
          }
          return null;
        },
      controller: workingdaysController,
      focuscontroller: _workingdaysFocus,
      focusnext: _passwordFocus,
      title: ApplicationLocalizations.of(context)!.translate("working_days")!,
      callbackOnchage: (value) {
        setState(() {
          workingdaysController.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
    );

  }

  /* Widget for password  text from field layout */
  Widget getPasswordLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
      validation: (value) {
          if (value!.isEmpty) {
            return     ApplicationLocalizations.of(context)!.translate("enter")!+    ApplicationLocalizations.of(context)!.translate("password")!;
          }
          return null;
        },
      controller: passwordController,
      focuscontroller: _passwordFocus,
      focusnext: _passwordFocus,
      title: ApplicationLocalizations.of(context)!.translate("password")!,
      callbackOnchage: (value) {
        setState(() {
          passwordController.text = value;
        });
      },
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
    );

  }



  /* Widget for franchisee name text from field layout */
  Widget getFranchiseeLayout(double parentHeight, double parentWidth) {
    return GetFranchiseeLayout(
        title:  ApplicationLocalizations.of(context)!.translate("franchisee")!,
        callback: (name,id){
          setState(() {
            franchiseeName=name!;
            franchiseeId=id!;
          });
        },
        franchiseeName: franchiseeName);
  }


  /*Widget for Terms and privacy Layout*/
  Widget getResetPswwordLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .016),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
           if( widget.editUser!=null){
             setState(() {
               if (!checkPasswordValue) {
                 checkPasswordValue = true;
               } else {
                 checkPasswordValue = false;
               }
             });
           } else{

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
                        color: checkPasswordValue == true
                            ? CommonColor.THEME_COLOR
                            : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            color: checkPasswordValue == true
                                ? CommonColor.HINT_TEXT_COLOR
                                .withOpacity(0.5)
                                : CommonColor.THEME_COLOR,
                            width: 1),
                      ),
                      child: Visibility(
                        visible: checkPasswordValue,
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
                child: Text(ApplicationLocalizations.of(context)!.translate("reset_password")!,
                  style: page_heading_textStyle,)
            ),
          ),
        ],
      ),
    );
  }


  /*Widget for active Layout*/
  Widget getActiveLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .016),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
    if( widget.editUser!=null){
      setState(() {
        if (!checkActiveValue) {
          checkActiveValue = true;
        } else {
          checkActiveValue = false;
        }
      });
    }else{

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
                child: Text(ApplicationLocalizations.of(context)!.translate("active")!,
                  style: page_heading_textStyle,)
            ),
          ),
        ],
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
              if(widget.editUser!=null){
                callUpdateItem();
              }else{
                callPostItem();
              }
             // _formkey.currentState?.validate();
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
                     widget.editUser!=null?ApplicationLocalizations.of(context)!.translate("update")!: ApplicationLocalizations.of(context)!.translate("save")!,
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
    String workingDay=workingdaysController.text.trim();
    String userName=userController.text.trim();
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      PostUserRequestModel model = PostUserRequestModel(
        uid: userName,
        Company_ID: companyId,
        ledgerID: franchiseeId,
        workingDays: workingDay,
        active: true,
        resetPassword: true,
        creator: creatorName,
        creatorMachine: deviceId
      );

      String apiUrl = ApiConstants().baseUrl + ApiConstants().users;
      apiRequestHelper.callAPIsForDynamicPI(apiUrl, model.toJson(), "",
          onSuccess:(data){
            print("  ITEM  $data ");
            setState(() {
              isLoaderShow=false;
            });
            widget.mListener.createUser();
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

  callUpdateItem() async {
    String workingDay=workingdaysController.text.trim();
    String userName=userController.text.trim();
    String creatorName = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String tokan = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        PutUserRequestModel model = PutUserRequestModel(
          uid: oldUid,
          uidNew: userName,
          Company_ID: companyIds,
          ledgerID: franchiseeId,
          workingDays: workingDay,
          active: checkActiveValue,
          resetPassword: checkPasswordValue,
            creator: creatorName,
            creatorMachine: deviceId,
        );
        print("jfhjfhjjhrjhr  $companyId ");
        String apiUrl = ApiConstants().baseUrl + ApiConstants().users/*+"/"+widget.editItem['ID'].toString()*/;
        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), tokan,
            onSuccess:(value)async{
              print("  Put Call :   $value ");
              var snackBar = SnackBar(content: Text('User  Updated Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              widget.mListener.updateUser();

            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
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

abstract class UserCreateInterface {
  createUser();
  updateUser();
}
