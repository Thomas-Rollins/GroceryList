import 'package:flutter/material.dart';
import 'package:grocery_list/caches/shared_preferences/shared_preferences_helper.dart';

class LanguageProvider extends ChangeNotifier {
  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;

  Locale _appLocale = const Locale('en');

  LanguageProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
  }

  Locale get appLocale {
    _sharedPrefsHelper.appLocale?.then((localeValue) {
      _appLocale = Locale(localeValue);
    });

    return _appLocale;
  }

  void updateLanguage(String languageCode) {
    _appLocale = const Locale("en");

    _sharedPrefsHelper.changeLanguage(languageCode);
    notifyListeners();
  }
}