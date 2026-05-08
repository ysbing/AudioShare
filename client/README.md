# AudioShare — Client

Stream Windows / macOS system audio to an Android device over ADB (USB or Wi-Fi), with automatic reconnection and no extra hardware required.

## Features

- **Windows**: WASAPI loopback capture (48 kHz stereo PCM16)
- **macOS**: ScreenCaptureKit capture (requires macOS 13.0+; grant Screen Recording permission on first launch)
- Streams over ADB reverse tunnel — USB and ADB over Wi-Fi both supported
- Auto-connects to the last used device on startup
- Bundles ADB and the Android server binary; no extra installs required

## Requirements

| Platform | Requirements |
|----------|-------------|
| Windows | Windows 10/11 x64, ADB drivers |
| macOS | macOS 13.0+, Xcode 14+ |
| Common | Android device with USB debugging enabled (or ADB over Wi-Fi) |

## Build

**Windows**
```powershell
flutter build windows --release
# Output: build\windows\x64\runner\Release\audioshare.exe
```

**macOS**
```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/AudioShare.app
```

## Project Structure

```
client/
  lib/
    main.dart                  # UI entry point
    data_source.dart           # State management, device polling
    services/
      adb_service.dart         # ADB device discovery & server launch
      audio_capture.dart       # FFI bindings (cross-platform)
    models/
      device_model.dart
    utils/
      prefs.dart               # Persistent preferences
  native/
    audio_capture.cpp          # Windows: WASAPI loopback + TCP server (DLL)
    audio_capture_mac.mm       # macOS: ScreenCaptureKit + TCP server (dylib)
  windows/
    runner/                    # Win32 Flutter runner
    CMakeLists.txt             # Builds audio_capture.dll, bundles ADB
  macos/
    Runner/                    # macOS app runner (Swift)
    Runner.xcodeproj/          # Xcode project (builds audio_capture.dylib, bundles ADB)
  assets/
    adb                        # macOS ADB binary (universal arm64/x86_64)
    adb.exe                    # Windows ADB binary
    AdbWinApi.dll              # Windows only
    AdbWinUsbApi.dll           # Windows only
    server                     # Android server APK (cross-platform)
```
