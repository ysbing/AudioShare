// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Otevřít Nastavení systému';

  @override
  String get noDevices => 'Nenalezena žádná zařízení';

  @override
  String get connect => 'Připojit';

  @override
  String get connecting => 'Připojování';

  @override
  String get disconnect => 'Odpojit';

  @override
  String get autoConnectLastDevice =>
      'Automaticky připojit naposledy použité zařízení';

  @override
  String get language => 'Jazyk';

  @override
  String get followSystem => 'Podle systému';

  @override
  String get noLanguageMatch => 'Žádný odpovídající jazyk nebyl nalezen';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Je vyžadováno oprávnění k nahrávání';

  @override
  String get recordingPermissionDescription =>
      'V Nastavení systému přejděte na Soukromí a zabezpečení > Nahrávání obrazovky a systémového zvuku a povolte AudioShare. macOS vyžaduje restart aplikace, aby nové oprávnění začalo platit; ukončete AudioShare, znovu jej otevřete a poté se připojte znovu.';

  @override
  String get connectionFailedTitle => 'Připojení se nezdařilo';

  @override
  String get captureInitializationFailed =>
      'Nepodařilo se inicializovat zachycení systémového zvuku.';

  @override
  String get captureStopped => 'Zachycení systémového zvuku bylo zastaveno.';

  @override
  String get captureStartFailed =>
      'Nepodařilo se spustit zachycení systémového zvuku.';

  @override
  String get listenerStartFailed =>
      'Nepodařilo se spustit místní službu streamování zvuku.';

  @override
  String get noAvailablePort => 'Není dostupný žádný místní naslouchací port.';

  @override
  String get connectAndroidDeviceFailed =>
      'Při připojování k zařízení se systémem Android došlo k chybě.';

  @override
  String get connectDeviceFailed => 'Při připojování k zařízení došlo k chybě.';

  @override
  String nativeErrorDetails(String code) {
    return 'Kód chyby: $code';
  }

  @override
  String get nativeError1000 => 'Inicializace zachycení zvuku se nezdařila.';

  @override
  String get nativeError1001 =>
      'Tato verze systému macOS nepodporuje zachycení systémového zvuku.';

  @override
  String get nativeError1002 =>
      'Oprávnění k nahrávání obrazovky a systémového zvuku není dostupné.';

  @override
  String get nativeError1100 =>
      'Nepodařilo se spustit místní naslouchání zvuku.';

  @override
  String get nativeError1101 =>
      'Nepodařilo se vytvořit místní naslouchací socket.';

  @override
  String get nativeError1102 =>
      'Nepodařilo se přiřadit místní naslouchací socket.';

  @override
  String get nativeError1103 =>
      'Místní naslouchací socket nemohl začít naslouchat.';

  @override
  String get nativeError1104 =>
      'Nepodařilo se vytvořit vlákno místního naslouchání.';

  @override
  String get nativeError1105 => 'Spuštění místního naslouchání vypršelo.';

  @override
  String get nativeError1106 =>
      'Připojení ze zařízení se systémem Android nebylo možné přijmout.';

  @override
  String get nativeError1107 =>
      'Kód připojení zařízení se systémem Android se nepodařilo načíst.';

  @override
  String get nativeError1200 =>
      'Nepodařilo se spustit zachycení systémového zvuku.';

  @override
  String get nativeError1201 => 'Obsah sdílení obrazovky se nepodařilo získat.';

  @override
  String get nativeError1202 =>
      'Pro zachycení systémového zvuku není dostupný žádný displej.';

  @override
  String get nativeError1203 =>
      'Zvukový výstup ScreenCaptureKit se nepodařilo nastavit.';

  @override
  String get nativeError1204 =>
      'Zachycení zvuku v ScreenCaptureKit se nepodařilo spustit.';

  @override
  String get nativeError1205 =>
      'Zachycení zvuku v ScreenCaptureKit se neočekávaně zastavilo.';

  @override
  String get nativeError1206 =>
      'Spuštění zachycení zvuku v ScreenCaptureKit vypršelo.';

  @override
  String get nativeErrorUnknown =>
      'Došlo k neznámé chybě zachycení systémového zvuku.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostika: $message';
  }
}
