import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/presentation/dashboard/dashboard_activity.dart';
import 'package:sweet_shop_app/presentation/login/Login.dart';

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


  void navigateUnit() {
    Navigator.of(context).pushReplacementNamed('/unit');
  }


  void navigateItemCategory() {
    Navigator.of(context).pushReplacementNamed('/category');
  }


  void navigateDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }




  /* Timer */
  startTimer() async {
    var duration =   const Duration(seconds: 3);
    try {
      String accessToken ="1";

      if (accessToken!="1" ) {
        return Timer(duration, navigateLogin);

      }else{
        return Timer(duration, navigateLogin);
      }
    } catch (e) {
    }
    return Timer(duration, navigateLogin);

  }

}

