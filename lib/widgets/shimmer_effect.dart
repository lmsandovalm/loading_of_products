import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_spaces.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class ProductItemShimmer extends StatelessWidget {
  const ProductItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(
        left: AppSpaces.m15,
        right: AppSpaces.m15,
        bottom: AppSpaces.m15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen shimmer
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ShimmerEffect(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(width: AppSpaces.m15),

          // Contenido shimmer
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpaces.m15,
                horizontal: AppSpaces.m5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título shimmer
                  ShimmerEffect(
                    width: double.infinity,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: AppSpaces.m10),

                  // Línea 1
                  ShimmerEffect(
                    width: 120,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: AppSpaces.m5),

                  // Línea 2
                  ShimmerEffect(
                    width: 80,
                    height: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: AppSpaces.m5),

                  // Rating y stock
                  Row(
                    children: [
                      ShimmerEffect(
                        width: 60,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(width: 10),
                      ShimmerEffect(
                        width: 70,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpaces.m10),

                  // "Ver más"
                  ShimmerEffect(
                    width: 50,
                    height: 13,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
