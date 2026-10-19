# AudioShare 隐私策略

[English](privacy-policy.md) | [简体中文](privacy-policy.zh-CN.md)

最后更新：2026 年 10 月 19 日

本策略适用于通过微软商店（Microsoft Store）和 [GitHub Releases](https://github.com/ysbing/AudioShare/releases) 分发的 AudioShare Windows / macOS 桌面应用，包括 2.2.2 及后续版本。

AudioShare 把你电脑上正在播放的声音通过 ADB（Android 调试桥）投送到你连接的安卓设备上。这是一个纯本地工具：没有账号体系、没有广告、没有统计分析，也没有任何数据发送给开发者或第三方。

## 一、AudioShare 处理哪些信息

**系统音频。** AudioShare 捕获你电脑当前播放的系统声音（Windows 上是 WASAPI 环回，macOS 上是 ScreenCaptureKit）。捕获到的音频只存在于内存中，被投送到你连接的安卓设备后即被丢弃：不会写入磁盘，也不会发送到别处。捕获在你点击“连接”时开始，在断开或退出应用时停止。AudioShare 不会访问麦克风。

**已连接安卓设备的信息。** 设备通过 ADB 连接期间，AudioShare 会调用自带的 `adb` 读取少量设备属性并显示在设备列表中：序列号、产品型号、厂商、Android 版本、API 级别。这些信息仅用于在应用内标识设备，以及记住你上次使用的设备。

**设置项。** AudioShare 会保存你的语言选择、上次使用的设备标识（USB 连接时为设备序列号，Wi-Fi 调试时为 `ip:端口`），以及是否开启自动重连。

## 二、这些信息保存在哪里

以上所有信息都只保存在你自己的电脑上，不会上传。

| 数据 | Windows | macOS |
| --- | --- | --- |
| 设置（`prefs.json`） | `%APPDATA%\ysbing\AudioShare\prefs.json` | `~/Library/Application Support/ysbing/AudioShare/prefs.json` |
| 自带 `adb` 及其库的临时副本 | `%TEMP%\ysbing\AudioShare\adb\` | 不使用（文件保留在应用包内） |
| 安卓端服务端程序的临时副本 | `%TEMP%\ysbing\AudioShare\server` | 不使用（文件保留在应用包内） |

在安卓设备上，AudioShare 会把服务端程序复制到设备的临时目录 `/data/local/tmp/audioshare`，并在会话期间以普通进程启动它。手机上不会安装任何应用，不会修改其他文件，除上面列出的设备属性外也不会读取设备上的其他数据。该文件会一直保留在 `/data/local/tmp` 中，直到你手动删除（例如执行 `adb shell rm /data/local/tmp/audioshare`）或设备被重置。

## 三、AudioShare 不会做的事

- 没有账号、登录或任何形式的注册。
- 不收集姓名、邮箱、通讯录、文件、文档、照片、浏览记录、键盘输入或位置信息。
- 不访问麦克风。
- 没有统计分析、遥测、崩溃上报或广告 SDK。
- 没有开发者运营的云端服务或服务器，AudioShare 不会产生任何互联网请求。
- 不读取其他应用的内容。

## 四、网络与本地连接

- AudioShare 通过 ADB 与你的安卓设备通信：走 USB 数据线，或者在你开启无线调试（Wi-Fi ADB）时走局域网。音频就是通过这条连接投送到设备的。
- 为了接收音频流，AudioShare 会在你电脑上打开 11794–21794 范围内的一个本地 TCP 端口，并通过 ADB 反向隧道把它映射给设备。该端口仅用于本次本地会话，只能通过 ADB 从已连接的设备访问。
- 如果你使用 Wi-Fi ADB，电脑与设备之间的流量会在局域网中传输，应用不对其加密。请只在可信网络下使用该方式。
- 从微软商店安装 AudioShare 时，微软会就其商店本身处理相关信息（例如下载与安装数据），适用 [Microsoft 隐私声明](https://privacy.microsoft.com/privacystatement)。这与 AudioShare 本身无关。

## 五、系统权限

- **macOS：** AudioShare 会申请**屏幕与系统音频录制**权限，这是 macOS 捕获系统音频所必需的。该权限仅用于捕获播放中的音频，不会录制或传输任何屏幕画面。你随时可以在「系统设置 > 隐私与安全性 > 屏幕与系统音频录制」中撤销。
- **Windows：** 不需要任何特殊权限。AudioShare 以共享模式捕获默认播放设备。

## 六、儿童隐私

AudioShare 不收集任何人的个人信息，包括儿童。该应用需要接触启用了 USB 调试的安卓设备，并非面向儿童。

## 七、保留与删除

- 设置项会一直保存在 `prefs.json` 中，直到你删除该文件或卸载应用。
- 第二节列出的临时文件可随时删除（应用关闭时也可以），下次启动时会重新生成。
- 卸载 AudioShare 不会自动删除 Windows 上的 `%TEMP%\ysbing\AudioShare`，也不会删除已连接设备上的 `/data/local/tmp/audioshare`，你可以按上面的方法手动删除。

## 八、策略变更

如果本策略有变更，更新后的版本会在本地址发布，并更新“最后更新”日期。重要变更还会在[发行说明](https://github.com/ysbing/AudioShare/releases)中注明。

## 九、联系方式

关于本策略以及 AudioShare 所处理数据的问题或请求，可以通过项目的问题反馈区提出：

<https://github.com/ysbing/AudioShare/issues>

## 十、源代码

AudioShare 是以 [LGPL-3.0-or-later](https://github.com/ysbing/AudioShare/blob/main/LICENSE) 许可发布的开源软件，完整源代码位于 <https://github.com/ysbing/AudioShare>，本策略描述的行为都可以直接对照代码核实。
