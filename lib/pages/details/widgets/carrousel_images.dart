import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/pages/details/models/details_page.dart';

class ProductImageArea extends StatefulWidget {
  final DetailsPage item;
  final double height;
  final String altAsset;

  const ProductImageArea({
    super.key,
    required this.item,
    this.height = 320,
    this.altAsset = 'assets/images/background_home.png',
  });

  @override
  State<ProductImageArea> createState() => _ProductImageAreaState();
}

class _ProductImageAreaState extends State<ProductImageArea> {
  late final PageController _pageController;
  int _currentPage = 0;

  List<String> get _images {
    try {
      return widget.item.images.toList();
    } catch (_) {
      return <String>[];
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: images.isEmpty
                ? _networkOrAsset(null, fit: BoxFit.contain)
                : images.length == 1
                    ? _networkOrAsset(images.first, fit: BoxFit.contain)
                    : _buildCarousel(images),
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> images) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (idx) => setState(() => _currentPage = idx),
          itemBuilder: (context, index) {
            return _networkOrAsset(images[index], fit: BoxFit.contain);
          },
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.white70,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _networkOrAsset(String? url, {BoxFit fit = BoxFit.cover}) {
    if (url == null || url.isEmpty) {
      return Image.asset(widget.altAsset, fit: fit, width: double.infinity);
    }

    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stack) {
        return Image.asset(widget.altAsset, fit: fit, width: double.infinity);
      },
    );
  }
}
