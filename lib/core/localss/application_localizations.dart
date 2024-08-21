/*
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

  static const LocalizationsDelegate<ApplicationLocalizations> delegate = ApplicationLocalizationsDelegate();

  Map<String, String> _localizedStrings=Map<String, String>();

  Future<bool> load() async {
    // Load JSON file from the "language" folder
    String jsonString = await rootBundle.loadString('assets/translations/${appLocale!.languageCode}.json');
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
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_shop_app/core/app_preferance.dart';


class ApplicationLocalizations {
  final Locale locale;

  ApplicationLocalizations(this.locale);

  static const LocalizationsDelegate<ApplicationLocalizations> delegate = _ApplicationLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    Locale _locale = Locale('en');
    String lang = await AppPreferences.getLang();
    if(lang=="mr_IN"){
      lang="mr";
    }else if(lang=="hi_IN"){
      lang="hi";
    }else{
      lang="en";
    }
    _locale = Locale(lang);
    String jsonString = await rootBundle.loadString('assets/translations/${_locale.languageCode}.json');
    print("translationstranslations  ${locale.languageCode} \n  $jsonString   ");
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? 'Translation not found';
  }

  static ApplicationLocalizations of(BuildContext context) {
    final instance = Localizations.of<ApplicationLocalizations>(context, ApplicationLocalizations);
    if (instance == null) {
      throw Exception('No ApplicationLocalizations found in context');
    }
    return instance;
  }
}

class _ApplicationLocalizationsDelegate extends LocalizationsDelegate<ApplicationLocalizations> {
  const _ApplicationLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'mr', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<ApplicationLocalizations> load(Locale locale) async {
    ApplicationLocalizations localizations = ApplicationLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_ApplicationLocalizationsDelegate old) => false;
}
