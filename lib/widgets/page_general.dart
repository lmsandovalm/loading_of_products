import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_spaces.dart';
import 'package:prueba_tecnica_flutter/core/utils/navigation_util.dart';
import 'package:prueba_tecnica_flutter/core/utils/theme_mode.dart';
import 'package:prueba_tecnica_flutter/logic/theme_logic.dart';

class PageGeneral extends StatefulWidget {
  const PageGeneral({
    super.key,
    this.body,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.title,
    this.isViewLogo = true,
    this.viewBigLogo = false,
    this.isViewBack = true,
    this.isViewThemeToggle = false,
  });

  final Widget? body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final String? title;
  final bool isViewLogo;
  final bool viewBigLogo;
  final bool isViewBack;
  final bool isViewThemeToggle;

  @override
  State<PageGeneral> createState() => _PageGeneralState();
}

class _PageGeneralState extends State<PageGeneral> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(PageGeneral oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.bottomNavigationBar,
      body: Column(
        children: [
          AppbarGeneral(
            isViewLogo: widget.isViewLogo,
            isViewBack: widget.isViewBack,
            // forcedDarkMode: widget.isDarkMode,
            isViewThemeToggle: widget.isViewThemeToggle,
          ),
          if (widget.viewBigLogo) const Logo(width: 200),
          Expanded(
            child: widget.body ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class AppbarGeneral extends StatelessWidget {
  const AppbarGeneral({
    super.key,
    this.isViewLogo = true,
    this.isViewBack = true,
    this.backgroundColor,
    this.forcedDarkMode,
    this.isViewThemeToggle = false,
  });

  final bool isViewLogo;
  final bool isViewBack;
  final Color? backgroundColor;
  final bool? forcedDarkMode;
  final bool isViewThemeToggle;

  Color _getAppbarColor(BuildContext context) {
    if (forcedDarkMode != null) {
      return forcedDarkMode! ? AppColors.darkgray : AppColors.lila;
    } else {
      return AppColors.lila;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ColoredBox(
        color: backgroundColor ?? _getAppbarColor(context),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isViewLogo)
                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: AppSpaces.m15),
                      Logo(),
                    ],
                  ),
                ),
              if (isViewBack)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: AppSpaces.m25,
                      color: _getIconColor(context),
                    ),
                    onPressed: () => navigationPop(context),
                  ),
                ),
              if (isViewThemeToggle)
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildThemeToggle(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDarkMode = _getCurrentThemeMode(context) == Brightness.dark;

        return IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            size: AppSpaces.m25,
            color: _getIconColor(context),
          ),
          onPressed: () {
            _toggleTheme(context);
          },
          tooltip:
              isDarkMode ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
        );
      },
    );
  }

  void _toggleTheme(BuildContext context) {
  final themeCubit = context.read<ThemeCubit>();
  final currentState = themeCubit.state;

  if (currentState is ThemeLoaded) {
    final currentMode = currentState.themeOptions.themeMode;
    
    // Toggle simple entre claro y oscuro
    AppThemeMode newMode = currentMode == AppThemeMode.light 
        ? AppThemeMode.dark 
        : AppThemeMode.light;

    themeCubit.changeThemeMode(newMode);
  }
}

Brightness _getCurrentThemeMode(BuildContext context) {
  if (forcedDarkMode != null) {
    return forcedDarkMode! ? Brightness.dark : Brightness.light;
  } else {
    final themeCubit = context.read<ThemeCubit>();
    if (themeCubit.state is ThemeLoaded) {
      final themeOptions = (themeCubit.state as ThemeLoaded).themeOptions;
      return themeOptions.themeMode == AppThemeMode.dark 
          ? Brightness.dark 
          : Brightness.light;
    }
    return Brightness.light;
  }
}

  Color _getIconColor(BuildContext context) {
    return AppColors.white;
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key, this.width = 120});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/LogoLS.png',
      width: width,
    );
  }
}
