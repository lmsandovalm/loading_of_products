import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_flutter/core/utils/theme_mode.dart';
import 'package:prueba_tecnica_flutter/core/utils/theme_options.dart';
import 'package:prueba_tecnica_flutter/logic/theme_logic.dart';

class ThemeProvider extends StatelessWidget {
  final Widget child;

  const ThemeProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit()..loadTheme(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          ThemeMode effectiveThemeMode;
          ThemeOptions themeOptions;

          if (state is ThemeLoaded) {
            themeOptions = state.themeOptions;
            effectiveThemeMode = state.forcedTheme ?? state.themeOptions.themeMode.toThemeMode;
          } else {
            themeOptions = const ThemeOptions();
            effectiveThemeMode = ThemeMode.system;
          }

          return MaterialApp(
            theme: _buildLightTheme(themeOptions),
            darkTheme: _buildDarkTheme(themeOptions),
            themeMode: effectiveThemeMode,
            home: child,
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme(ThemeOptions options) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        secondary: options.secondaryColor,
      ),
      brightness: Brightness.light,
    );
  }

  ThemeData _buildDarkTheme(ThemeOptions options) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        secondary: options.secondaryColor,
      ),
      brightness: Brightness.dark,
    );
  }
}
