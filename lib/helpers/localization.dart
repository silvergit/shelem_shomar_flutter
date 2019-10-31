// this class is used for localizations
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalizations {
  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  String getText(String key) => language[key];
}

Map<String, dynamic> language;

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) async {
    String string =
        await rootBundle.loadString("assets/json/${locale.languageCode}.json");
    language = json.decode(string);
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations());
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
