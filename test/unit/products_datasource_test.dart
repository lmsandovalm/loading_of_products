// test/unit/products_datasource_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prueba_tecnica_flutter/datasource/products_datasouce.dart';
import 'package:prueba_tecnica_flutter/pages/home/models/home_page.dart';
import 'package:prueba_tecnica_flutter/models/exception/general_exception.dart';

@GenerateMocks([http.Client])
import 'products_datasource_test.mocks.dart';

void main() {
  group('ProductsDataSource - getProducts', () {
    late MockClient mockHttpClient;
    late ProductsDataSource dataSource;

    setUp(() {
      mockHttpClient = MockClient();
      dataSource = ProductsDataSource(client: mockHttpClient);
    });

    test('debe retornar objeto Home cuando el API responde correctamente',
        () async {
      // ARRANGE
      const mockResponse = '''
      {
        "products": [
          {
            "id": 1,
            "title": "iPhone 9",
            "description": "An apple mobile which is nothing like apple",
            "price": 549,
            "rating": 4.69,
            "stock": 94,
            "brand": "Apple",
            "category": "smartphones",
            "thumbnail": "https://cdn.dummyjson.com/product-images/1/thumbnail.jpg",
            "images": [
              "https://cdn.dummyjson.com/product-images/1/1.jpg",
              "https://cdn.dummyjson.com/product-images/1/2.jpg"
            ]
          }
        ],
        "total": 100,
        "skip": 0,
        "limit": 30
      }
      ''';

      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      // ACT
      final result = await dataSource.getProducts(limit: 30, skip: 0);

      // ASSERT
      expect(result, isA<Home>());
      expect(result.total, 100);
      expect(result.skip, 0);
      expect(result.limit, 30);
      expect(result.data.length, 1);

      final product = result.data.first;
      expect(product.id, 1);
      expect(product.title, 'iPhone 9');
      expect(product.price, 549.0);
      expect(product.rating, 4.69);
      expect(product.brand, 'Apple');
      expect(product.category, 'smartphones');
    });

    test('debe limpiar campos nulos correctamente', () async {
      const mockResponseWithNulls = '''
      {
        "products": [
          {
            "id": 1,
            "title": "Test Product",
            "description": "Test description",
            "price": 100,
            "rating": 4.5,
            "stock": 50,
            "brand": null,
            "category": null,
            "thumbnail": "test.jpg",
            "images": null,
            "tags": null
          }
        ],
        "total": 1,
        "skip": 0,
        "limit": 30
      }
      ''';

      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response(mockResponseWithNulls, 200));

      final result = await dataSource.getProducts(limit: 30, skip: 0);

      final product = result.data.first;
      expect(product.brand, 'Unknown Brand');
      expect(product.category, 'Uncategorized');
      expect(product.images.isEmpty, true);
    });

    test('debe lanzar ResponseServerException cuando la API retorna error',
        () async {
      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // ACT & ASSERT - Verificar que lanza la excepción específica de tu código
      expect(() => dataSource.getProducts(limit: 30, skip: 0),
          throwsA(isA<ResponseServerException>()));
    });

    test('debe lanzar ResponseServerException por timeout', () async {
      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) => Future.delayed(
              const Duration(seconds: 11), () => http.Response('{}', 200)));

      expect(() => dataSource.getProducts(limit: 30, skip: 0),
          throwsA(isA<ResponseServerException>()));
    });

    test('debe construir la URL correctamente con diferentes parámetros',
        () async {
      const mockResponse = '''
      {
        "products": [],
        "total": 0,
        "skip": 20,
        "limit": 10
      }
      ''';

      when(mockHttpClient.get(
              Uri.parse('https://dummyjson.com/products?limit=10&skip=20')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await dataSource.getProducts(limit: 10, skip: 20);

      expect(result.skip, 20);
      expect(result.limit, 10);
    });

    test('debe usar valores por defecto cuando no se especifican parámetros',
        () async {
      const mockResponse = '''
      {
        "products": [],
        "total": 0,
        "skip": 0,
        "limit": 30
      }
      ''';

      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await dataSource.getProducts(); // Sin parámetros

      expect(result.limit, 30); // Valor por defecto
      expect(result.skip, 0); // Valor por defecto
    });
  });

  group('ProductsDataSource - edge cases', () {
    late MockClient mockHttpClient;
    late ProductsDataSource dataSource;

    setUp(() {
      mockHttpClient = MockClient();
      dataSource = ProductsDataSource(client: mockHttpClient);
    });

    test('debe manejar lista de productos vacía', () async {
      const mockEmptyResponse = '''
      {
        "products": [],
        "total": 0,
        "skip": 0,
        "limit": 30
      }
      ''';

      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response(mockEmptyResponse, 200));

      final result = await dataSource.getProducts();

      expect(result.data.isEmpty, true);
      expect(result.total, 0);
    });

    test('debe manejar error de conexión', () async {
      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenThrow(Exception('Connection failed'));

      expect(() => dataSource.getProducts(),
          throwsA(isA<ResponseServerException>()));
    });

    test('debe manejar JSON inválido', () async {
      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response('invalid json', 200));

      expect(() => dataSource.getProducts(),
          throwsA(isA<ResponseServerException>()));
    });
  });
}
