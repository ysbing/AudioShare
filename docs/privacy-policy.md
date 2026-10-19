# AudioShare Privacy Policy

[English](privacy-policy.md) | [简体中文](privacy-policy.zh-CN.md)

Last updated: October 19, 2026

This policy applies to the AudioShare desktop application for Windows and macOS, distributed through the Microsoft Store and through [GitHub Releases](https://github.com/ysbing/AudioShare/releases), including version 2.2.2 and later.

AudioShare streams the audio playing on your computer to an Android device that you connect over ADB (Android Debug Bridge). It is a local tool: there are no user accounts, no advertising, and no analytics, and no data is sent to the developer or to any third party.

## 1. What AudioShare processes

**System audio.** AudioShare captures the audio that is currently playing on your computer (the system playback output — WASAPI loopback on Windows, ScreenCaptureKit on macOS). The captured audio is kept in memory only, streamed to the Android device you connected, and then discarded. It is never recorded to disk, and it is not sent anywhere else. Capture starts when you click **Connect** and stops when you disconnect or quit the application. AudioShare does not access the microphone.

**Information about the connected Android device.** While a device is connected over ADB, AudioShare reads a small set of device properties through the bundled `adb` tool and shows them in the device list: serial number, product model, manufacturer, Android version, and API level. This information is used only to identify and label devices in the app and to remember the device you used last.

**Settings.** AudioShare stores your language choice, the identifier of the last used device (the device serial number, or the `ip:port` address when you use ADB over Wi-Fi), and whether automatic reconnection is enabled.

## 2. Where this information is stored

All of the information above stays on your computer. Nothing is uploaded.

| Data | Windows | macOS |
| --- | --- | --- |
| Settings (`prefs.json`) | `%APPDATA%\ysbing\AudioShare\prefs.json` | `~/Library/Application Support/ysbing/AudioShare/prefs.json` |
| Temporary copies of the bundled `adb` executable and its libraries | `%TEMP%\ysbing\AudioShare\adb\` | not used (files stay in the app bundle) |
| Temporary copy of the Android server binary | `%TEMP%\ysbing\AudioShare\server` | not used (files stay in the app bundle) |

On the Android device, AudioShare copies its server binary to the temporary directory `/data/local/tmp/audioshare` and starts it as a normal process while a session is active. No application is installed on the device, no other files are modified, and no data is read from the device beyond the device properties listed above. The copied file stays in `/data/local/tmp` until you remove it (for example with `adb shell rm /data/local/tmp/audioshare`) or the device is reset.

## 3. What AudioShare does not do

- No account, sign-in, or registration of any kind.
- No collection of names, email addresses, contacts, files, documents, photos, browsing history, keystrokes, or location.
- No microphone access.
- No analytics, telemetry, crash reporting, or advertising SDKs.
- No cloud service or server operated by the developer. AudioShare makes no requests to the internet.
- No access to the content of other applications.

## 4. Network and local connections

- AudioShare communicates with your Android device through ADB: over the USB cable, or over your local network if you have enabled wireless debugging (ADB over Wi-Fi). Audio is streamed to the device through this connection.
- To receive the stream, AudioShare opens a local TCP port on your computer in the range 11794–21794 and configures an ADB reverse tunnel to it. The port is used only for this local session and is reachable from the connected device through ADB.
- If you use ADB over Wi-Fi, traffic between the computer and the device travels over your local network and is not encrypted by the app. Use this option only on a network you trust.
- When you install AudioShare from the Microsoft Store, Microsoft processes information related to the Store itself (for example, download and installation data) under the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement). This is independent of AudioShare.

## 5. Permissions

- **macOS:** AudioShare asks for the **Screen & System Audio Recording** permission, which macOS requires in order to capture system audio. The permission is used only to capture audio playback. No screen images are recorded or transmitted. You can revoke it at any time in **System Settings > Privacy & Security > Screen & System Audio Recording**.
- **Windows:** no special permissions are requested. AudioShare captures the default playback device in shared mode.

## 6. Children's privacy

AudioShare does not collect personal information from anyone, including children. It requires physical access to an Android device with USB debugging enabled and is not directed at children.

## 7. Retention and deletion

- Settings are kept in `prefs.json` until you delete that file or uninstall the application.
- The temporary files listed in section 2 can be deleted at any time, including while the application is closed; they are recreated on the next launch.
- Uninstalling AudioShare does not automatically remove `%TEMP%\ysbing\AudioShare` on Windows or `/data/local/tmp/audioshare` on the connected device. You can delete them manually as described above.

## 8. Changes to this policy

If this policy changes, the updated version will be published at this address with a new "last updated" date. Material changes will also be noted in the [release notes](https://github.com/ysbing/AudioShare/releases).

## 9. Contact

Questions or requests about this policy and about data handled by AudioShare can be sent through the project's issue tracker:

<https://github.com/ysbing/AudioShare/issues>

## 10. Source code

AudioShare is open source software licensed under [LGPL-3.0-or-later](https://github.com/ysbing/AudioShare/blob/main/LICENSE). The complete source code is available at <https://github.com/ysbing/AudioShare>, so the behavior described in this policy can be verified directly.
