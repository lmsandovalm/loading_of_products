import 'package:prueba_tecnica_flutter/core/utils/filter_products.dart';
import 'package:prueba_tecnica_flutter/core/utils/internet_util.dart';
import 'package:prueba_tecnica_flutter/core/utils/sort_type.dart';
import 'package:prueba_tecnica_flutter/datasource/products_datasouce.dart';
import 'package:prueba_tecnica_flutter/models/exception/general_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_flutter/pages/details/models/details_page.dart';
import 'package:prueba_tecnica_flutter/pages/home/models/home_page.dart';

abstract class ProductsState {
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsSuccess extends ProductsState {
  final List<DetailsPage> products;
  final int currentPage;
  final int totalProducts;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const ProductsSuccess({
    required this.products,
    required this.currentPage,
    required this.totalProducts,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
}

class ProductsReport extends ProductsState {
  const ProductsReport();
}

class ProductsServerError extends ProductsState {
  const ProductsServerError({
    required this.error,
    required this.typeError,
  });
  final String error;
  final ExcResponse typeError;
}

class ListWait extends ProductsState {
  const ListWait();
}

//------------- CUBIT -------------//

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._productsdatasource) : super(const ProductsInitial());

  final ProductsDataSource _productsdatasource;
  List<DetailsPage> _allProducts = [];
  List<DetailsPage> _allAvailableProducts = [];
  int _currentPage = 0;
  int _totalProducts = 0;
  final int _pageSize = 10;
  bool _allProductsLoaded = false;
  FilterOptions _currentFilters = FilterOptions();
  SortType _currentSortType = SortType.none;

  //Obtener productos con paginación
  Future<void> getProducts({int page = 0}) async {
    emit(const ProductsLoading());
    try {
      final isConnected = await isInternetConected();

      if (isConnected) {
        final skip = page * _pageSize;
        final Home homeResponse = await _productsdatasource.getProducts(
          limit: _pageSize,
          skip: skip,
        );

        List<DetailsPage> listProductsTotal = <DetailsPage>[];

        if (homeResponse.data.isNotEmpty) {
          listProductsTotal = homeResponse.data.toList();
          for (var product in listProductsTotal) {
            if (!_allAvailableProducts.any((p) => p.id == product.id)) {
              _allAvailableProducts.add(product);
            }
          }
        }

        _allProducts = listProductsTotal;
        _currentPage = page;
        _totalProducts = homeResponse.total;
        _allProductsLoaded = _allAvailableProducts.length >= _totalProducts;

        emit(ProductsSuccess(
          products: _allProducts,
          currentPage: _currentPage,
          totalProducts: _totalProducts,
          hasNextPage: skip + _pageSize < _totalProducts,
          hasPreviousPage: page > 0,
        ));
      } else {
        _allProducts = [];
        _allAvailableProducts = [];
        emit(const ProductsSuccess(
          products: <DetailsPage>[],
          currentPage: 0,
          totalProducts: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        ));
      }
    } catch (e) {
      _allProducts = [];
      _allAvailableProducts = [];
      emit(ProductsServerError(
          error: e.toString(), typeError: ExcResponse.unknown));
    }
  }

  Future<void> loadAllProducts() async {
    if (_allProductsLoaded) return;

    emit(const ProductsLoading());
    try {
      final Home homeResponse = await _productsdatasource.getProducts(
        limit: _totalProducts,
        skip: 0,
      );

      if (homeResponse.data.isNotEmpty) {
        _allAvailableProducts = homeResponse.data.toList();
        _allProductsLoaded = true;

        emit(ProductsSuccess(
          products: _allAvailableProducts,
          currentPage: 0,
          totalProducts: _allAvailableProducts.length,
          hasNextPage: false,
          hasPreviousPage: false,
        ));
      }
    } catch (e) {
      emit(ProductsServerError(
          error: e.toString(), typeError: ExcResponse.unknown));
    }
  }

  Future<void> nextPage() async {
    if (state is ProductsSuccess) {
      final currentState = state as ProductsSuccess;
      if (currentState.hasNextPage) {
        await getProducts(page: _currentPage + 1);
      }
    }
  }

  Future<void> previousPage() async {
    if (state is ProductsSuccess) {
      final currentState = state as ProductsSuccess;
      if (currentState.hasPreviousPage) {
        await getProducts(page: _currentPage - 1);
      }
    }
  }

  Future<void> filterProductsByTitle(String searchText) async {
    if (searchText.isEmpty) {
      await getProducts(page: 0);
      return;
    }

    if (!_allProductsLoaded) {
      await loadAllProducts();
    }

    final filteredProducts = _allAvailableProducts.where((product) {
      return product.title.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    emit(ProductsSuccess(
      products: filteredProducts,
      currentPage: 0,
      totalProducts: filteredProducts.length,
      hasNextPage: false,
      hasPreviousPage: false,
    ));
  }

  //Funcion de busqueda en todos los productos por titulo
  Future<void> searchAllProductsByTitle(String searchText) async {
    if (searchText.isEmpty) {
      await getProducts(page: 0);
      return;
    }

    emit(const ProductsLoading());
    try {
      final Home homeResponse = await _productsdatasource.getProducts(
        limit: 300,
        skip: 0,
      );
      final allProducts = homeResponse.data.toList();
      final filteredProducts = allProducts.where((product) {
        return product.title.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      emit(ProductsSuccess(
        products: filteredProducts,
        currentPage: 0,
        totalProducts: filteredProducts.length,
        hasNextPage: false,
        hasPreviousPage: false,
      ));
    } catch (e) {
      emit(ProductsServerError(
          error: e.toString(), typeError: ExcResponse.unknown));
    }
  }

  Future<void> loadMoreProducts({int limit = 30, int skip = 0}) async {
    try {
      final isConnected = await isInternetConected();
      if (isConnected) {
        final Home homeResponse =
            await _productsdatasource.getProducts(limit: limit, skip: skip);

        if (homeResponse.data.isNotEmpty) {
          final newProducts = homeResponse.data.toList();
          _allProducts.addAll(newProducts);
          emit(ProductsSuccess(
            products: _allProducts,
            currentPage: _currentPage,
            totalProducts: _totalProducts + newProducts.length,
            hasNextPage: true,
            hasPreviousPage: _currentPage > 0,
          ));
        }
      }
    } catch (e) {
      emit(ProductsServerError(
          error: e.toString(), typeError: ExcResponse.errorGeneral));
    }
  }

  void filterProductsWithOptions(FilterOptions options) {
    if (state is ProductsSuccess) {
      if (options.isEmpty) {
        _currentFilters = FilterOptions();
        _currentSortType = SortType.none;
        _applyFiltersAndSort();
        return;
      }

      _currentFilters = options;
      _applyFiltersAndSort();
    }
  }

  Future<void> applyFilters(FilterOptions filters) async {
    _currentFilters = filters;
    await _applyFiltersAndSort();
  }

  Future<void> sortProducts(SortType sortType) async {
    _currentSortType = sortType;
    await _applyFiltersAndSort();
  }

  Future<void> _applyFiltersAndSort() async {
    if (!_allProductsLoaded) {
      await _loadAllProductsForFilters();
    }

    if (_allAvailableProducts.isEmpty) {
      await getProducts(page: 0);
      return;
    }

    List<DetailsPage> filteredProducts = List.from(_allAvailableProducts); 

    if (!_currentFilters.isEmpty) {
      filteredProducts = filteredProducts.where((product) {
        final productCategory = product.category ?? '';
        final productBrand = product.brand ?? '';

        bool categoryMatch = _currentFilters.category.isEmpty ||
            productCategory.toLowerCase().contains(_currentFilters.category.toLowerCase());

        bool brandMatch = _currentFilters.brand.isEmpty ||
            productBrand.toLowerCase().contains(_currentFilters.brand.toLowerCase());

        if (_currentFilters.filterType == FilterType.and) {
          return categoryMatch && brandMatch;
        } else {
          return categoryMatch || brandMatch;
        }
      }).toList();
    }

    filteredProducts = _sortProducts(filteredProducts, _currentSortType);

    final uniqueProducts = _removeDuplicates(filteredProducts);

    emit(ProductsSuccess(
      products: uniqueProducts,
      currentPage: 0,
      totalProducts: uniqueProducts.length,
      hasNextPage: false,
      hasPreviousPage: false,
    ));
  }

  List<DetailsPage> _removeDuplicates(List<DetailsPage> products) {
    final seenIds = <int>{};
    return products.where((product) => seenIds.add(product.id)).toList();
  }

  Future<void> _loadAllProductsForFilters() async {
    if (_allProductsLoaded && _allAvailableProducts.length >= _totalProducts) {
      return;
    }

    emit(const ProductsLoading());
    try {
      final Home homeResponse = await _productsdatasource.getProducts(
        limit: _totalProducts, 
        skip: 0,
      );
      
      if (homeResponse.data.isNotEmpty) {
        _allAvailableProducts = homeResponse.data.toList();
        _allProductsLoaded = true;
        
      }
    } catch (e) {
      if (_allAvailableProducts.isEmpty) {
        emit(ProductsServerError(
            error: e.toString(), typeError: ExcResponse.unknown));
      }
    }
  }

  List<DetailsPage> _sortProducts(
      List<DetailsPage> products, SortType sortType) {
    final sortedProducts = List<DetailsPage>.from(products);

    switch (sortType) {
      case SortType.alphabeticalAsc:
        sortedProducts.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.alphabeticalDesc:
        sortedProducts.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortType.priceAsc:
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceDesc:
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.ratingDesc:
        sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortType.ratingAsc:
        sortedProducts.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case SortType.none:
        break;
    }
    return sortedProducts;
  }

  Future<void> clearFilters() async {
    _currentFilters = FilterOptions();
    _currentSortType = SortType.none;
    await getProducts(page: 0);
  }

  List<String> getAvailableCategories() {
    final categories = _allAvailableProducts
        .map((product) => product.category ?? 'Uncategorized')
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    categories.sort();
    return categories;
  }

  List<String> getAvailableBrands() {
    final brands = _allAvailableProducts
        .map((product) => product.brand ?? 'Unknown')
        .where((brand) => brand.isNotEmpty && brand != 'Unknown')
        .toSet()
        .toList();

    brands.sort();
    return brands;
  }

  bool get hasActiveFilters {
    return !_currentFilters.isEmpty || _currentSortType != SortType.none;
  }


  Future<void> refreshProducts() async {
    try {
      if (state is ProductsSuccess) {
        final currentState = state as ProductsSuccess;

        if (hasActiveFilters) {
          await _applyFiltersAndSort();
        } else {
          await getProducts(page: currentState.currentPage);
        }
      } else {
        await getProducts(page: 0);
      }
    } catch (e) {
      emit(ProductsServerError(
          error: e.toString(), typeError: ExcResponse.unknown));
    }
  }
}
