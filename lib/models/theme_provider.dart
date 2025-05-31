import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Catppuccin 14 种颜色选项 - 使用库提供的预定义颜色
  static final List<CatppuccinColor> availableColors = [
    CatppuccinColor(
      name: 'rosewater',
      light: catppuccin.latte.rosewater,
      dark: catppuccin.frappe.rosewater,
    ),
    CatppuccinColor(
      name: 'flamingo',
      light: catppuccin.latte.flamingo,
      dark: catppuccin.frappe.flamingo,
    ),
    CatppuccinColor(
      name: 'pink',
      light: catppuccin.latte.pink,
      dark: catppuccin.frappe.pink,
    ),
    CatppuccinColor(
      name: 'mauve',
      light: catppuccin.latte.mauve,
      dark: catppuccin.frappe.mauve,
    ),
    CatppuccinColor(
      name: 'red',
      light: catppuccin.latte.red,
      dark: catppuccin.frappe.red,
    ),
    CatppuccinColor(
      name: 'maroon',
      light: catppuccin.latte.maroon,
      dark: catppuccin.frappe.maroon,
    ),
    CatppuccinColor(
      name: 'peach',
      light: catppuccin.latte.peach,
      dark: catppuccin.frappe.peach,
    ),
    CatppuccinColor(
      name: 'yellow',
      light: catppuccin.latte.yellow,
      dark: catppuccin.frappe.yellow,
    ),
    CatppuccinColor(
      name: 'green',
      light: catppuccin.latte.green,
      dark: catppuccin.frappe.green,
    ),
    CatppuccinColor(
      name: 'teal',
      light: catppuccin.latte.teal,
      dark: catppuccin.frappe.teal,
    ),
    CatppuccinColor(
      name: 'sky',
      light: catppuccin.latte.sky,
      dark: catppuccin.frappe.sky,
    ),
    CatppuccinColor(
      name: 'sapphire',
      light: catppuccin.latte.sapphire,
      dark: catppuccin.frappe.sapphire,
    ),
    CatppuccinColor(
      name: 'blue',
      light: catppuccin.latte.blue,
      dark: catppuccin.frappe.blue,
    ),
    CatppuccinColor(
      name: 'lavender',
      light: catppuccin.latte.lavender,
      dark: catppuccin.frappe.lavender,
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
