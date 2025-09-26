// core/utils/theme_mode.dart
import 'package:flutter/material.dart';

enum AppThemeMode {
  light,
  dark,
}

extension AppThemeModeExtension on AppThemeMode {
  String get name {
    switch (this) {
      case AppThemeMode.light:
        return 'Claro';
      case AppThemeMode.dark:
        return 'Oscuro';
    }
  }

  ThemeMode get toThemeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

ThemeMode appThemeModeToThemeMode(AppThemeMode appThemeMode) {
  switch (appThemeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
  }
}
