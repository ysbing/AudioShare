# AudioShare

## 项目简介
AudioShare是一款音频流传输应用，它能够实现实时从电脑向手机传输音频流，让用户在电脑缺乏外接扬声器或未带耳机的情况下，依然能通过手机扬声器或耳机播放电脑中的音频内容。

## 安装指南

1. **访问发布页面**  
   转到 [AudioShare的GitHub发布页面](https://github.com/ysbing/AudioShare/releases) 查看最新发布的版本。

2. **下载软件**  
   点击下载最新版本的文件，例如 `AudioShare-1.0.2.exe`。

3. **运行软件**  
   双击 `AudioShare-1.0.2.exe` 来启动程序。

## 主要功能

- **实时音频流传输**：
  AudioShare采用了特殊技术实现电脑音频的实时无线传输至手机端，确保在无额外硬件条件下，用户能够流畅地将电脑中的任何音频内容同步至Android手机进行播放。

- **便捷连接方式**：
  - **USB连接模式**：
    用户只需使用USB数据线将手机与电脑相连，AudioShare利用adb工具自动建立安全的音频传输链路。
  - **ADB WiFi连接模式**：
    初始阶段通过USB连线进行设备连接后，开启ADB over WiFi功能，即使断开USB连接，在同一局域网环境下，电脑仍能通过WiFi与已配对的手机保持音频流传输。首次设置时，用户需进行简易的ADB WiFi配对操作。

## Windows开发环境配置

### 使用Qt Creator

#### 配置步骤：

1. **安装必要工具**：
   - **Qt SDK**：下载并安装最新版本的 [Qt SDK](https://download.qt.io/archive/online_installers/)，确保安装了 Qt Creator IDE。
   - **Windows SDK**：根据项目需求安装相应的 Windows SDK 版本。
   - **CMake**：CMake 已包含在 Qt 安装包中，无需单独下载。但需要将 CMake 的路径添加到环境变量中。通常路径为 `Qt 安装目录\Tools\CMake_64\bin`。

2. **打开CMake项目**：
   - 在Qt Creator中直接打开项目根目录下的`CMakeLists.txt`文件。
   - Qt Creator将自动检测CMakeLists.txt并配置相应的构建套件（Kit），使用 MSVC 64 位编译器进行构建。

### 使用Visual Studio 2022

#### 配置步骤：

1. **安装必备组件**：
   - **Visual Studio 2022**：安装Visual Studio 2022，并确保安装了"C++桌面开发"工作负载以及CMake工具支持。
   - **Qt for MSVC2022 64-bit**：安装与VS 2022兼容的Qt MSVC2022 64-bit版本。
   - **Windows SDK**与**CMake**：按项目需求安装合适的Windows SDK和CMake版本。

2. **生成Visual Studio解决方案**：
   - 在项目根目录下运行`gen_msvs_cmake.bat`批处理脚本，该脚本会自动生成Visual Studio 2022可用的CMake解决方案。

3. **启动开发**：
   - 打开生成的`msvs_cmake`目录内的`AudioShare.sln`解决方案文件。
   - 在Visual Studio 2022中加载项目，即可进行构建、调试和开发工作。

## Android开发环境配置

### 导入项目

- 通过Android Studio的`File > Open`菜单导入项目目录，待索引完成即可进行代码编辑。

### 构建与部署项目

#### UI操作：

- 构建APK：在Android Studio顶部菜单选择`Build > Build Bundle(s) / APK(s)`，点击`Build APK(s)`编译调试版本APK。

#### 命令行构建：

- 使用Gradle构建Release版本APK：
  在项目根目录的终端中执行以下命令：
  
  ```shell
  gradlew :server:assembleRelease
- 部署构建产物： 构建完成后，Release版本的APK通常位于`<project_root>/server/build/outputs/apk/release`目录，需要手动将此APK文件移动到客户端所需的位置`<project_root>/client/utils/server`。

## 许可证
AudioShare遵循 [LGPLv3](https://opensource.org/licenses/LGPL-3.0)
