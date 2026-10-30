// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Deschide setările sistemului';

  @override
  String get noDevices => 'Nu s-a găsit niciun dispozitiv';

  @override
  String get connect => 'Conectare';

  @override
  String get connecting => 'Se conectează';

  @override
  String get disconnect => 'Deconectare';

  @override
  String get autoConnectLastDevice =>
      'Conectare automată la ultimul dispozitiv folosit';

  @override
  String get language => 'Limbă';

  @override
  String get followSystem => 'Ca în sistem';

  @override
  String get noLanguageMatch => 'Nicio limbă corespunzătoare nu a fost găsită';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle =>
      'Este necesară permisiunea de înregistrare';

  @override
  String get recordingPermissionDescription =>
      'În Setările sistemului, mergeți la Confidențialitate și securitate > Înregistrarea ecranului și a sunetului sistemului și permiteți AudioShare. macOS necesită repornirea aplicației pentru ca noua permisiune să intre în vigoare; ieșiți din AudioShare, deschideți-l din nou și apoi reconectați-vă.';

  @override
  String get connectionFailedTitle => 'Conectare nereușită';

  @override
  String get captureInitializationFailed =>
      'Capturarea sunetului sistemului nu a putut fi inițializată.';

  @override
  String get captureStopped => 'Capturarea sunetului sistemului s-a oprit.';

  @override
  String get captureStartFailed =>
      'Capturarea sunetului sistemului nu a putut fi pornită.';

  @override
  String get listenerStartFailed =>
      'Serviciul local de streaming audio nu a putut fi pornit.';

  @override
  String get noAvailablePort =>
      'Nu există niciun port de ascultare local disponibil.';

  @override
  String get connectAndroidDeviceFailed =>
      'A apărut o eroare la conectarea la dispozitivul Android.';

  @override
  String get connectDeviceFailed =>
      'A apărut o eroare la conectarea la dispozitiv.';

  @override
  String nativeErrorDetails(String code) {
    return 'Cod de eroare: $code';
  }

  @override
  String get nativeError1000 => 'Inițializarea capturii audio a eșuat.';

  @override
  String get nativeError1001 =>
      'Această versiune de macOS nu acceptă capturarea sunetului sistemului.';

  @override
  String get nativeError1002 =>
      'Permisiunea de înregistrare a ecranului și a sunetului sistemului nu este disponibilă.';

  @override
  String get nativeError1100 =>
      'Ascultătorul local de audio nu a putut fi pornit.';

  @override
  String get nativeError1101 =>
      'Socketul local de ascultare nu a putut fi creat.';

  @override
  String get nativeError1102 =>
      'Socketul local de ascultare nu a putut fi asociat.';

  @override
  String get nativeError1103 =>
      'Socketul local de ascultare nu a putut începe să asculte.';

  @override
  String get nativeError1104 =>
      'Fireul local de ascultare nu a putut fi creat.';

  @override
  String get nativeError1105 => 'Pornirea ascultătorului local a expirat.';

  @override
  String get nativeError1106 =>
      'Conexiunea de la dispozitivul Android nu a putut fi acceptată.';

  @override
  String get nativeError1107 =>
      'Codul de conexiune al dispozitivului Android nu a putut fi citit.';

  @override
  String get nativeError1200 =>
      'Capturarea sunetului sistemului nu a putut fi pornită.';

  @override
  String get nativeError1201 =>
      'Conținutul partajării ecranului nu a putut fi obținut.';

  @override
  String get nativeError1202 =>
      'Nu există niciun afișaj disponibil pentru capturarea sunetului sistemului.';

  @override
  String get nativeError1203 =>
      'Ieșirea audio ScreenCaptureKit nu a putut fi configurată.';

  @override
  String get nativeError1204 =>
      'Captura audio ScreenCaptureKit nu a putut fi pornită.';

  @override
  String get nativeError1205 =>
      'Captura audio ScreenCaptureKit s-a oprit neașteptat.';

  @override
  String get nativeError1206 =>
      'Pornirea capturii audio ScreenCaptureKit a expirat.';

  @override
  String get nativeErrorUnknown =>
      'A apărut o eroare necunoscută la capturarea sunetului sistemului.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostic: $message';
  }

  @override
  String get winMinimize => 'Minimizare';

  @override
  String get winClose => 'Închidere';
}
