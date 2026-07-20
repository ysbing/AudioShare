import 'package:intl/intl.dart';

import 'generated/app_localizations.dart';

/// Locale-aware presentation helpers for values supplied by devices and APIs.
extension AppLocalizationsFormatting on AppLocalizations {
  String formatNumber(num value) => NumberFormat.decimalPattern(localeName).format(value);

  String formatDateTime(DateTime value) =>
      DateFormat.yMMMd(localeName).add_jm().format(value);

  String deviceAndroidVersionFormatted(String version, int apiLevel) =>
      deviceAndroidVersion(version, formatNumber(apiLevel));

  String deviceNetworkAddressFormatted(String ip, int port) =>
      deviceNetworkAddress(ip, formatNumber(port));

  String nativeErrorDetailsFormatted(int code) => nativeErrorDetails(formatNumber(code));

  String nativeErrorDescription(int code) => switch (code) {
        1000 => nativeError1000,
        1001 => nativeError1001,
        1002 => nativeError1002,
        1100 => nativeError1100,
        1101 => nativeError1101,
        1102 => nativeError1102,
        1103 => nativeError1103,
        1104 => nativeError1104,
        1105 => nativeError1105,
        1106 => nativeError1106,
        1107 => nativeError1107,
        1200 => nativeError1200,
        1201 => nativeError1201,
        1202 => nativeError1202,
        1203 => nativeError1203,
        1204 => nativeError1204,
        1205 => nativeError1205,
        1206 => nativeError1206,
        _ => nativeErrorUnknown,
      };
}
