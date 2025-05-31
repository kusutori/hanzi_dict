import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'models/language_provider.dart';
import 'models/favorites_provider.dart';
import 'models/theme_provider.dart';
import 'l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _currentStorageLocation;

  @override
  void initState() {
    super.initState();
    _loadStorageLocation();
  }

  Future<void> _loadStorageLocation() async {
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    final location = await favoritesProvider.getCurrentStorageLocation();
    setState(() {
      _currentStorageLocation = location;
    });
  }

  Future<void> _selectStorageLocation() async {
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Custom storage location not supported on web platform',
            ),
          ),
        );
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null && mounted) {
      final favoritesProvider = Provider.of<FavoritesProvider>(
        context,
        listen: false,
      );
      await favoritesProvider.setCustomStorageLocation(result);
      setState(() {
        _currentStorageLocation = result;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage location updated to: $result')),
        );
      }
    }
  }

  Future<void> _exportFavorites() async {
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export not supported on web platform')),
        );
      }
      return;
    }

    final localizations = AppLocalizations.of(context)!;
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );

    try {
      // Get favorites data
      final favorites = favoritesProvider.favorites;

      // Create export data with metadata
      final exportData = {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'count': favorites.length,
        'favorites': favorites.map((item) => item.toJson()).toList(),
      };

      // Convert to JSON string
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      final bytes = utf8.encode(jsonString);

      // Use platform-specific file saving approach
      String? result;
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        // For mobile platforms, use saveFile with bytes
        result = await FilePicker.platform.saveFile(
          dialogTitle: localizations.exportFavorites,
          fileName:
              'hanzi_favorites_${DateTime.now().millisecondsSinceEpoch}.json',
          type: FileType.custom,
          allowedExtensions: ['json'],
          bytes: Uint8List.fromList(bytes),
        );
      } else {
        // For desktop platforms, use saveFile without bytes and write file manually
        result = await FilePicker.platform.saveFile(
          dialogTitle: localizations.exportFavorites,
          fileName:
              'hanzi_favorites_${DateTime.now().millisecondsSinceEpoch}.json',
          type: FileType.custom,
          allowedExtensions: ['json'],
        );

        if (result != null) {
          final file = File(result);
          await file.writeAsString(jsonString);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result != null
                  ? localizations.exportSuccess
                  : localizations.exportError,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${localizations.exportError}: $e')),
        );
      }
    }
  }

  Future<void> _importFavorites() async {
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Import not supported on web platform')),
        );
      }
      return;
    }

    final localizations = AppLocalizations.of(context)!;
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: localizations.importFavorites,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null && mounted) {
      final favoritesProvider = Provider.of<FavoritesProvider>(
        context,
        listen: false,
      );
      final success = await favoritesProvider.importFavorites(
        result.files.single.path!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? localizations.importSuccess : localizations.importError,
            ),
          ),
        );
      }
    }
  }

  Widget _buildColorSelector(
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.colorTheme,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 每行7个颜色球
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.0,
              ),
              itemCount: ThemeProvider.availableColors.length,
              itemBuilder: (context, index) {
                final color = ThemeProvider.availableColors[index];
                final isSelected = themeProvider.selectedColorIndex == index;
                final colorName = _getColorName(color.name, localizations);

                return Tooltip(
                  message: colorName,
                  child: GestureDetector(
                    onTap: () => themeProvider.setSelectedColor(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? color.light
                                : color.dark,
                        shape: BoxShape.circle,
                        border:
                            isSelected
                                ? Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  width: 3,
                                )
                                : Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                      ),
                      child:
                          isSelected
                              ? Icon(
                                Icons.check,
                                color: _getContrastColor(
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? color.light
                                      : color.dark,
                                ),
                                size: 20,
                              )
                              : null,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getColorName(String colorKey, AppLocalizations localizations) {
    switch (colorKey) {
      case 'rosewater':
        return localizations.colorRosewater;
      case 'flamingo':
        return localizations.colorFlamingo;
      case 'pink':
        return localizations.colorPink;
      case 'mauve':
        return localizations.colorMauve;
      case 'red':
        return localizations.colorRed;
      case 'maroon':
        return localizations.colorMaroon;
      case 'peach':
        return localizations.colorPeach;
      case 'yellow':
        return localizations.colorYellow;
      case 'green':
        return localizations.colorGreen;
      case 'teal':
        return localizations.colorTeal;
      case 'sky':
        return localizations.colorSky;
      case 'sapphire':
        return localizations.colorSapphire;
      case 'blue':
        return localizations.colorBlue;
      case 'lavender':
        return localizations.colorLavender;
      default:
        return colorKey;
    }
  }

  Color _getContrastColor(Color backgroundColor) {
    // 计算颜色对比度，选择合适的前景色
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 主题设置部分
              Text(
                localizations.themeMode,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListTile(
                title: Text(localizations.systemDefault),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) => themeProvider.setThemeMode(value!),
                ),
              ),
              ListTile(
                title: Text(localizations.lightMode),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) => themeProvider.setThemeMode(value!),
                ),
              ),
              ListTile(
                title: Text(localizations.darkMode),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) => themeProvider.setThemeMode(value!),
                ),
              ),
              const SizedBox(height: 32),

              // 颜色主题设置部分
              _buildColorSelector(themeProvider, localizations),
              const SizedBox(height: 32),

              // 语言设置部分
              Text(
                localizations.languageSettings,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListTile(
                title: Text(localizations.followSystem),
                leading: Radio<LanguageOption>(
                  value: LanguageOption.system,
                  groupValue: languageProvider.currentLanguage,
                  onChanged: (value) => languageProvider.setLanguage(value!),
                ),
              ),
              ListTile(
                title: Text(localizations.chinese),
                leading: Radio<LanguageOption>(
                  value: LanguageOption.chinese,
                  groupValue: languageProvider.currentLanguage,
                  onChanged: (value) => languageProvider.setLanguage(value!),
                ),
              ),
              ListTile(
                title: Text(localizations.english),
                leading: Radio<LanguageOption>(
                  value: LanguageOption.english,
                  groupValue: languageProvider.currentLanguage,
                  onChanged: (value) => languageProvider.setLanguage(value!),
                ),
              ),
              const SizedBox(height: 32),

              // 存储设置部分
              Text(
                localizations.storageSettings,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              // 当前存储位置
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.currentStorageLocation,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentStorageLocation ??
                            localizations.defaultLocation,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.favoritesCount(
                          favoritesProvider.favoritesCount,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 存储管理按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _selectStorageLocation,
                  icon: const Icon(Icons.folder_open),
                  label: Text(localizations.selectStorageLocation),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _exportFavorites,
                      icon: const Icon(Icons.upload),
                      label: Text(localizations.exportFavorites),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _importFavorites,
                      icon: const Icon(Icons.download),
                      label: Text(localizations.importFavorites),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
