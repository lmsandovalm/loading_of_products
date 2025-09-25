import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_spaces.dart';
import 'package:prueba_tecnica_flutter/pages/details/models/details_page.dart';
import 'package:prueba_tecnica_flutter/pages/details/widgets/carrousel_images.dart';
import 'package:prueba_tecnica_flutter/widgets/page_general.dart';

class ProductDetailPage extends StatelessWidget {
  final DetailsPage item;
  final double imageHeight;
  const ProductDetailPage({
    super.key,
    required this.item,
    this.imageHeight = 320,
  });

  @override
  Widget build(BuildContext context) {
    return PageGeneral(
      isViewLogo: true,
      isViewBack: true,
      body: Stack(
        children: [
          ProductImageArea(item: item, height: imageHeight),
          Positioned.fill(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      ProductImageArea(item: item, height: imageHeight),
                      const SizedBox(height: AppSpaces.m25),
                      ProductDetailsCard(item: item),
                      const SizedBox(height: AppSpaces.m15),
                    ],
                  )))
        ],
      ),
    );
  }
}

class ProductDetailsCard extends StatelessWidget {
  final DetailsPage item;
  final EdgeInsetsGeometry padding;

  const ProductDetailsCard({
    super.key,
    required this.item,
    this.padding = const EdgeInsets.all(18.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // estilo de tarjeta
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.pink),
                ),
              ),
              const SizedBox(width: AppSpaces.m15),
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkgray),
              ),
            ],
          ),

          const SizedBox(height: AppSpaces.m15),

          // categoria
          Text('Category: ${item.category}',
              style: const TextStyle(
                  color: AppColors.skyblue, fontWeight: FontWeight.w600)),

          const SizedBox(height: AppSpaces.m15),

          // descripcion
          Text(item.description,
              style: const TextStyle(
                  fontSize: 16, height: 1.5, color: AppColors.darkgray)),

          const SizedBox(height: 16),

          // rating/stock/brand
          Row(
            children: [
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const SizedBox(width: 6),
              Text('${item.rating}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              const Icon(Icons.inventory_2_outlined, size: 18),
              const SizedBox(width: 6),
              Text('Stock: ${item.stock}'),
              const SizedBox(width: 16),
              const Icon(Icons.branding_watermark, size: 18),
              const SizedBox(width: 6),
              Text(item.brand ?? 'Unknown'),
            ],
          ),

          const SizedBox(height: AppSpaces.m45),
        ],
      ),
    );
  }
}
