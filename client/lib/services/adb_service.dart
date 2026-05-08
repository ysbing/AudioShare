import 'dart:convert';
import 'dart:io';
import '../models/device_model.dart';

class AdbService {
  String _adbPath = '';
  Process? _launchProcess;

  AdbService() {
    _initAdbPath();
  }

  void _initAdbPath() {
    final sep = Platform.pathSeparator;
    final exeDir = File(Platform.resolvedExecutable).parent.path;

    if (Platform.isWindows) {
      // Windows: copy adb.exe + Win32 DLLs to temp so the daemon persists
      // across restarts (the bundle dir may be read-only when installed).
      final tempDir = '${Directory.systemTemp.path}${sep}ysbing${sep}AudioShare${sep}adb';
      final tempAdb = '$tempDir${sep}adb.exe';
      try {
        Directory(tempDir).createSync(recursive: true);
        for (final name in ['adb.exe', 'AdbWinApi.dll', 'AdbWinUsbApi.dll']) {
          final src = File('$exeDir$sep$name');
          if (src.existsSync()) {
            try { src.copySync('$tempDir$sep$name'); } catch (_) {}
          }
        }
        if (File(tempAdb).existsSync()) {
          _adbPath = tempAdb;
          return;
        }
      } catch (_) {}
      _adbPath = '$exeDir${sep}adb.exe';
      return;
    }

    // macOS / Linux: adb is bundled next to the executable by the build phase.
    _adbPath = '$exeDir${sep}adb';

    // Ensure the bundled binary is executable (it may lose the bit after copy).
    try { Process.runSync('chmod', ['+x', _adbPath]); } catch (_) {}
  }

  Future<String> _exec(List<String> arguments) async {
    try {
      final result = await Process.run(_adbPath, arguments);
      final stdout = result.stdout as String;
      final stderr = result.stderr as String;
      if (stdout.isNotEmpty) return stdout;
      if (stderr.isNotEmpty) return stderr;
      return '';
    } catch (_) {
      return '';
    }
  }

  // Cache device properties: they never change while connected.
  final Map<String, DeviceModel> _deviceCache = {};

  Future<List<DeviceModel>> devices() async {
    var output = await _exec(['devices']);
    if (!output.contains('\tdevice')) {
      await Future.delayed(const Duration(milliseconds: 800));
      output = await _exec(['devices']);
    }
    final lines = LineSplitter().convert(output);
    final devices = <DeviceModel>[];

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final parts = line.split(RegExp(r'\s+'));
      if (parts.length >= 2 && parts[1] == 'device') {
        final deviceId = parts[0];
        if (_deviceCache.containsKey(deviceId)) {
          devices.add(_deviceCache[deviceId]!);
          continue;
        }
        // Batch all getprop into one shell invocation with labeled output so
        // parsing is order-independent and robust against ADB daemon messages
        // or stray empty lines that would otherwise shift indices.
        final propsOut = await _exec([
          '-s', deviceId, 'shell',
          'echo "sn:\$(getprop ro.serialno)"; '
          'echo "mo:\$(getprop ro.product.model)"; '
          'echo "mf:\$(getprop ro.product.manufacturer)"; '
          'echo "av:\$(getprop ro.build.version.release)"; '
          'echo "al:\$(getprop ro.build.version.sdk)"',
        ]);
        String tag(String t) {
          for (final raw in LineSplitter().convert(propsOut)) {
            final line = raw.trim();
            if (line.startsWith('$t:')) return line.substring(t.length + 1);
          }
          return '';
        }
        final ipPort = _getIpPort(deviceId);
        final model = DeviceModel(
          deviceId: deviceId,
          usb: ipPort.$1.isEmpty || ipPort.$2.isEmpty,
          serialNumber:   tag('sn'),
          model:          tag('mo'),
          manufacturer:   tag('mf'),
          androidVersion: tag('av'),
          apiLevel:       tag('al'),
          ip: ipPort.$1,
          port: ipPort.$2,
        );
        _deviceCache[deviceId] = model;
        devices.add(model);
      }
    }
    // Evict cache entries for devices no longer present.
    _deviceCache.removeWhere((id, _) => !devices.any((d) => d.deviceId == id));
    return devices;
  }

  (String, String) _getIpPort(String deviceId) {
    final regex = RegExp(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):(\d{1,5})');
    final match = regex.firstMatch(deviceId);
    if (match != null) {
      return (match.group(1)!, match.group(2)!);
    }
    return ('', '');
  }

  Future<void> removeAllReverse(String deviceId) async {
    await _exec(['-s', deviceId, 'reverse', '--remove-all']);
  }

  Future<void> reverse(String deviceId, String socketName, String port) async {
    await _exec(['-s', deviceId, 'reverse', 'localabstract:$socketName', 'tcp:$port']);
  }

  Future<void> pushServer(String deviceId) async {
    final exeDir = File(Platform.resolvedExecutable).parent.path;
    // macOS: server APK lives in Contents/Resources/ to avoid codesign failures.
    // Windows: server is placed next to the exe by CMakeLists.txt.
    final serverPath = Platform.isMacOS
        ? '$exeDir/../Resources/server'
        : '$exeDir${Platform.pathSeparator}server';
    await _exec(['-s', deviceId, 'push', serverPath, '/data/local/tmp/audioshare']);
  }

  Future<void> launchServer(String deviceId, String socketName) async {
    stopServer();
    _launchProcess = await Process.start(_adbPath, [
      '-s', deviceId, 'shell', 'app_process',
      '-Djava.class.path=/data/local/tmp/audioshare',
      '/data/local/tmp',
      'com.ysbing.audioshare.Main',
      'socketName=$socketName',
      'connectCode=$deviceId',
    ]);
    _launchProcess!.stdout.transform(utf8.decoder).listen((_) {});
    _launchProcess!.stderr.transform(utf8.decoder).listen((_) {});
  }

  void stopServer() {
    if (_launchProcess != null) {
      _launchProcess!.kill(ProcessSignal.sigkill);
      _launchProcess = null;
    }
  }

  void dispose() {
    stopServer();
    // ADB daemon runs from temp dir and intentionally persists between restarts.
    // No kill-server needed.
  }
}
