import 'package:flutter/material.dart';
import 'package:sweet_shop_app/core/colors.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/core/string_en.dart';
import 'package:sweet_shop_app/presentation/dashboard/dashboard_activity.dart';

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
                      style: big_title_style
                    ),
                    SizedBox(height: 5.0),
                    const Text(
                      StringEn.LOGIN_SUB_TEXT,
                      style: subHeading_withBold
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
      decoration: textfield_decoration.copyWith(
        hintText: 'UserName',
      ),
    );
  }
  /* widget for password layout */
  Widget getPasswordLayout(){
  return  TextFormField(
    controller: password,
    obscureText: true,
    decoration: textfield_decoration.copyWith(
      hintText: 'Password',
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity()));
      },
      child:  Text(StringEn.LOG_IN,
        style: button_text_style),
    ),
  );
  }

}


