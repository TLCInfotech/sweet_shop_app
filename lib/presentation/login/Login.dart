import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_token_without_page.dart';
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
  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
                             Text(
                              ApplicationLocalizations.of(context).translate("sign_in"),
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
        hintText:ApplicationLocalizations.of(context).translate("user_name"),
      ),
    validator: (value){
        if(value!.isEmpty){
          return  ApplicationLocalizations.of(context).translate("enter")+ApplicationLocalizations.of(context).translate("user_name");
        }
    },
    );
  }
  /* widget for password layout */
  Widget getPasswordLayout(double parentHeight,double parentWidth){
  return  TextFormField(
    controller: password,
    obscureText: _obscureText,

    decoration:InputDecoration(
      hintText: 'Password',
      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      labelStyle: textfield_label_style,
      fillColor:  Colors.white,
      filled: true,
      hintStyle: hint_textfield_Style,
      floatingLabelStyle: const TextStyle(fontFamily: 'Inter_Medium_Font',fontSize: 20,color: Colors.indigo,fontWeight: FontWeight.w700),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off: Icons.visibility,
        ),
        onPressed: _togglePasswordVisibility,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent,width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.transparent,width: 1),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      errorBorder:  const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),

    ),
    validator: (value){
      if(value!.isEmpty){
        return  ApplicationLocalizations.of(context).translate("enter")+ApplicationLocalizations.of(context).translate("password");
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
          child:  Text(ApplicationLocalizations.of(context).translate("log_in"),
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
    if(mounted){
      setState(() {
        CommonWidget.getPlayerId();
      });
    }
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
              //  callGetFranchiseeNot(0);
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
  callGetFranchiseeNot(int page) async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String pushKey=await AppPreferences.getPushKey();
    String lang=await AppPreferences.getLang();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        TokenRequestWithoutPageModel model = TokenRequestWithoutPageModel(
          token: sessionToken,
        );
        String apiUrl = "${baseurl}${ApiConstants().sendFNotification}?Company_ID=$companyId&${StringEn.lang}=$lang&PushKey=$pushKey";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){
              setState(() {

              });

              // _arrListNew.addAll(data.map((arrData) =>
              // new EmailPhoneRegistrationModel.fromJson(arrData)));
              print("  franchisee   $data ");
            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
            }, onException: (e) {

              // print("Here2=> $e");
              // var val= CommonWidget.errorDialog(context, e);
              //
              // print("YES");
              // if(val=="yes"){
              //   print("Retry");
              // }
            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    }
    else{
      CommonWidget.noInternetDialogNew(context);
    }
  }
}


