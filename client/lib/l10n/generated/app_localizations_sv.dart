// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Öppna systeminställningar';

  @override
  String get noDevices => 'Inga enheter hittades';

  @override
  String get connect => 'Anslut';

  @override
  String get connecting => 'Ansluter';

  @override
  String get disconnect => 'Koppla ner';

  @override
  String get autoConnectLastDevice =>
      'Anslut automatiskt till den senast använda enheten';

  @override
  String get language => 'Språk';

  @override
  String get followSystem => 'Följ systemet';

  @override
  String get noLanguageMatch => 'Inget matchande språk hittades';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Inspelningsbehörighet krävs';

  @override
  String get recordingPermissionDescription =>
      'I Systeminställningar går du till Säkerhet och sekretess > Skärminspelning och systemljud och tillåter AudioShare. macOS kräver att appen startas om för att den nya behörigheten ska gälla: avsluta AudioShare, öppna det igen och anslut sedan på nytt.';

  @override
  String get connectionFailedTitle => 'Anslutningen misslyckades';

  @override
  String get captureInitializationFailed =>
      'Det gick inte att initiera upptagningen av systemljud.';

  @override
  String get captureStopped => 'Upptagningen av systemljud har stoppats.';

  @override
  String get captureStartFailed =>
      'Det gick inte att starta upptagningen av systemljud.';

  @override
  String get listenerStartFailed =>
      'Det gick inte att starta den lokala ljudströmmingstjänsten.';

  @override
  String get noAvailablePort => 'Ingen lokal lyssningsport är tillgänglig.';

  @override
  String get connectAndroidDeviceFailed =>
      'Ett fel uppstod vid anslutning till Android-enheten.';

  @override
  String get connectDeviceFailed =>
      'Ett fel uppstod vid anslutning till enheten.';

  @override
  String nativeErrorDetails(String code) {
    return 'Felkod: $code';
  }

  @override
  String get nativeError1000 => 'Det gick inte att initiera ljudupptagningen.';

  @override
  String get nativeError1001 =>
      'Den här versionen av macOS stöder inte upptagning av systemljud.';

  @override
  String get nativeError1002 =>
      'Behörigheten för skärminspelning och systemljud är inte tillgänglig.';

  @override
  String get nativeError1100 =>
      'Det gick inte att starta den lokala ljudlyssnaren.';

  @override
  String get nativeError1101 =>
      'Det gick inte att skapa den lokala lyssningssocketen.';

  @override
  String get nativeError1102 =>
      'Det gick inte att binda den lokala lyssningssocketen.';

  @override
  String get nativeError1103 =>
      'Den lokala lyssningssocketen kunde inte börja lyssna.';

  @override
  String get nativeError1104 =>
      'Det gick inte att skapa den lokala lyssningstråden.';

  @override
  String get nativeError1105 =>
      'Tidsgränsen för att starta den lokala lyssnaren överskreds.';

  @override
  String get nativeError1106 =>
      'Det gick inte att acceptera anslutningen från Android-enheten.';

  @override
  String get nativeError1107 =>
      'Det gick inte att läsa Android-enhetens anslutningskod.';

  @override
  String get nativeError1200 =>
      'Det gick inte att starta upptagningen av systemljud.';

  @override
  String get nativeError1201 =>
      'Det gick inte att hämta innehållet i skärmdelningen.';

  @override
  String get nativeError1202 =>
      'Ingen skärm är tillgänglig för upptagning av systemljud.';

  @override
  String get nativeError1203 =>
      'Det gick inte att konfigurera ljudutgången för ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Det gick inte att starta ljudupptagningen i ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Ljudupptagningen i ScreenCaptureKit stoppades oväntat.';

  @override
  String get nativeError1206 =>
      'Tidsgränsen för att starta ljudupptagningen i ScreenCaptureKit överskreds.';

  @override
  String get nativeErrorUnknown =>
      'Ett okänt fel uppstod vid upptagning av systemljud.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostik: $message';
  }
}
