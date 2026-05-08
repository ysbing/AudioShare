import 'dart:convert';
import 'dart:io';

class Prefs {
  static Map<String, dynamic> _cache = {};

  static File _file() {
    String base;
    if (Platform.isWindows) {
      base = Platform.environment['APPDATA'] ?? Directory.systemTemp.path;
    } else if (Platform.isMacOS) {
      final home = Platform.environment['HOME'] ?? Directory.systemTemp.path;
      base = '$home/Library/Application Support';
    } else {
      final home = Platform.environment['HOME'] ?? Directory.systemTemp.path;
      base = '$home/.config';
    }
    final sep = Platform.pathSeparator;
    final dir = Directory('$base${sep}ysbing${sep}AudioShare');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return File('${dir.path}${sep}prefs.json');
  }

  static void load() {
    try {
      final f = _file();
      if (f.existsSync()) {
        _cache = Map<String, dynamic>.from(jsonDecode(f.readAsStringSync()));
      }
    } catch (_) {}
  }

  static String getString(String key, {String defaultValue = ''}) =>
      (_cache[key] as String?) ?? defaultValue;

  static bool getBool(String key, {bool defaultValue = false}) =>
      (_cache[key] as bool?) ?? defaultValue;

  static void setString(String key, String value) {
    _cache[key] = value;
    _persist();
  }

  static void setBool(String key, bool value) {
    _cache[key] = value;
    _persist();
  }

  static void _persist() {
    try {
      _file().writeAsStringSync(jsonEncode(_cache));
    } catch (_) {}
  }
}
