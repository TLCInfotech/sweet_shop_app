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
import '../../../core/app_preferance.dart';
import '../../../core/internet_check.dart';
import '../../../core/localss/application_localizations.dart';
import '../../../data/api/constant.dart';
import '../../../data/api/request_helper.dart';
import '../../../data/domain/confirmPassword/create_login_user_upadte_request_model.dart';
import '../../dashboard/dashboard_activity.dart';

class ChangePasswordActivity extends StatefulWidget {
  final String logoImage;
  final  viewWorkDDate;
  final  viewWorkDVisible;
  const ChangePasswordActivity({super.key, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible});

  // final ChangePasswordActivityInterface mListener;

  @override
  State<ChangePasswordActivity> createState() => _ChangePasswordActivityState();
}

class _ChangePasswordActivityState extends State<ChangePasswordActivity>{
  final _newPasswordFocus = FocusNode();
  final newPasswordController = TextEditingController();


  final _confirmPasswordFocus = FocusNode();
  final confirmPasswordController = TextEditingController();

bool isLoaderShow=false;

  bool _obscureTextOne = true;
  bool _obscureTextTwo = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureTextOne = !_obscureTextOne;
    });
  }
  void _togglePasswordTwoVisibility() {
    setState(() {
      _obscureTextTwo = !_obscureTextTwo;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

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
                            child: Center(
                              child: Text(
                                ApplicationLocalizations.of(context)!.translate("change_password")!,
                                style: appbar_text_style,),
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



  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
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
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Column(children: [
                      getNewPasswordLayout(parentHeight, parentWidth),
                      getConfirmPasswordLayout(parentHeight, parentWidth),
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



  /* Widget for password text from field layout */
  Widget getNewPasswordLayout(double parentHeight, double parentWidth) {
    return
      Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ApplicationLocalizations.of(context)!.translate("new_password")!,
                style: item_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: parentHeight * .055,
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
                    focusNode: _newPasswordFocus,
                    obscureText: _obscureTextOne,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,

                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextOne ? Icons.visibility_off: Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText:ApplicationLocalizations.of(context)!.translate("new_password")!,
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: newPasswordController,
                    onEditingComplete: () {
                      _newPasswordFocus.unfocus();
                    },
                    style: text_field_textStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* Widget for confirm password text from field layout */
  Widget getConfirmPasswordLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ApplicationLocalizations.of(context)!.translate("confirm_password")!,
                style: item_heading_textStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: parentHeight * .005),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: parentHeight * .055,
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
                    focusNode: _confirmPasswordFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    obscureText: _obscureTextTwo,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: parentWidth * .04, right: parentWidth * .02),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextTwo ? Icons.visibility_off: Icons.visibility,
                        ),
                        onPressed: _togglePasswordTwoVisibility,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: ApplicationLocalizations.of(context).translate("confirm_password")!,
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: confirmPasswordController,
                    onEditingComplete: () {
                      _confirmPasswordFocus.unfocus();
                    },
                    style: text_field_textStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



bool disableColor=false;
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
     print("hkjfjhhfj  ${newPasswordController.text.isNotEmpty}");
                  if(newPasswordController.text == confirmPasswordController.text&&newPasswordController.text.isNotEmpty){
                    disableColor = true;
                    callUpdateItem();
                  }else{
                    var snackBar = SnackBar(content: Text('please add  both password same.'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    child:  Text(
                      ApplicationLocalizations.of(context)!.translate("change_password")!,
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

  callUpdateItem() async {
    String baseurl=await AppPreferences.getDomainLink();
    String creatorName = await AppPreferences.getUId();
    String tokenId = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String lang = await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        LoginUserRequestModel model = LoginUserRequestModel(
          uid: creatorName,
          Lang:lang,
          password: confirmPasswordController.text,
          modifier: creatorName,
          modifierMachine: deviceId,
          companyId: companyId,
        );
        print("jfhjfhjjhrjhr   ${model.toJson()}");
        String apiUrl = baseurl + ApiConstants().updateuer;
        print(apiUrl);
        apiRequestHelper.callAPIsForPutAPI(apiUrl, model.toJson(), tokenId,
            onSuccess:(value)async{
              print("  Put Call :   $value ");
              var snackBar = SnackBar(content: Text('password s Updated Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity()));

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

// abstract class ChangePasswordActivityInterface {
// }
