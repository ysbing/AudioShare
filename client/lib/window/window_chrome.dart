import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../l10n/generated/app_localizations.dart';
import 'window_configuration.dart';

/// The app-side window chrome for borderless desktop windows.
///
/// The runner hides the system title bar (see window_configuration.dart), so
/// this wraps the app to restore what the borderless look removed: rounded
/// corners and a hairline border while the window floats — once maximized the
/// OS provides straight full-screen edges, so both disappear.
///
/// On macOS the OS keeps its own rounded window and traffic lights, so the
/// frame is a pass-through there.
class DesktopWindowFrame extends StatefulWidget {
  const DesktopWindowFrame({super.key, required this.child});

  final Widget child;

  @override
  State<DesktopWindowFrame> createState() => _DesktopWindowFrameState();
}

class _DesktopWindowFrameState extends State<DesktopWindowFrame>
    with WindowListener {
  /// macOS keeps the native chrome; AudioShare ships no Linux runner.
  static final bool _applies = Platform.isWindows;

  bool _isMaximized = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    if (!_applies) {
      return;
    }
    windowManager.addListener(this);
    unawaited(_loadWindowState());
  }

  @override
  void dispose() {
    if (_applies) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  Future<void> _loadWindowState() async {
    final isMaximized = await windowManager.isMaximized();
    final isFullScreen = await windowManager.isFullScreen();
    if (!mounted) {
      return;
    }
    setState(() {
      _isMaximized = isMaximized;
      _isFullScreen = isFullScreen;
    });
  }

  @override
  void onWindowMaximize() {
    if (mounted) {
      setState(() => _isMaximized = true);
    }
  }

  @override
  void onWindowUnmaximize() {
    if (mounted) {
      setState(() => _isMaximized = false);
    }
  }

  @override
  void onWindowEnterFullScreen() {
    if (mounted) {
      setState(() => _isFullScreen = true);
    }
  }

  @override
  void onWindowLeaveFullScreen() {
    if (mounted) {
      setState(() => _isFullScreen = false);
    }
  }

  @override
  void onWindowRestore() {
    if (!_applies) {
      return;
    }
    unawaited(_loadWindowState());
  }

  @override
  Widget build(BuildContext context) {
    if (!_applies) {
      return widget.child;
    }

    final framed = !_isMaximized && !_isFullScreen;
    final borderRadius = BorderRadius.circular(framed ? 8 : 0);
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.10)
        : const Color(0xFFD8DEE6);

    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: borderRadius,
          border: framed ? Border.all(color: borderColor) : null,
        ),
        child: widget.child,
      ),
    );
  }
}

/// The custom caption row, sized to slot straight into `Scaffold.appBar`.
///
/// Holds the app logo and title, a button opening the language dialog,
/// and — on Windows — the built-in minimize/close buttons. The middle is a
/// drag-to-move area, matching what the system title bar used to offer.
class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({super.key, required this.onLanguagePressed});

  final VoidCallback onLanguagePressed;

  @override
  Size get preferredSize => const Size.fromHeight(kTitleBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );

    final content = Row(
      children: [
        // macOS keeps its traffic lights at the top left; the whole lead-in
        // (inset + logo) clears that zone on both platforms.
        SizedBox(width: Platform.isMacOS ? 78 : 14),
        const AppLogoMark(),
        const SizedBox(width: 10),
        Text(AppLocalizations.of(context).appTitle, style: titleStyle),
        Expanded(
          child: Platform.isWindows
              ? const WindowDragArea(child: SizedBox.expand())
              : const SizedBox.shrink(),
        ),
        TitleIconButton(
          tooltip: AppLocalizations.of(context).language,
          icon: Icons.language,
          onPressed: onLanguagePressed,
        ),
        if (Platform.isWindows)
          const CaptionButtons()
        else
          const SizedBox(width: 12),
      ],
    );

    return Material(
      color: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
      child: SizedBox(height: kTitleBarHeight, child: content),
    );
  }
}

/// Starts a native window drag on pan.
///
/// The package's DragToMoveArea also toggles maximize on double-click; the
/// window is fixed size, so this widget offers the drag alone.
class WindowDragArea extends StatelessWidget {
  const WindowDragArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) {
        unawaited(windowManager.startDragging());
      },
      child: child,
    );
  }
}

/// Same source as the desktop icon (tools/generate_icons.py output: rounded
/// corners, transparent corners), so the title bar mark reads as the app
/// icon.
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key});

  /// Generated by tools/generate_icons.py into the macOS AppIcon set; a copy
  /// lives under assets/images so both platforms share one Flutter asset.
  static const String assetPath = 'assets/images/app_logo.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: 22,
      height: 22,
      filterQuality: FilterQuality.medium,
    );
  }
}

/// A small icon button matching the title bar's compact look.
class TitleIconButton extends StatefulWidget {
  const TitleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<TitleIconButton> createState() => _TitleIconButtonState();
}

class _TitleIconButtonState extends State<TitleIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onSurface;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          width: 34,
          height: 26,
          margin: const EdgeInsets.only(right: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hovered
                ? iconColor.withValues(alpha: 0.07)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Tooltip(
            message: widget.tooltip,
            // 18 in a 34x26 box centers the glyph on whole pixel offsets
            // ((34-18)/2, (26-18)/2); an odd size would land on half pixels
            // and blur the thin strokes.
            child: Icon(
              widget.icon,
              size: 18,
              color: iconColor.withValues(alpha: _hovered ? 0.92 : 0.72),
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimize / close, mirroring the native caption buttons' hover and
/// pressed states. The maximize toggle lives only on the title bar's
/// double-click (DragToMoveArea), so there is no dedicated button for it.
class CaptionButtons extends StatelessWidget {
  const CaptionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CaptionButton(
          tooltip: l10n.winMinimize,
          icon: Icons.remove_rounded,
          onPressed: () {
            unawaited(windowManager.minimize());
          },
        ),
        CaptionButton(
          tooltip: l10n.winClose,
          icon: Icons.close_rounded,
          isClose: true,
          onPressed: () {
            unawaited(windowManager.close());
          },
        ),
      ],
    );
  }
}

class CaptionButton extends StatefulWidget {
  const CaptionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip = '',
    this.isClose = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final bool isClose;

  @override
  State<CaptionButton> createState() => _CaptionButtonState();
}

class _CaptionButtonState extends State<CaptionButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultIconColor = isDark
        ? Colors.white.withValues(alpha: 0.88)
        : Colors.black.withValues(alpha: 0.78);
    final standardHoverFill = isDark
        ? Colors.white.withValues(alpha: 0.09)
        : Colors.black.withValues(alpha: 0.055);
    final standardPressedFill = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.10);

    Color fill = Colors.transparent;
    Color iconColor = defaultIconColor;
    if (_hovered) {
      fill = widget.isClose ? const Color(0xFFE81123) : standardHoverFill;
      iconColor = widget.isClose ? Colors.white : defaultIconColor;
    }
    if (_pressed) {
      fill = widget.isClose ? const Color(0xFFF1707A) : standardPressedFill;
      iconColor = widget.isClose
          ? Colors.white.withValues(alpha: 0.92)
          : defaultIconColor.withValues(alpha: 0.74);
    }

    final button = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          width: kCaptionButtonWidth,
          height: kCaptionButtonHeight,
          color: fill,
          alignment: Alignment.center,
          child: Icon(widget.icon, size: 16, color: iconColor),
        ),
      ),
    );

    if (widget.tooltip.isEmpty) {
      return button;
    }
    return Tooltip(message: widget.tooltip, child: button);
  }
}
