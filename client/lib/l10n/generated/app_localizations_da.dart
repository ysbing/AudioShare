// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Åbn systemindstillinger';

  @override
  String get noDevices => 'Ingen enheder blev fundet';

  @override
  String get connect => 'Opret forbindelse';

  @override
  String get connecting => 'Opretter forbindelse';

  @override
  String get disconnect => 'Afbryd forbindelsen';

  @override
  String get autoConnectLastDevice =>
      'Opret automatisk forbindelse til den senest brugte enhed';

  @override
  String get language => 'Sprog';

  @override
  String get followSystem => 'Følg systemet';

  @override
  String get noLanguageMatch => 'Ingen matchende sprog fundet';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Optagelsestilladelse påkrævet';

  @override
  String get recordingPermissionDescription =>
      'Gå til Systemindstillinger > Privatliv og sikkerhed > Optagelse af skærm og systemlyd, og tillad AudioShare. macOS kræver, at appen genstarter, før den nye tilladelse træder i kraft: luk AudioShare, åbn den igen, og opret forbindelse på ny.';

  @override
  String get connectionFailedTitle => 'Forbindelsen mislykkedes';

  @override
  String get captureInitializationFailed =>
      'Optagelsen af systemlyd kunne ikke initialiseres.';

  @override
  String get captureStopped => 'Optagelsen af systemlyd blev stoppet.';

  @override
  String get captureStartFailed =>
      'Optagelsen af systemlyd kunne ikke startes.';

  @override
  String get listenerStartFailed =>
      'Den lokale lydstreamingtjeneste kunne ikke startes.';

  @override
  String get noAvailablePort => 'Der er ingen tilgængelig lokal lytteport.';

  @override
  String get connectAndroidDeviceFailed =>
      'Der opstod en fejl under forbindelse til Android-enheden.';

  @override
  String get connectDeviceFailed =>
      'Der opstod en fejl under forbindelse til enheden.';

  @override
  String nativeErrorDetails(String code) {
    return 'Fejlkode: $code';
  }

  @override
  String get nativeError1000 => 'Initialisering af lydoptagelse mislykkedes.';

  @override
  String get nativeError1001 =>
      'Denne version af macOS understøtter ikke optagelse af systemlyd.';

  @override
  String get nativeError1002 =>
      'Tilladelse til optagelse af skærm og systemlyd er ikke tilgængelig.';

  @override
  String get nativeError1100 => 'Den lokale lydlytter kunne ikke startes.';

  @override
  String get nativeError1101 => 'Den lokale lyttersocket kunne ikke oprettes.';

  @override
  String get nativeError1102 => 'Den lokale lyttersocket kunne ikke bindes.';

  @override
  String get nativeError1103 =>
      'Den lokale lyttersocket kunne ikke begynde at lytte.';

  @override
  String get nativeError1104 => 'Den lokale lyttertråd kunne ikke oprettes.';

  @override
  String get nativeError1105 => 'Start af den lokale lytter fik timeout.';

  @override
  String get nativeError1106 =>
      'Forbindelsen fra Android-enheden kunne ikke accepteres.';

  @override
  String get nativeError1107 =>
      'Forbindelseskoden for Android-enheden kunne ikke læses.';

  @override
  String get nativeError1200 => 'Optagelsen af systemlyd kunne ikke startes.';

  @override
  String get nativeError1201 => 'Indholdet af skærmdelingen kunne ikke hentes.';

  @override
  String get nativeError1202 =>
      'Der er ingen skærm tilgængelig til optagelse af systemlyd.';

  @override
  String get nativeError1203 =>
      'Lydudgangen for ScreenCaptureKit kunne ikke konfigureres.';

  @override
  String get nativeError1204 =>
      'Lydoptagelsen i ScreenCaptureKit kunne ikke startes.';

  @override
  String get nativeError1205 =>
      'Lydoptagelsen i ScreenCaptureKit stoppede uventet.';

  @override
  String get nativeError1206 =>
      'Start af lydoptagelsen i ScreenCaptureKit fik timeout.';

  @override
  String get nativeErrorUnknown =>
      'Der opstod en ukendt fejl under optagelse af systemlyd.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnose: $message';
  }
}
