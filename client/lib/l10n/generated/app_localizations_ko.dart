// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => '확인';

  @override
  String get openSystemSettings => '시스템 설정 열기';

  @override
  String get noDevices => '기기를 찾을 수 없습니다';

  @override
  String get connect => '연결';

  @override
  String get connecting => '연결 중';

  @override
  String get disconnect => '연결 해제';

  @override
  String get autoConnectLastDevice => '마지막으로 사용한 기기에 자동으로 연결';

  @override
  String get language => '언어';

  @override
  String get followSystem => '시스템 설정 따르기';

  @override
  String get noLanguageMatch => '일치하는 언어가 없습니다';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version(API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => '녹화 권한이 필요합니다';

  @override
  String get recordingPermissionDescription =>
      '시스템 설정에서 개인정보 및 보안 > 화면 및 시스템 오디오 녹화로 이동하여 AudioShare를 허용하세요. macOS는 새 권한을 적용하기 위해 앱을 다시 시작해야 합니다. AudioShare를 종료한 다음 다시 열어 다시 연결하세요.';

  @override
  String get connectionFailedTitle => '연결 실패';

  @override
  String get captureInitializationFailed => '시스템 오디오 캡처를 초기화할 수 없습니다.';

  @override
  String get captureStopped => '시스템 오디오 캡처가 중지되었습니다.';

  @override
  String get captureStartFailed => '시스템 오디오 캡처를 시작할 수 없습니다.';

  @override
  String get listenerStartFailed => '로컬 오디오 스트리밍 서비스를 시작할 수 없습니다.';

  @override
  String get noAvailablePort => '사용할 수 있는 로컬 수신 포트가 없습니다.';

  @override
  String get connectAndroidDeviceFailed => 'Android 기기에 연결하는 중 오류가 발생했습니다.';

  @override
  String get connectDeviceFailed => '기기에 연결하는 중 오류가 발생했습니다.';

  @override
  String nativeErrorDetails(String code) {
    return '오류 코드: $code';
  }

  @override
  String get nativeError1000 => '오디오 캡처 초기화에 실패했습니다.';

  @override
  String get nativeError1001 => '이 macOS 버전은 시스템 오디오 캡처를 지원하지 않습니다.';

  @override
  String get nativeError1002 => '화면 및 시스템 오디오 녹화 권한을 사용할 수 없습니다.';

  @override
  String get nativeError1100 => '로컬 오디오 리스너를 시작할 수 없습니다.';

  @override
  String get nativeError1101 => '로컬 수신 소켓을 만들 수 없습니다.';

  @override
  String get nativeError1102 => '로컬 수신 소켓을 바인딩할 수 없습니다.';

  @override
  String get nativeError1103 => '로컬 수신 소켓이 수신을 시작할 수 없습니다.';

  @override
  String get nativeError1104 => '로컬 리스너 스레드를 만들 수 없습니다.';

  @override
  String get nativeError1105 => '로컬 리스너를 시작하는 시간이 초과되었습니다.';

  @override
  String get nativeError1106 => 'Android 기기의 연결을 수락할 수 없습니다.';

  @override
  String get nativeError1107 => 'Android 기기의 연결 코드를 읽을 수 없습니다.';

  @override
  String get nativeError1200 => '시스템 오디오 캡처를 시작할 수 없습니다.';

  @override
  String get nativeError1201 => '화면 공유 내용을 가져올 수 없습니다.';

  @override
  String get nativeError1202 => '시스템 오디오 캡처에 사용할 수 있는 디스플레이가 없습니다.';

  @override
  String get nativeError1203 => 'ScreenCaptureKit 오디오 출력을 구성할 수 없습니다.';

  @override
  String get nativeError1204 => 'ScreenCaptureKit 오디오 캡처를 시작할 수 없습니다.';

  @override
  String get nativeError1205 => 'ScreenCaptureKit 오디오 캡처가 예기치 않게 중지되었습니다.';

  @override
  String get nativeError1206 => 'ScreenCaptureKit 오디오 캡처를 시작하는 시간이 초과되었습니다.';

  @override
  String get nativeErrorUnknown => '알 수 없는 시스템 오디오 캡처 오류가 발생했습니다.';

  @override
  String exceptionDetails(String message) {
    return '진단 정보: $message';
  }
}
