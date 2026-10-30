// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => '确定';

  @override
  String get openSystemSettings => '打开系统设置';

  @override
  String get noDevices => '未找到设备';

  @override
  String get connect => '连接';

  @override
  String get connecting => '连接中';

  @override
  String get disconnect => '断开';

  @override
  String get autoConnectLastDevice => '自动连接上次使用的设备';

  @override
  String get language => '语言';

  @override
  String get followSystem => '跟随系统';

  @override
  String get noLanguageMatch => '没有匹配的语言';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version（API $apiLevel）';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => '需要录制权限';

  @override
  String get recordingPermissionDescription =>
      '请在“系统设置 > 隐私与安全性 > 屏幕与系统音频录制”中允许 AudioShare。macOS 需要重新启动应用才能让新权限生效；授权后请退出并重新打开 AudioShare，然后再次连接。';

  @override
  String get connectionFailedTitle => '连接失败';

  @override
  String get captureInitializationFailed => '无法初始化系统音频捕获。';

  @override
  String get captureStopped => '系统音频捕获已停止。';

  @override
  String get captureStartFailed => '无法开始捕获系统音频。';

  @override
  String get listenerStartFailed => '无法启动本地音频传输服务。';

  @override
  String get noAvailablePort => '没有可用的本地监听端口。';

  @override
  String get connectAndroidDeviceFailed => '连接 Android 设备时发生错误。';

  @override
  String get connectDeviceFailed => '连接设备时发生错误。';

  @override
  String nativeErrorDetails(String code) {
    return '错误码：$code';
  }

  @override
  String get nativeError1000 => '系统音频捕获初始化失败。';

  @override
  String get nativeError1001 => '当前 macOS 版本不支持系统音频捕获。';

  @override
  String get nativeError1002 => '屏幕与系统音频录制权限不可用。';

  @override
  String get nativeError1100 => '本地音频监听服务无法启动。';

  @override
  String get nativeError1101 => '无法创建本地监听套接字。';

  @override
  String get nativeError1102 => '无法绑定本地监听套接字。';

  @override
  String get nativeError1103 => '本地监听套接字无法开始监听。';

  @override
  String get nativeError1104 => '无法创建本地监听线程。';

  @override
  String get nativeError1105 => '启动本地监听服务超时。';

  @override
  String get nativeError1106 => '无法接受 Android 设备连接。';

  @override
  String get nativeError1107 => '无法读取 Android 设备连接码。';

  @override
  String get nativeError1200 => '无法开始系统音频捕获。';

  @override
  String get nativeError1201 => '无法获取屏幕共享内容。';

  @override
  String get nativeError1202 => '没有可用于系统音频捕获的显示器。';

  @override
  String get nativeError1203 => '无法配置 ScreenCaptureKit 音频输出。';

  @override
  String get nativeError1204 => '无法启动 ScreenCaptureKit 音频捕获。';

  @override
  String get nativeError1205 => 'ScreenCaptureKit 音频捕获意外停止。';

  @override
  String get nativeError1206 => '启动 ScreenCaptureKit 音频捕获超时。';

  @override
  String get nativeErrorUnknown => '发生未知系统音频捕获错误。';

  @override
  String exceptionDetails(String message) {
    return '诊断信息：$message';
  }

  @override
  String get winMinimize => '最小化';

  @override
  String get winClose => '关闭';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => '確定';

  @override
  String get openSystemSettings => '打開系統設定';

  @override
  String get noDevices => '找不到裝置';

  @override
  String get connect => '連線';

  @override
  String get connecting => '連線中';

  @override
  String get disconnect => '中斷連線';

  @override
  String get autoConnectLastDevice => '自動連線到上次使用的裝置';

  @override
  String get language => '語言';

  @override
  String get followSystem => '跟隨系統';

  @override
  String get noLanguageMatch => '沒有符合的語言';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version（API $apiLevel）';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => '需要錄製權限';

  @override
  String get recordingPermissionDescription =>
      '請在「系統設定 > 隱私權與安全性 > 螢幕與系統音訊錄製」中允許 AudioShare。macOS 需要重新啟動應用程式才能讓新權限生效；請結束 AudioShare，重新開啟後再連線一次。';

  @override
  String get connectionFailedTitle => '連線失敗';

  @override
  String get captureInitializationFailed => '無法初始化系統音訊擷取。';

  @override
  String get captureStopped => '系統音訊擷取已停止。';

  @override
  String get captureStartFailed => '無法開始擷取系統音訊。';

  @override
  String get listenerStartFailed => '無法啟動本機音訊串流服務。';

  @override
  String get noAvailablePort => '沒有可用的本機監聽連接埠。';

  @override
  String get connectAndroidDeviceFailed => '連線 Android 裝置時發生錯誤。';

  @override
  String get connectDeviceFailed => '連線裝置時發生錯誤。';

  @override
  String nativeErrorDetails(String code) {
    return '錯誤碼：$code';
  }

  @override
  String get nativeError1000 => '系統音訊擷取初始化失敗。';

  @override
  String get nativeError1001 => '目前的 macOS 版本不支援系統音訊擷取。';

  @override
  String get nativeError1002 => '螢幕與系統音訊錄製權限無法使用。';

  @override
  String get nativeError1100 => '本機音訊監聽服務無法啟動。';

  @override
  String get nativeError1101 => '無法建立本機監聽通訊端。';

  @override
  String get nativeError1102 => '無法繫結本機監聽通訊端。';

  @override
  String get nativeError1103 => '本機監聽通訊端無法開始監聽。';

  @override
  String get nativeError1104 => '無法建立本機監聽執行緒。';

  @override
  String get nativeError1105 => '啟動本機監聽服務逾時。';

  @override
  String get nativeError1106 => '無法接受 Android 裝置連線。';

  @override
  String get nativeError1107 => '無法讀取 Android 裝置連線碼。';

  @override
  String get nativeError1200 => '無法開始擷取系統音訊。';

  @override
  String get nativeError1201 => '無法取得螢幕分享內容。';

  @override
  String get nativeError1202 => '沒有可用於系統音訊擷取的顯示器。';

  @override
  String get nativeError1203 => '無法設定 ScreenCaptureKit 音訊輸出。';

  @override
  String get nativeError1204 => '無法啟動 ScreenCaptureKit 音訊擷取。';

  @override
  String get nativeError1205 => 'ScreenCaptureKit 音訊擷取意外停止。';

  @override
  String get nativeError1206 => '啟動 ScreenCaptureKit 音訊擷取逾時。';

  @override
  String get nativeErrorUnknown => '發生未知的系統音訊擷取錯誤。';

  @override
  String exceptionDetails(String message) {
    return '診斷資訊：$message';
  }

  @override
  String get winMinimize => '最小化';

  @override
  String get winClose => '關閉';
}
