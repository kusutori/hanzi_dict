import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Catppuccin 14 种颜色选项
  static const List<CatppuccinColor> availableColors = [
    CatppuccinColor(
      name: 'rosewater',
      light: Color(0xFFDC8A78),
      dark: Color(0xFFF5E0DC),
    ),
    CatppuccinColor(
      name: 'flamingo',
      light: Color(0xFFDD7878),
      dark: Color(0xFFF2CDCD),
    ),
    CatppuccinColor(
      name: 'pink',
      light: Color(0xFFEA76CB),
      dark: Color(0xFFF5C2E7),
    ),
    CatppuccinColor(
      name: 'mauve',
      light: Color(0xFF8839EF),
      dark: Color(0xFFCBA6F7),
    ),
    CatppuccinColor(
      name: 'red',
      light: Color(0xFFD20F39),
      dark: Color(0xFFF38BA8),
    ),
    CatppuccinColor(
      name: 'maroon',
      light: Color(0xFFE64553),
      dark: Color(0xFFEBA0AC),
    ),
    CatppuccinColor(
      name: 'peach',
      light: Color(0xFFFE640B),
      dark: Color(0xFFFAB387),
    ),
    CatppuccinColor(
      name: 'yellow',
      light: Color(0xFFDF8E1D),
      dark: Color(0xFFF9E2AF),
    ),
    CatppuccinColor(
      name: 'green',
      light: Color(0xFF40A02B),
      dark: Color(0xFFA6E3A1),
    ),
    CatppuccinColor(
      name: 'teal',
      light: Color(0xFF179299),
      dark: Color(0xFF94E2D5),
    ),
    CatppuccinColor(
      name: 'sky',
      light: Color(0xFF04A5E5),
      dark: Color(0xFF89DCEB),
    ),
    CatppuccinColor(
      name: 'sapphire',
      light: Color(0xFF209FB5),
      dark: Color(0xFF74C7EC),
    ),
    CatppuccinColor(
      name: 'blue',
      light: Color(0xFF1E66F5),
      dark: Color(0xFF89B4FA),
    ),
    CatppuccinColor(
      name: 'lavender',
      light: Color(0xFF7287FD),
      dark: Color(0xFFB4BEFE),
    ),
  ];

  int _selectedColorIndex = 10; // 默认为 sky
  ThemeMode _themeMode = ThemeMode.system;

  int get selectedColorIndex => _selectedColorIndex;
  ThemeMode get themeMode => _themeMode;

  CatppuccinColor get selectedColor => availableColors[_selectedColorIndex];

  ThemeData get lightTheme => ThemeData(
    fontFamily: 'LXGWWenKai',
    colorScheme: ColorScheme.fromSeed(
      seedColor: selectedColor.light,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  ThemeData get darkTheme => ThemeData(
    fontFamily: 'LXGWWenKai',
    colorScheme: ColorScheme.fromSeed(
      seedColor: selectedColor.dark,
      brightness: Brightness.dark,
    ),
    brightness: Brightness.dark,
  );

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    _selectedColorIndex = prefs.getInt('selectedColorIndex') ?? 10; // 默认 sky
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
    notifyListeners();
  }

  Future<void> setSelectedColor(int colorIndex) async {
    if (colorIndex >= 0 && colorIndex < availableColors.length) {
      _selectedColorIndex = colorIndex;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('selectedColorIndex', colorIndex);
      notifyListeners();
    }
  }
}

class CatppuccinColor {
  final String name;
  final Color light;
  final Color dark;

  const CatppuccinColor({
    required this.name,
    required this.light,
    required this.dark,
  });
}
