// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Apri le impostazioni di sistema';

  @override
  String get noDevices => 'Nessun dispositivo trovato';

  @override
  String get connect => 'Connetti';

  @override
  String get connecting => 'Connessione in corso';

  @override
  String get disconnect => 'Disconnetti';

  @override
  String get autoConnectLastDevice =>
      'Connetti automaticamente all\'ultimo dispositivo utilizzato';

  @override
  String get language => 'Lingua';

  @override
  String get followSystem => 'Segui il sistema';

  @override
  String get noLanguageMatch => 'Nessuna lingua corrispondente';

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
      'È richiesta l\'autorizzazione alla registrazione';

  @override
  String get recordingPermissionDescription =>
      'In Impostazioni di sistema apri Privacy e sicurezza > Registrazione schermo e audio di sistema e consenti AudioShare. macOS richiede il riavvio dell\'app perché la nuova autorizzazione venga applicata: esci da AudioShare, riaprilo e poi ricollegati.';

  @override
  String get connectionFailedTitle => 'Connessione non riuscita';

  @override
  String get captureInitializationFailed =>
      'Non è stato possibile inizializzare l\'acquisizione dell\'audio di sistema.';

  @override
  String get captureStopped =>
      'L\'acquisizione dell\'audio di sistema si è interrotta.';

  @override
  String get captureStartFailed =>
      'Non è stato possibile avviare l\'acquisizione dell\'audio di sistema.';

  @override
  String get listenerStartFailed =>
      'Non è stato possibile avviare il servizio locale di streaming audio.';

  @override
  String get noAvailablePort => 'Nessuna porta di ascolto locale disponibile.';

  @override
  String get connectAndroidDeviceFailed =>
      'Si è verificato un errore durante la connessione al dispositivo Android.';

  @override
  String get connectDeviceFailed =>
      'Si è verificato un errore durante la connessione al dispositivo.';

  @override
  String nativeErrorDetails(String code) {
    return 'Codice di errore: $code';
  }

  @override
  String get nativeError1000 =>
      'Inizializzazione dell\'acquisizione audio non riuscita.';

  @override
  String get nativeError1001 =>
      'Questa versione di macOS non supporta l\'acquisizione dell\'audio di sistema.';

  @override
  String get nativeError1002 =>
      'L\'autorizzazione alla registrazione di schermo e audio di sistema non è disponibile.';

  @override
  String get nativeError1100 =>
      'Non è stato possibile avviare l\'ascolto audio locale.';

  @override
  String get nativeError1101 =>
      'Non è stato possibile creare il socket di ascolto locale.';

  @override
  String get nativeError1102 =>
      'Non è stato possibile associare il socket di ascolto locale.';

  @override
  String get nativeError1103 =>
      'Il socket di ascolto locale non è riuscito a iniziare l\'ascolto.';

  @override
  String get nativeError1104 =>
      'Non è stato possibile creare il thread di ascolto locale.';

  @override
  String get nativeError1105 => 'L\'avvio dell\'ascolto locale è scaduto.';

  @override
  String get nativeError1106 =>
      'Non è stato possibile accettare la connessione dal dispositivo Android.';

  @override
  String get nativeError1107 =>
      'Non è stato possibile leggere il codice di connessione del dispositivo Android.';

  @override
  String get nativeError1200 =>
      'Non è stato possibile avviare l\'acquisizione dell\'audio di sistema.';

  @override
  String get nativeError1201 =>
      'Non è stato possibile ottenere il contenuto della condivisione schermo.';

  @override
  String get nativeError1202 =>
      'Nessuno schermo disponibile per l\'acquisizione dell\'audio di sistema.';

  @override
  String get nativeError1203 =>
      'Non è stato possibile configurare l\'uscita audio di ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Non è stato possibile avviare l\'acquisizione audio di ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'L\'acquisizione audio di ScreenCaptureKit si è interrotta inaspettatamente.';

  @override
  String get nativeError1206 =>
      'L\'avvio dell\'acquisizione audio di ScreenCaptureKit è scaduto.';

  @override
  String get nativeErrorUnknown =>
      'Si è verificato un errore sconosciuto nell\'acquisizione dell\'audio di sistema.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostica: $message';
  }
}
