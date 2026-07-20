# AudioShare

Stream Windows and macOS system audio to Android over ADB.

[English](README.md) | [简体中文](docs/README.zh-CN.md)

AudioShare sends Windows or macOS system audio to an Android device through ADB. It works over USB and ADB over Wi-Fi, requires no extra hardware, and plays computer audio through the phone's speaker or headphones.

## Features

- WASAPI loopback system-audio capture on Windows (48 kHz stereo PCM16).
- ScreenCaptureKit system-audio capture on macOS 13 or later.
- USB and ADB over Wi-Fi connections through an ADB reverse tunnel.
- Automatic reconnection to the last used device.
- Bundled ADB and Android server, with no separate Android app to install.

## Quick Start

1. Download the package for your platform from [Releases](https://github.com/ysbing/AudioShare/releases) and extract it.
2. Enable USB debugging on the Android device, then connect it by USB or pair it with ADB over Wi-Fi.
3. Start AudioShare and select **Connect** when the device appears.

On first use on macOS, allow **Screen & System Audio Recording** when prompted. To grant it later, open **System Settings > Privacy & Security > Screen & System Audio Recording**, then reconnect.

## Requirements

| Platform | Runtime requirements | Build requirements |
| --- | --- | --- |
| Windows | Windows 10/11 x64 and working ADB drivers | Flutter 3.x and Visual Studio 2022+ with the Desktop C++ workload |
| macOS | macOS 13+ | Flutter 3.x and Xcode 14+ |
| Android device | USB debugging enabled, or paired ADB over Wi-Fi | Android Studio or JDK, only when building the server |

Use the language menu in the upper-right corner to choose English or Simplified Chinese. Enable the option at the bottom of the window to reconnect automatically on future launches.

## Build from Source

```bash
cd client
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

Build the Windows client:

```powershell
cd client
flutter build windows --release
```

Output: `client/build/windows/x64/runner/Release/audioshare.exe`

Build the macOS client:

```bash
cd client
flutter build macos --release
```

Output: `client/build/macos/Build/Products/Release/AudioShare.app`

Build the Android server. The output is copied to `client/assets/server`:

```bash
./gradlew :server:assembleRelease
```

## Project Structure

```text
AudioShare/
├── client/                  Flutter desktop client
│   ├── lib/                 UI, device state, ADB, and FFI bindings
│   ├── native/              Windows and macOS audio-capture implementations
│   ├── assets/              Bundled ADB binaries and Android server
│   ├── windows/             Windows runner and CMake configuration
│   └── macos/               macOS runner and Xcode configuration
├── server/                  Android audio playback server
└── tools/                   Repository tooling and branding assets
```

## License

Licensed under [LGPL-3.0-or-later](LICENSE).
