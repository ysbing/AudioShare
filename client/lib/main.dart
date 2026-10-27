import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'data_source.dart';
import 'l10n/app_localizations_extensions.dart';
import 'l10n/generated/app_localizations.dart';
import 'l10n/language_dialog.dart';
import 'l10n/supported_languages.dart';
import 'utils/design.dart';
import 'utils/prefs.dart';

const _languagePreferenceKey = 'locale';

void main() {
  Prefs.load();
  runZonedGuarded(
    () => runApp(const ScreenUtilInit(
      designSize: designSize,
      child: AudioShareApp(),
    )),
    (error, stack) {
      debugPrint('Uncaught error: $error\n$stack');
    },
  );
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
}

class AudioShareApp extends StatefulWidget {
  const AudioShareApp({super.key});

  @override
  State<AudioShareApp> createState() => _AudioShareAppState();
}

class _AudioShareAppState extends State<AudioShareApp> {
  /// Whether the app follows the device language instead of a fixed one.
  late bool _followSystem;

  /// The language currently in use.
  late AppLanguage _language;

  @override
  void initState() {
    super.initState();
    final savedLanguage = Prefs.getString(_languagePreferenceKey);
    final pinned = savedLanguage == followSystemLanguageId
        ? null
        : languageById(savedLanguage);
    _followSystem = pinned == null;
    _language = pinned ?? _deviceLanguage;
  }

  /// The language the device reports, or English when the app has no
  /// translation for it.
  AppLanguage get _deviceLanguage =>
      resolveLanguage(WidgetsBinding.instance.platformDispatcher.locale) ??
      fallbackLanguage;

  /// The id of the selected language entry.
  String get _currentLanguageId =>
      _followSystem ? followSystemLanguageId : _language.id;

  void _setLanguage(String id) {
    final pinned = id == followSystemLanguageId ? null : languageById(id);
    if (pinned == null && id != followSystemLanguageId) return;
    Prefs.setString(_languagePreferenceKey, id);
    setState(() {
      _followSystem = pinned == null;
      _language = pinned ?? _deviceLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioShare',
      debugShowCheckedModeBanner: false,
      locale: _language.locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AudioShareHomePage(
        onLanguageChanged: _setLanguage,
        currentLanguageId: _currentLanguageId,
        deviceLanguage: _deviceLanguage,
      ),
    );
  }
}

class AudioShareHomePage extends StatefulWidget {
  const AudioShareHomePage({
    super.key,
    required this.onLanguageChanged,
    required this.currentLanguageId,
    required this.deviceLanguage,
  });

  final ValueChanged<String> onLanguageChanged;

  /// The id of the selected language entry.
  final String currentLanguageId;

  /// The language the device reports.
  final AppLanguage deviceLanguage;

  @override
  State<AudioShareHomePage> createState() => _AudioShareHomePageState();
}

class _AudioShareHomePageState extends State<AudioShareHomePage>
    with WidgetsBindingObserver {
  late final DataSource _dataSource;
  bool _dataSourceDisposed = false;
  bool _showingError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dataSource = DataSource();
    _dataSource.addListener(_onDataSourceChanged);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) _cleanupDataSource();
  }

  void _cleanupDataSource() {
    if (_dataSourceDisposed) return;
    _dataSourceDisposed = true;
    _dataSource.removeListener(_onDataSourceChanged);
    _dataSource.dispose();
  }

  void _onDataSourceChanged() {
    if (!mounted) return;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPendingError());
  }

  String _errorDescription(AppLocalizations l10n, UiError error) {
    final description = switch (error.type) {
      UiErrorType.recordingPermissionRequired =>
        l10n.recordingPermissionDescription,
      UiErrorType.captureInitializationFailed =>
        l10n.captureInitializationFailed,
      UiErrorType.captureStopped => l10n.captureStopped,
      UiErrorType.captureStartFailed => l10n.captureStartFailed,
      UiErrorType.listenerStartFailed => l10n.listenerStartFailed,
      UiErrorType.noAvailablePort => l10n.noAvailablePort,
      UiErrorType.connectAndroidDeviceFailed => l10n.connectAndroidDeviceFailed,
      UiErrorType.connectDeviceFailed => l10n.connectDeviceFailed,
    };
    if (error.nativeError case final nativeError?) {
      final nativeDetails =
          '${l10n.nativeErrorDescription(nativeError.code)}\n\n${l10n.nativeErrorDetailsFormatted(nativeError.code)}';
      if (error.type == UiErrorType.recordingPermissionRequired) {
        return '$description\n\n$nativeDetails';
      }
      return nativeDetails;
    }
    if (error.exception case final exception?) {
      return '$description\n\n${l10n.exceptionDetails(exception.toString())}';
    }
    return description;
  }

  Future<void> _openScreenRecordingSettings() async {
    if (!Platform.isMacOS) return;
    const screenRecordingSettings =
        'x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture';
    const privacySettings =
        'x-apple.systempreferences:com.apple.preference.security';
    final result =
        await Process.run('/usr/bin/open', [screenRecordingSettings]);
    if (result.exitCode != 0) {
      await Process.run('/usr/bin/open', [privacySettings]);
    }
  }

  Future<void> _showPendingError() async {
    if (!mounted || _showingError) return;
    _showingError = true;
    try {
      while (mounted) {
        final error = _dataSource.takePendingError();
        if (error == null) break;
        if (!mounted) break;
        final l10n = AppLocalizations.of(context);
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(error.type == UiErrorType.recordingPermissionRequired
                ? l10n.recordingPermissionTitle
                : l10n.connectionFailedTitle),
            content: SelectableText(_errorDescription(l10n, error)),
            actions: [
              if (error.type == UiErrorType.recordingPermissionRequired)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    unawaited(_openScreenRecordingSettings());
                  },
                  child: Text(l10n.openSystemSettings),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      }
    } finally {
      _showingError = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cleanupDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onPressed: () async {
              final selected = await LanguageDialog.show(
                context,
                currentId: widget.currentLanguageId,
                deviceLanguage: widget.deviceLanguage,
              );
              if (selected != null) widget.onLanguageChanged(selected);
            },
          ),
        ],
      ),
      body: SizedBox(
        width: designSize.width.w,
        height: designSize.height.h,
        child: Column(children: [
          Expanded(child: _buildContent(l10n)),
          _buildCheckBox(l10n)
        ]),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    switch (_dataSource.deviceState) {
      case 0:
        return const Center(child: CircularProgressIndicator());
      case 1:
        return Center(child: Text(l10n.noDevices));
      case 2:
        return ListView.separated(
          itemCount: _dataSource.devices.length,
          separatorBuilder: (_, __) => Divider(height: 1.h),
          itemBuilder: (context, index) {
            final device = _dataSource.devices[index];
            final connectState = _dataSource.getConnectState(device.deviceId);
            final connectEnable = _dataSource.getConnectEnable(device.deviceId);
            final apiLevel = int.tryParse(device.apiLevel) ?? 0;
            final port = int.tryParse(device.port) ?? 0;
            final connectionLabel = switch (connectState) {
              0 => l10n.connect,
              1 => l10n.connecting,
              2 => l10n.disconnect,
              _ => l10n.connect,
            };
            return SizedBox(
              height: 60.h,
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Icon(device.usb ? Icons.usb : Icons.wifi, size: 24.w),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${device.manufacturer} ${device.model}',
                            style: TextStyle(fontSize: 14.sp),
                            overflow: TextOverflow.ellipsis),
                        SizedBox(height: 6.h),
                        Text(
                          '${l10n.deviceAndroidVersionFormatted(device.androidVersion, apiLevel)}${device.usb ? '' : l10n.deviceNetworkAddressFormatted(device.ip, port)}',
                          style: TextStyle(fontSize: 12.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: ElevatedButton(
                    onPressed: connectEnable
                        ? () {
                            if (connectState == 0) {
                              _dataSource.connectDevice(device.deviceId,
                                  userInitiated: true);
                            } else if (connectState == 2) {
                              _dataSource.disconnectDevice(device.deviceId);
                            }
                          }
                        : null,
                    child: Text(connectionLabel),
                  ),
                ),
              ]),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCheckBox(AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
      child: Row(children: [
        Checkbox(
            value: _dataSource.lastCheck,
            onChanged: (value) => _dataSource.lastCheck = value ?? false),
        Expanded(
            child: Text(
          l10n.autoConnectLastDevice,
          style: TextStyle(fontSize: 14.sp),
        )),
      ]),
    );
  }
}
