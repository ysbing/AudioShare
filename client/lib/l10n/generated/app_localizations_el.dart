// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Άνοιγμα ρυθμίσεων συστήματος';

  @override
  String get noDevices => 'Δεν βρέθηκαν συσκευές';

  @override
  String get connect => 'Σύνδεση';

  @override
  String get connecting => 'Σύνδεση σε εξέλιξη';

  @override
  String get disconnect => 'Αποσύνδεση';

  @override
  String get autoConnectLastDevice =>
      'Αυτόματη σύνδεση στην τελευταία χρησιμοποιημένη συσκευή';

  @override
  String get language => 'Γλώσσα';

  @override
  String get followSystem => 'Ακολουθεί το σύστημα';

  @override
  String get noLanguageMatch => 'Δεν βρέθηκε αντίστοιχη γλώσσα';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Απαιτείται άδεια εγγραφής';

  @override
  String get recordingPermissionDescription =>
      'Στις Ρυθμίσεις συστήματος μεταβείτε στο Απόρρητο και ασφάλεια > Εγγραφή οθόνης και ήχου συστήματος και επιτρέψτε το AudioShare. Το macOS απαιτεί επανεκκίνηση της εφαρμογής για να ισχύσει η νέα άδεια: κλείστε το AudioShare, ανοίξτε το ξανά και συνδεθείτε ξανά.';

  @override
  String get connectionFailedTitle => 'Η σύνδεση απέτυχε';

  @override
  String get captureInitializationFailed =>
      'Δεν ήταν δυνατή η αρχικοποίηση της λήψης ήχου συστήματος.';

  @override
  String get captureStopped => 'Η λήψη ήχου συστήματος διακόπηκε.';

  @override
  String get captureStartFailed =>
      'Δεν ήταν δυνατη η έναρξη της λήψης ήχου συστήματος.';

  @override
  String get listenerStartFailed =>
      'Δεν ήταν δυνατη η εκκίνηση της τοπικής υπηρεσίας ροής ήχου.';

  @override
  String get noAvailablePort => 'Δεν υπάρχει διαθέσιμη τοπική θύρα ακρόασης.';

  @override
  String get connectAndroidDeviceFailed =>
      'Παρουσιάστηκε σφάλμα κατά τη σύνδεση στη συσκευή Android.';

  @override
  String get connectDeviceFailed =>
      'Παρουσιάστηκε σφάλμα κατά τη σύνδεση στη συσκευή.';

  @override
  String nativeErrorDetails(String code) {
    return 'Κωδικός σφάλματος: $code';
  }

  @override
  String get nativeError1000 => 'Η αρχικοποίηση της λήψης ήχου απέτυχε.';

  @override
  String get nativeError1001 =>
      'Αυτή η έκδοση του macOS δεν υποστηρίζει τη λήψη ήχου συστήματος.';

  @override
  String get nativeError1002 =>
      'Η άδεια εγγραφής οθόνης και ήχου συστήματος δεν είναι διαθέσιμη.';

  @override
  String get nativeError1100 =>
      'Δεν ήταν δυνατη η εκκίνηση του τοπικού ακροατή ήχου.';

  @override
  String get nativeError1101 =>
      'Δεν ήταν δυνατη η δημιουργία της τοπικής υποδοχής ακρόασης.';

  @override
  String get nativeError1102 =>
      'Δεν ήταν δυνατη η σύνδεση της τοπικής υποδοχής ακρόασης.';

  @override
  String get nativeError1103 =>
      'Η τοπική υποδοχή ακρόασης δεν μπόρεσε να αρχίσει να ακούει.';

  @override
  String get nativeError1104 =>
      'Δεν ήταν δυνατη η δημιουργία του νήματος τοπικής ακρόασης.';

  @override
  String get nativeError1105 =>
      'Η εκκίνηση του τοπικού ακροατή έληξε με timeout.';

  @override
  String get nativeError1106 =>
      'Δεν ήταν δυνατη η αποδοχή της σύνδεσης από τη συσκευή Android.';

  @override
  String get nativeError1107 =>
      'Δεν ήταν δυνατη η ανάγνωση του κωδικού σύνδεσης της συσκευής Android.';

  @override
  String get nativeError1200 =>
      'Δεν ήταν δυνατη η έναρξη της λήψης ήχου συστήματος.';

  @override
  String get nativeError1201 =>
      'Δεν ήταν δυνατη η λήψη του περιεχομένου της κοινής χρήσης οθόνης.';

  @override
  String get nativeError1202 =>
      'Δεν υπάρχει διαθέσιμη οθόνη για τη λήψη ήχου συστήματος.';

  @override
  String get nativeError1203 =>
      'Δεν ήταν δυνατη η ρύθμιση της εξόδου ήχου του ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Δεν ήταν δυνατη η έναρξη της λήψης ήχου του ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Η λήψη ήχου του ScreenCaptureKit διακόπηκε απροσδόκητα.';

  @override
  String get nativeError1206 =>
      'Η έναρξη της λήψης ήχου του ScreenCaptureKit έληξε με timeout.';

  @override
  String get nativeErrorUnknown =>
      'Παρουσιάστηκε άγνωστο σφάλμα λήψης ήχου συστήματος.';

  @override
  String exceptionDetails(String message) {
    return 'Διαγνωστικά: $message';
  }
}
