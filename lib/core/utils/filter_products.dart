// lib/src/core/utils/filter_options.dart
class FilterOptions {
  final String category;
  final String brand;
  final FilterType filterType;
  
  const FilterOptions({
    this.category = '',
    this.brand = '',
    this.filterType = FilterType.and,
  });
  
  bool get isEmpty => category.isEmpty && brand.isEmpty;
  
  FilterOptions copyWith({
    String? category,
    String? brand,
    FilterType? filterType,
  }) {
    return FilterOptions(
      category: category ?? this.category,
      brand: brand ?? this.brand,
      filterType: filterType ?? this.filterType,
    );
  }
}

enum FilterType { and, or }