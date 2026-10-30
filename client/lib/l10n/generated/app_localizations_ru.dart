// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'ОК';

  @override
  String get openSystemSettings => 'Открыть системные настройки';

  @override
  String get noDevices => 'Устройства не найдены';

  @override
  String get connect => 'Подключить';

  @override
  String get connecting => 'Подключение';

  @override
  String get disconnect => 'Отключить';

  @override
  String get autoConnectLastDevice =>
      'Автоматически подключаться к последнему использованному устройству';

  @override
  String get language => 'Язык';

  @override
  String get followSystem => 'Как в системе';

  @override
  String get noLanguageMatch => 'Нет подходящего языка';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Требуется разрешение на запись';

  @override
  String get recordingPermissionDescription =>
      'В «Системных настройках» откройте «Конфиденциальность и безопасность» > «Запись экрана и системного звука» и разрешите AudioShare. Для применения нового разрешения macOS требует перезапуска приложения: закройте AudioShare, откройте его снова и повторите подключение.';

  @override
  String get connectionFailedTitle => 'Не удалось подключиться';

  @override
  String get captureInitializationFailed =>
      'Не удалось инициализировать захват системного звука.';

  @override
  String get captureStopped => 'Захват системного звука остановлен.';

  @override
  String get captureStartFailed => 'Не удалось начать захват системного звука.';

  @override
  String get listenerStartFailed =>
      'Не удалось запустить локальную службу потоковой передачи звука.';

  @override
  String get noAvailablePort => 'Нет доступных локальных портов прослушивания.';

  @override
  String get connectAndroidDeviceFailed =>
      'Произошла ошибка при подключении к устройству Android.';

  @override
  String get connectDeviceFailed =>
      'Произошла ошибка при подключении к устройству.';

  @override
  String nativeErrorDetails(String code) {
    return 'Код ошибки: $code';
  }

  @override
  String get nativeError1000 => 'Не удалось инициализировать захват звука.';

  @override
  String get nativeError1001 =>
      'Эта версия macOS не поддерживает захват системного звука.';

  @override
  String get nativeError1002 =>
      'Недоступно разрешение на запись экрана и системного звука.';

  @override
  String get nativeError1100 =>
      'Не удалось запустить локальный прослушиватель звука.';

  @override
  String get nativeError1101 =>
      'Не удалось создать локальный сокет прослушивания.';

  @override
  String get nativeError1102 =>
      'Не удалось привязать локальный сокет прослушивания.';

  @override
  String get nativeError1103 =>
      'Локальный сокет прослушивания не смог начать прослушивание.';

  @override
  String get nativeError1104 =>
      'Не удалось создать поток локального прослушивания.';

  @override
  String get nativeError1105 =>
      'Истекло время ожидания запуска локального прослушивателя.';

  @override
  String get nativeError1106 =>
      'Не удалось принять подключение от устройства Android.';

  @override
  String get nativeError1107 =>
      'Не удалось прочитать код подключения устройства Android.';

  @override
  String get nativeError1200 => 'Не удалось начать захват системного звука.';

  @override
  String get nativeError1201 =>
      'Не удалось получить содержимое общего доступа к экрану.';

  @override
  String get nativeError1202 =>
      'Нет доступных дисплеев для захвата системного звука.';

  @override
  String get nativeError1203 =>
      'Не удалось настроить аудиовыход ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Не удалось запустить захват звука ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Захват звука ScreenCaptureKit неожиданно остановился.';

  @override
  String get nativeError1206 =>
      'Истекло время ожидания запуска захвата звука ScreenCaptureKit.';

  @override
  String get nativeErrorUnknown =>
      'Произошла неизвестная ошибка захвата системного звука.';

  @override
  String exceptionDetails(String message) {
    return 'Диагностика: $message';
  }

  @override
  String get winMinimize => 'Свернуть';

  @override
  String get winClose => 'Закрыть';
}
