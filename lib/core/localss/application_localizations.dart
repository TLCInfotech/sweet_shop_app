import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/localss/application_localizations_delegate.dart';

class ApplicationLocalizations {
    Locale? appLocale;

 ApplicationLocalizations(this.appLocale) {
    // TODO: implement

  }

  static ApplicationLocalizations? of(BuildContext context) {
    return Localizations.of<ApplicationLocalizations>(context, ApplicationLocalizations);
  }

  static const LocalizationsDelegate<ApplicationLocalizations> delegate =
  ApplicationLocalizationsDelegate();

  Map<String, String> _localizedStrings=Map<String, String>();

  Future<bool> load() async {
    // Load JSON file from the "language" folder
    String jsonString =
    await rootBundle.loadString('assets/translations/${appLocale!.languageCode}.json');
    Map<String, dynamic> jsonLanguageMap = json.decode(jsonString);
    _localizedStrings = jsonLanguageMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  // called from every widget which needs a localized text
  String? translate(String jsonkey) {
    return _localizedStrings[jsonkey];
  }
}