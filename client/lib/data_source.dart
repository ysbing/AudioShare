import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'models/device_model.dart';
import 'services/adb_service.dart';
import 'services/audio_capture.dart';
import 'utils/prefs.dart';

class DataSource extends ChangeNotifier {
  final AdbService _adb = AdbService();
  final AudioCaptureService _audioCapture = AudioCaptureService();

  List<DeviceModel> _devices = [];
  final Map<String, int> _connectStateMap = {};
  int _deviceState = 0; // 0=loading, 1=no devices, 2=has devices
  bool _lastCheck = true;
  String _lastDeviceId = '';
  String _lastAutoDeviceId = '';
  late final DateTime _startTime;

  void _setLastDeviceId(String id) {
    _lastDeviceId = id;
    Prefs.setString('lastDeviceId', id);
  }

  Timer? _pollTimer;

  List<DeviceModel> get devices => _devices;
  int get deviceState => _deviceState;
  bool get lastCheck => _lastCheck;

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

    final initOk = _audioCapture.initialize();
    print('AudioCapture initialize: $initOk');
    _pollDevices();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _pollDevices());
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
    notifyListeners();
  }

  Future<int> _findAvailablePort() async {
    for (int port = 11794; port < 11794 + 10000; port++) {
      try {
        final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
        await server.close();
        return port;
      } catch (_) {
        continue;
      }
    }
    return 0;
  }

  void connectDevice(String deviceId) {
    print('connectDevice called with $deviceId');
    try {
      _lastAutoDeviceId = deviceId;
      _setLastDeviceId(deviceId);
      // Stop existing connection and set state=1 atomically in a single
      // notifyListeners so the button never flickers back to "连接" between
      // the clear and the state-1 assignment.
      _adb.stopServer();
      _audioCapture.stop();
      _connectStateMap.clear();
      _connectStateMap[deviceId] = 1;
      notifyListeners();
      print('State updated to connecting');

      () async {
        try {
          print('Step 4: finding port');
          final port = await _findAvailablePort();
          print('Found port: $port');
          final socketName = 'audioshare_$port';

          print('Step 5: calling listenOnPort');
          final listenOk = _audioCapture.listenOnPort(port, (connectCode) {
            print('=== CALLBACK FIRED: $connectCode ===');
            _audioCapture.start();
            _connectStateMap[deviceId] = 2;
            notifyListeners();
          });
          print('Step 6: listenOnPort result: $listenOk');

          if (!listenOk) {
            _connectStateMap[deviceId] = 0;
            notifyListeners();
            return;
          }

          print('Step 7: ADB reverse');
          await _adb.reverse(deviceId, socketName, port.toString());
          print('Step 8: Push server');
          await _adb.pushServer(deviceId);
          print('Step 9: Launch server');
          await _adb.launchServer(deviceId, socketName);
          print('Step 10: Server launched');
        } catch (e, s) {
          print('Connection error: $e\n$s');
          _connectStateMap[deviceId] = 0;
          notifyListeners();
        }
      }();
    } catch (e, s) {
      print('connectDevice outer error: $e\n$s');
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
    _audioCapture.dispose();
    disconnectAllDevice();
    _adb.dispose();
    super.dispose();
  }
}
