import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/item_category/Item_Category.dart';
import 'package:sweet_shop_app/presentation/unit/Units.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({super.key});

  @override
  State<LoginActivity> createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {

  final _formkey=GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

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
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                     StringEn.SIGN_IN,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    const Text(
                      StringEn.LOGIN_SUB_TEXT,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    getUserNameLayout(),
                    SizedBox(height: 10.0),
                    getPasswordLayout(),
                    SizedBox(height: 20.0),
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
  Widget getUserNameLayout(){
  return TextFormField(
      controller: username,
      decoration: const InputDecoration(
        hintText: 'Username',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
  /* widget for password layout */
  Widget getPasswordLayout(){
  return  TextFormField(
    controller: password,
    obscureText: true,
    decoration: const InputDecoration(
      hintText: 'Password',
      filled: true,
      fillColor: Colors.white,
    ),
  );
  }
  /* widget for button layout */
  Widget getButtonLayout(){
  return Container(
    width: 200,
    child: ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CommonColor.THEME_COLOR)),
      onPressed: () {
     Navigator.push(context, MaterialPageRoute(builder: (context) => ItemCategoryActivity()));
      },
      child:  Text(StringEn.LOG_IN,
        style: TextStyle(
          color: CommonColor.BLACK_COLOR,
          fontSize: SizeConfig.blockSizeHorizontal* 4.5,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter_Medium_Font',),),
    ),
  );
  }

}


