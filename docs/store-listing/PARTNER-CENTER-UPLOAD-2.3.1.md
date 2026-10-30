# 交接提示词：把 AudioShare 2.3.1 发布到微软商店

> 这段话是给接手的 AI 助手或同事看的，直接整段复制粘贴即可。2.3.0 的版本在旁边：`PARTNER-CENTER-UPLOAD.md`。

---

## 任务

把 AudioShare 2.3.1 更新包上传到微软商店的 Partner Center（包必须上传，What's new 可选更新）。
**最后一步"提交以进行认证"的按钮必须留给我（用户）自己点，不要代劳。**

## 项目背景

AudioShare 是一个 Flutter 桌面应用，把 Windows / macOS 的系统音频通过 ADB（USB 或 Wi-Fi）传到安卓手机。
仓库在 `D:\AudioShare`，GitHub 是 `ysbing/AudioShare`，主分支 `main`。
Partner Center 产品页：<https://partner.microsoft.com/zh-cn/dashboard/products/9MX0W331FVWF/overview>

## 已经做完的部分（不用重做）

**1. 版本号与代码**

- `client/pubspec.yaml` 版本是 `2.3.1+1`（MSIX 包版本会是 `2.3.1.0`，高于已提交的 2.3.0.0 和 2.2.2.0，Partner Center 按这个判断新旧）
- 已提交并推送到 origin/main：`98f5e95 Release v2.3.1`（67 个文件）
- 2.3.1 的内容：无边框窗口改由应用自绘标题栏（应用图标、标题、语言切换按钮、内置最小化/关闭按钮，28 语言的 tooltip）；窗口固定 360×540——不可拉伸、无最大化（含双击、Win+方向键贴边等一切途径）；修掉启动时的 zone mismatch；标题栏图标清晰度优化
- GitHub 方面沿用 2.3.0 的做法：**没打标签、没建 Release**，直推 main

**2. MSIX 包已构建并校验完毕**

文件在 `dist/audioshare-2.3.1.msix`（20.8 MB，21,766,046 字节）。

| 项 | 值 |
| --- | --- |
| 包版本 | `2.3.1.0` |
| Identity Name | `ysbing.AudioShare` |
| Publisher | `CN=928CDDD4-FB48-4610-8DFF-FD7336ABEB2F` |
| 架构 | x64 |
| 资源语言 | 28 个 `<Resource Language="...">`，已写进 AppxManifest.xml |
| SHA256 | `1A03FEE9FD7AD9A11A1E3DB47BD5DBA632EED8716D78158CD1144D8ED5A13575`（与 `client/build/windows/x64/runner/Release/audioshare.msix` 同哈希，dist 是它的拷贝） |
| 运行时文件 | `audioshare.exe`、`flutter_windows.dll`、`audio_capture.dll`、`window_manager_plugin.dll`、`screen_retriever_windows_plugin.dll`、`adb.exe`、`AdbWinApi.dll`、`AdbWinUsbApi.dll`、`server` 全部在包里，另有包配套的 VC 运行时（msvcp140/vcruntime140 等） |

**包故意不签名** —— 商店在认证阶段自己签，这是正常的，不要去签它。

> 校验脚本的一个坑，别再踩：插件 DLL 的实际文件名是 **`window_manager_plugin.dll`**。
> 前一轮校验误写成 `window_manager.dll`，得到"包里缺 DLL"的错误结论，白白怀疑了一轮打包流程。
> 校验时要么用准确文件名，要么对照包内全部条目清单（`System.IO.Compression.ZipFile::OpenRead`）。

如果要重新构建：

```powershell
cd D:\AudioShare
powershell -ExecutionPolicy Bypass -File tools/package_store.ps1
```

这个脚本会构建、跑 `msix:create`、然后校验包的身份和必需文件是否齐全。构建完记得把产物拷到 `dist\audioshare-2.3.1.msix`。

**3. 商店列表文案**

沿用 2.3.0 的提交：5 个语言（`en-us`、`zh-cn`、`fr-fr`、`ja-jp`、`es-es`），描述、截图、隐私政策均已就位，**本轮不需要改动**。`docs/store-listing/<locale>.md` 里的 What's new 还是 2.3.0 的内容，若要更新见下面的草稿。

## 还要做的

### 第一步：上传包

1. 打开 <https://partner.microsoft.com/zh-cn/dashboard/products/9MX0W331FVWF/overview>
2. 进 **包**（Packages）页面 → **上传新的包**（Upload a new package）
3. 传 `dist\audioshare-2.3.1.msix`
4. 等它校验完，变成"待发布"（pending）状态
5. 如果报身份不匹配，包里的 `Identity` 必须和产品页 **Identity** 页完全一致 —— 现在的值是 `ysbing.AudioShare` / `CN=928CDDD4-FB48-4610-8DFF-FD7336ABEB2F`

旧的 2.3.0.0 包留在列表里没有问题（商店按最高版本分发给用户），不必删除。

### 第二步（可选）：更新各语言的 What's new

在现有 5 个语言的商店列表里把"更新说明 / What's new"替换为：

**zh-cn**

```
• 窗口全面重做：无边框设计，标题栏由应用绘制，带有应用图标、语言切换按钮和最小化、关闭按钮。
• 窗口大小固定：去掉拉伸边缘和最大化，界面在任意屏幕缩放下保持一致。
• 修复启动初期的报错。
```

**en-us**

```
• The window is now drawn by the app itself: a borderless title bar carrying the app icon, the language switcher and built-in minimize and close buttons.
• The window now has a fixed size: no more drag-to-resize edges or maximize. The layout stays consistent at any display scaling.
• Fixed an error that could appear right after startup.
```

`fr-fr`、`ja-jp`、`es-es` 可以沿用上面的英文（与截图的做法一致，可接受），不改也不算错误。

### 第三步：停在这里

**不要点"提交以进行认证"**（Submit for certification）。这一步留给用户。

## 注意事项

- **列表文案是 AI 写的**，没有母语者校对过，上线前最好过一遍
- **GitHub 那边先别动**：不打 v2.3.1 标签、不建 Release，沿用上一轮用户的要求
- 提交代码按仓库风格：短英文标题 + 说明"为什么"的正文，直推 main
- 2.3.1 说"界面布局随窗口缩放"的那条 What's new（2.3.0 写的）与本版固定尺寸不冲突——布局仍是随当前窗口缩放的，只是窗口本身不再可调整大小
- 浏览器自动化工具如果不可用（此前会话出现过），Partner Center 的点击操作只能由用户完成，把步骤照抄给用户即可

## 完成后的自检

- 包在 **包** 页面显示为 2.3.1.0，状态"待发布"，没有校验错误
- （可选）5 个语言的 What's new 都显示 2.3.1 的更新说明
- **没有**点提交认证

## 如果需要重跑 App 验证

```bash
cd D:\AudioShare/client
flutter pub get
flutter gen-l10n
flutter analyze --no-fatal-infos
flutter test
```

`flutter test` 有 17 个测试，覆盖翻译完整性、locale 解析（含简繁分支）、28 个语言逐一渲染、RTL 方向、语言对话框搜索。
