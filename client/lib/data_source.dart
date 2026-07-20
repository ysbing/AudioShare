import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'models/device_model.dart';
import 'services/adb_service.dart';
import 'services/audio_capture.dart';
import 'utils/prefs.dart';

class UiError {
  const UiError({required this.title, required this.message});

  final String title;
  final String message;
}

class DataSource extends ChangeNotifier {
  final AdbService _adb = AdbService();
  final AudioCaptureService _audioCapture = AudioCaptureService();

  List<DeviceModel> _devices = [];
  final Map<String, int> _connectStateMap = {};
  int _deviceState = 0; // 0=loading, 1=no devices, 2=has devices
  bool _lastCheck = true;
  String _lastDeviceId = '';
  String _lastAutoDeviceId = '';
  UiError? _pendingError;
  late final DateTime _startTime;

  void _setLastDeviceId(String id) {
    _lastDeviceId = id;
    Prefs.setString('lastDeviceId', id);
  }

  Timer? _pollTimer;

  List<DeviceModel> get devices => _devices;
  int get deviceState => _deviceState;
  bool get lastCheck => _lastCheck;
  UiError? takePendingError() {
    final error = _pendingError;
    _pendingError = null;
    return error;
  }

  set lastCheck(bool value) {
    if (value) {
      // Checking: keep _lastDeviceId so next startup can auto-connect,
      // but sync _lastAutoDeviceId so the current session poll doesn't fire.
      _lastAutoDeviceId = _lastDeviceId;
    } else {
      // Unchecking: forget the last device entirely.
      _lastAutoDeviceId = '';
      _setLastDeviceId('');
    }
    _lastCheck = value;
    Prefs.setBool('lastCheck', value);
    notifyListeners();
  }

  DataSource() {
    _startTime = DateTime.now();
    Prefs.load();
    _lastDeviceId = Prefs.getString('lastDeviceId');
    _lastCheck = Prefs.getBool('lastCheck', defaultValue: true);

    _pollDevices();
    _pollTimer =
        Timer.periodic(const Duration(seconds: 3), (_) => _pollDevices());
  }

  int getConnectState(String deviceId) => _connectStateMap[deviceId] ?? 0;

  bool getConnectEnable(String deviceId) {
    for (final state in _connectStateMap.values) {
      if (state == 1) return false;
    }
    final state = _connectStateMap[deviceId] ?? 0;
    return state == 0 || state == 2;
  }

  Future<void> _pollDevices() async {
    final devices = await _adb.devices();
    _devices = devices;
    if (devices.isEmpty) {
      final elapsed = DateTime.now().difference(_startTime);
      if (elapsed.inSeconds >= 2) {
        _deviceState = 1;
      }
      _lastAutoDeviceId = '';
      // Don't wipe an active/connecting session on a transient empty poll.
      final hasActive = _connectStateMap.values.any((s) => s == 1 || s == 2);
      if (!hasActive) _connectStateMap.clear();
    } else {
      _deviceState = 2;
      final connectKeys = List<String>.from(_connectStateMap.keys);
      for (final key in connectKeys) {
        bool has = false;
        for (final device in devices) {
          if (device.deviceId == key) {
            has = true;
          }
        }
        if (!has) {
          _connectStateMap[key] = 0;
        }
      }
      bool hasLast = false;
      for (final device in devices) {
        if (_lastDeviceId.isNotEmpty && device.deviceId == _lastDeviceId) {
          hasLast = true;
        }
      }
      if (hasLast) {
        if (_lastCheck &&
            _lastDeviceId.isNotEmpty &&
            (_connectStateMap[_lastDeviceId] ?? 0) == 0 &&
            _lastDeviceId != _lastAutoDeviceId) {
          connectDevice(_lastDeviceId);
        }
      } else {
        _lastAutoDeviceId = '';
      }
    }
    _pollNativeCaptureError();
    notifyListeners();
  }

  bool _prepareAudioCapture({required bool userInitiated}) {
    if (Platform.isMacOS && !_audioCapture.hasScreenCapturePermission) {
      if (!userInitiated) return false;
      if (!_audioCapture.requestScreenCapturePermission()) {
        _reportNativeError(
          '未获得“屏幕与系统音频录制”权限。请在“系统设置 > 隐私与安全性 > 屏幕与系统音频录制”中允许 AudioShare，然后重新连接。',
          _audioCapture.takeLastError(
            fallbackCode: 1002,
            fallbackMessage:
                'Screen and system audio recording permission was not granted',
          ),
          title: '需要录制权限',
        );
        return false;
      }
    }

    if (!_audioCapture.initialize()) {
      _reportNativeError(
        '无法初始化系统音频捕获。',
        _audioCapture.takeLastError(
          fallbackCode: 1000,
          fallbackMessage: 'Audio capture initialization failed',
        ),
      );
      return false;
    }
    return true;
  }

  void _reportNativeError(
    String description,
    AudioCaptureError? error, {
    String title = '连接失败',
  }) {
    final detail = error ??
        const AudioCaptureError(-1, 'No native error information was returned');
    _pendingError = UiError(
      title: title,
      message: '$description\n\n错误码：${detail.code}\n错误信息：${detail.message}',
    );
    notifyListeners();
  }

  void _pollNativeCaptureError() {
    final hasSession =
        _connectStateMap.values.any((state) => state == 1 || state == 2);
    if (!hasSession) return;
    final error = _audioCapture.pollLastError();
    if (error == null) return;

    _adb.stopServer();
    _audioCapture.stop();
    for (final deviceId in _connectStateMap.keys.toList()) {
      _connectStateMap[deviceId] = 0;
    }
    _reportNativeError('系统音频捕获已停止。', error);
  }

  Future<int> _findAvailablePort() async {
    for (int port = 11794; port < 11794 + 10000; port++) {
      try {
        // Bind to anyIPv4 (0.0.0.0) — same address the native TCP server uses,
        // so the availability check is accurate and avoids false positives from
        // loopback-vs-wildcard mismatches (e.g. leftover ADB reverse tunnels).
        final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
        await server.close();
        return port;
      } catch (_) {
        continue;
      }
    }
    return 0;
  }

  void connectDevice(String deviceId, {bool userInitiated = false}) {
    try {
      _lastAutoDeviceId = deviceId;
      if (!_prepareAudioCapture(userInitiated: userInitiated)) return;

      _setLastDeviceId(deviceId);
      // Stop existing connection and set state=1 atomically in a single
      // notifyListeners so the button never flickers back to "连接" between
      // the clear and the state-1 assignment.
      _adb.stopServer();
      _audioCapture.stop();
      _connectStateMap.clear();
      _connectStateMap[deviceId] = 1;
      notifyListeners();

      () async {
        try {
          // Clear any leftover reverse tunnels from previous sessions so their
          // port reservations don't block our new binding.
          await _adb.removeAllReverse(deviceId);
          final port = await _findAvailablePort();
          if (port == 0) {
            throw const SocketException('没有可用的本地监听端口');
          }
          final socketName = 'audioshare_$port';

          final listenOk = _audioCapture.listenOnPort(port, (connectCode) {
            final startOk = _audioCapture.start();
            if (!startOk) {
              _adb.stopServer();
              _audioCapture.stop();
              _connectStateMap[deviceId] = 0;
              _reportNativeError(
                '无法开始捕获系统音频。',
                _audioCapture.takeLastError(
                  fallbackCode: 1200,
                  fallbackMessage: 'Audio capture failed to start',
                ),
              );
              return;
            }
            _connectStateMap[deviceId] = 2;
            notifyListeners();
          });

          if (!listenOk) {
            _connectStateMap[deviceId] = 0;
            _reportNativeError(
              '无法启动本地音频传输服务。',
              _audioCapture.takeLastError(
                fallbackCode: 1100,
                fallbackMessage: 'Audio capture listener failed to start',
              ),
            );
            return;
          }

          await _adb.reverse(deviceId, socketName, port.toString());
          await _adb.pushServer(deviceId);
          await _adb.launchServer(deviceId, socketName);
        } catch (e, s) {
          print('Connection error: $e\n$s');
          _connectStateMap[deviceId] = 0;
          _pendingError = UiError(
            title: '连接失败',
            message: '连接 Android 设备时发生错误。\n\n错误信息：$e',
          );
          notifyListeners();
        }
      }();
    } catch (e, s) {
      print('Connection error: $e\n$s');
      _connectStateMap[deviceId] = 0;
      _pendingError = UiError(
        title: '连接失败',
        message: '连接设备时发生错误。\n\n错误信息：$e',
      );
      notifyListeners();
    }
  }

  void disconnectDevice(String deviceId) {
    _adb.stopServer();
    _audioCapture.stop();
    _lastAutoDeviceId = '';
    _setLastDeviceId('');
    _connectStateMap[deviceId] = 0;
    notifyListeners();
  }

  void disconnectAllDevice() {
    _adb.stopServer();
    _audioCapture.stop();
    _connectStateMap.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    disconnectAllDevice();
    _audioCapture.dispose();
    _adb.dispose();
    super.dispose();
  }
}
