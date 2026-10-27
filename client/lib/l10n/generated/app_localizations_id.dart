// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Buka Pengaturan Sistem';

  @override
  String get noDevices => 'Tidak ada perangkat ditemukan';

  @override
  String get connect => 'Hubungkan';

  @override
  String get connecting => 'Menghubungkan';

  @override
  String get disconnect => 'Putuskan';

  @override
  String get autoConnectLastDevice =>
      'Hubungkan otomatis ke perangkat terakhir yang digunakan';

  @override
  String get language => 'Bahasa';

  @override
  String get followSystem => 'Ikuti sistem';

  @override
  String get noLanguageMatch => 'Tidak ada bahasa yang cocok';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Izin perekaman diperlukan';

  @override
  String get recordingPermissionDescription =>
      'Di Pengaturan Sistem, buka Privasi & Keamanan > Perekaman Layar & Audio Sistem dan izinkan AudioShare. macOS memerlukan aplikasi dimulai ulang agar izin baru berlaku; keluarlah dari AudioShare, buka kembali, lalu hubungkan lagi.';

  @override
  String get connectionFailedTitle => 'Koneksi gagal';

  @override
  String get captureInitializationFailed =>
      'Tidak dapat menginisialisasi perekaman audio sistem.';

  @override
  String get captureStopped => 'Perekaman audio sistem berhenti.';

  @override
  String get captureStartFailed =>
      'Tidak dapat memulai perekaman audio sistem.';

  @override
  String get listenerStartFailed =>
      'Tidak dapat memulai layanan streaming audio lokal.';

  @override
  String get noAvailablePort => 'Tidak ada porta listener lokal yang tersedia.';

  @override
  String get connectAndroidDeviceFailed =>
      'Terjadi kesalahan saat menghubungkan ke perangkat Android.';

  @override
  String get connectDeviceFailed =>
      'Terjadi kesalahan saat menghubungkan ke perangkat.';

  @override
  String nativeErrorDetails(String code) {
    return 'Kode kesalahan: $code';
  }

  @override
  String get nativeError1000 => 'Gagal menginisialisasi perekaman audio.';

  @override
  String get nativeError1001 =>
      'Versi macOS ini tidak mendukung perekaman audio sistem.';

  @override
  String get nativeError1002 =>
      'Izin perekaman layar dan audio sistem tidak tersedia.';

  @override
  String get nativeError1100 => 'Tidak dapat memulai listener audio lokal.';

  @override
  String get nativeError1101 => 'Tidak dapat membuat socket listener lokal.';

  @override
  String get nativeError1102 => 'Tidak dapat mengikat socket listener lokal.';

  @override
  String get nativeError1103 =>
      'Socket listener lokal tidak dapat mulai mendengarkan.';

  @override
  String get nativeError1104 => 'Tidak dapat membuat thread listener lokal.';

  @override
  String get nativeError1105 =>
      'Waktu tunggu untuk memulai listener lokal habis.';

  @override
  String get nativeError1106 =>
      'Tidak dapat menerima koneksi dari perangkat Android.';

  @override
  String get nativeError1107 =>
      'Tidak dapat membaca kode koneksi perangkat Android.';

  @override
  String get nativeError1200 => 'Tidak dapat memulai perekaman audio sistem.';

  @override
  String get nativeError1201 => 'Tidak dapat mengambil konten berbagi layar.';

  @override
  String get nativeError1202 =>
      'Tidak ada layar yang tersedia untuk perekaman audio sistem.';

  @override
  String get nativeError1203 =>
      'Tidak dapat mengonfigurasi output audio ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Tidak dapat memulai perekaman audio ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Perekaman audio ScreenCaptureKit berhenti secara tidak terduga.';

  @override
  String get nativeError1206 =>
      'Waktu tunggu untuk memulai perekaman audio ScreenCaptureKit habis.';

  @override
  String get nativeErrorUnknown =>
      'Terjadi kesalahan perekaman audio sistem yang tidak dikenal.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnosis: $message';
  }
}
