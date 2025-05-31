import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'components/hanzi_card.dart';
// import 'models/mcp_dict.dart';
import 'models/favorites_provider.dart';
import 'models/theme_provider.dart';
import 'l10n/app_localizations.dart';
import 'components/theme_selector_dialog.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final isMobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    // 构建主题按钮列表
    final List<Widget> themeActions =
        isMobile
            ? [
              // 暗模式切换按钮
              IconButton(
                icon: Icon(
                  themeProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : themeProvider.themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.brightness_auto,
                ),
                onPressed: () {
                  // 循环切换主题模式
                  final currentMode = themeProvider.themeMode;
                  if (currentMode == ThemeMode.light) {
                    themeProvider.setThemeMode(ThemeMode.dark);
                  } else if (currentMode == ThemeMode.dark) {
                    themeProvider.setThemeMode(ThemeMode.system);
                  } else {
                    themeProvider.setThemeMode(ThemeMode.light);
                  }
                },
                tooltip:
                    themeProvider.themeMode == ThemeMode.dark
                        ? '深色模式'
                        : themeProvider.themeMode == ThemeMode.light
                        ? '浅色模式'
                        : '跟随系统',
              ),
              // 主题选择器按钮
              IconButton(
                icon: const Icon(Icons.palette),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ThemeSelectorDialog(),
                  );
                },
                tooltip: '主题颜色',
              ),
            ]
            : [];

    // 合并所有actions
    final List<Widget> allActions = [
      ...themeActions,
      if (favoritesProvider.favorites.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: Text(
              localizations.favoritesCount(favoritesProvider.favoritesCount),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.favorites),
        actions: allActions.isNotEmpty ? allActions : null,
      ),
      body:
          !favoritesProvider.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : favoritesProvider.favorites.isEmpty
              ? Center(child: Text(localizations.noFavoritesYet))
              : ListView.builder(
                itemCount: favoritesProvider.favorites.length,
                itemBuilder: (context, index) {
                  return HanziCard(item: favoritesProvider.favorites[index]);
                },
              ),
    );
  }
}
