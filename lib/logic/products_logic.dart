import 'package:prueba_tecnica_flutter/core/utils/filter_products.dart';
import 'package:prueba_tecnica_flutter/core/utils/internet_util.dart';
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
  int _currentPage = 0;
  int _totalProducts = 0;
  final int _pageSize = 10;

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
        }

        _allProducts = listProductsTotal;
        _currentPage = page;
        _totalProducts = homeResponse.total;

        emit(ProductsSuccess(
          products: _allProducts,
          currentPage: _currentPage,
          totalProducts: _totalProducts,
          hasNextPage: skip + _pageSize < _totalProducts,
          hasPreviousPage: page > 0,
        ));
      } else {
        _allProducts = [];
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

  void filterProductsByTitle(String searchText) {
    if (state is ProductsSuccess) {
      if (searchText.isEmpty) {
        getProducts(page: 0);
        return;
      }

      final filteredProducts = _allProducts.where((product) {
        return product.title.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      emit(ProductsSuccess(
        products: filteredProducts,
        currentPage: _currentPage,
        totalProducts: _totalProducts,
        hasNextPage: false,
        hasPreviousPage: false,
      ));
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

  void filterBlogWithOptions(FilterOptions options) {
    if (state is ProductsSuccess) {
      if (options.isEmpty) {
        getProducts(page: 0);
        return;
      }

      final filteredProducts = _allProducts.where((product) {
        final productCategory = product.category ?? '';
        final productBrand = product.brand ?? '';

        bool categoryMatch = options.category.isEmpty ||
            productCategory
                .toLowerCase()
                .contains(options.category.toLowerCase());

        bool brandMatch = options.brand.isEmpty ||
            productBrand.toLowerCase().contains(options.brand.toLowerCase());

        if (options.filterType == FilterType.and) {
          return categoryMatch && brandMatch;
        } else {
          return categoryMatch || brandMatch;
        }
      }).toList();

      emit(ProductsSuccess(
        products: filteredProducts,
        currentPage: _currentPage,
        totalProducts: _totalProducts,
        hasNextPage: false,
        hasPreviousPage: false,
      ));
    }
  }
}
