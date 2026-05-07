import 'dart:async';
import 'package:flutter/material.dart';
import 'data_source.dart';

void main() {
  runZonedGuarded(
    () => runApp(const AudioShareApp()),
    (error, stack) {
      print('UNCAUGHT ERROR: $error');
      print('STACK: $stack');
    },
  );
  FlutterError.onError = (details) {
    print('FLUTTER ERROR: ${details.exception}');
    print('STACK: ${details.stack}');
  };
}

class AudioShareApp extends StatelessWidget {
  const AudioShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioShare',
      debugShowCheckedModeBanner: false,
      home: const AudioShareHomePage(),
    );
  }
}

class AudioShareHomePage extends StatefulWidget {
  const AudioShareHomePage({super.key});

  @override
  State<AudioShareHomePage> createState() => _AudioShareHomePageState();
}

class _AudioShareHomePageState extends State<AudioShareHomePage>
    with WidgetsBindingObserver {
  late final DataSource _dataSource;
  bool _dataSourceDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dataSource = DataSource();
    _dataSource.addListener(_onDataSourceChanged);
  }

  // Called when the app lifecycle changes. On Windows, AppLifecycleState.detached
  // fires when the window is closed — guaranteed to run before the process exits,
  // unlike dispose() which may be skipped if the isolate is torn down first.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _cleanupDataSource();
    }
  }

  void _cleanupDataSource() {
    if (_dataSourceDisposed) return;
    _dataSourceDisposed = true;
    _dataSource.removeListener(_onDataSourceChanged);
    _dataSource.dispose();
  }

  void _onDataSourceChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cleanupDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 360,
        height: 540,
        child: Column(
          children: [
            Expanded(
              child: _buildContent(),
            ),
            _buildCheckBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_dataSource.deviceState) {
      case 0:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case 1:
        return const Center(
          child: Text('没有找到设备'),
        );
      case 2:
        return ListView.separated(
          itemCount: _dataSource.devices.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final device = _dataSource.devices[index];
            final connectState = _dataSource.getConnectState(device.deviceId);
            final connectEnable =
                _dataSource.getConnectEnable(device.deviceId);
            return SizedBox(
              height: 60,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      device.usb ? Icons.usb : Icons.wifi,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${device.manufacturer} ${device.model}',
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Android ${device.androidVersion}(API ${device.apiLevel})'
                            '${device.usb ? '' : ' - ${device.ip}:${device.port}'}',
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
                                _dataSource.connectDevice(device.deviceId);
                              } else if (connectState == 2) {
                                _dataSource.disconnectDevice(device.deviceId);
                              }
                            }
                          : null,
                      child: Text(
                        switch (connectState) {
                          0 => '连接',
                          1 => '连接中',
                          2 => '断开',
                          _ => '连接',
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCheckBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Row(
        children: [
          Checkbox(
            value: _dataSource.lastCheck,
            onChanged: (value) {
              _dataSource.lastCheck = value ?? false;
            },
          ),
          const Text('自动连接上次使用的设备'),
        ],
      ),
    );
  }
}
