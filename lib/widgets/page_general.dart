import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_spaces.dart';
import 'package:prueba_tecnica_flutter/core/utils/navigation_util.dart';

class PageGeneral extends StatelessWidget {
  const PageGeneral({
    super.key,
    this.body,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.title,
    this.isViewLogo = true,
    this.viewBigLogo = false,
    this.isViewBack = true,
  });

  final Widget? body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final String? title;
  final bool isViewLogo;
  final bool viewBigLogo;
  final bool isViewBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor ??
          (Theme.of(context).brightness == Brightness.dark
              ? AppColors.black
              : AppColors.white),
      body: Column(
        children: [
          AppbarGeneral(
            isViewLogo: isViewLogo,
            isViewBack: isViewBack,
          ),
          if (viewBigLogo) const LogoArm(width: 200),
          Expanded(
            child: body ??
                const SizedBox.shrink(), // ← Quita el SingleChildScrollView
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
  });

  final bool isViewLogo;
  final bool isViewBack;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ColoredBox(
        color: backgroundColor ??
            (Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkgray
                : AppColors.lila),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (isViewLogo)
                const Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: AppSpaces.m15),
                      LogoArm(),
                    ],
                  ),
                ),
              if (isViewBack)
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: AppSpaces.m25,
                          color: AppColors.white,
                        ),
                        onPressed: () => navigationPop(context),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoArm extends StatelessWidget {
  const LogoArm({super.key, this.width = 120});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/LogoLS.png',
      width: width,
    );
  }
}
