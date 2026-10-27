import 'dart:convert';
import 'dart:io';

import 'package:audioshare/l10n/generated/app_localizations.dart';
import 'package:audioshare/l10n/language_dialog.dart';
import 'package:audioshare/l10n/supported_languages.dart';
import 'package:audioshare/utils/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _readArb(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();

Widget _localizedApp({required Widget home, Locale? locale}) {
  return ScreenUtilInit(
    designSize: designSize,
    child: MaterialApp(
      locale: locale ?? const Locale('en'),
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    ),
  );
}

void main() {
  group('translations', () {
    final template = _readArb('lib/l10n/app_en.arb');

    test('every supported language has a translation file', () {
      for (final language in supportedLanguages) {
        expect(
          File('lib/l10n/app_${language.id}.arb').existsSync(),
          isTrue,
          reason: 'missing translation file for ${language.id}',
        );
      }
    });

    test('every translation file covers all messages', () {
      for (final language in supportedLanguages) {
        final messages = _readArb('lib/l10n/app_${language.id}.arb');
        expect(
          _messageKeys(messages),
          _messageKeys(template),
          reason: '${language.id} does not translate every message',
        );
      }
    });

    test('no translation is left blank', () {
      for (final language in supportedLanguages) {
        final messages = _readArb('lib/l10n/app_${language.id}.arb');
        for (final entry in messages.entries) {
          if (entry.key.startsWith('@')) continue;
          expect(
            entry.value,
            isNotEmpty,
            reason: '${language.id}.${entry.key} is blank',
          );
        }
      }
    });

    test('placeholders match the template', () {
      for (final language in supportedLanguages) {
        final messages = _readArb('lib/l10n/app_${language.id}.arb');
        for (final entry in messages.entries) {
          if (!entry.key.startsWith('@') || entry.key.startsWith('@@')) continue;
          expect(
            entry.value,
            template[entry.key],
            reason: '${language.id}.${entry.key} has different placeholders',
          );
        }
      }
    });
  });

  group('language list', () {
    test('matches the generated localizations', () {
      expect(AppLocalizations.supportedLocales, unorderedEquals(supportedLocales));
    });

    test('ids are unique', () {
      final ids = supportedLanguages.map((language) => language.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('every language is found by its id', () {
      for (final language in supportedLanguages) {
        expect(languageById(language.id)?.locale, language.locale);
        expect(languageByLocale(language.locale)?.id, language.id);
      }
    });

    test('the follow-system option is not a language of its own', () {
      expect(languageById(followSystemLanguageId), isNull);
      expect(
        supportedLanguages.any((language) => language.id == followSystemLanguageId),
        isFalse,
      );
    });
  });

  group('resolveLanguage', () {
    test('matches the device language', () {
      expect(resolveLanguage(const Locale('ja'))?.id, 'ja');
      expect(resolveLanguage(const Locale('ja', 'JP'))?.id, 'ja');
      expect(resolveLanguage(const Locale.fromSubtags(
        languageCode: 'pt',
        countryCode: 'BR',
      ))?.id, 'pt');
    });

    test('prefers Traditional Chinese for Traditional Chinese devices', () {
      expect(
        resolveLanguage(const Locale.fromSubtags(
          languageCode: 'zh',
          countryCode: 'TW',
        ))?.id,
        'zh_TW',
      );
      expect(
        resolveLanguage(const Locale.fromSubtags(
          languageCode: 'zh',
          countryCode: 'HK',
        ))?.id,
        'zh_TW',
      );
      expect(
        resolveLanguage(const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
        ))?.id,
        'zh_TW',
      );
    });

    test('keeps Simplified Chinese for Simplified Chinese devices', () {
      expect(resolveLanguage(const Locale('zh'))?.id, 'zh');
      expect(
        resolveLanguage(const Locale.fromSubtags(
          languageCode: 'zh',
          countryCode: 'CN',
        ))?.id,
        'zh',
      );
      expect(
        resolveLanguage(const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hans',
        ))?.id,
        'zh',
      );
    });

    test('returns null for languages the app does not translate', () {
      expect(resolveLanguage(const Locale('is')), isNull);
      expect(resolveLanguage(null), isNull);
    });
  });

  group('localized rendering', () {
    testWidgets('every language renders its own translation', (tester) async {
      for (final language in supportedLanguages) {
        final messages = _readArb('lib/l10n/app_${language.id}.arb');
        await tester.pumpWidget(_localizedApp(
          locale: language.locale,
          home: Builder(
            builder: (context) =>
                Text(AppLocalizations.of(context).connect),
          ),
        ));
        expect(
          find.text(messages['connect'] as String),
          findsOneWidget,
          reason: '${language.id} did not render its translation',
        );
      }
    });

    testWidgets('right-to-left languages lay out from the right', (tester) async {
      await tester.pumpWidget(_localizedApp(
        locale: const Locale('ar'),
        home: Builder(
          builder: (context) => Directionality(
            textDirection: Directionality.of(context),
            child: Text(AppLocalizations.of(context).connect),
          ),
        ),
      ));
      expect(Directionality.of(tester.element(find.text('اتصال'))),
          TextDirection.rtl);
    });
  });

  group('language dialog', () {
    Future<void> openDialog(
      WidgetTester tester, {
      required String currentId,
      AppLanguage? deviceLanguage,
    }) async {
      await tester.pumpWidget(_localizedApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => LanguageDialog.show(
              context,
              currentId: currentId,
              deviceLanguage: deviceLanguage ?? fallbackLanguage,
            ),
            child: const Text('open'),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('filters the list by either name', (tester) async {
      await openDialog(tester, currentId: 'en');
      expect(find.text('English'), findsWidgets);
      expect(find.text('简体中文'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'japanese');
      await tester.pumpAndSettle();
      expect(find.text('日本語'), findsOneWidget);
      expect(find.text('简体中文'), findsNothing);

      await tester.enterText(find.byType(TextField), '繁體');
      await tester.pumpAndSettle();
      expect(find.text('繁體中文'), findsOneWidget);
      expect(find.text('简体中文'), findsNothing);
    });

    testWidgets('offers following the device language', (tester) async {
      await openDialog(
        tester,
        currentId: followSystemLanguageId,
        deviceLanguage: languageById('ja')!,
      );
      expect(find.text('Follow system'), findsOneWidget);

      final tile = tester.widget<ListTile>(
        find.widgetWithText(ListTile, 'Follow system'),
      );
      expect((tile.subtitle! as Text).data, '日本語');
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('returns the follow-system id when it is picked',
        (tester) async {
      String? result;
      await tester.pumpWidget(_localizedApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await LanguageDialog.show(
                context,
                currentId: 'en',
                deviceLanguage: fallbackLanguage,
              );
            },
            child: const Text('open'),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Follow system'));
      await tester.pumpAndSettle();
      expect(result, followSystemLanguageId);
    });
  });
}
