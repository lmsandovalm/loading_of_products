// lib/src/presentation/cubits/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_flutter/core/utils/theme_mode.dart';
import 'package:prueba_tecnica_flutter/core/utils/theme_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeState {
  const ThemeState();
}

class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded({required this.themeOptions});
  
  final ThemeOptions themeOptions;
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeInitial());
  
  static const String _themePreferenceKey = 'app_theme_mode';
  static const String _primaryColorKey = 'primary_color';
  static const String _secondaryColorKey = 'secondary_color';
  static const String _dynamicColorKey = 'dynamic_color';

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final themeIndex = prefs.getInt(_themePreferenceKey) ?? 2; // system por defecto
      final primaryColorValue = prefs.getInt(_primaryColorKey) ?? Colors.white.value;
      final secondaryColorValue = prefs.getInt(_secondaryColorKey) ?? Colors.black.value;
      final useDynamicColor = prefs.getBool(_dynamicColorKey) ?? false;
      
      final themeOptions = ThemeOptions(
        themeMode: AppThemeMode.values[themeIndex],
        primaryColor: Color(primaryColorValue),
        secondaryColor: Color(secondaryColorValue),
        useDynamicColor: useDynamicColor,
      );
      
      emit(ThemeLoaded(themeOptions: themeOptions));
    } catch (e) {
      // En caso de error, usar tema por defecto
      emit(const ThemeLoaded(themeOptions: ThemeOptions()));
    }
  }

  Future<void> changeTheme(ThemeOptions newOptions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setInt(_themePreferenceKey, newOptions.themeMode.index);
      await prefs.setInt(_primaryColorKey, newOptions.primaryColor.value);
      await prefs.setInt(_secondaryColorKey, newOptions.secondaryColor.value);
      await prefs.setBool(_dynamicColorKey, newOptions.useDynamicColor);
      
      emit(ThemeLoaded(themeOptions: newOptions));
    } catch (e) {
      // Manejar error sin emitir nuevo estado
      print('Error saving theme: $e');
    }
  }

  void changeThemeMode(AppThemeMode themeMode) {
    if (state is ThemeLoaded) {
      final currentOptions = (state as ThemeLoaded).themeOptions;
      final newOptions = currentOptions.copyWith(themeMode: themeMode);
      changeTheme(newOptions);
    }
  }

  void changePrimaryColor(Color color) {
    if (state is ThemeLoaded) {
      final currentOptions = (state as ThemeLoaded).themeOptions;
      final newOptions = currentOptions.copyWith(primaryColor: color);
      changeTheme(newOptions);
    }
  }

  void toggleDynamicColor() {
    if (state is ThemeLoaded) {
      final currentOptions = (state as ThemeLoaded).themeOptions;
      final newOptions = currentOptions.copyWith(useDynamicColor: !currentOptions.useDynamicColor);
      changeTheme(newOptions);
    }
  }
}