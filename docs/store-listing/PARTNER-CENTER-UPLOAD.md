# 交接提示词：把 AudioShare 2.3.0 发布到微软商店

> 这段话是给接手的 AI 助手或同事看的，直接整段复制粘贴即可。下面是任务的全部内容。

---

## 任务

把 AudioShare 2.3.0 更新包上传到微软商店的 Partner Center，并把商店列表文案扩充到全部 28 个语言。
**最后一步"提交以进行认证"的按钮必须留给我（用户）自己点，不要代劳。**

## 项目背景

AudioShare 是一个 Flutter 桌面应用，把 Windows / macOS 的系统音频通过 ADB（USB 或 Wi-Fi）传到安卓手机。
仓库在 `D:\AudioShare`，GitHub 是 `ysbing/AudioShare`，主分支 `main`。
Partner Center 产品页：<https://partner.microsoft.com/zh-cn/dashboard/products/9MX0W331FVWF/overview>

## 已经做完的部分（不用重做）

**1. 版本号与代码**

- `client/pubspec.yaml` 里版本已经是 `2.3.0+1`
- 已提交并推送：`19e5b10 Release v2.3.0`、`ebe5d9f Round scaled dimensions to whole pixels`、`c46ddc6 Add the Microsoft Store listing copy for every shipped language`
- CI 绿灯，Windows 和 macOS 两个产物都出了

**2. MSIX 包已构建并校验完毕**

文件在 `dist/audioshare-2.3.0.msix`（20.6 MB）。

| 项 | 值 |
| --- | --- |
| 包版本 | `2.3.0.0`（必须高于已提交的 2.2.2.0，Partner Center 靠这个判断新旧） |
| Identity Name | `ysbing.AudioShare` |
| Publisher | `CN=928CDDD4-FB48-4610-8DFF-FD7332ABEB2F` |
| 架构 | x64 |
| 资源语言 | 28 个 `<Resource Language="...">`，已写进 AppxManifest.xml |
| 运行时文件 | `audioshare.exe`、`audio_capture.dll`、`adb.exe`、`AdbWinApi.dll`、`AdbWinUsbApi.dll`、`server` 全部在包里 |

**包故意不签名** —— 商店在认证阶段自己签，这是正常的，不要去签它。

如果要重新构建：

```powershell
cd D:\AudioShare
powershell -ExecutionPolicy Bypass -File tools/package_store.ps1
```

这个脚本会构建、跑 `msix:create`、然后校验包的身份和必需文件是否齐全。

**3. 商店列表文案已写好**

`docs/store-listing/` 下每个语言一个文件，文件名就是 Partner Center 用的 locale：

```
en-us.md  zh-cn.md  zh-tw.md  es-es.md  pt-br.md  ru-ru.md  ja-jp.md
ko-kr.md  de-de.md  fr-fr.md  it-it.md  hi-in.md  ar-sa.md  tr-tr.md
vi-vn.md  id-id.md  pl-pl.md  th-th.md  nl-nl.md  sv-se.md  cs-cz.md
he-il.md  uk-ua.md  ro-ro.md  el-gr.md  hu-hu.md  da-dk.md  fi-fi.md
```

每个文件里有三段，对应商店列表表单的三个字段：

- **Display name**（显示名称，上限 50 字符）—— 所有语言都是 `AudioShare`
- **Description**（描述，上限 3000 字符）—— 约 1100 字符，含快速上手、功能要点、运行要求、28 种语言说明
- **What's new**（更新说明，上限 3000 字符）—— 2.3.0 的三条

这 28 个 locale 和 MSIX 包里的资源语言表**逐项一致**（已用 diff 校验过）。

**4. 商店营销截图**

`docs/store-shots/` 下现成四张 1920×1080：

```
en-01-connect.png   en-02-playing.png
zh-01-connect.png   zh-02-playing.png
```

## 还要做的

### 第一步：上传包

1. 打开 <https://partner.microsoft.com/zh-cn/dashboard/products/9MX0W331FVWF/overview>
2. 进 **包**（Packages）页面 → **上传新的包**（Upload a new package）
3. 传 `dist/audioshare-2.3.0.msix`
4. 等它校验完，变成"待发布"状态
5. 如果报身份不匹配，包里的 `Identity` 必须和产品页 **Identity** 页完全一致 —— 现在的值是 `ysbing.AudioShare` / `CN=928CDDD4-FB48-4610-8DFF-FD7332ABEB2F`

### 第二步：填商店列表

1. 进 **商店列表**（Store listing）页面
2. 每个语言：先在 **添加语言**（Add language）里选 locale，然后从 `docs/store-listing/<locale>.md` 里把三段内容分别粘进对应字段
3. **截图**：拉丁字母系语言用 `en-01-connect.png` + `en-02-playing.png`；`zh-cn` 和 `zh-tw` 用 `zh-01-connect.png` + `zh-02-playing.png`。图上的说明文字是烧进图片里的英文/中文，其他语言沿用英文那两张是可接受的
4. **隐私政策 URL 不要动**。现在的地址已经覆盖"2.2.2 及后续版本"，2.3.0 自动包含在内

### 第三步：停在这里

**不要点"提交以进行认证"**（Submit for certification）。这一步留给用户。

## 注意事项

- **列表文案是 AI 写的**，和 App 里的 28 语言翻译一样，没有母语者校对过。内容与代码一致，但上线前最好让母语者过一遍
- **GitHub 那边先别动**。用户明确说了"先别管 github"，所以**不要**打 v2.3.0 标签、**不要**创建 GitHub Release。仓库历史虽然全是直推 main 的，但这轮先按用户说的办
- 如果要提交代码，按仓库现有的风格来：短标题 + 说明"为什么这么做"的两三段正文。仓库惯例是直推 main
- 商店截图没有重新拍。界面相比 2.2.2 只差 1px 字号（`.w`/`.h` 改成整像素之后），在营销图上看不出来；重拍的话设备型号会从截图里的 Samsung SM-A5360 变成实际连接的 OPPO PEDM30，属于无谓的素材变动
- **浏览器工具如果调不动**（曾出现过 `auto mode cannot determine the safety` 的分类器故障），那就只有人能点 —— 把上面的步骤交给用户，别卡在那儿

## 完成后的自检

- 包在 **包** 页面显示为 2.3.0.0，状态是"待发布"（pending），没有校验错误
- 商店列表里能看到新描述，且 28 个语言都加上了
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
