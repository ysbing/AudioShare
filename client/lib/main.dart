import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data_source.dart';
import 'l10n/app_localizations_extensions.dart';
import 'l10n/generated/app_localizations.dart';
import 'utils/prefs.dart';

const _supportedLocales = [Locale('en'), Locale('zh')];
const _languagePreferenceKey = 'locale';

void main() {
  Prefs.load();
  runZonedGuarded(
    () => runApp(const AudioShareApp()),
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
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    final savedLanguage = Prefs.getString(_languagePreferenceKey);
    if (_supportedLocales.any((locale) => locale.languageCode == savedLanguage)) {
      _locale = Locale(savedLanguage);
    }
  }

  void _setLocale(Locale locale) {
    Prefs.setString(_languagePreferenceKey, locale.languageCode);
    setState(() => _locale = locale);
  }

  Locale _resolveLocale(Locale? deviceLocale, Iterable<Locale> supportedLocales) {
    final languageCode = deviceLocale?.languageCode;
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => const Locale('en'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioShare',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: _supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: _resolveLocale,
      home: AudioShareHomePage(onLocaleChanged: _setLocale),
    );
  }
}

class AudioShareHomePage extends StatefulWidget {
  const AudioShareHomePage({super.key, required this.onLocaleChanged});

  final ValueChanged<Locale> onLocaleChanged;

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
      UiErrorType.recordingPermissionRequired => l10n.recordingPermissionDescription,
      UiErrorType.captureInitializationFailed => l10n.captureInitializationFailed,
      UiErrorType.captureStopped => l10n.captureStopped,
      UiErrorType.captureStartFailed => l10n.captureStartFailed,
      UiErrorType.listenerStartFailed => l10n.listenerStartFailed,
      UiErrorType.noAvailablePort => l10n.noAvailablePort,
      UiErrorType.connectAndroidDeviceFailed => l10n.connectAndroidDeviceFailed,
      UiErrorType.connectDeviceFailed => l10n.connectDeviceFailed,
    };
    if (error.nativeError case final nativeError?) {
      return '${l10n.nativeErrorDescription(nativeError.code)}\n\n${l10n.nativeErrorDetailsFormatted(nativeError.code)}';
    }
    if (error.exception case final exception?) {
      return '$description\n\n${l10n.exceptionDetails(exception.toString())}';
    }
    return description;
  }

  Future<void> _showPendingError() async {
    if (!mounted || _showingError) return;
    _showingError = true;
    try {
      while (mounted) {
        final error = _dataSource.takePendingError();
        if (error == null) break;
        final l10n = AppLocalizations.of(context);
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(error.type == UiErrorType.recordingPermissionRequired
                ? l10n.recordingPermissionTitle
                : l10n.connectionFailedTitle),
            content: SelectableText(_errorDescription(l10n, error)),
            actions: [
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
          PopupMenuButton<Locale>(
            tooltip: l10n.language,
            icon: const Icon(Icons.language),
            onSelected: widget.onLocaleChanged,
            itemBuilder: (context) => [
              PopupMenuItem(value: const Locale('en'), child: Text(l10n.languageEnglish)),
              PopupMenuItem(value: const Locale('zh'), child: Text(l10n.languageChinese)),
            ],
          ),
        ],
      ),
      body: SizedBox(
        width: 360,
        height: 540,
        child: Column(children: [Expanded(child: _buildContent(l10n)), _buildCheckBox(l10n)]),
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
          separatorBuilder: (_, __) => const Divider(height: 1),
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
              height: 60,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(device.usb ? Icons.usb : Icons.wifi, size: 24),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${device.manufacturer} ${device.model}', style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Text(
                          '${l10n.deviceAndroidVersionFormatted(device.androidVersion, apiLevel)}${device.usb ? '' : l10n.deviceNetworkAddressFormatted(device.ip, port)}',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: connectEnable
                        ? () {
                            if (connectState == 0) {
                              _dataSource.connectDevice(device.deviceId, userInitiated: true);
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
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Row(children: [
        Checkbox(value: _dataSource.lastCheck, onChanged: (value) => _dataSource.lastCheck = value ?? false),
        Expanded(child: Text(l10n.autoConnectLastDevice)),
      ]),
    );
  }
}
