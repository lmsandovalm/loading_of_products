import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/pages/home/products_page_general.dart';
import 'package:prueba_tecnica_flutter/logic/theme_logic.dart';
import 'package:prueba_tecnica_flutter/core/utils/theme_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit()..loadTheme(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          ThemeMode effectiveThemeMode = ThemeMode.system;
          Color primaryColor = AppColors.white;
          Color secondaryColor = AppColors.darkgray;

          if (state is ThemeLoaded) {
            effectiveThemeMode =
                state.forcedTheme ?? state.themeOptions.themeMode.toThemeMode;
            secondaryColor = state.themeOptions.secondaryColor;
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(primaryColor, secondaryColor),
            darkTheme: _buildDarkTheme(primaryColor, secondaryColor),
            themeMode: effectiveThemeMode,
            home: const ProductsGeneralPage(),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme(Color primaryColor, Color secondaryColor) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: AppColors.white,
        onSurface: AppColors.darkgray,
      ),
      brightness: Brightness.light,
    );
  }

  ThemeData _buildDarkTheme(Color primaryColor, Color secondaryColor) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: AppColors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: AppColors.black,
        onSurface: AppColors.white,
      ),
      brightness: Brightness.dark,
    );
  }
}
