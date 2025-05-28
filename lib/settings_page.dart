import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/language_provider.dart';
import 'l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const SettingsPage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                groupValue: themeMode,
                onChanged: (value) => onThemeModeChanged(value!),
              ),
            ),
            ListTile(
              title: Text(localizations.lightMode),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeMode,
                onChanged: (value) => onThemeModeChanged(value!),
              ),
            ),
            ListTile(
              title: Text(localizations.darkMode),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeMode,
                onChanged: (value) => onThemeModeChanged(value!),
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
          ],
        ),
      ),
    );
  }
}
