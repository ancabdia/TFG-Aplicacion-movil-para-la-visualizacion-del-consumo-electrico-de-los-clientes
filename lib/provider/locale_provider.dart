import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class LocaleProvider extends ChangeNotifier{
  Locale _locale = Locale('es');
  Locale get locale => _locale;

  void setLocale(Locale locale){
    LocalizationsDelegate<AppLocalizations> delegate = AppLocalizations.delegate;
    if(!delegate.isSupported(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale(){
    _locale = const Locale('es');
    notifyListeners();
  }
}