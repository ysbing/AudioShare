// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Mở Cài đặt hệ thống';

  @override
  String get noDevices => 'Không tìm thấy thiết bị nào';

  @override
  String get connect => 'Kết nối';

  @override
  String get connecting => 'Đang kết nối';

  @override
  String get disconnect => 'Ngắt kết nối';

  @override
  String get autoConnectLastDevice =>
      'Tự động kết nối với thiết bị đã dùng gần nhất';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get followSystem => 'Theo hệ thống';

  @override
  String get noLanguageMatch => 'Không có ngôn ngữ phù hợp';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Cần quyền ghi hình';

  @override
  String get recordingPermissionDescription =>
      'Trong Cài đặt hệ thống, vào Quyền riêng tư & Bảo mật > Ghi hình màn hình và âm thanh hệ thống, rồi cho phép AudioShare. macOS cần khởi động lại ứng dụng để quyền mới có hiệu lực; hãy thoát AudioShare, mở lại rồi kết nối lại lần nữa.';

  @override
  String get connectionFailedTitle => 'Kết nối thất bại';

  @override
  String get captureInitializationFailed =>
      'Không thể khởi tạo việc thu âm thanh hệ thống.';

  @override
  String get captureStopped => 'Việc thu âm thanh hệ thống đã dừng.';

  @override
  String get captureStartFailed => 'Không thể bắt đầu thu âm thanh hệ thống.';

  @override
  String get listenerStartFailed =>
      'Không thể khởi động dịch vụ truyền âm thanh cục bộ.';

  @override
  String get noAvailablePort => 'Không có cổng lắng nghe cục bộ nào khả dụng.';

  @override
  String get connectAndroidDeviceFailed =>
      'Đã xảy ra lỗi khi kết nối với thiết bị Android.';

  @override
  String get connectDeviceFailed => 'Đã xảy ra lỗi khi kết nối với thiết bị.';

  @override
  String nativeErrorDetails(String code) {
    return 'Mã lỗi: $code';
  }

  @override
  String get nativeError1000 => 'Khởi tạo thu âm thanh thất bại.';

  @override
  String get nativeError1001 =>
      'Phiên bản macOS này không hỗ trợ thu âm thanh hệ thống.';

  @override
  String get nativeError1002 =>
      'Không có quyền ghi hình màn hình và âm thanh hệ thống.';

  @override
  String get nativeError1100 =>
      'Không thể khởi động bộ lắng nghe âm thanh cục bộ.';

  @override
  String get nativeError1101 => 'Không thể tạo socket lắng nghe cục bộ.';

  @override
  String get nativeError1102 => 'Không thể liên kết socket lắng nghe cục bộ.';

  @override
  String get nativeError1103 =>
      'Socket lắng nghe cục bộ không thể bắt đầu lắng nghe.';

  @override
  String get nativeError1104 => 'Không thể tạo luồng lắng nghe cục bộ.';

  @override
  String get nativeError1105 =>
      'Khởi động bộ lắng nghe cục bộ đã hết thời gian chờ.';

  @override
  String get nativeError1106 =>
      'Không thể chấp nhận kết nối từ thiết bị Android.';

  @override
  String get nativeError1107 =>
      'Không thể đọc mã kết nối của thiết bị Android.';

  @override
  String get nativeError1200 => 'Không thể bắt đầu thu âm thanh hệ thống.';

  @override
  String get nativeError1201 => 'Không thể lấy nội dung chia sẻ màn hình.';

  @override
  String get nativeError1202 =>
      'Không có màn hình nào khả dụng để thu âm thanh hệ thống.';

  @override
  String get nativeError1203 =>
      'Không thể cấu hình âm thanh đầu ra của ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Không thể bắt đầu thu âm thanh của ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Việc thu âm thanh của ScreenCaptureKit đã dừng đột ngột.';

  @override
  String get nativeError1206 =>
      'Bắt đầu thu âm thanh của ScreenCaptureKit đã hết thời gian chờ.';

  @override
  String get nativeErrorUnknown =>
      'Đã xảy ra lỗi thu âm thanh hệ thống không xác định.';

  @override
  String exceptionDetails(String message) {
    return 'Chẩn đoán: $message';
  }
}
