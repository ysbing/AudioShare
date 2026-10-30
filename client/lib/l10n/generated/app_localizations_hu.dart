// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Rendszerbeállítások megnyitása';

  @override
  String get noDevices => 'Nem található eszköz';

  @override
  String get connect => 'Csatlakozás';

  @override
  String get connecting => 'Csatlakozás';

  @override
  String get disconnect => 'Leválasztás';

  @override
  String get autoConnectLastDevice =>
      'Automatikus csatlakozás az utoljára használt eszközhöz';

  @override
  String get language => 'Nyelv';

  @override
  String get followSystem => 'Rendszer szerint';

  @override
  String get noLanguageMatch => 'Nincs találat';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Rögzítési engedély szükséges';

  @override
  String get recordingPermissionDescription =>
      'A Rendszerbeállításokban lépjen az Adatvédelem és biztonság > Képernyőrögzítés és rendszerhang rögzítése pontba, és engedélyezze az AudioShare alkalmazást. A macOS az új engedély érvénybelépéséhez újraindítja az alkalmazást: zárja be az AudioShare-t, nyissa meg újra, majd csatlakozzon ismét.';

  @override
  String get connectionFailedTitle => 'A csatlakozás nem sikerült';

  @override
  String get captureInitializationFailed =>
      'A rendszerhang rögzítése nem inicializálható.';

  @override
  String get captureStopped => 'A rendszerhang rögzítése leállt.';

  @override
  String get captureStartFailed => 'A rendszerhang rögzítése nem indítható el.';

  @override
  String get listenerStartFailed =>
      'A helyi hangfolyam-szolgáltatás nem indítható el.';

  @override
  String get noAvailablePort => 'Nincs elérhető helyi figyelő port.';

  @override
  String get connectAndroidDeviceFailed =>
      'Hiba történt az Android-eszközhöz való csatlakozáskor.';

  @override
  String get connectDeviceFailed =>
      'Hiba történt az eszközhöz való csatlakozáskor.';

  @override
  String nativeErrorDetails(String code) {
    return 'Hibakód: $code';
  }

  @override
  String get nativeError1000 => 'A hangrögzítés inicializálása nem sikerült.';

  @override
  String get nativeError1001 =>
      'A macOS ezen verziója nem támogatja a rendszerhang rögzítését.';

  @override
  String get nativeError1002 =>
      'A képernyőrögzítés és rendszerhang engedélye nem érhető el.';

  @override
  String get nativeError1100 => 'A helyi hangfigyelő nem indítható el.';

  @override
  String get nativeError1101 => 'A helyi figyelő foglaló nem hozható létre.';

  @override
  String get nativeError1102 => 'A helyi figyelő foglaló nem köthető le.';

  @override
  String get nativeError1103 =>
      'A helyi figyelő foglaló nem tudott figyelni kezdeni.';

  @override
  String get nativeError1104 => 'A helyi figyelő szál nem hozható létre.';

  @override
  String get nativeError1105 =>
      'A helyi figyelő indítása időtúllépést szenvedett.';

  @override
  String get nativeError1106 =>
      'Az Android-eszköz csatlakozása nem fogadható el.';

  @override
  String get nativeError1107 =>
      'Az Android-eszköz csatlakozási kódja nem olvasható.';

  @override
  String get nativeError1200 => 'A rendszerhang rögzítése nem indítható el.';

  @override
  String get nativeError1201 => 'A képernyőmegosztás tartalma nem kérhető le.';

  @override
  String get nativeError1202 =>
      'Nincs elérhető kijelző a rendszerhang rögzítéséhez.';

  @override
  String get nativeError1203 =>
      'A ScreenCaptureKit hangkimenete nem konfigurálható.';

  @override
  String get nativeError1204 =>
      'A ScreenCaptureKit hangrögzítése nem indítható el.';

  @override
  String get nativeError1205 =>
      'A ScreenCaptureKit hangrögzítése váratlanul leállt.';

  @override
  String get nativeError1206 =>
      'A ScreenCaptureKit hangrögzítésének indítása időtúllépést szenvedett.';

  @override
  String get nativeErrorUnknown =>
      'Ismeretlen rendszerhang-rögzítési hiba történt.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnosztika: $message';
  }

  @override
  String get winMinimize => 'Kis méret';

  @override
  String get winClose => 'Bezárás';
}
