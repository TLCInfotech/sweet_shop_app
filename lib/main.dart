import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/internet_check.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/data/api/constant.dart';
import 'package:sweet_shop_app/data/api/request_helper.dart';
import 'package:sweet_shop_app/data/domain/commonRequest/get_toakn_request.dart';
import 'package:sweet_shop_app/presentation/dashboard/dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/login/Login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sweet_shop_app/presentation/menu/setting/domain_link_activity.dart';
import 'package:sweet_shop_app/presentation/menu/setting/language_select_screen.dart';
import 'package:sweet_shop_app/presentation/menu/transaction/constant/local_notification.dart';
import 'core/app_preferance.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize((payload) {
    if (payload != null) {
      OpenFile.open(payload);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
 // Default locale
  // shkj
  @override
  void initState() {
    super.initState();
    getUserPermissions();
   // getData();
  }

  Locale? _locale;
/*
  Locale _locale = Locale('mr');
   getData() async {
    String lang = await AppPreferences.getLang();
    print("jkjggjgj  $lang");
    if(lang=="mr_IN"){
      lang="mr";
    }else if(lang=="hi_IN"){
      lang="hi";
    }else{
      lang="en";
    }
    print("jfjfhjfv   $lang");
    setState(() {
      _locale = Locale(lang);
    });
  }

    Locale _locale(String languageCode) {
    print("languageCode    $languageCode");
    return languageCode != null && languageCode.isNotEmpty
        ? Locale(languageCode, '')
        : Locale('en', '');
  }
*/

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      print("jfjbvvbbgv   ${locale.languageCode}");
      AppPreferences.setLang(locale.languageCode+"_IN"); // Optionally save the new locale
    });
  }

  @override
  void didChangeDependencies()   {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
        print("_locale111111111    $_locale");

      });
    });

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    print("gkmngnng  $_locale");
    return MaterialApp(
      title: 'SWEETSHOP',
      debugShowCheckedModeBanner: false,
        locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('mr', ''),
        Locale('hi', ''),
      ],
      localizationsDelegates: const [
        ApplicationLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
        );
      },
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/loginActivity': (BuildContext context) => const LoginActivity(),
        '/domainLinkActivity': (BuildContext context) => const DomainLinkActivity(),
        '/dashboard': (BuildContext context) => DashboardActivity(),
      },
    );
  }

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  getUserPermissions() async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String date=await AppPreferences.getDateLayout();
    String uid=await AppPreferences.getUId();
    String lang=await AppPreferences.getLang();
    //DateTime newDate=DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    print("objectgggg   $date  ");
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().getUserPermission}?UID=$uid&Company_ID=$companyId&${StringEn.lang}=$lang";
        apiRequestHelper.callAPIsForGetAPI(apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){

              setState(() {
                if(data!=null){
                  if (mounted) {
                    AppPreferences.setCompanyName(data['FranchiseeName']);
                    AppPreferences.setCompanyId(data['Franchisee']);
                    // AppPreferences.setReportMenuList(jsonEncode(apiResponse.reportMenu));
                  }

                }else{
                }
              });
            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              // var val= CommonWidget.errorDialog(context, e);
              // print("YES");
              // if(val=="yes"){
              //   print("Retry");
              // }
            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }
    else{
      CommonWidget.noInternetDialogNew(context);
    }
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Locale? _locale;
  @override
  void didChangeDependencies()   {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
        print("_locale111111111    $_locale");

      });
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    CommonWidget.getPlayerId();
    getDeviceID();
    setData();
    DateTime saleDate = DateTime.now().subtract(Duration(days: 1, minutes: 30 - DateTime.now().minute % 30));
    AppPreferences.setDateLayout(DateFormat('yyyy-MM-dd').format(saleDate));
  }
  String logoImage="";
  String companyName="";
  setData()async{
    logoImage=await AppPreferences.getCompanyUrl();
  setState(() {
  });
  }
  void getDeviceID() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((iosInfo) {
        AppPreferences.setDeviceId(iosInfo.identifierForVendor!);
      });
    } else {
      deviceInfo.androidInfo.then((androidInfo) {
        AppPreferences.setDeviceId(androidInfo.id);
        print("Android ID: ${androidInfo.id} Product: ${androidInfo.product}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: CommonColor.WHITE_COLOR,
      body: getAddNameLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
    );
  }

  Widget getAddNameLayout(double parentHeight, double parentWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child:logoImage!=""? Container(
            height: parentWidth*.6,
            width: parentWidth * .6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                image: DecorationImage(
                  image: FileImage(File(logoImage)),
                  fit: BoxFit.cover,
                )
            ),
          ):Image(
              height: parentWidth,
              width: parentWidth * .6,
              image:  AssetImage('assets/images/tlc.jpg'),),
        ),
      ],
    );
  }

  void navigateLogin() {
    Navigator.of(context).pushReplacementNamed('/loginActivity');
  }

  void navigateDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  void navigateDomainLink() {
    Navigator.of(context).pushReplacementNamed('/domainLinkActivity');
  }

  startTimer() async {
    var duration = const Duration(seconds: 1);
    try {
      String accessToken = "1";
      String sessionToken = await AppPreferences.getSessionToken();
      String companyId = await AppPreferences.getCompanyId();
      String domainLink = await AppPreferences.getDomainLink();
      print(domainLink);
      print(companyId);
      print("Session Token: $sessionToken");

      if (sessionToken != "") {
        return Timer(duration, navigateDashboard);
      } else {
        if (domainLink != "" && companyId != "")
          return Timer(duration, navigateLogin);
        else
          return Timer(duration, navigateDomainLink);
      }
    } catch (e) {
      print(e.toString());
    }
    return Timer(duration, navigateDomainLink);
  }
}
