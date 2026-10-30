// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'ตกลง';

  @override
  String get openSystemSettings => 'เปิดการตั้งค่าระบบ';

  @override
  String get noDevices => 'ไม่พบอุปกรณ์';

  @override
  String get connect => 'เชื่อมต่อ';

  @override
  String get connecting => 'กำลังเชื่อมต่อ';

  @override
  String get disconnect => 'ตัดการเชื่อมต่อ';

  @override
  String get autoConnectLastDevice =>
      'เชื่อมต่ออุปกรณ์ที่ใช้ล่าสุดโดยอัตโนมัติ';

  @override
  String get language => 'ภาษา';

  @override
  String get followSystem => 'ตามระบบ';

  @override
  String get noLanguageMatch => 'ไม่พบภาษาที่ตรงกัน';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'ต้องได้รับสิทธิ์บันทึก';

  @override
  String get recordingPermissionDescription =>
      'ในการตั้งค่าระบบ ให้ไปที่ ความเป็นส่วนตัวและความปลอดภัย > การบันทึกหน้าจอและเสียงระบบ แล้วอนุญาตให้ AudioShare เมื่อเปลี่ยนสิทธิ์ใหม่ macOS ต้องให้รีสตาร์ตแอปเพื่อให้มีผล จึงออกจาก AudioShare เปิดใหม่ แล้วเชื่อมต่ออีกครั้ง';

  @override
  String get connectionFailedTitle => 'เชื่อมต่อไม่สำเร็จ';

  @override
  String get captureInitializationFailed =>
      'ไม่สามารถเริ่มต้นการจับเสียงระบบได้';

  @override
  String get captureStopped => 'การจับเสียงระบบหยุดแล้ว';

  @override
  String get captureStartFailed => 'ไม่สามารถเริ่มการจับเสียงระบบได้';

  @override
  String get listenerStartFailed =>
      'ไม่สามารถเริ่มบริการสตรีมเสียงในเครื่องได้';

  @override
  String get noAvailablePort => 'ไม่มีพอร์ตฟังในเครื่องที่ใช้ได้';

  @override
  String get connectAndroidDeviceFailed =>
      'เกิดข้อผิดพลาดขณะเชื่อมต่อกับอุปกรณ์ Android';

  @override
  String get connectDeviceFailed => 'เกิดข้อผิดพลาดขณะเชื่อมต่อกับอุปกรณ์';

  @override
  String nativeErrorDetails(String code) {
    return 'รหัสข้อผิดพลาด: $code';
  }

  @override
  String get nativeError1000 => 'การเริ่มต้นการจับเสียงล้มเหลว';

  @override
  String get nativeError1001 => 'macOS เวอร์ชันนี้ไม่รองรับการจับเสียงระบบ';

  @override
  String get nativeError1002 => 'ไม่มีสิทธิ์บันทึกหน้าจอและเสียงระบบ';

  @override
  String get nativeError1100 => 'ไม่สามารถเริ่มตัวฟังเสียงในเครื่องได้';

  @override
  String get nativeError1101 => 'ไม่สามารถสร้างซ็อกเก็ตฟังในเครื่องได้';

  @override
  String get nativeError1102 => 'ไม่สามารถผูกซ็อกเก็ตฟังในเครื่องได้';

  @override
  String get nativeError1103 => 'ซ็อกเก็ตฟังในเครื่องไม่สามารถเริ่มฟังได้';

  @override
  String get nativeError1104 => 'ไม่สามารถสร้างเธรดตัวฟังในเครื่องได้';

  @override
  String get nativeError1105 => 'การเริ่มตัวฟังในเครื่องหมดเวลา';

  @override
  String get nativeError1106 =>
      'ไม่สามารถยอมรับการเชื่อมต่อจากอุปกรณ์ Android ได้';

  @override
  String get nativeError1107 =>
      'ไม่สามารถอ่านรหัสการเชื่อมต่อของอุปกรณ์ Android ได้';

  @override
  String get nativeError1200 => 'ไม่สามารถเริ่มการจับเสียงระบบได้';

  @override
  String get nativeError1201 => 'ไม่สามารถรับเนื้อหาการแชร์หน้าจอได้';

  @override
  String get nativeError1202 => 'ไม่มีจอแสดงผลที่ใช้ได้สำหรับการจับเสียงระบบ';

  @override
  String get nativeError1203 =>
      'ไม่สามารถกำหนดค่าเอาต์พุตเสียงของ ScreenCaptureKit ได้';

  @override
  String get nativeError1204 =>
      'ไม่สามารถเริ่มการจับเสียงของ ScreenCaptureKit ได้';

  @override
  String get nativeError1205 =>
      'การจับเสียงของ ScreenCaptureKit หยุดโดยไม่คาดคิด';

  @override
  String get nativeError1206 =>
      'การเริ่มการจับเสียงของ ScreenCaptureKit หมดเวลา';

  @override
  String get nativeErrorUnknown =>
      'เกิดข้อผิดพลาดที่ไม่รู้จักในการจับเสียงระบบ';

  @override
  String exceptionDetails(String message) {
    return 'การวินิจฉัย: $message';
  }

  @override
  String get winMinimize => 'ย่อ';

  @override
  String get winClose => 'ปิด';
}
