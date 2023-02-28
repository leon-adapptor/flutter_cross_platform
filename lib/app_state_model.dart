import 'package:cross_platform/platform_ui.dart';
import 'package:cross_platform/theme/my_color_schemes.dart';
import 'package:flutter/material.dart';

class AppStateModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  MyColorScheme _colorScheme = myColorSchemes.first;
  String _targetUI = MyPlatformUI.auto;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  set darkMode(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.system;
    notifyListeners();
  }

  MyColorScheme get colorScheme => _colorScheme;
  set colorScheme(MyColorScheme scheme) {
    _colorScheme = scheme;
    notifyListeners();
  }

  String get targetUI => _targetUI;
  set targetUI(String ui) {
    _targetUI = ui;
    notifyListeners();
  }
}
