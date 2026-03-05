import 'package:flutter/material.dart';

/// Simple controller for toggling between light and dark [ThemeMode]s.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setMode(final ThemeMode mode) {
    if (_mode == mode) {
      return;
    }
    _mode = mode;
    notifyListeners();
  }

  void toggle() {
    switch (_mode) {
      case ThemeMode.system:
      case ThemeMode.light:
        setMode(ThemeMode.dark);
        return;
      case ThemeMode.dark:
        setMode(ThemeMode.light);
        return;
    }
  }
}
