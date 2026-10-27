import 'package:flutter/widgets.dart';

/// A language the app ships a translation for.
class AppLanguage {
  const AppLanguage(this.id, this.locale, this.name, this.englishName);

  /// Stable identifier for the language, also what gets stored in the
  /// preferences file. Matches the locale suffix of the ARB file.
  final String id;

  /// The locale this language resolves to.
  ///
  /// Country codes go into the positional argument because that is how
  /// Flutter's own generated localizations spell them: `Locale('zh', 'TW')`.
  final Locale locale;

  /// The language's name in that language. Showing autonyms keeps the menu
  /// readable for people who do not read the language the app is currently
  /// displayed in.
  final String name;

  /// The language's name in English, used to make the language list
  /// searchable by either name.
  final String englishName;

  /// Everything the language search should match, lowercased.
  List<String> get searchTerms =>
      [name.toLowerCase(), englishName.toLowerCase(), id.toLowerCase()];

  @override
  String toString() => 'AppLanguage($id)';
}

/// The id of the "follow the device language" option.
///
/// It is stored in the preferences file like a language id, but it is not a
/// language of its own: the app keeps using whatever the device reports.
const String followSystemLanguageId = 'system';

/// Every language the app can be displayed in.
///
/// Ordered by how widely each language is spoken, with the two Chinese
/// variants kept next to each other and English first because it is the
/// fallback for devices running a language that is not listed here.
const List<AppLanguage> supportedLanguages = <AppLanguage>[
  AppLanguage('en', Locale('en'), 'English', 'English'),
  AppLanguage('zh', Locale('zh'), '简体中文', 'Chinese (Simplified)'),
  AppLanguage('zh_TW', Locale('zh', 'TW'), '繁體中文', 'Chinese (Traditional)'),
  AppLanguage('es', Locale('es'), 'Español', 'Spanish'),
  AppLanguage('ar', Locale('ar'), 'العربية', 'Arabic'),
  AppLanguage('hi', Locale('hi'), 'हिन्दी', 'Hindi'),
  AppLanguage('pt', Locale('pt'), 'Português', 'Portuguese'),
  AppLanguage('ru', Locale('ru'), 'Русский', 'Russian'),
  AppLanguage('ja', Locale('ja'), '日本語', 'Japanese'),
  AppLanguage('de', Locale('de'), 'Deutsch', 'German'),
  AppLanguage('tr', Locale('tr'), 'Türkçe', 'Turkish'),
  AppLanguage('vi', Locale('vi'), 'Tiếng Việt', 'Vietnamese'),
  AppLanguage('ko', Locale('ko'), '한국어', 'Korean'),
  AppLanguage('fr', Locale('fr'), 'Français', 'French'),
  AppLanguage('it', Locale('it'), 'Italiano', 'Italian'),
  AppLanguage('th', Locale('th'), 'ไทย', 'Thai'),
  AppLanguage('id', Locale('id'), 'Bahasa Indonesia', 'Indonesian'),
  AppLanguage('pl', Locale('pl'), 'Polski', 'Polish'),
  AppLanguage('uk', Locale('uk'), 'Українська', 'Ukrainian'),
  AppLanguage('nl', Locale('nl'), 'Nederlands', 'Dutch'),
  AppLanguage('ro', Locale('ro'), 'Română', 'Romanian'),
  AppLanguage('el', Locale('el'), 'Ελληνικά', 'Greek'),
  AppLanguage('sv', Locale('sv'), 'Svenska', 'Swedish'),
  AppLanguage('cs', Locale('cs'), 'Čeština', 'Czech'),
  AppLanguage('hu', Locale('hu'), 'Magyar', 'Hungarian'),
  AppLanguage('he', Locale('he'), 'עברית', 'Hebrew'),
  AppLanguage('da', Locale('da'), 'Dansk', 'Danish'),
  AppLanguage('fi', Locale('fi'), 'Suomi', 'Finnish'),
];

/// The locales the app supports, in the order of [supportedLanguages].
List<Locale> get supportedLocales =>
    supportedLanguages.map((language) => language.locale).toList();

/// The language used when the device runs a language the app has no
/// translation for.
AppLanguage get fallbackLanguage => supportedLanguages.first;

/// The language stored under [id], or null when no translation exists.
AppLanguage? languageById(String id) {
  for (final language in supportedLanguages) {
    if (language.id == id) return language;
  }
  return null;
}

/// The language whose locale equals [locale], or null.
AppLanguage? languageByLocale(Locale locale) {
  for (final language in supportedLanguages) {
    if (language.locale == locale) return language;
  }
  return null;
}

/// The language that best matches the device's [deviceLocale], or null when
/// the app has no translation for it.
AppLanguage? resolveLanguage(Locale? deviceLocale) {
  if (deviceLocale == null) return null;

  // An exact match, for example zh-TW on a Traditional Chinese install.
  final exact = languageById(deviceLocale.toString());
  if (exact != null) return exact;

  // Chinese needs its script handled separately: Simplified and Traditional
  // are separate translations, and the country alone is not always reported.
  if (deviceLocale.languageCode == 'zh') {
    final variant = _chineseVariant(deviceLocale);
    if (variant != null) return languageById(variant);
  }

  // Any other language falls back to its base translation.
  for (final language in supportedLanguages) {
    if (language.locale.languageCode == deviceLocale.languageCode) {
      return language;
    }
  }
  return null;
}

/// The Chinese variant [locale] belongs to, or null when it is not
/// conclusive.
String? _chineseVariant(Locale locale) {
  switch (locale.scriptCode) {
    case 'Hant':
      return 'zh_TW';
    case 'Hans':
      return 'zh';
  }
  switch (locale.countryCode) {
    case 'TW':
    case 'HK':
    case 'MO':
      return 'zh_TW';
  }
  return null;
}
