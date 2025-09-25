import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prueba_tecnica_flutter/datasource/products_datasouce.dart';


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

    test(
        'debe retornar lista de productos cuando el API responde correctamente',
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
            "tags": 0,
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

      //mock
      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      // ACT
      final result = await dataSource.getProducts(limit: 30, skip: 0);

      // ASSERT - para built_value
      expect(result, isNotNull);
      expect(result, isA<List>());
      expect(result.length, 1);

      final product = result.first;
      // verificación de propiedades
      expect(product.id, 1);
      expect(product.title, 'iPhone 9');
      expect(product.description, contains('apple mobile'));
      expect(product.price, 549.0);
      expect(product.rating, 4.69);
    });

    test('debe lanzar excepción cuando la API retorna error', () async {
      // ARRANGE
      when(mockHttpClient
              .get(Uri.parse('https://dummyjson.com/products?limit=30&skip=0')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // ACT & ASSERT
      expect(() => dataSource.getProducts(), throwsA(isA<Exception>()));
    });
  });
}
