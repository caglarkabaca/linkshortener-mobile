import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/theme.dart';

class ThemeProvider extends ChangeNotifier {
  MaterialTheme _theme;
  late ThemeData _themeData;
  bool isDark = false;

  get themeData => _themeData;

  ThemeProvider(this._theme) {
    if (isDark) {
      _themeData = _theme.darkMediumContrast();
    } else {
      _themeData = _theme.lightMediumContrast();
    }
  }

  void toggleTheme(BuildContext context) {
    if (isDark) {
      _themeData = _theme.lightMediumContrast();
      isDark = false;
    } else {
      _themeData = _theme.darkMediumContrast();
      isDark = true;
    }

    notifyListeners();
  }
}
