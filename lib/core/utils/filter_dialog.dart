import 'package:flutter/material.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_colors.dart';
import 'package:prueba_tecnica_flutter/core/styles/app_spaces.dart';
import 'package:prueba_tecnica_flutter/core/utils/filter_products.dart';
import 'package:prueba_tecnica_flutter/core/utils/sort_type.dart';
import 'package:prueba_tecnica_flutter/logic/products_logic.dart';

class FilterDialog extends StatefulWidget {
  final ProductsCubit cubit;
  final List<String> categories;
  final List<String> brands;

  const FilterDialog({
    super.key,
    required this.cubit,
    required this.categories,
    required this.brands,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late FilterOptions _selectedFilters;
  late SortType _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedFilters = FilterOptions();
    _selectedSort = SortType.none;
  }

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Categoría:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpaces.m10),
              DropdownButtonFormField<String>(
                value: _selectedFilters.category.isEmpty
                    ? null
                    : _selectedFilters.category,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todas las categorías'),
                  ),
                  ...widget.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFilters =
                        _selectedFilters.copyWith(category: value ?? '');
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
                value: _selectedFilters.brand.isEmpty
                    ? null
                    : _selectedFilters.brand,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todas las marcas'),
                  ),
                  ...widget.brands.map((brand) {
                    return DropdownMenuItem(
                      value: brand,
                      child: Text(brand),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFilters =
                        _selectedFilters.copyWith(brand: value ?? '');
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                  DropdownMenuItem(
                    value: SortType.ratingDesc,
                    child: Text('Mejor valorados primero'),
                  ),
                  DropdownMenuItem(
                      value: SortType.ratingAsc,
                      child: Text('Peor valorados primero')),
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
                      child: const Text('Limpiar'),
                    ),
                  ),
                  const SizedBox(width: AppSpaces.m10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.cubit.applyFilters(_selectedFilters);
                        widget.cubit.sortProducts(_selectedSort);
                        Navigator.of(context).pop();
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
          ),
        ),
      ),
    );
  }
}
