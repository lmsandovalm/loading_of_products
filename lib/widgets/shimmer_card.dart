import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_spaces.dart';
import 'package:prueba_tecnica_flutter/pages/details/models/details_page.dart';
import 'package:prueba_tecnica_flutter/widgets/shimmer_effect.dart';

class ShimmerProductCard extends StatelessWidget {
  final DetailsPage? item;
  final bool isLoading;
  final EdgeInsetsGeometry padding;

  const ShimmerProductCard({
    super.key,
    this.item,
    this.isLoading = false,
    this.padding = const EdgeInsets.all(18.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isLoading ? _buildShimmerContent() : _buildRealContent(),
    );
  }

  Widget _buildRealContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item!.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.pink,
                ),
              ),
            ),
            const SizedBox(width: AppSpaces.m15),
            Text(
              '\$${item!.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkgray,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpaces.m15),
        Text(
          'Category: ${item!.category}',
          style: const TextStyle(
            color: AppColors.skyblue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpaces.m15),
        Text(
          item!.description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: AppColors.darkgray,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 6),
            Text('${item!.rating}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 16),
            const Icon(Icons.inventory_2_outlined, size: 18),
            const SizedBox(width: 6),
            Text('Stock: ${item!.stock}'),
            const SizedBox(width: 16),
            const Icon(Icons.branding_watermark, size: 18),
            const SizedBox(width: 6),
            Text(item!.brand ?? 'Unknown'),
          ],
        ),
        const SizedBox(height: AppSpaces.m45),
      ],
    );
  }

  Widget _buildShimmerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ShimmerEffect(
                width: double.infinity,
                height: 24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 15),
            ShimmerEffect(
              width: 80,
              height: 20,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ShimmerEffect(
          width: 120,
          height: 18,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            ShimmerEffect(
              width: double.infinity,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            ShimmerEffect(
              width: double.infinity,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            ShimmerEffect(
              width: 200,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ShimmerEffect(
              width: 60,
              height: 18,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(width: 16),
            ShimmerEffect(
              width: 80,
              height: 18,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(width: 16),
            ShimmerEffect(
              width: 100,
              height: 18,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        const SizedBox(height: 45),
      ],
    );
  }
}
