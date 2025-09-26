// theme_logic.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
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
  const ThemeLoaded({required this.themeOptions, this.forcedTheme});

  final ThemeOptions themeOptions;
  final ThemeMode? forcedTheme;
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

      final themeIndex = prefs.getInt('theme_mode') ?? 0;
      final primaryColorValue = prefs.getInt(_primaryColorKey) ??
          AppColors.lila.value; // CAMBIO: lila por defecto
      final secondaryColorValue =
          prefs.getInt(_secondaryColorKey) ?? Colors.orange.value;
      final useDynamicColor = prefs.getBool(_dynamicColorKey) ?? false;

      final themeOptions = ThemeOptions(
        themeMode: AppThemeMode.values[themeIndex],
        primaryColor: Color(primaryColorValue),
        secondaryColor: Color(secondaryColorValue),
        useDynamicColor: useDynamicColor,
      );

      emit(ThemeLoaded(themeOptions: themeOptions));
    } catch (e) {
      emit(const ThemeLoaded(
          themeOptions: ThemeOptions(
      )));
    }
  }

  Future<void> changeTheme(ThemeOptions newOptions) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(_themePreferenceKey, newOptions.themeMode.index);
      await prefs.setInt(_primaryColorKey, newOptions.primaryColor.value);
      await prefs.setInt(_secondaryColorKey, newOptions.secondaryColor.value);
      await prefs.setBool(_dynamicColorKey, newOptions.useDynamicColor);

      print('Tema guardado: ${newOptions.themeMode.name}');
      emit(ThemeLoaded(themeOptions: newOptions));
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  void forceTheme(ThemeMode? forcedTheme) {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      emit(ThemeLoaded(
        themeOptions: currentState.themeOptions,
        forcedTheme: forcedTheme,
      ));
    }
  }

  void restoreTheme() {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      emit(ThemeLoaded(
        themeOptions: currentState.themeOptions,
        forcedTheme: null,
      ));
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
      final newOptions = currentOptions.copyWith(
          useDynamicColor: !currentOptions.useDynamicColor);
      changeTheme(newOptions);
    }
  }

  void changeThemeColors(Color primary, Color secondary) {
    if (state is ThemeLoaded) {
      final currentOptions = (state as ThemeLoaded).themeOptions;
      final newOptions = currentOptions.copyWith(
        primaryColor: primary,
        secondaryColor: secondary,
      );
      changeTheme(newOptions);
    }
  }
}
