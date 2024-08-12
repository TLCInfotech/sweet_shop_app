import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dashboard/dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/login/Login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sweet_shop_app/presentation/menu/setting/domain_link_activity.dart';
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
  Locale _locale = Locale('en'); // Default locale

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    String lang = await AppPreferences.getLang();
    print("jfjfhjfv   $lang");
    setState(() {
      _locale = Locale(lang);
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      AppPreferences.setLang(locale.languageCode); // Optionally save the new locale
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWEETSHOP',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
        Locale('hi', ''),
      ],
      locale: _locale,
      localizationsDelegates: const [
        ApplicationLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
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
      routes: <String, WidgetBuilder>{
        '/loginActivity': (BuildContext context) => const LoginActivity(),
        '/domainLinkActivity': (BuildContext context) => const DomainLinkActivity(),
        '/dashboard': (BuildContext context) => DashboardActivity(),
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
              image:  AssetImage('assets/images/Shop_Logo.png'),),
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
