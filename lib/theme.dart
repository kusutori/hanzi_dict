import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';

final lightTheme = ThemeData(
  fontFamily: 'LXGWWenKai',
  colorScheme: ColorScheme.fromSeed(
    seedColor: catppuccin.latte.sky,
    brightness: Brightness.light, // 确保与 ThemeData 的 brightness 一致
  ),
  useMaterial3: true,
);

final darkTheme = ThemeData(
  fontFamily: 'LXGWWenKai',
  colorScheme: ColorScheme.fromSeed(
    seedColor: catppuccin.frappe.sky,
    brightness: Brightness.dark, // 确保与 ThemeData 的 brightness 一致
  ),
  brightness: Brightness.dark,
);
