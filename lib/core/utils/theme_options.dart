import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/core/utils/theme_mode.dart';

class ThemeOptions {
  final AppThemeMode themeMode;
  final Color primaryColor;
  final Color secondaryColor;
  final bool useDynamicColor;
  
  const ThemeOptions({
    this.themeMode = AppThemeMode.system,
    this.primaryColor = Colors.white,
    this.secondaryColor = Colors.black,
    this.useDynamicColor = false,
  });
  
  ThemeOptions copyWith({
    AppThemeMode? themeMode,
    Color? primaryColor,
    Color? secondaryColor,
    bool? useDynamicColor,
  }) {
    return ThemeOptions(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ThemeOptions &&
        other.themeMode == themeMode &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.useDynamicColor == useDynamicColor;
  }
  
  @override
  int get hashCode {
    return themeMode.hashCode ^
        primaryColor.hashCode ^
        secondaryColor.hashCode ^
        useDynamicColor.hashCode;
  }
}