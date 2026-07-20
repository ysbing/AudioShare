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
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '简体中文';

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
      '未获得“屏幕与系统音频录制”权限。请在“系统设置 > 隐私与安全性 > 屏幕与系统音频录制”中允许 AudioShare，然后重新连接。';

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
}
