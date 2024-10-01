import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';
import 'package:sweet_shop_app/core/common_style.dart';
import 'package:sweet_shop_app/core/localss/application_localizations.dart';
import 'package:sweet_shop_app/core/size_config.dart';
import 'package:sweet_shop_app/main.dart';

class LanguageSelectionPage extends StatefulWidget {
  final String logoImage;

  const LanguageSelectionPage({Key? key, required this.logoImage}) : super(key: key);

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {




  void changeLanguage(BuildContext context, String selectedLanguageCode) async {
    var _locale = await setLocale(selectedLanguageCode);
    print("_locale   $_locale");
    MyApp.setLocale(context, _locale);
  }
  Future<void> _changeLanguage(BuildContext context, String languageCode) async {
    var newLocale =await setLocale(languageCode);
     MyApp.setLocale(context, newLocale);
    Navigator.of(context).pushReplacementNamed('/dashboard');
 /*   Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
          (Route<dynamic> route) => false, // This removes all the routes
    );*/
  }
  // ndkjsk
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: SafeArea(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            color: Colors.transparent,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: AppBar(
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              title: Container(
                width: SizeConfig.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: FaIcon(Icons.arrow_back),
                    ),
                    widget.logoImage != ""
                        ? Container(
                      height: SizeConfig.screenHeight * .05,
                      width: SizeConfig.screenHeight * .05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          image: DecorationImage(
                            image: FileImage(File(widget.logoImage)),
                            fit: BoxFit.cover,
                          )),
                    )
                        : Container(),
                    Expanded(
                      child: Center(
                        child: Text(
                          ApplicationLocalizations.of(context).translate("select_language"),
                          style: appbar_text_style,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildLanguageOption(
              context,
              'English',
              'assets/images/en_logo.jpg',
              'en_IN',
              'en',
            ),
            _buildLanguageOption(
              context,
              'मराठी',
              'assets/images/mr.jpg',
              'mr_IN',
              'mr',
            ),
            _buildLanguageOption(
              context,
              'हिंदी',
              'assets/images/hi.jpg',
              'hi_IN',
              'hi',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String languageName, String imagePath, String languageCodeSet, String languageCode ) {
    return GestureDetector(
      onTap: () {
  setState(() {
    changeLanguage(context,languageCode);
    _changeLanguage(context, languageCode);
    AppPreferences.setLang(languageCodeSet);
  //  MyApp();
  });

        print("vnjvnfvn  $languageCode");
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueAccent.withOpacity(0.1),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
              SizedBox(height: 20),
              Text(
                languageName,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
String prefSelectedLanguageCode = "SelectedLanguageCode";
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "en";
  print("languageCode....    $languageCode");
  return _locale(languageCode);
}
Locale _locale(String languageCode) {
  print("languageCode    $languageCode");
  return languageCode != null && languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : Locale('en', '');
}