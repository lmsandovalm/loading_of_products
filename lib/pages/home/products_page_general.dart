import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_spaces.dart';
import 'package:prueba_tecnica_flutter/core/utils/navigation_util.dart';
import 'package:prueba_tecnica_flutter/datasource/products_datasouce.dart';
import 'package:prueba_tecnica_flutter/logic/products_logic.dart';
import 'package:prueba_tecnica_flutter/pages/details/models/details_page.dart';
import 'package:prueba_tecnica_flutter/pages/details/product_detail_page.dart';
import 'package:prueba_tecnica_flutter/widgets/page_general.dart';

class ProductsGeneralPage extends StatelessWidget {
  const ProductsGeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(ProductsDataSource())..getProducts(),
      child: Scaffold(
        body: PageGeneral(
          title: 'Products',
          isViewLogo: true,
          isViewBack: false,
          body: Column(
            children: [
              const SizedBox(height: AppSpaces.m25),
              const SearchWidget(), // Widget de búsqueda
              const SizedBox(height: AppSpaces.m25),
              Expanded(
                child: _buildProductsList(), // Lista de productos
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ProductsServerError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.skyblue, size: 50),
                const SizedBox(height: AppSpaces.m10),
                Text(
                  'Error: ${state.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.darkgray),
                ),
                const SizedBox(height: AppSpaces.m25),
                ElevatedButton(
                  onPressed: () => context.read<ProductsCubit>().getProducts(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is ProductsSuccess) {
          final products = state.products;

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No hay productos disponibles',
                style: TextStyle(color: AppColors.darkgray),
              ),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpaces.m25),
            itemBuilder: (context, index) {
              return TotalProducts(currentNew: products[index]);
            },
          );
        }

        // Estado inicial
        return const Center(
          child: Text('Cargando productos...'),
        );
      },
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final _debouncer = _Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpaces.m25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.greyLight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _debouncer.run(() {
                    context.read<ProductsCubit>().filterProductsByTitle(value);
                  });
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '¿Qué buscas?',
                  hintStyle: TextStyle(
                    color: AppColors.darkgray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const Icon(Icons.search, color: AppColors.darkgray),
          ],
        ),
      ),
    );
  }
}

class TotalProducts extends StatelessWidget {
  const TotalProducts({super.key, required this.currentNew});

  final DetailsPage currentNew;

  @override
  Widget build(BuildContext context) {
    final item = currentNew;

    return GestureDetector(
      onTap: () {
        navigateTo(context, ProductDetailPage(item: item));
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: (item.thumbnail != null && item.thumbnail.isNotEmpty)
                    ? Image.network(
                        item.thumbnail,
                        fit: BoxFit.cover,
                        height: 110,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 110,
                            color: AppColors.greyLight,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/background_home.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/background_home.png',
                        fit: BoxFit.cover,
                        height: 110,
                        width: double.infinity,
                      ),
              ),
            ),

            const SizedBox(width: AppSpaces.m15),

            // Detalles
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
                    // Título
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.darkgray,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: AppSpaces.m10),
                    
                    // Marca y Categoría
                    Text(
                      '${item.brand} • ${item.category}',
                      style: const TextStyle(
                        color: AppColors.darkgray,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppSpaces.m5),
                    
                    // Precio
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.darkgray,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppSpaces.m5),
                    
                    // Rating y Stock
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.darkgray,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.inventory, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${item.stock} units',
                          style: const TextStyle(
                            color: AppColors.darkgray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpaces.m10),
                    
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Ver más',
                        style: TextStyle(
                          color: AppColors.darkgray,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Debouncer para optimizar la búsqueda
class _Debouncer {
  final int milliseconds;
  VoidCallback? _callback;

  _Debouncer({required this.milliseconds});

  void run(VoidCallback callback) {
    _callback?.cancel();
    _callback = callback;
    Future.delayed(Duration(milliseconds: milliseconds), () {
      _callback?.call();
    });
  }
}