import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension TranslateExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

const Map<String, String> codeToName = {
  "en": "English",
  "es": "Español",
  "tr": "Türkçe",
  "ru": "Русский",
};

extension FullName on Locale {
  String fullName() {
    return codeToName[languageCode] ?? "Unknown";
  }
}

const supportedLocale = const [
  Locale('en'), // English
  Locale('es'), // Spanish
  Locale('tr'),
  Locale('ru'),
];
