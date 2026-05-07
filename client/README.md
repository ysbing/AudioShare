# AudioShare — Windows Client

Stream Windows system audio to an Android device over ADB (USB or Wi-Fi), with zero latency configuration and automatic reconnection.

## Features

- Captures system audio via WASAPI loopback (48 kHz stereo PCM16)
- Streams to Android over ADB reverse tunnel — no Wi-Fi setup needed
- Auto-connects to the last used device on startup
- Bundles ADB and the Android server binary; no extra installs required

## Requirements

- Windows 10/11 x64
- Android device with USB debugging enabled (or ADB over Wi-Fi)
- ADB drivers installed on the PC

## Build

```powershell
flutter build windows --release
```

Output: `build\windows\x64\runner\Release\audioshare.exe`

## Project Structure

```
client/
  lib/
    main.dart              # UI entry point
    data_source.dart       # State management
    services/
      adb_service.dart     # ADB device discovery & server launch
      audio_capture.dart   # FFI bindings to audio_capture.dll
    models/
      device_model.dart
    utils/
      prefs.dart           # Persistent preferences
  native/
    audio_capture.cpp      # WASAPI loopback capture + TCP server (DLL)
  windows/
    runner/                # Win32 Flutter runner
    CMakeLists.txt
  assets/
    adb.exe / AdbWinApi.dll / AdbWinUsbApi.dll
    server                 # Android APK (app_process server)
```
