import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'models/language_provider.dart';
import 'models/favorites_provider.dart';
import 'l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const SettingsPage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

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
    final result = await FilePicker.platform.saveFile(
      dialogTitle: localizations.exportFavorites,
      fileName: 'hanzi_favorites_${DateTime.now().millisecondsSinceEpoch}.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && mounted) {
      final favoritesProvider = Provider.of<FavoritesProvider>(
        context,
        listen: false,
      );
      final success = await favoritesProvider.exportFavorites(result);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? localizations.exportSuccess : localizations.exportError,
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  groupValue: widget.themeMode,
                  onChanged: (value) => widget.onThemeModeChanged(value!),
                ),
              ),
              ListTile(
                title: Text(localizations.lightMode),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: widget.themeMode,
                  onChanged: (value) => widget.onThemeModeChanged(value!),
                ),
              ),
              ListTile(
                title: Text(localizations.darkMode),
                leading: Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: widget.themeMode,
                  onChanged: (value) => widget.onThemeModeChanged(value!),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
