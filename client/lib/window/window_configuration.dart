import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// The app is a fixed-size panel: the window always stays at the design
/// size — no resize edges, no maximize (see configureDesktopWindow, and
/// MainFlutterWindow.swift on macOS). The interface scales automatically on
/// displays where the physical pixel ratio is not 1.0.
const Size kDesktopInitialWindowSize = Size(360, 540);

const double kTitleBarHeight = 44;
const double kCaptionButtonWidth = 46;
const double kCaptionButtonHeight = kTitleBarHeight;

/// Prepares the handheld-sized desktop window before anything is drawn.
///
/// Both runners show the window on Flutter's first frame, so applying the
/// borderless options here — right before runApp — means the user never
/// catches the native system title bar mid-transition.
///
/// Windows hides the system title bar entirely and draws its own caption row
/// (see window/window_chrome.dart). macOS also hides the title bar but keeps
/// the native traffic lights, inset as a leading empty zone in the caption
/// row.
///
/// The window is fixed size on both platforms: on macOS MainFlutterWindow
/// .swift removes .resizable from the style mask (which also disables the
/// zoom button); on Windows the styles are dropped below so the window
/// cannot be stretched, snapped, or maximized.
Future<void> configureDesktopWindow() async {
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    return;
  }

  await windowManager.ensureInitialized();
  if (Platform.isMacOS) {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: true,
    );
    return;
  }

  final windowOptions = WindowOptions(
    title: 'AudioShare',
    size: kDesktopInitialWindowSize,
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: Platform.isWindows ? false : null,
    backgroundColor: Platform.isWindows ? Colors.transparent : null,
  );

  if (Platform.isWindows) {
    // The runner shows the window after Flutter's first frame, so no show()
    // callback is needed — applying the options alone is enough.
    await windowManager.waitUntilReadyToShow(windowOptions);
    // Fixed size: drop the resize frame and the maximize box so neither
    // drag-resize nor window snapping (drag to edges, Win+arrow) can change
    // the window's size. Minimize stays available.
    await windowManager.setResizable(false);
    await windowManager.setMaximizable(false);
    return;
  }

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
