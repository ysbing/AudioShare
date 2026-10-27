// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'אישור';

  @override
  String get openSystemSettings => 'פתיחת הגדרות המערכת';

  @override
  String get noDevices => 'לא נמצאו מכשירים';

  @override
  String get connect => 'התחברות';

  @override
  String get connecting => 'מתחבר';

  @override
  String get disconnect => 'ניתוק';

  @override
  String get autoConnectLastDevice => 'התחברות אוטומטית למכשיר ששימש לאחרונה';

  @override
  String get language => 'שפה';

  @override
  String get followSystem => 'בהתאם למערכת';

  @override
  String get noLanguageMatch => 'לא נמצאה שפה מתאימה';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'נדרשת הרשאת הקלטה';

  @override
  String get recordingPermissionDescription =>
      'בהגדרות המערכת עברו אל Privacy & Security > Screen & System Audio Recording ואשרו ל-AudioShare. ב-macOS נדרשת הפעלה מחדש של היישום כדי שההרשאה החדשה תיכנס לתוקף; סגרו את AudioShare, פתחו אותו מחדש ולאחר מכן התחברו שוב.';

  @override
  String get connectionFailedTitle => 'ההתחברות נכשלה';

  @override
  String get captureInitializationFailed =>
      'לא ניתן לאתחל את לכידת השמע המערכת.';

  @override
  String get captureStopped => 'לכידת השמע המערכת נעצרה.';

  @override
  String get captureStartFailed => 'לא ניתן להתחיל את לכידת השמע המערכת.';

  @override
  String get listenerStartFailed =>
      'לא ניתן להפעיל את שירות הזרימת השמע המקומי.';

  @override
  String get noAvailablePort => 'אין פורט האזנה מקומי זמין.';

  @override
  String get connectAndroidDeviceFailed =>
      'אירעה שגיאה בעת ההתחברות למכשיר Android.';

  @override
  String get connectDeviceFailed => 'אירעה שגיאה בעת ההתחברות למכשיר.';

  @override
  String nativeErrorDetails(String code) {
    return 'קוד שגיאה: $code';
  }

  @override
  String get nativeError1000 => 'אתחול לכידת השמע נכשל.';

  @override
  String get nativeError1001 => 'גרסת macOS זו אינה תומכת בלכידת שמע מערכת.';

  @override
  String get nativeError1002 => 'הרשאת הקלטת מסך ושמע מערכת אינה זמינה.';

  @override
  String get nativeError1100 => 'לא ניתן להפעיל את מאזין השמע המקומי.';

  @override
  String get nativeError1101 => 'לא ניתן ליצור את שק ההאזנה המקומי.';

  @override
  String get nativeError1102 => 'לא ניתן לקשור את שק ההאזנה המקומי.';

  @override
  String get nativeError1103 => 'שק ההאזנה המקומי לא הצליח להתחיל להאזין.';

  @override
  String get nativeError1104 => 'לא ניתן ליצור את תת ההאזנה המקומי.';

  @override
  String get nativeError1105 => 'הפעלת המאזין המקומי התמהמהה.';

  @override
  String get nativeError1106 => 'לא ניתן לקבל את החיבור ממכשיר Android.';

  @override
  String get nativeError1107 => 'לא ניתן לקרוא את קוד החיבור של מכשיר Android.';

  @override
  String get nativeError1200 => 'לא ניתן להתחיל את לכידת השמע המערכת.';

  @override
  String get nativeError1201 => 'לא ניתן לקבל את תוכן שיתוף המסך.';

  @override
  String get nativeError1202 => 'אין תצוגה זמינה ללכידת שמע מערכת.';

  @override
  String get nativeError1203 =>
      'לא ניתן להגדיר את פלט השמע של ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'לא ניתן להתחיל את לכידת השמע של ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'לכידת השמע של ScreenCaptureKit נעצרה באופן לא צפוי.';

  @override
  String get nativeError1206 => 'הפעלת לכידת השמע של ScreenCaptureKit התמהמהה.';

  @override
  String get nativeErrorUnknown => 'אירעה שגיאה לא ידועה בלכידת שמע המערכת.';

  @override
  String exceptionDetails(String message) {
    return 'אבחון: $message';
  }
}
