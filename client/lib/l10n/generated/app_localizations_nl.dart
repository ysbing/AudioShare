// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Systeeminstellingen openen';

  @override
  String get noDevices => 'Geen apparaten gevonden';

  @override
  String get connect => 'Verbinden';

  @override
  String get connecting => 'Verbinden';

  @override
  String get disconnect => 'Verbinding verbreken';

  @override
  String get autoConnectLastDevice =>
      'Automatisch verbinden met het laatst gebruikte apparaat';

  @override
  String get language => 'Taal';

  @override
  String get followSystem => 'Systeeminstelling volgen';

  @override
  String get noLanguageMatch => 'Geen overeenkomende taal gevonden';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Opnametoestemming vereist';

  @override
  String get recordingPermissionDescription =>
      'Ga in Systeeminstellingen naar Privacy en beveiliging > Scherm- en systeemaudio opnemen en geef AudioShare toestemming. macOS vereist dat de app opnieuw wordt gestart voordat de nieuwe toestemming geldt: sluit AudioShare af, open het opnieuw en verbind daarna opnieuw.';

  @override
  String get connectionFailedTitle => 'Verbinding mislukt';

  @override
  String get captureInitializationFailed =>
      'De opname van systeemaudio kon niet worden geïnitialiseerd.';

  @override
  String get captureStopped => 'De opname van systeemaudio is gestopt.';

  @override
  String get captureStartFailed =>
      'De opname van systeemaudio kon niet worden gestart.';

  @override
  String get listenerStartFailed =>
      'De lokale audiostreamingservice kon niet worden gestart.';

  @override
  String get noAvailablePort => 'Er is geen lokale luisterpoort beschikbaar.';

  @override
  String get connectAndroidDeviceFailed =>
      'Er is een fout opgetreden bij het verbinden met het Android-apparaat.';

  @override
  String get connectDeviceFailed =>
      'Er is een fout opgetreden bij het verbinden met het apparaat.';

  @override
  String nativeErrorDetails(String code) {
    return 'Foutcode: $code';
  }

  @override
  String get nativeError1000 => 'Initialisatie van de audio-opname is mislukt.';

  @override
  String get nativeError1001 =>
      'Deze macOS-versie ondersteunt geen opname van systeemaudio.';

  @override
  String get nativeError1002 =>
      'Toestemming voor het opnemen van scherm en systeemaudio is niet beschikbaar.';

  @override
  String get nativeError1100 =>
      'De lokale audioluister kon niet worden gestart.';

  @override
  String get nativeError1101 =>
      'De lokale luister-socket kon niet worden aangemaakt.';

  @override
  String get nativeError1102 =>
      'De lokale luister-socket kon niet worden gebonden.';

  @override
  String get nativeError1103 =>
      'De lokale luister-socket kon niet beginnen met luisteren.';

  @override
  String get nativeError1104 => 'De luisterthread kon niet worden aangemaakt.';

  @override
  String get nativeError1105 =>
      'Het starten van de lokale luister is verlopen.';

  @override
  String get nativeError1106 =>
      'De verbinding van het Android-apparaat kon niet worden geaccepteerd.';

  @override
  String get nativeError1107 =>
      'De verbindingscode van het Android-apparaat kon niet worden gelezen.';

  @override
  String get nativeError1200 =>
      'De opname van systeemaudio kon niet worden gestart.';

  @override
  String get nativeError1201 =>
      'De inhoud van de schermdeling kon niet worden opgehaald.';

  @override
  String get nativeError1202 =>
      'Er is geen scherm beschikbaar voor de opname van systeemaudio.';

  @override
  String get nativeError1203 =>
      'De audio-uitvoer van ScreenCaptureKit kon niet worden geconfigureerd.';

  @override
  String get nativeError1204 =>
      'De audio-opname van ScreenCaptureKit kon niet worden gestart.';

  @override
  String get nativeError1205 =>
      'De audio-opname van ScreenCaptureKit is onverwacht gestopt.';

  @override
  String get nativeError1206 =>
      'Het starten van de audio-opname van ScreenCaptureKit is verlopen.';

  @override
  String get nativeErrorUnknown =>
      'Er is een onbekende fout opgetreden bij de opname van systeemaudio.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnose: $message';
  }

  @override
  String get winMinimize => 'Minimaliseren';

  @override
  String get winClose => 'Sluiten';
}
