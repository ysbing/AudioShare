// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'Tamam';

  @override
  String get openSystemSettings => 'Sistem Ayarları\'nı Aç';

  @override
  String get noDevices => 'Cihaz bulunamadı';

  @override
  String get connect => 'Bağlan';

  @override
  String get connecting => 'Bağlanıyor';

  @override
  String get disconnect => 'Bağlantıyı Kes';

  @override
  String get autoConnectLastDevice =>
      'En son kullanılan cihaza otomatik olarak bağlan';

  @override
  String get language => 'Dil';

  @override
  String get followSystem => 'Sistemi izle';

  @override
  String get noLanguageMatch => 'Eşleşen dil yok';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Kayıt izni gerekli';

  @override
  String get recordingPermissionDescription =>
      'Sistem Ayarları\'nda Gizlilik ve Güvenlik > Ekran ve Sistem Sesi Kaydı yolunu izleyin ve AudioShare\'e izin verin. Yeni izin etkin olabilmesi için macOS uygulamanın yeniden başlatılmasını gerektirir; AudioShare\'den çıkıp yeniden açın, ardından yeniden bağlanın.';

  @override
  String get connectionFailedTitle => 'Bağlantı başarısız oldu';

  @override
  String get captureInitializationFailed =>
      'Sistem sesi yakalama başlatılamadı.';

  @override
  String get captureStopped => 'Sistem sesi yakalama durdu.';

  @override
  String get captureStartFailed => 'Sistem sesi yakalama başlatılamadı.';

  @override
  String get listenerStartFailed => 'Yerel ses akışı hizmeti başlatılamadı.';

  @override
  String get noAvailablePort =>
      'Kullanılabilir yerel dinleme bağlantı noktası yok.';

  @override
  String get connectAndroidDeviceFailed =>
      'Android cihazına bağlanırken bir hata oluştu.';

  @override
  String get connectDeviceFailed => 'Cihaza bağlanırken bir hata oluştu.';

  @override
  String nativeErrorDetails(String code) {
    return 'Hata kodu: $code';
  }

  @override
  String get nativeError1000 => 'Ses yakalama başlatılamadı.';

  @override
  String get nativeError1001 =>
      'Bu macOS sürümü sistem sesi yakalamayı desteklemiyor.';

  @override
  String get nativeError1002 =>
      'Ekran ve sistem sesi kaydı izni kullanılamıyor.';

  @override
  String get nativeError1100 => 'Yerel ses dinleyici başlatılamadı.';

  @override
  String get nativeError1101 => 'Yerel dinleme yuvası oluşturulamadı.';

  @override
  String get nativeError1102 => 'Yerel dinleme yuvası bağlanamadı.';

  @override
  String get nativeError1103 => 'Yerel dinleme yuvası dinlemeye başlayamadı.';

  @override
  String get nativeError1104 => 'Yerel dinleyici iş parçacığı oluşturulamadı.';

  @override
  String get nativeError1105 =>
      'Yerel dinleyici başlatılırken zaman aşımına uğradı.';

  @override
  String get nativeError1106 => 'Android cihazının bağlantısı kabul edilemedi.';

  @override
  String get nativeError1107 => 'Android cihazının bağlantı kodu okunamadı.';

  @override
  String get nativeError1200 => 'Sistem sesi yakalama başlatılamadı.';

  @override
  String get nativeError1201 => 'Ekran paylaşımı içeriği alınamadı.';

  @override
  String get nativeError1202 =>
      'Sistem sesi yakalama için kullanılabilir ekran yok.';

  @override
  String get nativeError1203 =>
      'ScreenCaptureKit ses çıkışı yapılandırılamadı.';

  @override
  String get nativeError1204 => 'ScreenCaptureKit ses yakalama başlatılamadı.';

  @override
  String get nativeError1205 =>
      'ScreenCaptureKit ses yakalama beklenmedik şekilde durdu.';

  @override
  String get nativeError1206 =>
      'ScreenCaptureKit ses yakalama başlatılırken zaman aşımına uğradı.';

  @override
  String get nativeErrorUnknown =>
      'Bilinmeyen bir sistem sesi yakalama hatası oluştu.';

  @override
  String exceptionDetails(String message) {
    return 'Tanılama: $message';
  }

  @override
  String get winMinimize => 'Simge durumuna küçült';

  @override
  String get winClose => 'Kapat';
}
