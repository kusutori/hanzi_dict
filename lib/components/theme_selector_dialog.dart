import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart';

class ThemeSelectorDialog extends StatelessWidget {
  const ThemeSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AlertDialog(
          title: const Text('选择主题颜色'),
          content: SizedBox(
            width: 320,
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 主题模式选择
                const Text(
                  '主题模式',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ThemeModeOption(
                        mode: ThemeMode.light,
                        currentMode: themeProvider.themeMode,
                        onSelected: (mode) => themeProvider.setThemeMode(mode),
                        icon: Icons.light_mode,
                        label: '浅色',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ThemeModeOption(
                        mode: ThemeMode.dark,
                        currentMode: themeProvider.themeMode,
                        onSelected: (mode) => themeProvider.setThemeMode(mode),
                        icon: Icons.dark_mode,
                        label: '深色',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ThemeModeOption(
                        mode: ThemeMode.system,
                        currentMode: themeProvider.themeMode,
                        onSelected: (mode) => themeProvider.setThemeMode(mode),
                        icon: Icons.brightness_auto,
                        label: '系统',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 颜色选择
                const Text(
                  '主题颜色',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                    itemCount: ThemeProvider.availableColors.length,
                    itemBuilder: (context, index) {
                      final color = ThemeProvider.availableColors[index];
                      final isSelected =
                          themeProvider.selectedColorIndex == index;
                      final isDark =
                          themeProvider.themeMode == ThemeMode.dark ||
                          (themeProvider.themeMode == ThemeMode.system &&
                              MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark);

                      return _ColorOption(
                        color: color,
                        isDark: isDark,
                        isSelected: isSelected,
                        onTap: () => themeProvider.setSelectedColor(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  final ThemeMode mode;
  final ThemeMode currentMode;
  final Function(ThemeMode) onSelected;
  final IconData icon;
  final String label;

  const _ThemeModeOption({
    required this.mode,
    required this.currentMode,
    required this.onSelected,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == currentMode;

    return InkWell(
      onTap: () => onSelected(mode),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final CatppuccinColor color;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = isDark ? color.dark : color.light;

    return Tooltip(
      message: _getColorDisplayName(color.name),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorValue,
            border: Border.all(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.transparent,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:
              isSelected
                  ? Icon(
                    Icons.check,
                    color: _getContrastColor(colorValue),
                    size: 20,
                  )
                  : null,
        ),
      ),
    );
  }

  String _getColorDisplayName(String name) {
    const nameMap = {
      'rosewater': '玫瑰水',
      'flamingo': '火烈鸟',
      'pink': '粉色',
      'mauve': '淡紫',
      'red': '红色',
      'maroon': '栗色',
      'peach': '桃色',
      'yellow': '黄色',
      'green': '绿色',
      'teal': '青色',
      'sky': '天空蓝',
      'sapphire': '蓝宝石',
      'blue': '蓝色',
      'lavender': '薰衣草',
    };
    return nameMap[name] ?? name;
  }

  Color _getContrastColor(Color background) {
    // 计算亮度以确定使用白色还是黑色图标
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
