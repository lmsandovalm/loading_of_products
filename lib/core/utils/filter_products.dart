class FilterOptions {
  final String category;
  final String brand;
  final List<String> tags; 
  final FilterType filterType;

  FilterOptions({
    this.category = '',
    this.brand = '',
    this.tags = const [],
    this.filterType = FilterType.and,
  });

  bool get isEmpty => category.isEmpty && brand.isEmpty && tags.isEmpty;

  FilterOptions copyWith({
    String? category,
    String? brand,
    List<String>? tags,
    FilterType? filterType,
  }) {
    return FilterOptions(
      category: category ?? this.category,
      brand: brand ?? this.brand,
      tags: tags ?? this.tags,
      filterType: filterType ?? this.filterType,
    );
  }
}

enum FilterType { and, or }