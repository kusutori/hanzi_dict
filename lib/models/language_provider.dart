import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LanguageOption { system, chinese, english }

class LanguageProvider extends ChangeNotifier {
  LanguageOption _currentLanguage = LanguageOption.system;
  Locale? _currentLocale;

  LanguageOption get currentLanguage => _currentLanguage;
  Locale? get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final languageIndex = prefs.getInt('language') ?? 0;
    _currentLanguage = LanguageOption.values[languageIndex];
    _updateLocale();
    notifyListeners();
  }

  Future<void> setLanguage(LanguageOption language) async {
    _currentLanguage = language;
    _updateLocale();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', language.index);

    notifyListeners();
  }

  void _updateLocale() {
    switch (_currentLanguage) {
      case LanguageOption.chinese:
        _currentLocale = const Locale('zh');
        break;
      case LanguageOption.english:
        _currentLocale = const Locale('en');
        break;
      case LanguageOption.system:
        _currentLocale = null; // Let system decide
        break;
    }
  }

  String getLanguageDisplayName(BuildContext context, LanguageOption option) {
    switch (option) {
      case LanguageOption.system:
        return 'Follow System'; // This will be localized later
      case LanguageOption.chinese:
        return '中文';
      case LanguageOption.english:
        return 'English';
    }
  }
}
