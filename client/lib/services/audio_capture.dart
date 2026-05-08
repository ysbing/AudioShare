import 'dart:ffi';
import 'dart:io';

// Connect callback: void (*)(const char* connectCode)
typedef ConnectCallbackNative = Void Function(Pointer<Int8> connectCode);
typedef ConnectCallbackDart = void Function(Pointer<Int8> connectCode);

typedef AudioCaptureInitializeNative = Int32 Function();
typedef AudioCaptureInitializeDart = int Function();

typedef AudioCaptureListenNative = Int32 Function(
    Int32 port, Pointer<NativeFunction<ConnectCallbackNative>> callback);
typedef AudioCaptureListenDart = int Function(
    int port, Pointer<NativeFunction<ConnectCallbackNative>> callback);

typedef AudioCaptureStartNative = Int32 Function();
typedef AudioCaptureStartDart = int Function();

typedef AudioCaptureStopNative = Void Function();
typedef AudioCaptureStopDart = void Function();

typedef AudioCaptureCleanupNative = Void Function();
typedef AudioCaptureCleanupDart = void Function();

AudioCaptureService? _activeService;

void _handleConnect(Pointer<Int8> connectCodePtr) {
  final service = _activeService;
  if (service != null && service.onConnected != null) {
    final bytes = <int>[];
    var i = 0;
    while (true) {
      final byte = (connectCodePtr + i).value;
      if (byte == 0) break;
      bytes.add(byte);
      i++;
    }
    final connectCode = String.fromCharCodes(bytes);
    service.onConnected!(connectCode);
  }
}

class AudioCaptureService {
  DynamicLibrary? _lib;
  AudioCaptureInitializeDart? _initialize;
  AudioCaptureListenDart? _listen;
  AudioCaptureStartDart? _start;
  AudioCaptureStopDart? _stop;
  AudioCaptureCleanupDart? _cleanup;

  bool _initialized = false;
  void Function(String connectCode)? onConnected;

  NativeCallable<ConnectCallbackNative>? _connectCallback;

  AudioCaptureService() {
    _loadLibrary();
  }

  void _loadLibrary() {
    try {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final libName = Platform.isMacOS ? 'audio_capture.dylib' : 'audio_capture.dll';
      final dllPath = '$exeDir${Platform.pathSeparator}$libName';
      _lib = DynamicLibrary.open(dllPath);
      _initialize = _lib!
          .lookupFunction<AudioCaptureInitializeNative, AudioCaptureInitializeDart>(
              'AudioCapture_Initialize');
      _listen = _lib!
          .lookupFunction<AudioCaptureListenNative, AudioCaptureListenDart>(
              'AudioCapture_Listen');
      _start = _lib!
          .lookupFunction<AudioCaptureStartNative, AudioCaptureStartDart>(
              'AudioCapture_Start');
      _stop = _lib!
          .lookupFunction<AudioCaptureStopNative, AudioCaptureStopDart>(
              'AudioCapture_Stop');
      _cleanup = _lib!
          .lookupFunction<AudioCaptureCleanupNative, AudioCaptureCleanupDart>(
              'AudioCapture_Cleanup');
    } catch (_) {}
  }

  /// Initialize system audio capture (WASAPI on Windows, ScreenCaptureKit on macOS).
  bool initialize() {
    if (_initialize == null) return false;
    _activeService = this;
    _initialized = _initialize!() != 0;
    return _initialized;
  }

  /// Start listening for Android connection on given port.
  /// [onConnect] is called with the device connectCode when Android connects.
  bool listenOnPort(int port, void Function(String connectCode) onConnect) {
    if (!_initialized || _listen == null) return false;
    onConnected = onConnect;

    _connectCallback?.close();
    _connectCallback = NativeCallable<ConnectCallbackNative>.listener(
      _handleConnect,
    );

    return _listen!(port, _connectCallback!.nativeFunction) != 0;
  }

  /// Start audio capture stream (call after listenOnPort callback fires)
  bool start() {
    if (!_initialized || _start == null) return false;
    return _start!() != 0;
  }

  void stop() {
    if (!_initialized || _stop == null) return;
    _stop!();
  }

  void cleanup() {
    if (!_initialized || _cleanup == null) return;
    _cleanup!();
    _connectCallback?.close();
    _connectCallback = null;
    _initialized = false;
  }

  void dispose() {
    cleanup();
  }
}
