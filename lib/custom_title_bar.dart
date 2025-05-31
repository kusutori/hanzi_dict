import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'models/theme_provider.dart';

class CustomTitleBar extends StatelessWidget {
  final String title;

  const CustomTitleBar({super.key, required this.title});

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
                          color: foregroundColor.withOpacity(0.2),
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

                  // Theme selector button (placeholder for future implementation)
                  _TitleBarButton(
                    icon: Icons.palette,
                    onPressed: () {
                      // TODO: Implement theme selector dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('主题选择功能即将推出')),
                      );
                    },
                    tooltip: '选择主题',
                    foregroundColor: foregroundColor,
                  ),

                  // Window control buttons
                  _WindowControlButton(
                    icon: Icons.minimize,
                    onPressed: () => appWindow.minimize(),
                    foregroundColor: foregroundColor,
                  ),
                  _WindowControlButton(
                    icon: Icons.crop_square,
                    onPressed: () => appWindow.maximizeOrRestore(),
                    foregroundColor: foregroundColor,
                  ),
                  _WindowControlButton(
                    icon: Icons.close,
                    onPressed: () => appWindow.close(),
                    foregroundColor: foregroundColor,
                    isClose: true,
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
                      ? widget.foregroundColor.withOpacity(0.1)
                      : Colors.transparent,
            ),
            child: Icon(widget.icon, size: 16, color: widget.foregroundColor),
          ),
        ),
      ),
    );
  }
}

class _WindowControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color foregroundColor;
  final bool isClose;

  const _WindowControlButton({
    required this.icon,
    required this.onPressed,
    required this.foregroundColor,
    this.isClose = false,
  });

  @override
  State<_WindowControlButton> createState() => _WindowControlButtonState();
}

class _WindowControlButtonState extends State<_WindowControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
                    ? (widget.isClose
                        ? Colors.red
                        : widget.foregroundColor.withOpacity(0.1))
                    : Colors.transparent,
          ),
          child: Icon(
            widget.icon,
            size: 16,
            color:
                _isHovered && widget.isClose
                    ? Colors.white
                    : widget.foregroundColor,
          ),
        ),
      ),
    );
  }
}
