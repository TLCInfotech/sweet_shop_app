import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dashboard/dashboard_activity.dart';

import '../../core/app_preferance.dart';
import '../../core/common.dart';
import '../../data/api/constant.dart';
import '../../data/api/request_helper.dart';
import '../../data/domain/login/login_request_model.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({super.key});

  @override
  State<LoginActivity> createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {

  final _formkey=GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Login_Background.jpg'), // Replace with your image asset path
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                     StringEn.SIGN_IN,
                      style: big_title_style
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      StringEn.LOGIN_SUB_TEXT,
                      style: subHeading_withBold
                    ),
                    const SizedBox(height: 40.0),
                    getUserNameLayout(  SizeConfig.screenHeight, SizeConfig.screenWidth),
                    const SizedBox(height: 10.0),
                    getPasswordLayout(  SizeConfig.screenHeight, SizeConfig.screenWidth),
                    const SizedBox(height: 20.0),
                    getButtonLayout()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* widget for user name layout */
  Widget getUserNameLayout(double parentHeight,double parentWidth){
  return TextFormField(
      controller: username,
      decoration: textfield_decoration.copyWith(
        hintText: StringEn.USER_NAME,
      ),
    validator: (value){
        if(value!.isEmpty){
          return  StringEn.ENTER+StringEn.USER_NAME;
        }
    },
    );
  }
  /* widget for password layout */
  Widget getPasswordLayout(double parentHeight,double parentWidth){
  return  TextFormField(
    controller: password,
    obscureText: true,
    decoration: textfield_decoration.copyWith(
      hintText: 'Password',
     ),
    validator: (value){
      if(value!.isEmpty){
        return  StringEn.ENTER+"password";
      }

    },
  );
  }
  /* widget for button layout */
  Widget getButtonLayout(){
  return Container(
    width: 200,
    child: ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CommonColor.THEME_COLOR)),
      onPressed: () async{
        bool? isvalid=_formkey.currentState?.validate();
        print(isvalid);
        if(isvalid!) {
          callLogin();
        }
       //             Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity()));
      },
      child:  Text(StringEn.LOG_IN,
        style: button_text_style),
    ),
  );
  }



  callLogin() async {
    String userName = username.text.trim();
    String passwordText = password.text.trim();
    String deviceId = await AppPreferences.getDeviceId();
    String sessionToken = await AppPreferences.getSessionToken();

    AppPreferences.getDeviceId().then((deviceId) {
      LoginRequestModel model = LoginRequestModel(
     Password: passwordText,
     UID: userName,
        Machine_Name: deviceId
      );
      //  widget.mListener.loaderShow(true);
        String apiUrl = ApiConstants().baseUrl + ApiConstants().login;
        apiRequestHelper.callAPIsForPostLoginAPI(apiUrl, model.toJson(), "",
            onSuccess:(token,uid){
             print("  LedgerLedger  $token ");
             AppPreferences.setSessionToken(token);
             AppPreferences.setUId(uid);
             Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity()));
            }, onFailure: (error) {
              CommonWidget.noInternetDialog(context, "Signup Error");
             // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
            }, onException: (e) {
             // widget.mListener.loaderShow(false);
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
             // widget.mListener.loaderShow(false);
            });

    });
  }

}


