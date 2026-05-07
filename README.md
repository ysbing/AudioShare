# AudioShare

实时将 Windows 系统音频流传输到 Android 设备，通过 ADB（USB 或 Wi-Fi）无需额外硬件，让手机扬声器/耳机播放电脑声音。

## 主要功能

- WASAPI loopback 捕获系统音频（48kHz 立体声 PCM16）
- 通过 ADB reverse tunnel 传输，USB 和 ADB over Wi-Fi 均支持
- 启动时自动连接上次使用的设备
- 内置 ADB 和 Android 服务端，无需额外安装

## 使用方法

1. 下载 [最新发布版本](https://github.com/ysbing/AudioShare/releases)
2. 手机开启 USB 调试，用 USB 连接电脑（或已配对 ADB over Wi-Fi）
3. 运行 `audioshare.exe`，点击"连接"即可

## 开发构建

### 环境要求

- Windows 10/11 x64
- Flutter 3.x（Windows desktop）
- Android Studio / JDK（构建 Android 服务端）
- Visual Studio 2022+ with "Desktop development with C++"

### 构建 Windows 客户端

```powershell
cd client
flutter build windows --release
# 产物：client/build/windows/x64/runner/Release/audioshare.exe
```

### 构建 Android 服务端

```powershell
# 构建后自动复制到 client/assets/server
gradlew :server:assembleRelease
```

## 项目结构

```
AudioShare/
  client/          # Flutter Windows 客户端
    lib/
      main.dart
      data_source.dart
      services/    # ADB 管理、音频捕获 FFI
      models/
      utils/
    native/
      audio_capture.cpp   # WASAPI + TCP server (DLL)
    assets/
      adb.exe / AdbWinApi.dll / AdbWinUsbApi.dll
      server              # Android 服务端 APK
  server/          # Android 服务端（app_process）
    src/main/java/com/ysbing/audioshare/
      Main.java    # AudioTrack 播放
      Options.java # 参数解析
```

## 许可证

[LGPLv3](https://opensource.org/licenses/LGPL-3.0)
