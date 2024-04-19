# AudioShare

## 项目简介
AudioShare是一款音频流传输应用，它能够实现实时从电脑向手机传输音频流，让用户在电脑缺乏外接扬声器或未带耳机的情况下，依然能通过手机扬声器或耳机播放电脑中的音频内容。

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
   - **Qt SDK**：下载并安装[Qt 6.6 for MSVC2019 64-bit](https://download.qt.io/archive/qt/6.6/)，确保其中包含了Qt Creator IDE。
   - **Windows SDK**：根据项目需求安装相应的Windows SDK版本。
   - **CMake**：下载并安装与项目兼容的[CMake](https://cmake.org/download/)版本。

2. **打开CMake项目**：
   - 在Qt Creator中直接打开项目根目录下的`CMakeLists.txt`文件。
   - Qt Creator将自动检测CMakeLists.txt并配置相应的构建套件（Kit），采用Qt 6.6 MSVC2019 64-bit编译器进行构建。

### 使用Visual Studio 2019

#### 配置步骤：

1. **安装必备组件**：
   - **Visual Studio 2019**：安装Visual Studio 2019，并确保安装了"C++桌面开发"工作负载以及CMake工具支持。
   - **Qt 6.6 for MSVC2019 64-bit**：安装与VS 2019兼容的Qt 6.6 MSVC2019 64-bit版本。
   - **Windows SDK**与**CMake**：按项目需求安装合适的Windows SDK和CMake版本。

2. **生成Visual Studio解决方案**：
   - 在项目根目录下运行`gen_msvs_cmake.bat`批处理脚本，该脚本会自动生成Visual Studio 2019可用的CMake解决方案。

3. **启动开发**：
   - 打开生成的`msvs_cmake`目录内的`AudioShare.sln`解决方案文件。
   - 在Visual Studio 2019中加载项目，即可进行构建、调试和开发工作。

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
