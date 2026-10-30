// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'موافق';

  @override
  String get openSystemSettings => 'فتح إعدادات النظام';

  @override
  String get noDevices => 'لم يتم العثور على أي أجهزة';

  @override
  String get connect => 'اتصال';

  @override
  String get connecting => 'جارٍ الاتصال';

  @override
  String get disconnect => 'قطع الاتصال';

  @override
  String get autoConnectLastDevice => 'الاتصال تلقائيًا بآخر جهاز استُخدم';

  @override
  String get language => 'اللغة';

  @override
  String get followSystem => 'اتّباع النظام';

  @override
  String get noLanguageMatch => 'لا توجد لغة مطابقة';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'مطلوب إذن التسجيل';

  @override
  String get recordingPermissionDescription =>
      'في إعدادات النظام، انتقل إلى الخصوصية والأمان > تسجيل الشاشة وصوت النظام واسمح لـ AudioShare. يتطلب macOS إعادة تشغيل التطبيق حتى يسري الإذن الجديد؛ quit AudioShare ثم افتحه مرة أخرى واتصل به من جديد.';

  @override
  String get connectionFailedTitle => 'فشل الاتصال';

  @override
  String get captureInitializationFailed => 'تعذّرت تهيئة التقاط صوت النظام.';

  @override
  String get captureStopped => 'توقف التقاط صوت النظام.';

  @override
  String get captureStartFailed => 'تعذّر بدء التقاط صوت النظام.';

  @override
  String get listenerStartFailed => 'تعذّر تشغيل خدمة بث الصوت المحلية.';

  @override
  String get noAvailablePort => 'لا يوجد منفذ استماع محلي متاح.';

  @override
  String get connectAndroidDeviceFailed =>
      'حدث خطأ أثناء الاتصال بجهاز Android.';

  @override
  String get connectDeviceFailed => 'حدث خطأ أثناء الاتصال بالجهاز.';

  @override
  String nativeErrorDetails(String code) {
    return 'رمز الخطأ: $code';
  }

  @override
  String get nativeError1000 => 'فشلت تهيئة التقاط الصوت.';

  @override
  String get nativeError1001 => 'إصدار macOS هذا لا يدعم التقاط صوت النظام.';

  @override
  String get nativeError1002 => 'إذن تسجيل الشاشة وصوت النظام غير متاح.';

  @override
  String get nativeError1100 => 'تعذّر تشغيل مستمع الصوت المحلي.';

  @override
  String get nativeError1101 => 'تعذّر إنشاء مقبس الاستماع المحلي.';

  @override
  String get nativeError1102 => 'تعذّر ربط مقبس الاستماع المحلي.';

  @override
  String get nativeError1103 => 'تعذّر على مقبس الاستماع المحلي بدء الاستماع.';

  @override
  String get nativeError1104 => 'تعذّر إنشاء خيط الاستماع المحلي.';

  @override
  String get nativeError1105 => 'انتهت المهلة أثناء بدء المستمع المحلي.';

  @override
  String get nativeError1106 => 'تعذّر قبول الاتصال من جهاز Android.';

  @override
  String get nativeError1107 => 'تعذّرت قراءة رمز الاتصال الخاص بجهاز Android.';

  @override
  String get nativeError1200 => 'تعذّر بدء التقاط صوت النظام.';

  @override
  String get nativeError1201 => 'تعذّر الحصول على محتوى مشاركة الشاشة.';

  @override
  String get nativeError1202 => 'لا تتوفر أي شاشة لالتقاط صوت النظام.';

  @override
  String get nativeError1203 => 'تعذّر ضبط إخراج الصوت في ScreenCaptureKit.';

  @override
  String get nativeError1204 => 'تعذّر بدء التقاط الصوت في ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'توقف التقاط الصوت في ScreenCaptureKit بشكل غير متوقع.';

  @override
  String get nativeError1206 =>
      'انتهت المهلة أثناء بدء التقاط الصوت في ScreenCaptureKit.';

  @override
  String get nativeErrorUnknown => 'حدث خطأ غير معروف في التقاط صوت النظام.';

  @override
  String exceptionDetails(String message) {
    return 'التشخيص: $message';
  }

  @override
  String get winMinimize => 'تصغير';

  @override
  String get winClose => 'إغلاق';
}
