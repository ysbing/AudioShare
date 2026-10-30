// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Systemeinstellungen öffnen';

  @override
  String get noDevices => 'Keine Geräte gefunden';

  @override
  String get connect => 'Verbinden';

  @override
  String get connecting => 'Verbinden';

  @override
  String get disconnect => 'Trennen';

  @override
  String get autoConnectLastDevice =>
      'Automatisch mit dem zuletzt verwendeten Gerät verbinden';

  @override
  String get language => 'Sprache';

  @override
  String get followSystem => 'Systemeinstellungen folgen';

  @override
  String get noLanguageMatch => 'Keine passende Sprache';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Aufnahmeberechtigung erforderlich';

  @override
  String get recordingPermissionDescription =>
      'Öffne in den Systemeinstellungen Datenschutz & Sicherheit > Bildschirm- und Systemaudioaufnahme und erlaube AudioShare. macOS verlangt einen Neustart der App, damit die neue Berechtigung wirksam wird. Beende AudioShare, öffne es erneut und stelle anschließend die Verbindung noch einmal her.';

  @override
  String get connectionFailedTitle => 'Verbindung fehlgeschlagen';

  @override
  String get captureInitializationFailed =>
      'Die Systemaudioaufnahme konnte nicht initialisiert werden.';

  @override
  String get captureStopped => 'Die Systemaudioaufnahme wurde beendet.';

  @override
  String get captureStartFailed =>
      'Die Systemaudioaufnahme konnte nicht gestartet werden.';

  @override
  String get listenerStartFailed =>
      'Der lokale Audio-Streamingdienst konnte nicht gestartet werden.';

  @override
  String get noAvailablePort => 'Es ist kein lokaler Listening-Port verfügbar.';

  @override
  String get connectAndroidDeviceFailed =>
      'Beim Verbinden mit dem Android-Gerät ist ein Fehler aufgetreten.';

  @override
  String get connectDeviceFailed =>
      'Beim Verbinden mit dem Gerät ist ein Fehler aufgetreten.';

  @override
  String nativeErrorDetails(String code) {
    return 'Fehlercode: $code';
  }

  @override
  String get nativeError1000 =>
      'Audioaufnahme konnte nicht initialisiert werden.';

  @override
  String get nativeError1001 =>
      'Diese macOS-Version unterstützt keine Systemaudioaufnahme.';

  @override
  String get nativeError1002 =>
      'Die Berechtigung für Bildschirm- und Systemaudioaufnahme ist nicht verfügbar.';

  @override
  String get nativeError1100 =>
      'Der lokale Audio-Listener konnte nicht gestartet werden.';

  @override
  String get nativeError1101 =>
      'Der lokale Listening-Socket konnte nicht erstellt werden.';

  @override
  String get nativeError1102 =>
      'Der lokale Listening-Socket konnte nicht gebunden werden.';

  @override
  String get nativeError1103 =>
      'Der lokale Listening-Socket konnte nicht mit dem Lauschen beginnen.';

  @override
  String get nativeError1104 =>
      'Der lokale Listener-Thread konnte nicht erstellt werden.';

  @override
  String get nativeError1105 =>
      'Zeitüberschreitung beim Starten des lokalen Listeners.';

  @override
  String get nativeError1106 =>
      'Die Verbindung des Android-Geräts konnte nicht angenommen werden.';

  @override
  String get nativeError1107 =>
      'Der Verbindungscode des Android-Geräts konnte nicht gelesen werden.';

  @override
  String get nativeError1200 =>
      'Die Systemaudioaufnahme konnte nicht gestartet werden.';

  @override
  String get nativeError1201 =>
      'Der Inhalt der Bildschirmfreigabe konnte nicht abgerufen werden.';

  @override
  String get nativeError1202 =>
      'Es ist kein Display für die Systemaudioaufnahme verfügbar.';

  @override
  String get nativeError1203 =>
      'Die ScreenCaptureKit-Audioausgabe konnte nicht konfiguriert werden.';

  @override
  String get nativeError1204 =>
      'Die ScreenCaptureKit-Audioaufnahme konnte nicht gestartet werden.';

  @override
  String get nativeError1205 =>
      'Die ScreenCaptureKit-Audioaufnahme wurde unerwartet beendet.';

  @override
  String get nativeError1206 =>
      'Zeitüberschreitung beim Starten der ScreenCaptureKit-Audioaufnahme.';

  @override
  String get nativeErrorUnknown =>
      'Ein unbekannter Fehler bei der Systemaudioaufnahme ist aufgetreten.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnose: $message';
  }

  @override
  String get winMinimize => 'Minimieren';

  @override
  String get winClose => 'Schließen';
}
