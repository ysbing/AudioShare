# AudioShare

[English](../README.md) | [简体中文](README.zh-CN.md)

AudioShare 通过 ADB 将 Windows 或 macOS 的系统音频传输到 Android 设备。它支持 USB 和 ADB over Wi-Fi，无需额外硬件，可通过手机扬声器或耳机播放电脑声音。

## 功能

- Windows 使用 WASAPI loopback 捕获系统音频（48 kHz、立体声、PCM16）。
- macOS 使用 ScreenCaptureKit 捕获系统音频，需要 macOS 13 或更高版本。
- 使用 ADB reverse tunnel 传输，支持 USB 与 ADB over Wi-Fi。
- 可自动连接上一次使用的设备。
- 客户端内置 ADB 和 Android 服务端，无需单独安装手机应用。

## 快速开始

1. 从 [Releases](https://github.com/ysbing/AudioShare/releases) 下载对应平台的安装包或压缩包并解压。
2. 在 Android 设备上开启 USB 调试，再通过 USB 连接电脑，或完成 ADB over Wi-Fi 配对。
3. 启动 AudioShare；设备出现后点击“连接”。

macOS 首次使用时，请在系统提示中允许“屏幕与系统音频录制”。如需稍后授权，可前往“系统设置 > 隐私与安全性 > 屏幕与系统音频录制”，授权后重新连接。

## 运行要求

| 平台 | 运行要求 | 构建要求 |
| --- | --- | --- |
| Windows | Windows 10/11 x64、可用的 ADB 驱动 | Flutter 3.x、Visual Studio 2022+（Desktop C++ 工作负载） |
| macOS | macOS 13+ | Flutter 3.x、Xcode 14+ |
| Android 设备 | 已开启 USB 调试，或已配置 ADB over Wi-Fi | Android Studio 或 JDK（仅构建服务端时需要） |

可使用右上角语言菜单切换 English 或简体中文。勾选窗口底部选项后，应用会在后续启动时自动连接上次使用的设备。

## 从源码构建

```bash
cd client
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

构建 Windows 客户端：

```powershell
cd client
flutter build windows --release
```

产物：`client/build/windows/x64/runner/Release/audioshare.exe`

构建 macOS 客户端：

```bash
cd client
flutter build macos --release
```

产物：`client/build/macos/Build/Products/Release/AudioShare.app`

构建 Android 服务端，产物会复制到 `client/assets/server`：

```bash
./gradlew :server:assembleRelease
```

## 项目结构

```text
AudioShare/
├── client/                  Flutter 桌面客户端
│   ├── lib/                 界面、设备状态、ADB 与 FFI 绑定
│   ├── native/              Windows 与 macOS 音频捕获实现
│   ├── assets/              内置 ADB 二进制与 Android 服务端
│   ├── windows/             Windows runner 与 CMake 配置
│   └── macos/               macOS runner 与 Xcode 配置
├── server/                  Android 音频播放服务端
└── tools/                   仓库工具与品牌资源
```

## 许可证

本项目采用 [LGPL-3.0-or-later](../LICENSE) 许可证。
