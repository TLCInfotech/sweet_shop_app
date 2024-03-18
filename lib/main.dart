import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dashboard/dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/login/Login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sweet_shop_app/presentation/menu/setting/domain_link_activity.dart';
import 'core/app_preferance.dart';
import 'presentation/menu/master/item_category/Item_Category.dart';
import 'presentation/menu/master/unit/Units.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

  // Rest of your code remains the same...
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWEETSHOP',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale( 'en' , '' ),
        Locale( 'de' , '' ),
      ],

      localizationsDelegates: const [
        ApplicationLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale!.languageCode &&
              supportedLocaleLanguage.countryCode == locale.countryCode) {
            return supportedLocaleLanguage;
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
      routes: <String, WidgetBuilder>{
        '/category': (BuildContext context) =>   ItemCategoryActivity(),
        '/unit': (BuildContext context) =>   UnitsActivity(),
        '/loginActivity': (BuildContext context) =>   const LoginActivity(),
        '/domainLinkActivity': (BuildContext context) =>   const DomainLinkActivity(),
        '/dashboard': (BuildContext context) =>   DashboardActivity(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    getDeviceID();
  }


  /*Function for get Device Id is IOS or Android */
  getDeviceID()   {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((iosInfo) {
        AppPreferences.setDeviceId(iosInfo.identifierForVendor!);
      });
    } else {
      deviceInfo.androidInfo.then((androidInfo) {
        AppPreferences.setDeviceId(androidInfo.id);
        print("ttttttttttt  ${androidInfo.id}      ${androidInfo.product}");
      });

    }

  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: CommonColor.WHITE_COLOR,
      body: getAddNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
    );
  }

  /* Widget for Add Name Layout */
  Widget getAddNameLayout(double parentHeight, double parentWidth){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image(
            height: parentHeight,
            width: parentWidth*.6,
            image: const AssetImage('assets/images/Shop_Logo.png'),
            // fit: BoxFit.contain,
          ),
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

  /* Timer */
  startTimer() async {
    var duration =   const Duration(seconds: 1);
    try {
      String accessToken ="1";
      String sessionToken =await AppPreferences.getSessionToken();
      String companyId =await AppPreferences.getCompanyId();
      String domainLink =await AppPreferences.getDomainLink();
      print(domainLink);
      print(companyId);
        print("grhrgeghreghre  $sessionToken");
      if (sessionToken!="") {
        return Timer(duration, navigateDashboard);
      }else{
        if(domainLink!="" && companyId!="")
          return Timer(duration, navigateLogin);
        else
          return Timer(duration, navigateDomainLink);
      }
    } catch (e) {
    }
    return Timer(duration, navigateDomainLink);

  }

}

