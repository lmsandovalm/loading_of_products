// test/unit/products_datasource_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prueba_tecnica_flutter/datasource/products_datasouce.dart';
import 'package:prueba_tecnica_flutter/pages/home/models/home_page.dart';
import 'package:built_collection/built_collection.dart'; // ← Importa BuiltList

@GenerateMocks([http.Client])
import 'products_datasource_test.mocks.dart' as mock_file;

void main() {
  group('ProductsDataSource - getProducts', () {
    late mock_file.MockClient mockHttpClient;
    late ProductsDataSource dataSource;

    setUp(() {
      mockHttpClient = mock_file.MockClient();
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
            "tags": ["beauty", "mascara"],
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

      // ASSERT - Corregido para BuiltList
      expect(result, isNotNull);
      expect(result, isA<Home>());
      expect(result.total, 100);
      expect(result.skip, 0);
      expect(result.limit, 30);

      // CORRECCIÓN: Usar isNotEmpty en lugar de isA<List>()
      expect(result.data, isNotEmpty); 
      expect(result.data.length, 1);  

      final product = result.data.first;
      expect(product.id, 1);
      expect(product.title, 'iPhone 9');
      expect(product.description, contains('apple mobile'));
      expect(product.price, 549.0);
      expect(product.rating, 4.69);

      // Verificar tags
      expect(product.tags, isNotEmpty);
      expect(product.tags?.length, 2);
      expect(product.tags?.first, 'beauty');
    });

    test('debe lanzar excepción cuando la API retorna error', () async {
      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => dataSource.getProducts(), throwsA(isA<Exception>()));
    });

    test('debe limpiar campos nulos correctamente', () async {
      // ARRANGE - JSON con campos nulos
      const mockResponseWithNulls = '''
      {
        "products": [
          {
            "id": 1,
            "title": "iPhone 9",
            "description": "An apple mobile which is nothing like apple",
            "price": 549,
            "rating": 4.69,
            "stock": 94,
            "tags": null,
            "brand": null,
            "category": null,
            "thumbnail": "https://cdn.dummyjson.com/product-images/1/thumbnail.jpg",
            "images": null
          }
        ],
        "total": 100,
        "skip": 0,
        "limit": 30
      }
      ''';

      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response(mockResponseWithNulls, 200));

      // ACT
      final result = await dataSource.getProducts(limit: 30, skip: 0);

      // ASSERT - Para BuiltList
      final product = result.data.first;
      expect(product.brand, 'Unknown Brand');
      expect(product.category, 'Uncategorized');
      expect(product.images.isEmpty,
          true); 
      expect(product.images.length, 0); 
    });

    // Se verifica conversión de BuiltList a List
    test('debe permitir convertir BuiltList a List normal', () async {
      const mockResponse = '''
      {
        "products": [
          {
            "id": 1,
            "title": "iPhone 9",
            "description": "Test",
            "price": 549,
            "rating": 4.69,
            "stock": 94,
            "tags": ["tag1", "tag2"],
            "brand": "Apple",
            "category": "smartphones",
            "thumbnail": "test.jpg",
            "images": ["img1.jpg", "img2.jpg"]
          }
        ],
        "total": 1,
        "skip": 0,
        "limit": 30
      }
      ''';

      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await dataSource.getProducts();

      // Convertir BuiltList a List normal para verificación
      final productsList = result.data.toList();
      expect(productsList, isA<List>());
      expect(productsList.length, 1);

      final imagesList = result.data.first.images.toList();
      expect(imagesList, isA<List<String>>());
    });
  });
}
