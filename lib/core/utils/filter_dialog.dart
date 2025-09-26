import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_spaces.dart';
import 'package:prueba_tecnica_flutter/core/utils/filter_products.dart';
import 'package:prueba_tecnica_flutter/core/utils/sort_type.dart';
import 'package:prueba_tecnica_flutter/logic/products_logic.dart';

class FilterDialog extends StatefulWidget {
  final ProductsCubit cubit;

  const FilterDialog({
    super.key,
    required this.cubit,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late FilterOptions _selectedFilters;
  late SortType _selectedSort;
  List<String> _categories = [];
  List<String> _brands = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _selectedFilters = FilterOptions();
    _selectedSort = SortType.none;
    _loadFilterData();
  }

  Future<void> _loadFilterData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      await widget.cubit.loadAllProducts();
      
      final categories = widget.cubit.getAvailableCategories();
      final brands = widget.cubit.getAvailableBrands();

      setState(() {
        _categories = categories;
        _brands = brands;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar y Ordenar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkgray,
                ),
              ),
              const SizedBox(height: AppSpaces.m25),

              if (_isLoading) _buildLoadingIndicator(),
              if (_hasError) _buildErrorWidget(),
              if (!_isLoading && !_hasError) _buildFilterContent(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando categorías y marcas...'),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          const Text(
            'Error cargando filtros',
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadFilterData,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Información de resultados disponibles
        _buildFilterInfo(),
        const SizedBox(height: AppSpaces.m15),

        const Text(
          'Categoría:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpaces.m10),
        DropdownButtonFormField<String>(
          value: _selectedFilters.category.isEmpty ? null : _selectedFilters.category,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            hintText: 'Selecciona categoría',
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Todas las categorías'),
            ),
            ..._categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedFilters = _selectedFilters.copyWith(category: value ?? '');
            });
          },
        ),
        const SizedBox(height: AppSpaces.m25),

        const Text(
          'Marca:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpaces.m10),
        DropdownButtonFormField<String>(
          value: _selectedFilters.brand.isEmpty ? null : _selectedFilters.brand,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            hintText: 'Selecciona marca',
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Todas las marcas'),
            ),
            ..._brands.map((brand) {
              return DropdownMenuItem(
                value: brand,
                child: Text(brand),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedFilters = _selectedFilters.copyWith(brand: value ?? '');
            });
          },
        ),
        const SizedBox(height: AppSpaces.m25),

        const Text(
          'Tipo de filtro:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpaces.m10),
        DropdownButtonFormField<FilterType>(
          value: _selectedFilters.filterType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items: const [
            DropdownMenuItem(
              value: FilterType.and,
              child: Text('Y (ambas condiciones)'),
            ),
            DropdownMenuItem(
              value: FilterType.or,
              child: Text('O (cualquier condición)'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedFilters = _selectedFilters.copyWith(
                  filterType: value ?? FilterType.and);
            });
          },
        ),
        const SizedBox(height: AppSpaces.m25),

        const Text(
          'Ordenar por:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpaces.m10),
        DropdownButtonFormField<SortType>(
          value: _selectedSort,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items: const [
            DropdownMenuItem(
              value: SortType.none,
              child: Text('Sin ordenamiento'),
            ),
            DropdownMenuItem(
              value: SortType.alphabeticalAsc,
              child: Text('A-Z (Alfabético)'),
            ),
            DropdownMenuItem(
              value: SortType.alphabeticalDesc,
              child: Text('Z-A (Alfabético inverso)'),
            ),
            DropdownMenuItem(
              value: SortType.priceAsc,
              child: Text('Precio: Menor a Mayor'),
            ),
            DropdownMenuItem(
              value: SortType.priceDesc,
              child: Text('Precio: Mayor a Menor'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedSort = value ?? SortType.none;
            });
          },
        ),
        const SizedBox(height: AppSpaces.m25),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  widget.cubit.clearFilters();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Limpiar',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpaces.m10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _applyFilters();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lila,
                ),
                child: const Text(
                  'Aplicar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lila.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.lila, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${_categories.length} categorías • ${_brands.length} marcas disponibles',
              style: const TextStyle(
                color: AppColors.lila,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    widget.cubit.applyFilters(_selectedFilters);
    widget.cubit.sortProducts(_selectedSort);
    Navigator.of(context).pop();
  }
}