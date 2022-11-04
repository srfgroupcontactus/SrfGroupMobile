import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocale extends ChangeNotifier {

  Locale? _locale;

  Locale get locale => _locale ?? Locale('en');

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language') == null) {
      _locale = Locale('fr');
      return Null;
    }
    _locale = Locale(prefs.getString('language').toString());
    return Null;
  }

  void changeLocale(Locale newLocale) async  {
    var prefs = await SharedPreferences.getInstance();
    if(newLocale == Locale('fr')) {
      _locale = Locale('fr');
      await prefs.setString('language', 'fr');
    } else {
      _locale = Locale('en');
      await prefs.setString('language', 'en');
    }
    notifyListeners();
  }
}
