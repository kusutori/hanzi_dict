import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'models/theme_provider.dart';
import 'components/theme_selector_dialog.dart';

class CustomTitleBar extends StatelessWidget {
  final String title;

  const CustomTitleBar({super.key, required this.title});

  void _showContextMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () => appWindow.minimize(),
          child: Row(
            children: [
              const Icon(Icons.minimize, size: 16),
              const SizedBox(width: 8),
              const Text('最小化'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => appWindow.maximizeOrRestore(),
          child: Row(
            children: [
              Icon(
                appWindow.isMaximized
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(appWindow.isMaximized ? '还原' : '最大化'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => appWindow.close(),
          child: Row(
            children: [
              const Icon(Icons.close, size: 16),
              const SizedBox(width: 8),
              const Text('关闭'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark =
            themeProvider.themeMode == ThemeMode.dark ||
            (themeProvider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        final backgroundColor =
            isDark
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.primary;

        final foregroundColor =
            isDark
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onPrimary;

        return Container(
          height: 40,
          color: backgroundColor,
          child: Row(
            children: [
              // App icon and title area (draggable)
              Expanded(
                child: Listener(
                  onPointerDown: (event) {
                    // 检查是否是右键点击
                    if (event.buttons == 2) {
                      // 2 表示右键
                      _showContextMenu(context, event.position);
                    }
                  },
                  child: MoveWindow(
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        // App icon
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: foregroundColor.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.book,
                            size: 16,
                            color: foregroundColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title
                        Text(
                          title,
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Control buttons area
              Row(
                children: [
                  // Dark mode toggle button
                  _TitleBarButton(
                    icon: isDark ? Icons.light_mode : Icons.dark_mode,
                    onPressed: () {
                      final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                      themeProvider.setThemeMode(newMode);
                    },
                    tooltip: isDark ? '切换到浅色模式' : '切换到深色模式',
                    foregroundColor: foregroundColor,
                  ),

                  // Theme selector button
                  _TitleBarButton(
                    icon: Icons.palette,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ThemeSelectorDialog();
                        },
                      );
                    },
                    tooltip: '选择主题',
                    foregroundColor: foregroundColor,
                  ), // Window control buttons - 使用原生按钮样式
                  Row(
                    children: [
                      // 使用原生样式的窗口控制按钮
                      MinimizeWindowButton(
                        colors: WindowButtonColors(
                          iconNormal: foregroundColor,
                          mouseOver: foregroundColor.withValues(alpha: 0.1),
                          iconMouseOver: foregroundColor,
                          mouseDown: foregroundColor.withValues(alpha: 0.2),
                          iconMouseDown: foregroundColor,
                        ),
                      ),
                      MaximizeWindowButton(
                        colors: WindowButtonColors(
                          iconNormal: foregroundColor,
                          mouseOver: foregroundColor.withValues(alpha: 0.1),
                          iconMouseOver: foregroundColor,
                          mouseDown: foregroundColor.withValues(alpha: 0.2),
                          iconMouseDown: foregroundColor,
                        ),
                      ),
                      CloseWindowButton(
                        colors: WindowButtonColors(
                          iconNormal: foregroundColor,
                          mouseOver: Colors.red,
                          iconMouseOver: Colors.white,
                          mouseDown: Colors.red.shade700,
                          iconMouseDown: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TitleBarButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color foregroundColor;

  const _TitleBarButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.foregroundColor,
  });

  @override
  State<_TitleBarButton> createState() => _TitleBarButtonState();
}

class _TitleBarButtonState extends State<_TitleBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 46,
            height: 40,
            decoration: BoxDecoration(
              color:
                  _isHovered
                      ? widget.foregroundColor.withValues(alpha: 0.1)
                      : Colors.transparent,
            ),
            child: Icon(widget.icon, size: 16, color: widget.foregroundColor),
          ),
        ),
      ),
    );
  }
}
