// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get noDevices => 'No devices found';

  @override
  String get connect => 'Connect';

  @override
  String get connecting => 'Connecting';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get autoConnectLastDevice =>
      'Automatically connect to the last used device';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => 'Chinese (Simplified)';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Recording permission required';

  @override
  String get recordingPermissionDescription =>
      'Screen and system audio recording permission was not granted. In System Settings, go to Privacy & Security > Screen & System Audio Recording, allow AudioShare, then connect again.';

  @override
  String get connectionFailedTitle => 'Connection failed';

  @override
  String get captureInitializationFailed =>
      'System audio capture could not be initialized.';

  @override
  String get captureStopped => 'System audio capture stopped.';

  @override
  String get captureStartFailed => 'System audio capture could not be started.';

  @override
  String get listenerStartFailed =>
      'The local audio streaming service could not be started.';

  @override
  String get noAvailablePort => 'No local listening port is available.';

  @override
  String get connectAndroidDeviceFailed =>
      'An error occurred while connecting to the Android device.';

  @override
  String get connectDeviceFailed =>
      'An error occurred while connecting to the device.';

  @override
  String nativeErrorDetails(String code) {
    return 'Error code: $code';
  }

  @override
  String get nativeError1000 => 'Audio capture initialization failed.';

  @override
  String get nativeError1001 =>
      'This macOS version does not support system audio capture.';

  @override
  String get nativeError1002 =>
      'Screen and system audio recording permission is unavailable.';

  @override
  String get nativeError1100 =>
      'The local audio listener could not be started.';

  @override
  String get nativeError1101 =>
      'The local listening socket could not be created.';

  @override
  String get nativeError1102 =>
      'The local listening socket could not be bound.';

  @override
  String get nativeError1103 =>
      'The local listening socket could not start listening.';

  @override
  String get nativeError1104 =>
      'The local listener thread could not be created.';

  @override
  String get nativeError1105 => 'Starting the local listener timed out.';

  @override
  String get nativeError1106 => 'The Android connection could not be accepted.';

  @override
  String get nativeError1107 =>
      'The Android connection code could not be read.';

  @override
  String get nativeError1200 => 'System audio capture could not be started.';

  @override
  String get nativeError1201 => 'Screen sharing content could not be obtained.';

  @override
  String get nativeError1202 =>
      'No display is available for system audio capture.';

  @override
  String get nativeError1203 =>
      'ScreenCaptureKit audio output could not be configured.';

  @override
  String get nativeError1204 =>
      'ScreenCaptureKit audio capture could not be started.';

  @override
  String get nativeError1205 =>
      'ScreenCaptureKit audio capture stopped unexpectedly.';

  @override
  String get nativeError1206 =>
      'Starting ScreenCaptureKit audio capture timed out.';

  @override
  String get nativeErrorUnknown =>
      'An unknown system audio capture error occurred.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostic: $message';
  }
}
