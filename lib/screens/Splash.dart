import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sweet_shop_app/screens/Login.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState

    Timer(Duration(seconds: 5), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
   });


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/Shop_Logo.png'),
              fit: BoxFit.contain,// Replace with your image asset path
             ),
           ],
        ),

      ),
    );
  }
}
