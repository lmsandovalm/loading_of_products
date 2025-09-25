// lib/src/presentation/widgets/theme_provider.dart
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
          if (state is ThemeLoaded) {
            return MaterialApp(
              theme: _buildLightTheme(state.themeOptions),
              darkTheme: _buildDarkTheme(state.themeOptions),
              themeMode: state.themeOptions.themeMode.toThemeMode,
              home: child,
            );
          }
          
          // Mientras carga el tema, mostrar loading o tema por defecto
          return MaterialApp(
            theme: _buildLightTheme(const ThemeOptions()),
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
        primary: options.primaryColor,
        secondary: options.secondaryColor,
      ),
      brightness: Brightness.light,
    );
  }

  ThemeData _buildDarkTheme(ThemeOptions options) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: options.primaryColor,
        secondary: options.secondaryColor,
      ),
      brightness: Brightness.dark,
    );
  }
}