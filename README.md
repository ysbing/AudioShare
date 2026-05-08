# AudioShare

实时将 Windows / macOS 系统音频流传输到 Android 设备，通过 ADB（USB 或 Wi-Fi）无需额外硬件，让手机扬声器/耳机播放电脑声音。

## 主要功能

- Windows：WASAPI loopback 捕获系统音频（48kHz 立体声 PCM16）
- macOS：ScreenCaptureKit 捕获系统音频（需 macOS 13.0+，首次使用请授予"屏幕录制"权限）
- 通过 ADB reverse tunnel 传输，USB 和 ADB over Wi-Fi 均支持
- 启动时自动连接上次使用的设备
- 内置 ADB 和 Android 服务端，无需额外安装

## 使用方法

1. 下载 [最新发布版本](https://github.com/ysbing/AudioShare/releases)
2. 手机开启 USB 调试，用 USB 连接电脑（或已配对 ADB over Wi-Fi）
3. 运行客户端，点击"连接"即可

## 开发构建

### 环境要求

| 平台 | 要求 |
|------|------|
| Windows | Windows 10/11 x64、Flutter 3.x、Visual Studio 2022+（Desktop C++）|
| macOS | macOS 13.0+、Flutter 3.x、Xcode 14+ |
| 公共 | Android Studio / JDK（构建 Android 服务端） |

### 构建 Windows 客户端

```powershell
cd client
flutter build windows --release
# 产物：client/build/windows/x64/runner/Release/audioshare.exe
```

### 构建 macOS 客户端

```bash
cd client
flutter build macos --release
# 产物：client/build/macos/Build/Products/Release/AudioShare.app
```

> macOS 首次运行时系统会弹出"屏幕录制"权限申请，授权后即可捕获系统音频。

### 构建 Android 服务端

```bash
# 构建后自动复制到 client/assets/server
./gradlew :server:assembleRelease
```

## 项目结构

```
AudioShare/
  client/                    # Flutter 跨平台客户端
    lib/
      main.dart
      data_source.dart
      services/
        adb_service.dart     # ADB 管理（跨平台）
        audio_capture.dart   # 音频捕获 FFI（跨平台）
      models/
      utils/
    native/
      audio_capture.cpp      # Windows：WASAPI loopback + TCP server (DLL)
      audio_capture_mac.mm   # macOS：ScreenCaptureKit + TCP server (dylib)
    assets/
      adb                    # macOS ADB 二进制
      adb.exe                # Windows ADB 二进制
      AdbWinApi.dll          # Windows only
      AdbWinUsbApi.dll       # Windows only
      server                 # Android 服务端 APK（跨平台）
    windows/                 # Windows 平台配置（CMake）
    macos/                   # macOS 平台配置（Xcode）
  server/                    # Android 服务端（app_process）
    src/main/java/com/ysbing/audioshare/
      Main.java              # AudioTrack 播放
      Options.java           # 参数解析
```

## 许可证

[LGPLv3](https://opensource.org/licenses/LGPL-3.0)
