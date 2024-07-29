import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dashboard/dashboard_activity.dart';
import '../../core/app_preferance.dart';
import '../../core/common.dart';
import '../../core/internet_check.dart';
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
  bool isLoaderShow=false;
//  File? picImage;

  @override
  void initState() {
    // TODO: implement initState
    CommonWidget.getPlayerId();
    super.initState();
    setData();
  }
  String picImage="";
  String companyName="";
  setData()async{
    picImage=await AppPreferences.getCompanyUrl();
    companyName=await AppPreferences.getCompanyName();
    print("bdbndbndbnd   $picImage");
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/Login_Background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding:  EdgeInsets.all(16.0),
                child: Center(
                  child: Stack(
                    children: [

                      Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getImageLayout(  SizeConfig.screenHeight, SizeConfig.screenWidth),
                            const SizedBox(height: 20.0),
                            Text(
                                companyName,
                                style: big_title_style
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                             StringEn.SIGN_IN,
                              style: big_title_style
                            ),
                          /*  const SizedBox(height: 5.0),
                            const Text(
                              StringEn.LOGIN_SUB_TEXT,
                              style: subHeading_withBold
                            ),*/

                            const SizedBox(height: 20.0),

                            getUserNameLayout(  SizeConfig.screenHeight, SizeConfig.screenWidth),
                            const SizedBox(height: 10.0),
                            getPasswordLayout(  SizeConfig.screenHeight, SizeConfig.screenWidth),
                            const SizedBox(height: 20.0),
                            getButtonLayout()
                          ],
                        ),
                      ),
                      Positioned(
                          top: 30,
                          right: 5 ,
                          child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed('/domainLinkActivity');
                              },
                              child: Icon(Icons.settings,color: Colors.white,size: 25,)))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  /* widget for user name layout */
  Widget getImageLayout(double parentHeight,double parentWidth){
  return   picImage==""?Container():Container(
    height:parentHeight*.1,
    width:parentHeight*.1,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        image: DecorationImage(
          image: FileImage(File(picImage!)),
          fit: BoxFit.cover,
        )
    ),
    // child: ImageMemory(bytes: bytes),
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
  return Column(
    children: [
      Container(
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
      ),
    /*  Container(
        width: 200,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CommonColor.THEME_COLOR)),
          onPressed: () async{
            Navigator.of(context).pushReplacementNamed('/domainLinkActivity');
          },
          child:  Text( ApplicationLocalizations.of(context)!.translate("domain")!,
              style: button_text_style),
        ),
      ),*/
    ],
  );
  }



  callLogin() async {
    String baseurl=await AppPreferences.getDomainLink();
    String userName = username.text.trim();
    String passwordText = password.text.trim();
    String deviceId = await AppPreferences.getDeviceId();
    String sessionToken = await AppPreferences.getSessionToken();
    String pushKey = await AppPreferences.getPushKey();
    print("jjfjfhjfhjf  $pushKey");
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });

        LoginRequestModel model = LoginRequestModel(
            Password: passwordText,
            UID: userName,
            PushKey:pushKey ,
            AppType: "C",
            Machine_Name: deviceId,
           // modifire: "myMachine",
        );

        print("ejewjhjhrwhjr  ${model.toJson()}");
        String apiUrl = baseurl + ApiConstants().login+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForPostLoginAPI(apiUrl, model.toJson(), "",
            onSuccess:(token,uid){
              setState(() {
                isLoaderShow=false;
              });
              AppPreferences.setSessionToken(token);
              AppPreferences.setCompanyId("74");
              AppPreferences.setDomainLink("http://61.2.227.173:3000/");
              AppPreferences.setUId(uid);

              Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity()));
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


