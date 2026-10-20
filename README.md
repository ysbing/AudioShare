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

On first use on macOS, allow **Screen & System Audio Recording** when prompted. To grant it later, open **System Settings > Privacy & Security > Screen & System Audio Recording**, then quit and reopen AudioShare before reconnecting.

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

Output: `client/build/windows/x64/runner/Release/audioshare.exe`. AudioShare loads `adb.exe`, `AdbWinApi.dll`, `AdbWinUsbApi.dll`, `audio_capture.dll`, and the `server` asset from that directory at runtime, so the whole `Release` directory has to be shipped; a package that only contains `audioshare.exe` stays stuck on "Connecting".

Package the build output with `./tools/package_windows.ps1 [-Version <version>]`, which validates those files and writes `dist/audioshare-<version>-win.7z`:

```powershell
./tools/package_windows.ps1
```

Build the macOS client:

```bash
cd client
flutter build macos --release
```

Output: `client/build/macos/Build/Products/Release/AudioShare.app`

Package the build output with `./tools/package_macos.sh [--version <version>]`, which validates those files, ad-hoc signs the bundle, and writes `dist/audioshare-<version>-macos.zip`:

```bash
./tools/package_macos.sh
```

Build the Android server. The output is copied to `client/assets/server`:

```bash
./gradlew :server:assembleRelease
```

## Continuous Integration

[`.github/workflows/build.yml`](.github/workflows/build.yml) builds the Android server and both desktop clients on every push and pull request. Each run uploads `audioshare-<version>-win.7z` and `audioshare-<version>-macos.zip` as artifacts; pushing a `v*` tag also attaches both packages to the GitHub release.

The macOS job runs without an Apple Developer certificate and ad-hoc signs the bundle, so its packages are not notarized.

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
