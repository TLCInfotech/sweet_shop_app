import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  void _changeLanguage(BuildContext context, String languageCode) {
    Locale newLocale = Locale(languageCode);
     MyApp.setLocale(context, newLocale);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(
    )));
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
    _changeLanguage(context, languageCode);
    AppPreferences.setLang(languageCodeSet);
    MyApp();
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
