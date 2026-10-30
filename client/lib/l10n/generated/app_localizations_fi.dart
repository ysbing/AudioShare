// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Avaa järjestelmäasetukset';

  @override
  String get noDevices => 'Laitteita ei löytynyt';

  @override
  String get connect => 'Yhdistä';

  @override
  String get connecting => 'Yhdistetään';

  @override
  String get disconnect => 'Katkaise yhteys';

  @override
  String get autoConnectLastDevice =>
      'Yhdistä automaattisesti viimeksi käytettyyn laitteeseen';

  @override
  String get language => 'Kieli';

  @override
  String get followSystem => 'Järjestelmän mukaan';

  @override
  String get noLanguageMatch => 'Vastaavaa kieltä ei löytynyt';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Tallennuslupa vaaditaan';

  @override
  String get recordingPermissionDescription =>
      'Siirry Järjestelmäasetuksissa kohtaan Tietosuoja ja turvallisuus > Näytön ja järjestelmän äänen tallennus ja salli AudioShare. macOS vaatii, että sovellus käynnistetään uudelleen, jotta uusi lupa tulee voimaan: sulje AudioShare, avaa se uudelleen ja yhdistä sitten uudelleen.';

  @override
  String get connectionFailedTitle => 'Yhdistäminen epäonnistui';

  @override
  String get captureInitializationFailed =>
      'Järjestelmän äänen tallennusta ei voitu alustaa.';

  @override
  String get captureStopped => 'Järjestelmän äänen tallennus pysäytettiin.';

  @override
  String get captureStartFailed =>
      'Järjestelmän äänen tallennusta ei voitu aloittaa.';

  @override
  String get listenerStartFailed =>
      'Paikallista äänen suoratoistopalvelua ei voitu käynnistää.';

  @override
  String get noAvailablePort =>
      'Paikallista kuuntelporttia ei ole käytettävissä.';

  @override
  String get connectAndroidDeviceFailed =>
      'Android-laitteeseen yhdistettäessä tapahtui virhe.';

  @override
  String get connectDeviceFailed =>
      'Laitteeseen yhdistettäessä tapahtui virhe.';

  @override
  String nativeErrorDetails(String code) {
    return 'Virhekoodi: $code';
  }

  @override
  String get nativeError1000 => 'Äänentallennuksen alustaminen epäonnistui.';

  @override
  String get nativeError1001 =>
      'Tämä macOS-versio ei tue järjestelmän äänen tallennusta.';

  @override
  String get nativeError1002 =>
      'Näytön ja järjestelmän äänen tallennuslupa ei ole käytettävissä.';

  @override
  String get nativeError1100 =>
      'Paikallista äänikuuntelijaa ei voitu käynnistää.';

  @override
  String get nativeError1101 => 'Paikallista kuuntelusokkia ei voitu luoda.';

  @override
  String get nativeError1102 => 'Paikallista kuuntelusokkia ei voitu sitoa.';

  @override
  String get nativeError1103 =>
      'Paikallinen kuuntelusokki ei voinut alkaa kuunnella.';

  @override
  String get nativeError1104 => 'Paikallista kuuntelusäiettä ei voitu luoda.';

  @override
  String get nativeError1105 =>
      'Paikallisen kuuntelijan käynnistys aikakatkaistiin.';

  @override
  String get nativeError1106 => 'Android-laitteen yhteyttä ei voitu hyväksyä.';

  @override
  String get nativeError1107 => 'Android-laitteen yhteyskoodia ei voitu lukea.';

  @override
  String get nativeError1200 =>
      'Järjestelmän äänen tallennusta ei voitu aloittaa.';

  @override
  String get nativeError1201 => 'Näytön jakamisen sisältöä ei voitu hakea.';

  @override
  String get nativeError1202 =>
      'Järjestelmän äänen tallennukseen ei ole käytettävissä näyttöä.';

  @override
  String get nativeError1203 =>
      'ScreenCaptureKitin äänilähtöä ei voitu määrittää.';

  @override
  String get nativeError1204 =>
      'ScreenCaptureKitin äänentallennusta ei voitu aloittaa.';

  @override
  String get nativeError1205 =>
      'ScreenCaptureKitin äänentallennus pysähtyi odottamatta.';

  @override
  String get nativeError1206 =>
      'ScreenCaptureKitin äänentallennuksen aloitus aikakatkaistiin.';

  @override
  String get nativeErrorUnknown =>
      'Järjestelmän äänen tallennuksessa tapahtui tuntematon virhe.';

  @override
  String exceptionDetails(String message) {
    return 'Vianmääritys: $message';
  }

  @override
  String get winMinimize => 'Pienennä';

  @override
  String get winClose => 'Sulje';
}
