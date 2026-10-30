// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'Гаразд';

  @override
  String get openSystemSettings => 'Відкрити системні параметри';

  @override
  String get noDevices => 'Пристроїв не знайдено';

  @override
  String get connect => 'Підключити';

  @override
  String get connecting => 'Підключення';

  @override
  String get disconnect => 'Відключити';

  @override
  String get autoConnectLastDevice =>
      'Автоматично підключатися до останнього використаного пристрою';

  @override
  String get language => 'Мова';

  @override
  String get followSystem => 'Як у системі';

  @override
  String get noLanguageMatch => 'Відповідної мови не знайдено';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Потрібен дозвіл на запис';

  @override
  String get recordingPermissionDescription =>
      'У «Системних параметрах» відкрийте «Конфіденційність і безпека» > «Запис екрана та системного звуку» і дозвольте AudioShare. Щоб новий дозвіл набув чинності, macOS потребує перезапуску застосунку: закрийте AudioShare, відкрийте його знову та повторіть підключення.';

  @override
  String get connectionFailedTitle => 'Не вдалося підключитися';

  @override
  String get captureInitializationFailed =>
      'Не вдалося ініціалізувати захоплення системного звуку.';

  @override
  String get captureStopped => 'Захоплення системного звуку зупинено.';

  @override
  String get captureStartFailed =>
      'Не вдалося почати захоплення системного звуку.';

  @override
  String get listenerStartFailed =>
      'Не вдалося запустити локальну службу трансляції звуку.';

  @override
  String get noAvailablePort =>
      'Немає доступних локальних портів прослуховування.';

  @override
  String get connectAndroidDeviceFailed =>
      'Під час підключення до пристрою Android сталася помилка.';

  @override
  String get connectDeviceFailed =>
      'Під час підключення до пристрою сталася помилка.';

  @override
  String nativeErrorDetails(String code) {
    return 'Код помилки: $code';
  }

  @override
  String get nativeError1000 => 'Не вдалося ініціалізувати захоплення звуку.';

  @override
  String get nativeError1001 =>
      'Ця версія macOS не підтримує захоплення системного звуку.';

  @override
  String get nativeError1002 =>
      'Дозвіл на запис екрана та системного звуку недоступний.';

  @override
  String get nativeError1100 =>
      'Не вдалося запустити локальний прослуховувач звуку.';

  @override
  String get nativeError1101 =>
      'Не вдалося створити локальний сокет прослуховування.';

  @override
  String get nativeError1102 =>
      'Не вдалося прив\'язати локальний сокет прослуховування.';

  @override
  String get nativeError1103 =>
      'Локальний сокет прослуховування не зміг почати прослуховування.';

  @override
  String get nativeError1104 =>
      'Не вдалося створити потік локального прослуховування.';

  @override
  String get nativeError1105 =>
      'Час очікування запуску локального прослуховувача вичерпано.';

  @override
  String get nativeError1106 =>
      'Не вдалося прийняти підключення від пристрою Android.';

  @override
  String get nativeError1107 =>
      'Не вдалося прочитати код підключення пристрою Android.';

  @override
  String get nativeError1200 =>
      'Не вдалося почати захоплення системного звуку.';

  @override
  String get nativeError1201 =>
      'Не вдалося отримати вміст спільного доступу до екрана.';

  @override
  String get nativeError1202 =>
      'Немає доступних дисплеїв для захоплення системного звуку.';

  @override
  String get nativeError1203 =>
      'Не вдалося налаштувати аудіовивід ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Не вдалося запустити захоплення звуку ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Захоплення звуку ScreenCaptureKit несподівано зупинилося.';

  @override
  String get nativeError1206 =>
      'Час очікування запуску захоплення звуку ScreenCaptureKit вичерпано.';

  @override
  String get nativeErrorUnknown =>
      'Сталася невідома помилка захоплення системного звуку.';

  @override
  String exceptionDetails(String message) {
    return 'Діагностика: $message';
  }

  @override
  String get winMinimize => 'Згорнути';

  @override
  String get winClose => 'Закрити';
}
